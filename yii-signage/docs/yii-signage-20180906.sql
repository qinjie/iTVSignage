-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: iot-centre-rds.crqhd2o1amcg.ap-southeast-1.rds.amazonaws.com
-- Generation Time: Sep 06, 2018 at 02:48 AM
-- Server version: 5.7.19-log
-- PHP Version: 7.2.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+08:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wired_noticeboard2`
--

-- --------------------------------------------------------

--
-- Table structure for table `device`
--

CREATE TABLE `device` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `remark` varchar(200) DEFAULT NULL,
  `serial` varchar(50) DEFAULT NULL,
  `turn_on_time` time DEFAULT '07:00:00',
  `turn_off_time` time DEFAULT '18:00:00',
  `slide_timing` int(10) UNSIGNED DEFAULT '3000',
  `status` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
  `playlist_ref` varchar(50) DEFAULT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `device`
--

INSERT INTO `device` (`id`, `name`, `remark`, `serial`, `turn_on_time`, `turn_off_time`, `slide_timing`, `status`, `playlist_ref`, `user_id`, `created_at`, `updated_at`) VALUES
(7, 'Police-001', '', '000000007dcfc91e', '00:00:00', '22:00:00', 5, 0, 'QyNYz1k6OpB0A4eKVnuBuW', 6, '2017-05-22 14:30:04', '2018-01-31 01:37:34'),
(10, 'My Device', 'Testing only', 'S9JX4VrIKqnjYBEu6ACWbj', '07:00:00', '23:00:00', 3000, 0, 'UlVmuzjzktSHBy6rK1ya2l', 7, '2018-01-25 06:41:24', '2018-01-31 12:25:04'),
(11, 'Your Device', 'Is this yours?', 'd8zAE9G-P1XXvQa1eDJzsT', '07:00:00', '19:00:00', 3000, 0, 'FBAh1-c6LXsA-7SpWkiJoG', 7, '2018-01-25 15:35:38', '2018-01-26 15:34:35'),
(12, 'Test Device', 'testing testing testing', 'ru38cY8jgfDzAxyHjhaKar', '07:00:00', '19:00:00', 3000, 0, 'QyNYz1k6OpB0A4eKVnuBuW', 7, '2018-01-25 22:07:43', '2018-01-26 15:34:29'),
(13, 'Library Device', '', 'DwYvG2yCN0UOMNEIzAw4k3', '09:00:00', '18:00:00', 3000, 0, 'UlVmuzjzktSHBy6rK1ya2l', 7, '2018-03-30 07:24:10', '2018-03-30 09:11:33');

-- --------------------------------------------------------

--
-- Table structure for table `device_token`
--

CREATE TABLE `device_token` (
  `id` int(10) UNSIGNED NOT NULL,
  `device_id` int(10) UNSIGNED DEFAULT NULL,
  `mac` varchar(32) NOT NULL,
  `ip_address` varchar(32) DEFAULT NULL,
  `token` varchar(32) DEFAULT NULL,
  `expire` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `device_token`
--

INSERT INTO `device_token` (`id`, `device_id`, `mac`, `ip_address`, `token`, `expire`, `created_at`, `updated_at`) VALUES
(4, 10, '00000000d5e1f8fe', '192.168.1.31, 169.254.96.47', 'HzZsEpoDe9IHQo8QfoTMo9msCMCFZ20w', '2019-01-30 15:49:57', '2018-01-30 07:49:57', '2018-01-31 09:36:44'),
(5, 13, '00000000035b1b07', '172.17.1.222, 169.254.96.47', 'miJI8qpgn3Iz3V1ZYMWIWHMm3dunmtaq', '2019-03-30 15:25:00', '2018-03-30 07:25:00', '2018-04-05 03:46:19');

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(10) UNSIGNED NOT NULL,
  `playlist_ref` varchar(50) NOT NULL DEFAULT '',
  `file_name` varchar(200) DEFAULT NULL,
  `real_filename` varchar(200) DEFAULT NULL,
  `file_type` varchar(200) DEFAULT NULL,
  `type` varchar(200) DEFAULT NULL,
  `size` int(10) UNSIGNED DEFAULT NULL,
  `width` int(10) UNSIGNED DEFAULT NULL,
  `height` int(10) UNSIGNED DEFAULT NULL,
  `sequence` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `playlist_ref`, `file_name`, `real_filename`, `file_type`, `type`, `size`, `width`, `height`, `sequence`, `created_at`, `updated_at`) VALUES
(37, 'lgcbY_p5BM0KBCbvOn6rBv', '1891819-015beedrill.png', 'a94b94566c19e7570720618eba592b82.png', 'image/png', 'image', 61139, 209, 252, NULL, '2018-01-29 16:35:18', NULL),
(38, 'lgcbY_p5BM0KBCbvOn6rBv', '1891827-058growlithe.png', 'cc500544830edd6c4982845167d17c72.png', 'image/png', 'image', 54583, 162, 230, NULL, '2018-01-29 16:35:18', NULL),
(39, 'lgcbY_p5BM0KBCbvOn6rBv', '1891822-027sandshrew.png', 'e3982a44581c6bd77942075340766e30.png', 'image/png', 'image', 59059, 260, 240, NULL, '2018-01-29 16:35:19', NULL),
(40, 'lgcbY_p5BM0KBCbvOn6rBv', '1891763-006charizard.png', 'a159af7a64296a7c3541ebe90c4736f3.png', 'image/png', 'image', 61059, 260, 200, NULL, '2018-01-29 16:35:19', NULL),
(41, 'lgcbY_p5BM0KBCbvOn6rBv', '1891829-060poliwag.png', 'c227bc81cb2528e16f163f3751aa6d9d.png', 'image/png', 'image', 59058, 260, 240, NULL, '2018-01-29 16:35:19', NULL),
(42, 'lgcbY_p5BM0KBCbvOn6rBv', '1891764-007squirtle.png', 'b02a9005083fdc97b965ee10e03be85a.png', 'image/png', 'image', 379284, 618, 640, NULL, '2018-01-29 16:35:19', NULL),
(60, 'FBAh1-c6LXsA-7SpWkiJoG', 'IMG-20180128-WA0018.jpg', '57ada285e927e858a3052cc1a5b84064.jpg', 'image/jpeg', 'image', 413162, 1600, 1200, NULL, '2018-01-31 09:47:42', NULL),
(83, 'UlVmuzjzktSHBy6rK1ya2l', 'IMG-20180201-WA0012.jpg', '0f188d91618053d71d944b2be72c792e.jpg', 'image/jpeg', 'image', 25432, 425, 440, NULL, '2018-02-02 05:36:54', NULL),
(85, 'UlVmuzjzktSHBy6rK1ya2l', 'images.jpeg', '9690349a8570e00735a32c7695de84de.jpeg', 'image/jpeg', 'image', 12420, 189, 266, NULL, '2018-02-02 05:38:05', NULL),
(86, 'UlVmuzjzktSHBy6rK1ya2l', 'CMOP_Office.jpg', '864b86a68037aab7d5928b2a6e30d95c.jpg', 'image/jpeg', 'image', 296907, 2126, 3091, NULL, '2018-02-02 05:38:08', NULL),
(87, 'UlVmuzjzktSHBy6rK1ya2l', 'Pickpocket.jpg', 'ad76e6f6ec397ae9582f57d86759e217.jpg', 'image/jpeg', 'image', 661058, 2128, 3090, NULL, '2018-02-02 05:38:15', NULL),
(88, 'UlVmuzjzktSHBy6rK1ya2l', 'Outrage of Modesty_A3.jpg', '2c6cc62dfd7286d3f269f73cdfbb42bb.jpg', 'image/jpeg', 'image', 758182, 2126, 3091, NULL, '2018-02-02 05:38:16', NULL),
(89, 'UlVmuzjzktSHBy6rK1ya2l', 'Run Hide Tell - 30 Second Animation _1_.mp4', '017513c055f6e4f55f8422b33e77fa17.mp4', 'video/mp4', 'video', 982333, NULL, NULL, NULL, '2018-02-02 05:39:00', NULL),
(90, 'UlVmuzjzktSHBy6rK1ya2l', 'IMG-20180201-WA0011.jpg', 'cc5681b0cd8f52293e39e23ccc4bd306.jpg', 'image/jpeg', 'image', 23354, 456, 632, NULL, '2018-02-02 06:08:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `playlist`
--

CREATE TABLE `playlist` (
  `id` int(10) UNSIGNED NOT NULL,
  `ref` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `detail` varchar(500) DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `playlist`
--

INSERT INTO `playlist` (`id`, `ref`, `name`, `detail`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 'lgcbY_p5BM0KBCbvOn6rBv', 'Good Playlist', 'Test\r\nTest Test', 7, '2018-01-25 22:23:18', '2018-01-26 11:10:34'),
(4, 'FBAh1-c6LXsA-7SpWkiJoG', 'Bad List', 'Bad bad bad', 6, '2018-01-26 14:31:57', '2018-01-26 14:57:56'),
(5, 'QyNYz1k6OpB0A4eKVnuBuW', 'Friday List', 'Friday friday friday', 7, '2018-01-26 14:57:27', NULL),
(6, 'UlVmuzjzktSHBy6rK1ya2l', 'Singapore police force', 'For spf\r\n', 7, '2018-01-31 12:23:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(10) UNSIGNED NOT NULL,
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
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `auth_key`, `password_hash`, `password_reset_token`, `email`, `role`, `status`, `allowance`, `allowance_updated_at`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'vNEwh8r5deHf5bOFR3P5---XJg1EVV3q', '$2y$13$m/wcR1jxzw3/uYWWQME6DeB0gU7tGDWcB6Z1OSlBhiz/I57IensxC', 'gOIuoR3WfWtKqBEqh8XclbbdfBOfrFi4_1487838150', 'eceiot.np@gmail.com', 40, 10, NULL, NULL, '2017-02-23 16:22:30', '2018-03-30 07:20:12'),
(2, 'khl2', 'CkZRssyeTKc-8xJ4cJVlQxSlM3RRyNrJ', '$2y$13$.TFtwH13KdTcvryf1qtgPu.IYswl.TrXZxUmwhUUfXLFmQNRGogba', 'yS2c8rKhyCeQ95Kmb1ALzaeu3xEOu9UH_1491288151', 'khl2@np.edu.sg', 10, 10, NULL, NULL, '2017-02-23 15:41:40', '2017-04-26 15:50:55'),
(4, 'zqi2', 'vNEwh8r5deHf5bOFR3P5---XJg1EVV3q', '$2y$13$yrwZ9mzIsk6JoxnGqvRRX.R2viSh1Jy8ivTA6SHMjBBGIZdTrZoOO', 'gOIuoR3WfWtKqBEqh8XclbbdfBOfrFi4_1487838160', 'qinjie@np.edu.sg', 10, 10, NULL, NULL, '2017-02-23 16:22:30', '2017-03-25 15:27:34'),
(6, 'lsc', 'vNEwh8r5deHf5bOFR3P5---XJg1EVV3q', '$2y$13$yrwZ9mzIsk6JoxnGqvRRX.R2viSh1Jy8ivTA6SHMjBBGIZdTrZoOO', NULL, 'LAU_Soon_Cheng@spf.gov.sg', 10, 10, NULL, NULL, '2017-02-23 16:22:30', '2017-03-25 15:27:34'),
(7, 'demo', 'V4Wq71xfHBHhCuS4mSj8kmyzF5e9ZlgW', '$2y$13$m/wcR1jxzw3/uYWWQME6DeB0gU7tGDWcB6Z1OSlBhiz/I57IensxC', NULL, 'mark.qj@gmail.com', 10, 10, 9, 1522401408, '2018-01-21 21:23:50', '2018-03-30 09:16:48');

-- --------------------------------------------------------

--
-- Table structure for table `user_setting`
--

CREATE TABLE `user_setting` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `open_enroll` int(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT '1: self-register, 0: hand-register',
  `enroll_code` varchar(12) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_setting`
--

INSERT INTO `user_setting` (`id`, `user_id`, `open_enroll`, `enroll_code`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'bj6ndxk459', '2017-04-11 11:30:18', '2017-04-11 13:45:39'),
(2, 2, 1, 'bfdd6qelgvu', '2017-04-11 11:30:36', '2017-04-11 11:31:27'),
(3, 4, 1, 'zrl3km3j4u', '2017-04-11 11:30:36', '2017-04-11 11:31:53');

-- --------------------------------------------------------

--
-- Table structure for table `user_token`
--

CREATE TABLE `user_token` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token` varchar(32) NOT NULL DEFAULT '',
  `label` varchar(20) DEFAULT NULL,
  `mac_address` varchar(32) DEFAULT NULL,
  `expire` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_token`
--

INSERT INTO `user_token` (`id`, `user_id`, `token`, `label`, `mac_address`, `expire`, `created_at`) VALUES
(8618, 4, 'pdBtONi1qhqtyC88z73noc_wl-cRGXYZ', 'ACCESS', '153.20.95.84', '2017-04-24 15:43:53', '2017-03-24 14:15:07'),
(8744, 1, '-22vH9fpSDhVDfOhtFHDTKr0atU0M_rF', 'ACCESS', '153.20.95.84', '2017-04-26 16:09:55', '2017-03-27 16:08:44'),
(8787, 2, 'HaLPPjMlZA6KKsldN0DHdAoDKPsI7iVr', 'ACCESS', '153.20.95.84', '2017-05-03 09:56:57', '2017-03-27 17:00:20'),
(8794, 7, 'Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA', 'ACCESS', '::1', '2018-02-27 15:02:29', '2018-01-26 09:40:19'),
(8795, 7, 'aH73PQrrKvkk39qX_zmE4n89ApST5c26', 'ACCESS', '::1', '2018-02-27 12:26:52', '2018-01-28 12:26:52'),
(8796, 7, 'u3Ep6FTURGavLnHh7wescaOnmP0WnZ74', 'ACCESS', '::1', '2018-02-27 13:11:44', '2018-01-28 13:11:44'),
(8797, 7, 'js70E7Rs_B2HAHm7-3DlYMJXWTmbCa9h', 'ACCESS', '::1', '2018-02-27 13:29:03', '2018-01-28 13:29:03'),
(8798, 7, 'W-MVkGwDjhLvIkxiyLM2Ju_eIp9iBmxD', 'ACCESS', '::1', '2018-02-27 13:29:09', '2018-01-28 13:29:09'),
(8799, 7, 'wOfIE6W8YPnveEvkA6QyqfN_hQkJ4Z5i', 'ACCESS', '::1', '2018-02-27 13:29:27', '2018-01-28 13:29:27'),
(8800, 7, 'krfeVuspemZdP_7YXZ0bxCzIFJ0Ad4hN', 'ACCESS', '::1', '2018-02-27 13:30:10', '2018-01-28 13:30:10'),
(8801, 7, '6CJndCQH9p7WmjPtWfdeolQmWyRtgDCG', 'ACCESS', '::1', '2018-02-27 13:30:27', '2018-01-28 13:30:27'),
(8802, 7, 'yvZeBMbJfrKwHxnFF8kPCABla_CCTDxq', 'ACCESS', '::1', '2018-02-27 13:36:19', '2018-01-28 13:36:19'),
(8803, 7, 'fyZd9zepvxMzZYJY7RqMsVEbIOFHwuIo', 'ACCESS', '::1', '2018-02-27 14:18:37', '2018-01-28 13:39:53'),
(8804, 7, 'zmaS8IZfx7cDUmT5ApkH0cUERB3WLMTv', 'ACCESS', '::1', '2018-02-27 13:44:59', '2018-01-28 13:44:59'),
(8805, 7, 'jyqvLBQcZR_Ms-bknS_Pe8e1ozP1Ndgl', 'ACCESS', '::1', '2018-02-27 13:50:46', '2018-01-28 13:50:46'),
(8806, 7, '8CkVR1ktNx4ePlQBV7NpdovKvpnAVgr8', 'ACCESS', '::1', '2018-02-27 13:51:26', '2018-01-28 13:51:26'),
(8807, 7, '60KpMDnFVlxRmYovXWmIkeI-0OWl0KSr', 'ACCESS', '::1', '2018-02-27 13:51:50', '2018-01-28 13:51:50'),
(8808, 7, '-PSm9IbWV2yMbnU2raUMok_WIN73xDSL', 'ACCESS', '::1', '2018-02-27 14:16:02', '2018-01-28 14:16:02'),
(8809, 7, 'oRjaboDidthq8-0qXqu6SeER63ngZkV8', 'ACCESS', '::1', '2018-02-27 14:16:33', '2018-01-28 14:16:33'),
(8810, 7, 'UrKVv9VzWWkVtk-GAqLJBBhkgbGF-WZt', 'ACCESS', '::1', '2018-02-27 14:16:55', '2018-01-28 14:16:55'),
(8811, 7, 'jzI8e9gQjRN3cQfQ0PdpjR7blVuXJa0x', 'ACCESS', '::1', '2018-02-27 14:18:43', '2018-01-28 14:18:43'),
(8812, 7, 'bAyyBzQMCLXHIDBviw-6sDJPD1CdLFi6', 'ACCESS', '::1', '2018-02-27 14:20:25', '2018-01-28 14:20:25'),
(8813, 7, 'wnpavIGwZNCrr1OxBpgquQfsd2YX5wzY', 'ACCESS', '::1', '2018-02-27 14:32:13', '2018-01-28 14:32:13'),
(8814, 7, 'Befu7orI46Fs-k799inw77S60QqWitRn', 'ACCESS', '::1', '2018-02-27 14:33:39', '2018-01-28 14:33:39'),
(8815, 7, 'nPqnuXY-Q8bKnG6D8dLnRtCtprmv2ORn', 'ACCESS', '::1', '2018-02-27 14:35:38', '2018-01-28 14:35:38'),
(8816, 7, '0H8sbJZD04HGuVHgIjIuHCtee3V04GTh', 'ACCESS', '::1', '2018-02-27 14:36:05', '2018-01-28 14:36:05'),
(8817, 7, 'GC5GZvAccs9TJDo4i4vX0FPQ7U68OU21', 'ACCESS', '::1', '2018-02-27 14:40:07', '2018-01-28 14:40:07'),
(8818, 7, 'dgV4IdHNnNbzZ-yfsmXcRpPPQeRVagJL', 'ACCESS', '::1', '2018-02-27 14:40:27', '2018-01-28 14:40:27'),
(8819, 7, 'XVjwuEanHKoimxBisXLtfLgoes4XZZqA', 'ACCESS', '::1', '2018-02-27 14:41:25', '2018-01-28 14:41:25'),
(8820, 7, '-cVcydQUJIAYxoN0fcjtzRifsKVUI43J', 'ACCESS', '::1', '2018-02-27 15:02:34', '2018-01-28 15:02:34'),
(8821, 7, 'pkDAkc8rd525_r-dd5n3dHvJo4vQ_AnX', 'ACCESS', '::1', '2018-02-27 15:07:40', '2018-01-28 15:07:40'),
(8822, 7, 'J5C_3UM-RIjIsxu6_ICwQB2VI637UNM1', 'ACCESS', '::1', '2018-02-27 15:13:33', '2018-01-28 15:13:33'),
(8823, 7, 'HOaUATalcHCjYY-BFZNm_uOGr9sgSN3S', 'ACCESS', '::1', '2018-02-27 15:16:05', '2018-01-28 15:16:05'),
(8824, 7, '16svZk267BbEdhhqpeaND8q2TOEPlFPz', 'ACCESS', '::1', '2018-02-27 15:17:20', '2018-01-28 15:17:20'),
(8825, 7, 'He5gWu9AJPkXyw7iICSBvlhNWSTtgVHC', 'ACCESS', '::1', '2018-02-27 15:39:15', '2018-01-28 15:39:15'),
(8826, 7, 'dblfW9CN-OUWFs6Trc5AlEFmTzVOl4EJ', 'ACCESS', '::1', '2018-02-27 15:42:09', '2018-01-28 15:42:09'),
(8827, 7, '3CujKLIZqmj0MMeCwmR8lkZVloH9ede3', 'ACCESS', '::1', '2018-02-28 13:39:00', '2018-01-29 13:39:00'),
(8828, 7, 'dlyLwItIJVxN5TgVdu_cgZYzGikt2Ovk', 'ACCESS', '::1', '2018-02-28 13:42:06', '2018-01-29 13:42:06'),
(8829, 7, 'l90Yd0P4ZcYygvL9ev89su9f8uVy0Llh', 'ACCESS', '::1', '2018-02-28 13:43:38', '2018-01-29 13:43:38'),
(8830, 7, 'L67Vql9vtZGP3tUXUAg3SYYSXedDwxUp', 'ACCESS', '::1', '2018-02-28 13:45:03', '2018-01-29 13:44:11'),
(8831, 7, 'YHaBKwDZ0Nv-n9ExiRUEzYg49BKzz-Ez', 'ACCESS', '::1', '2018-02-28 13:54:44', '2018-01-29 13:54:30'),
(8832, 7, '5mCf6Z0IlJbMEn9We3upXxLOiaiRGdYZ', 'ACCESS', '::1', '2018-02-28 13:55:09', '2018-01-29 13:55:07'),
(8833, 7, 'Po9d7bByBdXJLxKTjqNEGveEsQYorj2f', 'ACCESS', '153.20.95.84', '2018-03-01 15:49:57', '2018-01-30 07:49:53'),
(8834, 7, 'JtaWSciAX8FzFem_bSYDqfARgnJBzbrJ', 'ACCESS', '153.20.95.84', '2018-04-29 15:25:00', '2018-03-30 07:24:53'),
(8835, 7, 'jyma331ZmiKnx8mivTIiI5c2WscxmI9t', 'ACCESS', '153.20.95.84', '2018-04-29 17:16:48', '2018-03-30 09:16:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `device`
--
ALTER TABLE `device`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serial` (`serial`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `device_token`
--
ALTER TABLE `device_token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mac` (`mac`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `deviceId` (`device_id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `playlist`
--
ALTER TABLE `playlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ref` (`ref`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `password_reset_token` (`password_reset_token`);

--
-- Indexes for table `user_setting`
--
ALTER TABLE `user_setting`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_token`
--
ALTER TABLE `user_token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `userId` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `device`
--
ALTER TABLE `device`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `device_token`
--
ALTER TABLE `device_token`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `playlist`
--
ALTER TABLE `playlist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_setting`
--
ALTER TABLE `user_setting`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_token`
--
ALTER TABLE `user_token`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8836;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `device`
--
ALTER TABLE `device`
  ADD CONSTRAINT `device_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `device_token`
--
ALTER TABLE `device_token`
  ADD CONSTRAINT `device_token_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `playlist`
--
ALTER TABLE `playlist`
  ADD CONSTRAINT `playlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_setting`
--
ALTER TABLE `user_setting`
  ADD CONSTRAINT `user_setting_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_token`
--
ALTER TABLE `user_token`
  ADD CONSTRAINT `user_token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
