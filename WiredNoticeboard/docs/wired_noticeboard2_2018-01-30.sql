# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.21)
# Database: wired_noticeboard2
# Generation Time: 2018-01-30 07:05:52 +0000
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
	(3,10,'ERROR000000000',', ','7xrQ5J9gHEB5NMFh6r45D5QvMARDDY5G','2019-01-28 15:07:40','2018-01-28 15:07:40','2018-01-29 09:54:24');

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
	(37,'lgcbY_p5BM0KBCbvOn6rBv','1891819-015beedrill.png','a94b94566c19e7570720618eba592b82.png','image/png','image',61139,209,252,NULL,'2018-01-29 16:35:18',NULL),
	(38,'lgcbY_p5BM0KBCbvOn6rBv','1891827-058growlithe.png','cc500544830edd6c4982845167d17c72.png','image/png','image',54583,162,230,NULL,'2018-01-29 16:35:18',NULL),
	(39,'lgcbY_p5BM0KBCbvOn6rBv','1891822-027sandshrew.png','e3982a44581c6bd77942075340766e30.png','image/png','image',59059,260,240,NULL,'2018-01-29 16:35:19',NULL),
	(40,'lgcbY_p5BM0KBCbvOn6rBv','1891763-006charizard.png','a159af7a64296a7c3541ebe90c4736f3.png','image/png','image',61059,260,200,NULL,'2018-01-29 16:35:19',NULL),
	(41,'lgcbY_p5BM0KBCbvOn6rBv','1891829-060poliwag.png','c227bc81cb2528e16f163f3751aa6d9d.png','image/png','image',59058,260,240,NULL,'2018-01-29 16:35:19',NULL),
	(42,'lgcbY_p5BM0KBCbvOn6rBv','1891764-007squirtle.png','b02a9005083fdc97b965ee10e03be85a.png','image/png','image',379284,618,640,NULL,'2018-01-29 16:35:19',NULL),
	(43,'FBAh1-c6LXsA-7SpWkiJoG','1891759-002ivysaur _2_.png','a2a313425f4735e9fa0600c4f05c1e27.png','image/png','image',82229,247,230,NULL,'2018-01-30 15:01:19',NULL),
	(44,'FBAh1-c6LXsA-7SpWkiJoG','1891827-058growlithe _1_.png','8ca8af83b602a406b1b4b36079908cfd.png','image/png','image',54583,162,230,NULL,'2018-01-30 15:01:20',NULL),
	(45,'FBAh1-c6LXsA-7SpWkiJoG','IMG_3965.mp4','db0d8214390cfe0ac2dc8828789b9251.mp4','video/mp4','video',6960258,NULL,NULL,NULL,'2018-01-30 15:01:20',NULL);

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
	(7,'mark.qj','V4Wq71xfHBHhCuS4mSj8kmyzF5e9ZlgW','$2y$13$m/wcR1jxzw3/uYWWQME6DeB0gU7tGDWcB6Z1OSlBhiz/I57IensxC',NULL,'mark.qj@gmail.com',10,10,9,1517205309,'2018-01-21 21:23:50','2018-01-29 13:55:09');

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
	(8794,7,'Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA','ACCESS','::1','2018-02-27 15:02:29','2018-01-26 09:40:19'),
	(8795,7,'aH73PQrrKvkk39qX_zmE4n89ApST5c26','ACCESS','::1','2018-02-27 12:26:52','2018-01-28 12:26:52'),
	(8796,7,'u3Ep6FTURGavLnHh7wescaOnmP0WnZ74','ACCESS','::1','2018-02-27 13:11:44','2018-01-28 13:11:44'),
	(8797,7,'js70E7Rs_B2HAHm7-3DlYMJXWTmbCa9h','ACCESS','::1','2018-02-27 13:29:03','2018-01-28 13:29:03'),
	(8798,7,'W-MVkGwDjhLvIkxiyLM2Ju_eIp9iBmxD','ACCESS','::1','2018-02-27 13:29:09','2018-01-28 13:29:09'),
	(8799,7,'wOfIE6W8YPnveEvkA6QyqfN_hQkJ4Z5i','ACCESS','::1','2018-02-27 13:29:27','2018-01-28 13:29:27'),
	(8800,7,'krfeVuspemZdP_7YXZ0bxCzIFJ0Ad4hN','ACCESS','::1','2018-02-27 13:30:10','2018-01-28 13:30:10'),
	(8801,7,'6CJndCQH9p7WmjPtWfdeolQmWyRtgDCG','ACCESS','::1','2018-02-27 13:30:27','2018-01-28 13:30:27'),
	(8802,7,'yvZeBMbJfrKwHxnFF8kPCABla_CCTDxq','ACCESS','::1','2018-02-27 13:36:19','2018-01-28 13:36:19'),
	(8803,7,'fyZd9zepvxMzZYJY7RqMsVEbIOFHwuIo','ACCESS','::1','2018-02-27 14:18:37','2018-01-28 13:39:53'),
	(8804,7,'zmaS8IZfx7cDUmT5ApkH0cUERB3WLMTv','ACCESS','::1','2018-02-27 13:44:59','2018-01-28 13:44:59'),
	(8805,7,'jyqvLBQcZR_Ms-bknS_Pe8e1ozP1Ndgl','ACCESS','::1','2018-02-27 13:50:46','2018-01-28 13:50:46'),
	(8806,7,'8CkVR1ktNx4ePlQBV7NpdovKvpnAVgr8','ACCESS','::1','2018-02-27 13:51:26','2018-01-28 13:51:26'),
	(8807,7,'60KpMDnFVlxRmYovXWmIkeI-0OWl0KSr','ACCESS','::1','2018-02-27 13:51:50','2018-01-28 13:51:50'),
	(8808,7,'-PSm9IbWV2yMbnU2raUMok_WIN73xDSL','ACCESS','::1','2018-02-27 14:16:02','2018-01-28 14:16:02'),
	(8809,7,'oRjaboDidthq8-0qXqu6SeER63ngZkV8','ACCESS','::1','2018-02-27 14:16:33','2018-01-28 14:16:33'),
	(8810,7,'UrKVv9VzWWkVtk-GAqLJBBhkgbGF-WZt','ACCESS','::1','2018-02-27 14:16:55','2018-01-28 14:16:55'),
	(8811,7,'jzI8e9gQjRN3cQfQ0PdpjR7blVuXJa0x','ACCESS','::1','2018-02-27 14:18:43','2018-01-28 14:18:43'),
	(8812,7,'bAyyBzQMCLXHIDBviw-6sDJPD1CdLFi6','ACCESS','::1','2018-02-27 14:20:25','2018-01-28 14:20:25'),
	(8813,7,'wnpavIGwZNCrr1OxBpgquQfsd2YX5wzY','ACCESS','::1','2018-02-27 14:32:13','2018-01-28 14:32:13'),
	(8814,7,'Befu7orI46Fs-k799inw77S60QqWitRn','ACCESS','::1','2018-02-27 14:33:39','2018-01-28 14:33:39'),
	(8815,7,'nPqnuXY-Q8bKnG6D8dLnRtCtprmv2ORn','ACCESS','::1','2018-02-27 14:35:38','2018-01-28 14:35:38'),
	(8816,7,'0H8sbJZD04HGuVHgIjIuHCtee3V04GTh','ACCESS','::1','2018-02-27 14:36:05','2018-01-28 14:36:05'),
	(8817,7,'GC5GZvAccs9TJDo4i4vX0FPQ7U68OU21','ACCESS','::1','2018-02-27 14:40:07','2018-01-28 14:40:07'),
	(8818,7,'dgV4IdHNnNbzZ-yfsmXcRpPPQeRVagJL','ACCESS','::1','2018-02-27 14:40:27','2018-01-28 14:40:27'),
	(8819,7,'XVjwuEanHKoimxBisXLtfLgoes4XZZqA','ACCESS','::1','2018-02-27 14:41:25','2018-01-28 14:41:25'),
	(8820,7,'-cVcydQUJIAYxoN0fcjtzRifsKVUI43J','ACCESS','::1','2018-02-27 15:02:34','2018-01-28 15:02:34'),
	(8821,7,'pkDAkc8rd525_r-dd5n3dHvJo4vQ_AnX','ACCESS','::1','2018-02-27 15:07:40','2018-01-28 15:07:40'),
	(8822,7,'J5C_3UM-RIjIsxu6_ICwQB2VI637UNM1','ACCESS','::1','2018-02-27 15:13:33','2018-01-28 15:13:33'),
	(8823,7,'HOaUATalcHCjYY-BFZNm_uOGr9sgSN3S','ACCESS','::1','2018-02-27 15:16:05','2018-01-28 15:16:05'),
	(8824,7,'16svZk267BbEdhhqpeaND8q2TOEPlFPz','ACCESS','::1','2018-02-27 15:17:20','2018-01-28 15:17:20'),
	(8825,7,'He5gWu9AJPkXyw7iICSBvlhNWSTtgVHC','ACCESS','::1','2018-02-27 15:39:15','2018-01-28 15:39:15'),
	(8826,7,'dblfW9CN-OUWFs6Trc5AlEFmTzVOl4EJ','ACCESS','::1','2018-02-27 15:42:09','2018-01-28 15:42:09'),
	(8827,7,'3CujKLIZqmj0MMeCwmR8lkZVloH9ede3','ACCESS','::1','2018-02-28 13:39:00','2018-01-29 13:39:00'),
	(8828,7,'dlyLwItIJVxN5TgVdu_cgZYzGikt2Ovk','ACCESS','::1','2018-02-28 13:42:06','2018-01-29 13:42:06'),
	(8829,7,'l90Yd0P4ZcYygvL9ev89su9f8uVy0Llh','ACCESS','::1','2018-02-28 13:43:38','2018-01-29 13:43:38'),
	(8830,7,'L67Vql9vtZGP3tUXUAg3SYYSXedDwxUp','ACCESS','::1','2018-02-28 13:45:03','2018-01-29 13:44:11'),
	(8831,7,'YHaBKwDZ0Nv-n9ExiRUEzYg49BKzz-Ez','ACCESS','::1','2018-02-28 13:54:44','2018-01-29 13:54:30'),
	(8832,7,'5mCf6Z0IlJbMEn9We3upXxLOiaiRGdYZ','ACCESS','::1','2018-02-28 13:55:09','2018-01-29 13:55:07');

/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
