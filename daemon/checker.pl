#!/usr/bin/perl

use strict;
use Errno qw(ENOENT EACCES);
use DBI;
use Data::Dumper;
use File::stat;
use threads;
use threads::shared;

our ($tmp_base, %avs, %db, %opts);

my @threads = ();
my %scans = ();
system('echo $$ > /var/run/av_check.pid');

sub log
{
    my $to = shift;
    my $debug = shift;
    my $msg = shift;
    my $date = localtime;

    if ($debug > $opts{'debug'}) {
	return;
    }
    if ($to eq '-') {
	print "$date: av_check: $msg\n";
    } else {
	open(LOG, ">> $to") or die "Can't open log file $to: $!";
	flock (LOG, 2);
	print LOG "$date: av_check: $msg\n";
	close(LOG);
    }
}

sub read_config(@)
{
    my @config_files = @_;
    foreach my $config_file (@config_files) {
	my $base_config_file = `basename $config_file`;
	my($errn) = stat($config_file) ? 0 : 0+$!;
	if ($errn == ENOENT) {
	    print "Warning: $config_file does not exist" if ($base_config_file !~ /^\..*/) ;
	    next;
	}
	if (defined(do $config_file)) {}
	elsif ($@ ne '') { 
	    die "Error in config file \"$config_file\": $@"; 
	}
	elsif ($! != 0)  { 
	    die "Error reading config file \"$config_file\": $!";
	}
    }
}

my @config_files = ("/etc/checker/checker.cfg");
read_config(@config_files);

my $DB = DBI->connect_cached(
    "DBI:mysql:database=$db{'base'};host=$db{'host'}",
    $db{'user'}, $db{'password'},
) or die "Can't open dbh: $DBI::errstr";

sub thr_check
{
    my $file = shift;
    my $logfile = shift;
    my $DB = DBI->connect(
	"DBI:mysql:database=$db{'base'};host=$db{'host'}",
	$db{'user'}, $db{'password'},
    ) or die "Can't open dbh: $DBI::errstr";
    my $sql = "update $db{'prefix'}files set status_id = 2 where id = ?";
    &log($logfile, 11, "SQL: $sql");
    $DB->do($sql, undef, $file->{'id'}) ;
    &log($logfile, 1, 'DEBUG(' . threads->self()->tid . '): begin check of file ' . $file->{'tmpname'});
    foreach my $value (keys %avs) {
        my $av = $avs{$value};
        next if (!$av && !ref($av));
        my $engine;
        my $last_update;
        my $name = $av->{'name'};
        my $result = 'ok';
	my $packer = '';
        if ($av->{'type'} eq 'command') {
            my $args = $av->{'args'};
	    my $file_location = $tmp_base . '/' . $file->{'tmpname'};
	    $file_location =~ s/\(/\\\(/g;
	    $file_location =~ s/\)/\\\)/g;
            $args =~ s/%%/$file_location/g;
	    &log($logfile, 5, 'DEBUG(' . threads->self()->tid . '): start of ' . $av->{'name'});
            my $out = `$av->{'command'} $args 2>&1`;
            if ($av->{'engine_command'}) {
                my $engine_out = `$av->{'engine_command'}`;
           	    if ($engine_out =~ /$av->{'engine'}/m) {
            	        $engine = $1;
            	        $last_update = $2;
                    } else {
			$engine = 'unknown';
                    }
            } elsif ($out =~ /$av->{'engine'}/m) {
                $engine = $1;
                $last_update = $2;
            } else {
                $engine = 'unknown';
            }
	    if ($av->{'datafile'}) {
	        my @dfiles = split(':', $av->{'datafile'});
		my $curr_last_update = 0;
		foreach my $dfile (@dfiles) {
		    my $info = stat($dfile);
		    if ($info) {
		        $curr_last_update = $info->mtime if ($info->mtime > $curr_last_update);
		        my ($sec, $min, $hours, $day, $mon, $year) = localtime($curr_last_update);
		        $mon++;
		        $year += 1900;
		        $last_update = "$year-$mon-$day $hours:$min:$sec";
		    }
		}
	    }
            if ($av->{'infected'} && $out =~ /$av->{'infected'}/m) {
                my @viruses = $out =~ /$av->{'match'}/gm;
	        @viruses = grep { /.+/ } @viruses;
		$result = join(", ",@viruses);
		&log($logfile, 2, 'DEBUG(' . threads->self()->tid . '): ' . $av->{'name'} . " found viruses $result");
            }
            if ($av->{'packer'} && $out =~ /$av->{'packer'}/m) {
                my @packers = $out =~ /$av->{'packer'}/gm;
		$packer = join(", ",@packers);
		&log($logfile, 2, 'DEBUG(' . threads->self()->tid . '): ' . $av->{'name'} . " found packer $packer");
            }
            $sql = "insert into $db{'prefix'}checks values (?, ?, ?, ?, ?, now(), ?)";
	    $DB->do($sql, undef, $file->{'id'}, $name, $engine, $last_update, $result, $packer);
	    &log($logfile, 5, 'DEBUG(' . threads->self()->tid . '): stop of ' . $av->{'name'});
        }
    }
    $sql = "update $db{'prefix'}files set status_id = 3 where id = ?";
    &log($logfile, 11, "SQL: $sql");
    $DB->do($sql, undef, $file->{'id'}) ;
    $DB->disconnect;
    &log($logfile, 1, 'DEBUG(' . threads->self()->tid . '): end check of file ' . $file->{'tmpname'});
}

my $logfile = $opts{'logfile'};
&log($logfile, 1, "av_check is successfully started");
while(1) {
    my $sql = "select * from $db{'prefix'}files where status_id < 3 order by added";
    &log($logfile, 11, "SQL: $sql");
    my $sth = $DB->prepare($sql) or &log($logfile, 0, "ERROR: Cannot prepare query: $sql\n" . $DB->errstr);
    $sth->execute();
    my $file;
    while (my $row = $sth->fetchrow_hashref) {
	$file = $row;
	my $id = $file->{'id'};
	if ($scans{$id}) {
	    next;
	}
	@threads = threads->list();
	while ($#threads >= $opts{thr_number} - 1) {
	    sleep(1);
	    my @jthreads = threads->list(threads::joinable);
	    foreach my $thr (@jthreads) {
		my $tid = $thr->tid;
		$thr->join();
		&log($logfile, 3, "DEBUG(main): thread $tid is finished (1)");
	    }
	    @threads = threads->list();
	}
	$sql = "update $db{'prefix'}files set status_id = 1 where id = ?";
	&log($logfile, 11, "SQL: $sql");
	$DB->do($sql, undef, $file->{'id'}) ;
	$scans{$id} = threads->new(\&thr_check, $file, $logfile)->tid;
	&log($logfile, 3, "DEBUG(main): file(" . $file->{id} . ") " . $file->{'tmpname'} . ' is added to check with thread ' . $scans{$id});
    } 
    @threads = threads->list(threads::joinable);
    foreach my $thr (@threads) {
	my $tid = $thr->tid;
	$thr->join();
	&log($logfile, 3, "DEBUG(main): thread $tid is finished");
    }
    sleep(1);
}
$DB->disconnect;

