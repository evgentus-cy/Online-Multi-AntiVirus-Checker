-- phpMyAdmin SQL Dump
-- version 3.3.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Мар 23 2012 г., 05:11
-- Версия сервера: 5.1.54
-- Версия PHP: 5.3.5-1ubuntu7.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `checker`
--

-- --------------------------------------------------------

--
-- Структура таблицы `checker_checks`
--

CREATE TABLE IF NOT EXISTS `checker_checks` (
  `file_id` int(11) NOT NULL DEFAULT '0',
  `av_name` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `av_ver` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `av_update` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `result` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `packers` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`av_name`,`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `checker_checks`
--


-- --------------------------------------------------------

--
-- Структура таблицы `checker_files`
--

CREATE TABLE IF NOT EXISTS `checker_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `tmpname` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `status_id` int(11) NOT NULL DEFAULT '0',
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `size` int(11) NOT NULL DEFAULT '0',
  `md5` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `sha1` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `checker_files`
--

