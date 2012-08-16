#/bin/sh
PS=/bin/ps
GREP=/bin/grep
PATH=/bin:/sbin:/usr/bin:/usr/sbin

if $PS ax | $GREP checker | $GREP -v grep > /dev/null 2>&1; then
   echo "OK"
else
    perl /etc/init.d/checker.pl
fi
