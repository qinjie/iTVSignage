# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.21)
# Database: wired_noticeboard
# Generation Time: 2018-01-26 14:13:22 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table device
# ------------------------------------------------------------

DROP TABLE IF EXISTS `device`;

CREATE TABLE `device` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `remark` varchar(200) DEFAULT NULL,
  `serial` varchar(50) DEFAULT NULL,
  `turn_on_time` time DEFAULT '07:00:00',
  `turn_off_time` time DEFAULT '18:00:00',
  `slide_timing` int(10) unsigned DEFAULT '3000',
  `status` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `playlist_ref` varchar(50) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial` (`serial`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `device_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;

INSERT INTO `device` (`id`, `name`, `remark`, `serial`, `turn_on_time`, `turn_off_time`, `slide_timing`, `status`, `playlist_ref`, `user_id`, `created_at`, `updated_at`)
VALUES
	(1,'Samsung S3','noname',NULL,'07:00:00','18:00:00',5,0,NULL,1,'2017-03-01 17:06:28','2018-01-21 16:17:24'),
	(2,'Asus Zenphone','',NULL,'07:00:00','18:00:00',5,0,NULL,1,'2017-03-01 17:07:19','2018-01-21 16:17:19'),
	(3,'RPi 3','Noticeboard','0000000038a3eddd','10:30:00','18:00:00',5,0,NULL,1,'2017-03-09 09:32:03','2017-05-23 13:44:37'),
	(4,'ECE Noticeboard 01','Noticeboard','00000000d5e1f8fe','07:30:00','17:45:00',5,0,NULL,2,'2017-03-09 09:32:03','2017-05-23 17:28:04'),
	(5,'Test Noticeboard 01','Test Noticeboard 01','00000000000000','07:00:00','18:00:00',5,0,NULL,4,'2017-03-09 09:32:03','2017-05-23 13:44:37'),
	(6,'Test Noticeboard 02','Test Noticeboard 02','000000007dcfc92d','07:00:00','18:00:00',5,0,'FBAh1-c6LXsA-7SpWkiJoG',4,'2017-03-09 09:32:03','2018-01-26 15:33:18'),
	(7,'Police-001','','000000007dcfc91e','00:00:00','22:00:00',5,1,'QyNYz1k6OpB0A4eKVnuBuW',6,'2017-05-22 14:30:04','2018-01-26 15:34:46'),
	(10,'My Device','Testing only','S9JX4VrIKqnjYBEu6ACWbj','07:00:00','19:00:00',3000,2,'FBAh1-c6LXsA-7SpWkiJoG',7,'2018-01-25 06:41:24','2018-01-26 21:48:25'),
	(11,'Your Device','Is this yours?','d8zAE9G-P1XXvQa1eDJzsT','07:00:00','19:00:00',3000,0,'FBAh1-c6LXsA-7SpWkiJoG',7,'2018-01-25 15:35:38','2018-01-26 15:34:35'),
	(12,'Test Device','testing testing testing','ru38cY8jgfDzAxyHjhaKar','07:00:00','19:00:00',3000,0,'QyNYz1k6OpB0A4eKVnuBuW',7,'2018-01-25 22:07:43','2018-01-26 15:34:29');

/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table device_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `device_token`;

CREATE TABLE `device_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned DEFAULT NULL,
  `mac` varchar(32) NOT NULL,
  `ip_address` varchar(32) DEFAULT NULL,
  `token` varchar(32) DEFAULT NULL,
  `expire` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mac` (`mac`),
  UNIQUE KEY `token` (`token`),
  KEY `deviceId` (`device_id`),
  CONSTRAINT `device_token_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `device_token` WRITE;
/*!40000 ALTER TABLE `device_token` DISABLE KEYS */;

INSERT INTO `device_token` (`id`, `device_id`, `mac`, `ip_address`, `token`, `expire`, `created_at`, `updated_at`)
VALUES
	(2,10,'mac-abcd','127.0.3.1','PXbKe4ePiPJP2tR9UnjchsNBBtRxgWTR','2019-01-26 16:38:52','2018-01-26 16:38:52','2018-01-26 20:16:51');

/*!40000 ALTER TABLE `device_token` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table media
# ------------------------------------------------------------

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `playlist_ref` varchar(50) NOT NULL DEFAULT '',
  `file_name` varchar(200) DEFAULT NULL,
  `real_filename` varchar(200) DEFAULT NULL,
  `file_type` varchar(200) DEFAULT NULL,
  `type` varchar(200) DEFAULT NULL,
  `size` int(10) unsigned DEFAULT NULL,
  `width` int(10) unsigned DEFAULT NULL,
  `height` int(10) unsigned DEFAULT NULL,
  `sequence` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;

INSERT INTO `media` (`id`, `playlist_ref`, `file_name`, `real_filename`, `file_type`, `type`, `size`, `width`, `height`, `sequence`, `created_at`, `updated_at`)
VALUES
	(13,'lgcbY_p5BM0KBCbvOn6rBv','1891764-007squirtle.png','25ac45af40445315e4fcecf08afef699.png','image/png','image',379284,618,640,NULL,'2018-01-25 22:22:54',NULL),
	(14,'lgcbY_p5BM0KBCbvOn6rBv','1891759-002ivysaur.png','6a3a7eddc11ed984cbdfe2df873e1b99.png','image/png','image',82229,247,230,NULL,'2018-01-25 22:22:55',NULL),
	(15,'lgcbY_p5BM0KBCbvOn6rBv','005SCdb4gy1fn4i4lfxc7g30f408ihdu.gif','8ad8422b9f4dbb80b3b149ff079ffea4.gif','image/gif','image',2639594,544,306,NULL,'2018-01-25 22:22:55',NULL),
	(16,'lgcbY_p5BM0KBCbvOn6rBv','006DgDOtly1fn5myyb0j1g306c06cu0z _1_.gif','3e3f902532aedcd54587405f137438bb.gif','image/gif','image',4027545,228,228,NULL,'2018-01-25 22:22:55',NULL),
	(17,'lgcbY_p5BM0KBCbvOn6rBv','Screenshot at Jan 07 08-13-08_2.4G.png','08fd3e12cc57e8448bd63e9751f09081.png','image/png','image',135496,1284,1138,NULL,'2018-01-26 05:12:48',NULL),
	(18,'lgcbY_p5BM0KBCbvOn6rBv','A Cloud Guru.pdf','87b6bd71e0d973bec33608ed8516be4a.pdf','application/pdf','pdf',2149842,NULL,NULL,NULL,'2018-01-26 05:14:02',NULL),
	(19,'lgcbY_p5BM0KBCbvOn6rBv','Attendance Made Easy_iOS.mp4','2a27af58b2ca0af25f8fa49954e831f1.mp4','video/mp4','video',7975105,NULL,NULL,NULL,'2018-01-26 05:14:42',NULL),
	(20,'FBAh1-c6LXsA-7SpWkiJoG','1891829-060poliwag.png','38b1fb25ac1112ab3b8571e403319d61.png','image/png','image',59058,260,240,NULL,'2018-01-26 14:31:34',NULL),
	(22,'FBAh1-c6LXsA-7SpWkiJoG','006DgDOtly1fn5myyb0j1g306c06cu0z _1_.gif','59386f6ce4ac8e397e21f07e80075305.gif','image/gif','image',4027545,228,228,NULL,'2018-01-26 14:31:34',NULL),
	(23,'FBAh1-c6LXsA-7SpWkiJoG','568c0004bcc619afd95f.gif','0bf2782b2d9f2d4cb5d44469fc7f4742.gif','image/gif','image',3783543,320,240,NULL,'2018-01-26 14:31:34',NULL),
	(24,'QyNYz1k6OpB0A4eKVnuBuW','88f67bb939.jpg','0713faa176505e4a5b694ce5b39eeddd.jpg','image/jpeg','image',13532,550,445,NULL,'2018-01-26 14:57:15',NULL),
	(25,'QyNYz1k6OpB0A4eKVnuBuW','A Cloud Guru.pdf','5ddded46ffece5812f9f1993c57c0c28.pdf','application/pdf','pdf',2149842,NULL,NULL,NULL,'2018-01-26 14:57:15',NULL);

/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table playlist
# ------------------------------------------------------------

DROP TABLE IF EXISTS `playlist`;

CREATE TABLE `playlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ref` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `detail` varchar(500) DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ref` (`ref`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `playlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;

INSERT INTO `playlist` (`id`, `ref`, `name`, `detail`, `user_id`, `created_at`, `updated_at`)
VALUES
	(3,'lgcbY_p5BM0KBCbvOn6rBv','Good Playlist','Test\r\nTest Test',7,'2018-01-25 22:23:18','2018-01-26 11:10:34'),
	(4,'FBAh1-c6LXsA-7SpWkiJoG','Bad List','Bad bad bad',6,'2018-01-26 14:31:57','2018-01-26 14:57:56'),
	(5,'QyNYz1k6OpB0A4eKVnuBuW','Friday List','Friday friday friday',7,'2018-01-26 14:57:27',NULL);

/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `auth_key` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password_reset_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `role` int(11) NOT NULL DEFAULT '10',
  `status` smallint(6) NOT NULL DEFAULT '10',
  `allowance` int(10) DEFAULT NULL,
  `allowance_updated_at` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password_reset_token` (`password_reset_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`id`, `username`, `auth_key`, `password_hash`, `password_reset_token`, `email`, `role`, `status`, `allowance`, `allowance_updated_at`, `created_at`, `updated_at`)
VALUES
	(1,'admin','vNEwh8r5deHf5bOFR3P5---XJg1EVV3q','$2y$13$yrwZ9mzIsk6JoxnGqvRRX.R2viSh1Jy8ivTA6SHMjBBGIZdTrZoOO','gOIuoR3WfWtKqBEqh8XclbbdfBOfrFi4_1487838150','eceiot.np@gmail.com',40,10,NULL,NULL,'2017-02-23 16:22:30','2017-03-06 14:04:01'),
	(2,'khl2','CkZRssyeTKc-8xJ4cJVlQxSlM3RRyNrJ','$2y$13$.TFtwH13KdTcvryf1qtgPu.IYswl.TrXZxUmwhUUfXLFmQNRGogba','yS2c8rKhyCeQ95Kmb1ALzaeu3xEOu9UH_1491288151','khl2@np.edu.sg',10,10,NULL,NULL,'2017-02-23 15:41:40','2017-04-26 15:50:55'),
	(4,'zqi2','vNEwh8r5deHf5bOFR3P5---XJg1EVV3q','$2y$13$yrwZ9mzIsk6JoxnGqvRRX.R2viSh1Jy8ivTA6SHMjBBGIZdTrZoOO','gOIuoR3WfWtKqBEqh8XclbbdfBOfrFi4_1487838160','qinjie@np.edu.sg',10,10,NULL,NULL,'2017-02-23 16:22:30','2017-03-25 15:27:34'),
	(6,'lsc','vNEwh8r5deHf5bOFR3P5---XJg1EVV3q','$2y$13$yrwZ9mzIsk6JoxnGqvRRX.R2viSh1Jy8ivTA6SHMjBBGIZdTrZoOO',NULL,'LAU_Soon_Cheng@spf.gov.sg',10,10,NULL,NULL,'2017-02-23 16:22:30','2017-03-25 15:27:34'),
	(7,'mark.qj','V4Wq71xfHBHhCuS4mSj8kmyzF5e9ZlgW','$2y$13$m/wcR1jxzw3/uYWWQME6DeB0gU7tGDWcB6Z1OSlBhiz/I57IensxC',NULL,'mark.qj@gmail.com',10,10,9,1516968994,'2018-01-21 21:23:50','2018-01-26 20:16:34');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_setting`;

CREATE TABLE `user_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `open_enroll` int(1) unsigned NOT NULL DEFAULT '1' COMMENT '1: self-register, 0: hand-register',
  `enroll_code` varchar(12) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_setting_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_setting` WRITE;
/*!40000 ALTER TABLE `user_setting` DISABLE KEYS */;

INSERT INTO `user_setting` (`id`, `user_id`, `open_enroll`, `enroll_code`, `created_at`, `updated_at`)
VALUES
	(1,1,1,'bj6ndxk459','2017-04-11 11:30:18','2017-04-11 13:45:39'),
	(2,2,1,'bfdd6qelgvu','2017-04-11 11:30:36','2017-04-11 11:31:27'),
	(3,4,1,'zrl3km3j4u','2017-04-11 11:30:36','2017-04-11 11:31:53');

/*!40000 ALTER TABLE `user_setting` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_token`;

CREATE TABLE `user_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `token` varchar(32) NOT NULL DEFAULT '',
  `label` varchar(20) DEFAULT NULL,
  `mac_address` varchar(32) DEFAULT NULL,
  `expire` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `userId` (`user_id`),
  CONSTRAINT `user_token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_token` WRITE;
/*!40000 ALTER TABLE `user_token` DISABLE KEYS */;

INSERT INTO `user_token` (`id`, `user_id`, `token`, `label`, `mac_address`, `expire`, `created_at`)
VALUES
	(8618,4,'pdBtONi1qhqtyC88z73noc_wl-cRGXYZ','ACCESS','153.20.95.84','2017-04-24 15:43:53','2017-03-24 14:15:07'),
	(8744,1,'-22vH9fpSDhVDfOhtFHDTKr0atU0M_rF','ACCESS','153.20.95.84','2017-04-26 16:09:55','2017-03-27 16:08:44'),
	(8787,2,'HaLPPjMlZA6KKsldN0DHdAoDKPsI7iVr','ACCESS','153.20.95.84','2017-05-03 09:56:57','2017-03-27 17:00:20'),
	(8794,7,'Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA','ACCESS','::1','2018-02-25 20:16:34','2018-01-26 09:40:19');

/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
