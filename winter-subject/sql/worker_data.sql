/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : localhost:3306
 Source Schema         : worker_data

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 10/02/2025 17:33:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for move_history
-- ----------------------------
DROP TABLE IF EXISTS `move_history`;
CREATE TABLE `move_history`  (
  `move_history_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `worker_id` int UNSIGNED NOT NULL,
  `x` int NOT NULL,
  `y` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `cumulative_dust` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`move_history_id`) USING BTREE,
  INDEX `idx_worker_time`(`worker_id` ASC, `start_time` ASC, `end_time` ASC) USING BTREE,
  INDEX `idx_position_time`(`x` ASC, `y` ASC, `start_time` ASC, `end_time` ASC) USING BTREE,
  CONSTRAINT `move_history_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `worker` (`worker_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 383 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of move_history
-- ----------------------------
INSERT INTO `move_history` VALUES (260, 50, 0, 0, '2025-01-12 23:32:01', '2025-01-12 23:32:04', 0);
INSERT INTO `move_history` VALUES (261, 51, 0, 0, '2025-01-12 23:33:02', '2025-01-12 23:33:04', 0);
INSERT INTO `move_history` VALUES (262, 52, 1, 0, '2025-01-12 23:33:22', '2025-01-12 23:33:24', 0);
INSERT INTO `move_history` VALUES (263, 53, 1, 0, '2025-01-12 23:33:34', '2025-01-12 23:33:35', 0);
INSERT INTO `move_history` VALUES (264, 54, 2, 0, '2025-01-12 23:33:58', '2025-01-12 23:34:02', 0);
INSERT INTO `move_history` VALUES (265, 55, 2, 0, '2025-01-12 23:34:09', '2025-01-12 23:34:10', 0);
INSERT INTO `move_history` VALUES (266, 56, 2, 0, '2025-01-12 23:34:16', '2025-01-12 23:34:18', 0);
INSERT INTO `move_history` VALUES (267, 57, 2, 0, '2025-01-12 23:34:26', '2025-01-12 23:34:30', 0);
INSERT INTO `move_history` VALUES (268, 58, 2, 0, '2025-01-12 23:34:51', '2025-01-12 23:34:53', 0);
INSERT INTO `move_history` VALUES (269, 59, 2, 0, '2025-01-12 23:35:02', '2025-01-12 23:35:03', 0);
INSERT INTO `move_history` VALUES (270, 60, 7, 0, '2025-01-12 23:35:28', '2025-01-12 23:35:31', 0);
INSERT INTO `move_history` VALUES (271, 61, 7, 0, '2025-01-12 23:35:46', '2025-01-12 23:35:49', 0);
INSERT INTO `move_history` VALUES (272, 62, 6, 0, '2025-01-12 23:35:58', '2025-01-12 23:36:01', 0);
INSERT INTO `move_history` VALUES (273, 58, 1, 0, '2025-01-13 00:08:36', '2025-01-13 00:08:41', 6.78765);
INSERT INTO `move_history` VALUES (274, 59, 2, 1, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 1.44997);
INSERT INTO `move_history` VALUES (275, 54, 1, 0, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 10.0874);
INSERT INTO `move_history` VALUES (276, 62, 6, 1, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 13.61);
INSERT INTO `move_history` VALUES (277, 57, 1, 0, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 11.5233);
INSERT INTO `move_history` VALUES (278, 52, 2, 0, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 2.0471);
INSERT INTO `move_history` VALUES (279, 50, 0, 1, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 7.02603);
INSERT INTO `move_history` VALUES (280, 57, 0, 0, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 14.9442);
INSERT INTO `move_history` VALUES (281, 62, 6, 0, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 18.9907);
INSERT INTO `move_history` VALUES (282, 60, 7, 1, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 13.298);
INSERT INTO `move_history` VALUES (283, 54, 1, 1, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 11.4874);
INSERT INTO `move_history` VALUES (284, 55, 1, 0, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 12.0918);
INSERT INTO `move_history` VALUES (285, 52, 1, 0, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 14.5242);
INSERT INTO `move_history` VALUES (286, 58, 0, 0, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 12.7365);
INSERT INTO `move_history` VALUES (287, 55, 0, 0, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 18.0418);
INSERT INTO `move_history` VALUES (288, 59, 2, 2, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 12.0372);
INSERT INTO `move_history` VALUES (289, 52, 1, 1, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 22.3115);
INSERT INTO `move_history` VALUES (290, 62, 7, 0, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 23.8819);
INSERT INTO `move_history` VALUES (291, 57, 0, 1, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 26.3269);
INSERT INTO `move_history` VALUES (292, 56, 1, 0, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 13.2426);
INSERT INTO `move_history` VALUES (293, 59, 1, 2, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 22.077);
INSERT INTO `move_history` VALUES (294, 51, 0, 1, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 11.5106);
INSERT INTO `move_history` VALUES (295, 57, 0, 0, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 35.3558);
INSERT INTO `move_history` VALUES (296, 62, 6, 0, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 35.7358);
INSERT INTO `move_history` VALUES (297, 56, 0, 0, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 19.0189);
INSERT INTO `move_history` VALUES (298, 61, 7, 1, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 6.4278);
INSERT INTO `move_history` VALUES (299, 54, 2, 1, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 13.2306);
INSERT INTO `move_history` VALUES (300, 51, 0, 0, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 14.0147);
INSERT INTO `move_history` VALUES (301, 57, 0, 1, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 43.997);
INSERT INTO `move_history` VALUES (302, 55, 0, 1, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 23.6782);
INSERT INTO `move_history` VALUES (303, 53, 1, 1, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 3.81867);
INSERT INTO `move_history` VALUES (304, 50, 0, 0, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 17.4373);
INSERT INTO `move_history` VALUES (305, 58, 1, 0, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 15.2731);
INSERT INTO `move_history` VALUES (306, 54, 2, 2, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 27.1519);
INSERT INTO `move_history` VALUES (307, 59, 2, 2, '2025-01-13 00:10:50', '2025-01-13 00:10:55', 31.8522);
INSERT INTO `move_history` VALUES (308, 61, 7, 0, '2025-01-13 00:10:50', '2025-01-13 00:10:55', 15.1774);
INSERT INTO `move_history` VALUES (309, 51, 0, 1, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 23.8661);
INSERT INTO `move_history` VALUES (310, 53, 2, 1, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 17.3908);
INSERT INTO `move_history` VALUES (311, 62, 6, 1, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 43.0224);
INSERT INTO `move_history` VALUES (312, 51, 0, 2, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 31.3639);
INSERT INTO `move_history` VALUES (313, 54, 2, 3, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 34.1569);
INSERT INTO `move_history` VALUES (314, 58, 0, 0, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 29.3842);
INSERT INTO `move_history` VALUES (315, 62, 6, 2, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 47.1846);
INSERT INTO `move_history` VALUES (316, 52, 1, 0, '2025-01-13 00:11:35', '2025-01-13 00:11:40', 28.3258);
INSERT INTO `move_history` VALUES (317, 53, 1, 1, '2025-01-13 00:11:35', '2025-01-13 00:11:40', 31.7971);
INSERT INTO `move_history` VALUES (318, 57, 1, 1, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 52.6055);
INSERT INTO `move_history` VALUES (319, 55, 0, 2, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 28.1875);
INSERT INTO `move_history` VALUES (320, 59, 3, 2, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 38.2171);
INSERT INTO `move_history` VALUES (321, 51, 1, 2, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 39.0592);
INSERT INTO `move_history` VALUES (322, 51, 0, 2, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 47.8005);
INSERT INTO `move_history` VALUES (323, 54, 3, 3, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 47.4827);
INSERT INTO `move_history` VALUES (324, 58, 1, 0, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 33.107);
INSERT INTO `move_history` VALUES (325, 53, 2, 1, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 36.724);
INSERT INTO `move_history` VALUES (326, 50, 1, 0, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 22.6419);
INSERT INTO `move_history` VALUES (327, 57, 1, 2, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 57.2266);
INSERT INTO `move_history` VALUES (328, 52, 0, 0, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 34.6582);
INSERT INTO `move_history` VALUES (329, 58, 0, 0, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 37.6248);
INSERT INTO `move_history` VALUES (330, 62, 6, 1, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 54.9953);
INSERT INTO `move_history` VALUES (331, 50, 2, 0, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 25.6853);
INSERT INTO `move_history` VALUES (332, 61, 7, 1, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 22.9607);
INSERT INTO `move_history` VALUES (333, 50, 1, 0, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 36.2268);
INSERT INTO `move_history` VALUES (334, 62, 6, 2, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 61.1449);
INSERT INTO `move_history` VALUES (335, 53, 1, 1, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 48.5367);
INSERT INTO `move_history` VALUES (336, 56, 0, 1, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 32.2542);
INSERT INTO `move_history` VALUES (337, 62, 6, 3, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 65.692);
INSERT INTO `move_history` VALUES (338, 53, 2, 1, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 59.5392);
INSERT INTO `move_history` VALUES (339, 51, 0, 1, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 52.2219);
INSERT INTO `move_history` VALUES (340, 60, 7, 2, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 25.3066);
INSERT INTO `move_history` VALUES (341, 55, 1, 2, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 33.4692);
INSERT INTO `move_history` VALUES (342, 51, 0, 2, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 60.7482);
INSERT INTO `move_history` VALUES (343, 50, 1, 1, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 43.3091);
INSERT INTO `move_history` VALUES (344, 52, 0, 1, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 36.2687);
INSERT INTO `move_history` VALUES (345, 62, 5, 3, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 70.1898);
INSERT INTO `move_history` VALUES (346, 60, 7, 1, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 34.6945);
INSERT INTO `move_history` VALUES (347, 54, 3, 4, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 61.7357);
INSERT INTO `move_history` VALUES (348, 56, 1, 1, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 42.8552);
INSERT INTO `move_history` VALUES (349, 55, 1, 3, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 40.8154);
INSERT INTO `move_history` VALUES (350, 51, 1, 2, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 72.6089);
INSERT INTO `move_history` VALUES (351, 50, 0, 1, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 52.6275);
INSERT INTO `move_history` VALUES (352, 55, 0, 3, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 51.3963);
INSERT INTO `move_history` VALUES (353, 62, 4, 3, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 76.7445);
INSERT INTO `move_history` VALUES (354, 56, 2, 1, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 55.5614);
INSERT INTO `move_history` VALUES (355, 57, 0, 2, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 65.7204);
INSERT INTO `move_history` VALUES (356, 52, 0, 0, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 47.7706);
INSERT INTO `move_history` VALUES (357, 62, 3, 3, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 88.3188);
INSERT INTO `move_history` VALUES (358, 61, 7, 0, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 35.3544);
INSERT INTO `move_history` VALUES (359, 56, 2, 2, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 62.3469);
INSERT INTO `move_history` VALUES (360, 59, 4, 2, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 44.9823);
INSERT INTO `move_history` VALUES (361, 54, 3, 3, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 66.6796);
INSERT INTO `move_history` VALUES (362, 55, 1, 3, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 66.2162);
INSERT INTO `move_history` VALUES (363, 59, 4, 1, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 52.0709);
INSERT INTO `move_history` VALUES (364, 55, 1, 2, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 75.2967);
INSERT INTO `move_history` VALUES (365, 62, 3, 4, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 91.0633);
INSERT INTO `move_history` VALUES (366, 60, 7, 0, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 48.3748);
INSERT INTO `move_history` VALUES (367, 53, 3, 1, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 61.9769);
INSERT INTO `move_history` VALUES (368, 59, 4, 2, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 63.8869);
INSERT INTO `move_history` VALUES (369, 55, 2, 2, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 86.1931);
INSERT INTO `move_history` VALUES (370, 51, 2, 2, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 82.1204);
INSERT INTO `move_history` VALUES (371, 62, 4, 4, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 92.08);
INSERT INTO `move_history` VALUES (372, 56, 2, 3, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 66.8371);
INSERT INTO `move_history` VALUES (373, 58, 0, 1, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 38.7347);
INSERT INTO `move_history` VALUES (374, 51, 2, 1, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 92.1256);
INSERT INTO `move_history` VALUES (375, 50, 0, 2, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 55.1644);
INSERT INTO `move_history` VALUES (376, 59, 4, 1, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 72.6789);
INSERT INTO `move_history` VALUES (377, 55, 3, 2, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 99.2494);
INSERT INTO `move_history` VALUES (378, 61, 6, 0, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 38.1204);
INSERT INTO `move_history` VALUES (379, 52, 0, 1, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 56.9175);
INSERT INTO `move_history` VALUES (380, 50, 0, 1, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 62.2561);
INSERT INTO `move_history` VALUES (381, 62, 4, 3, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 100.761);
INSERT INTO `move_history` VALUES (382, 58, 1, 1, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 49.1327);

-- ----------------------------
-- Table structure for sensor
-- ----------------------------
DROP TABLE IF EXISTS `sensor`;
CREATE TABLE `sensor`  (
  `sensor_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `x` int NOT NULL,
  `y` int NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `video_src` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sensor_id`) USING BTREE,
  UNIQUE INDEX `unique_region`(`x` ASC, `y` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sensor
-- ----------------------------
INSERT INTO `sensor` VALUES (11, 6, 0, '2025-01-12 23:37:26', 'fake_video_src');
INSERT INTO `sensor` VALUES (12, 5, 0, '2025-01-12 23:37:59', 'fake_video_src');
INSERT INTO `sensor` VALUES (13, 1, 4, '2025-01-12 23:38:11', 'fake_video_src');

-- ----------------------------
-- Table structure for sensor_history
-- ----------------------------
DROP TABLE IF EXISTS `sensor_history`;
CREATE TABLE `sensor_history`  (
  `sensor_history_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sensor_id` int UNSIGNED NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `dust` float NOT NULL,
  `humidity` float NOT NULL,
  `temperature` float NOT NULL,
  PRIMARY KEY (`sensor_history_id`) USING BTREE,
  INDEX `idx_sensor_time`(`sensor_id` ASC, `start_time` ASC, `end_time` ASC) USING BTREE,
  CONSTRAINT `sensor_history_ibfk_1` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`sensor_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 800 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sensor_history
-- ----------------------------
INSERT INTO `sensor_history` VALUES (710, 11, '2025-01-12 23:37:26', '2025-01-12 23:37:31', 4.27157, 50.9934, 26.1781);
INSERT INTO `sensor_history` VALUES (711, 12, '2025-01-12 23:37:59', '2025-01-12 23:38:04', 12.5711, 66.7918, 37.3662);
INSERT INTO `sensor_history` VALUES (712, 13, '2025-01-12 23:38:11', '2025-01-12 23:38:16', 6.91955, 58.9006, 33.9444);
INSERT INTO `sensor_history` VALUES (713, 11, '2025-01-13 00:08:35', '2025-01-13 00:08:40', 12.9952, 56.8457, 39.7971);
INSERT INTO `sensor_history` VALUES (714, 12, '2025-01-13 00:08:35', '2025-01-13 00:08:40', 7.16381, 63.5073, 30.9731);
INSERT INTO `sensor_history` VALUES (715, 13, '2025-01-13 00:08:35', '2025-01-13 00:08:40', 13.435, 64.2664, 37.8646);
INSERT INTO `sensor_history` VALUES (716, 11, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 2.87126, 52.7567, 38.0895);
INSERT INTO `sensor_history` VALUES (717, 12, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 10.3626, 68.4672, 37.9994);
INSERT INTO `sensor_history` VALUES (718, 13, '2025-01-13 00:08:50', '2025-01-13 00:08:55', 12.6197, 67.7703, 43.8248);
INSERT INTO `sensor_history` VALUES (719, 11, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 2.97188, 61.4249, 26.6989);
INSERT INTO `sensor_history` VALUES (720, 12, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 14.581, 63.5518, 31.0139);
INSERT INTO `sensor_history` VALUES (721, 13, '2025-01-13 00:09:05', '2025-01-13 00:09:10', 13.8771, 52.1228, 32.5166);
INSERT INTO `sensor_history` VALUES (722, 11, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 11.6006, 59.4976, 32.2666);
INSERT INTO `sensor_history` VALUES (723, 12, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 1.78396, 62.6029, 43.9072);
INSERT INTO `sensor_history` VALUES (724, 13, '2025-01-13 00:09:20', '2025-01-13 00:09:25', 11.6805, 51.2397, 41.7805);
INSERT INTO `sensor_history` VALUES (725, 11, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 9.61644, 52.9527, 27.9731);
INSERT INTO `sensor_history` VALUES (726, 12, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 2.14692, 62.3271, 27.0664);
INSERT INTO `sensor_history` VALUES (727, 13, '2025-01-13 00:09:35', '2025-01-13 00:09:40', 4.45827, 60.6, 43.5888);
INSERT INTO `sensor_history` VALUES (728, 11, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 1.24346, 57.3622, 25.5339);
INSERT INTO `sensor_history` VALUES (729, 12, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 2.50759, 58.0113, 42.0495);
INSERT INTO `sensor_history` VALUES (730, 13, '2025-01-13 00:09:50', '2025-01-13 00:09:55', 3.42335, 64.7823, 27.8235);
INSERT INTO `sensor_history` VALUES (731, 11, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 13.5234, 50.0523, 34.1122);
INSERT INTO `sensor_history` VALUES (732, 12, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 9.16049, 63.0887, 44.3548);
INSERT INTO `sensor_history` VALUES (733, 13, '2025-01-13 00:10:05', '2025-01-13 00:10:10', 3.49019, 58.0694, 28.0189);
INSERT INTO `sensor_history` VALUES (734, 11, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 2.38294, 63.9548, 31.8352);
INSERT INTO `sensor_history` VALUES (735, 12, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 3.86185, 54.5251, 32.7169);
INSERT INTO `sensor_history` VALUES (736, 13, '2025-01-13 00:10:20', '2025-01-13 00:10:25', 8.70685, 56.7899, 25.3001);
INSERT INTO `sensor_history` VALUES (737, 11, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 9.182, 64.6108, 43.015);
INSERT INTO `sensor_history` VALUES (738, 12, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 2.87405, 66.323, 28.9934);
INSERT INTO `sensor_history` VALUES (739, 13, '2025-01-13 00:10:35', '2025-01-13 00:10:40', 14.0138, 63.3786, 36.7499);
INSERT INTO `sensor_history` VALUES (740, 11, '2025-01-13 00:10:50', '2025-01-13 00:10:55', 6.86289, 64.7986, 26.1857);
INSERT INTO `sensor_history` VALUES (741, 12, '2025-01-13 00:10:50', '2025-01-13 00:10:55', 14.5929, 57.1419, 43.6118);
INSERT INTO `sensor_history` VALUES (742, 13, '2025-01-13 00:10:50', '2025-01-13 00:10:55', 12.5843, 61.1935, 30.7784);
INSERT INTO `sensor_history` VALUES (743, 11, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 10.9411, 67.6396, 35.0578);
INSERT INTO `sensor_history` VALUES (744, 12, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 14.6403, 66.6662, 26.2698);
INSERT INTO `sensor_history` VALUES (745, 13, '2025-01-13 00:11:05', '2025-01-13 00:11:10', 11.5971, 53.1634, 31.0319);
INSERT INTO `sensor_history` VALUES (746, 11, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 6.88808, 57.698, 28.2835);
INSERT INTO `sensor_history` VALUES (747, 12, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 1.27351, 62.5821, 39.445);
INSERT INTO `sensor_history` VALUES (748, 13, '2025-01-13 00:11:20', '2025-01-13 00:11:25', 7.55199, 61.0555, 39.9481);
INSERT INTO `sensor_history` VALUES (749, 11, '2025-01-13 00:11:35', '2025-01-13 00:11:40', 7.59133, 50.7973, 29.1028);
INSERT INTO `sensor_history` VALUES (750, 12, '2025-01-13 00:11:35', '2025-01-13 00:11:40', 7.82269, 68.8001, 38.4672);
INSERT INTO `sensor_history` VALUES (751, 13, '2025-01-13 00:11:35', '2025-01-13 00:11:40', 2.78408, 50.5523, 34.0486);
INSERT INTO `sensor_history` VALUES (752, 11, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 10.3352, 64.1695, 36.2071);
INSERT INTO `sensor_history` VALUES (753, 12, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 5.47951, 62.5206, 29.4629);
INSERT INTO `sensor_history` VALUES (754, 13, '2025-01-13 00:11:50', '2025-01-13 00:11:55', 8.74338, 59.9902, 35.6201);
INSERT INTO `sensor_history` VALUES (755, 11, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 3.46352, 67.4853, 36.9067);
INSERT INTO `sensor_history` VALUES (756, 12, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 11.9894, 55.5272, 31.9757);
INSERT INTO `sensor_history` VALUES (757, 13, '2025-01-13 00:12:05', '2025-01-13 00:12:10', 6.84224, 63.2257, 36.6414);
INSERT INTO `sensor_history` VALUES (758, 11, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 10.8365, 65.0363, 26.6475);
INSERT INTO `sensor_history` VALUES (759, 12, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 10.9134, 54.7574, 25.8508);
INSERT INTO `sensor_history` VALUES (760, 13, '2025-01-13 00:12:20', '2025-01-13 00:12:25', 6.79982, 51.7735, 43.2926);
INSERT INTO `sensor_history` VALUES (761, 11, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 3.08104, 69.5129, 26.7163);
INSERT INTO `sensor_history` VALUES (762, 12, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 9.92991, 55.6363, 33.6437);
INSERT INTO `sensor_history` VALUES (763, 13, '2025-01-13 00:12:35', '2025-01-13 00:12:40', 4.85559, 56.0078, 41.0559);
INSERT INTO `sensor_history` VALUES (764, 11, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 8.27485, 55.9239, 33.3556);
INSERT INTO `sensor_history` VALUES (765, 12, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 9.70639, 52.2994, 36.0612);
INSERT INTO `sensor_history` VALUES (766, 13, '2025-01-13 00:12:50', '2025-01-13 00:12:55', 5.48907, 56.817, 29.3315);
INSERT INTO `sensor_history` VALUES (767, 11, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 3.1975, 65.9389, 30.8411);
INSERT INTO `sensor_history` VALUES (768, 12, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 8.65712, 51.7365, 28.7211);
INSERT INTO `sensor_history` VALUES (769, 13, '2025-01-13 00:13:05', '2025-01-13 00:13:10', 10.1682, 68.9028, 42.5544);
INSERT INTO `sensor_history` VALUES (770, 11, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 6.84775, 66.7339, 40.1173);
INSERT INTO `sensor_history` VALUES (771, 12, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 12.9609, 57.071, 42.5484);
INSERT INTO `sensor_history` VALUES (772, 13, '2025-01-13 00:13:20', '2025-01-13 00:13:25', 2.1206, 61.537, 33.0126);
INSERT INTO `sensor_history` VALUES (773, 11, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 11.372, 60.3278, 31.017);
INSERT INTO `sensor_history` VALUES (774, 12, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 1.74743, 66.1526, 42.745);
INSERT INTO `sensor_history` VALUES (775, 13, '2025-01-13 00:13:35', '2025-01-13 00:13:40', 11.8432, 61.8788, 29.402);
INSERT INTO `sensor_history` VALUES (776, 11, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 10.6473, 69.0477, 37.7996);
INSERT INTO `sensor_history` VALUES (777, 12, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 14.6648, 50.6107, 37.682);
INSERT INTO `sensor_history` VALUES (778, 13, '2025-01-13 00:13:50', '2025-01-13 00:13:55', 3.32011, 64.1388, 44.1987);
INSERT INTO `sensor_history` VALUES (779, 11, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 12.5928, 65.7478, 34.393);
INSERT INTO `sensor_history` VALUES (780, 12, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 7.541, 53.5315, 43.4396);
INSERT INTO `sensor_history` VALUES (781, 13, '2025-01-13 00:14:05', '2025-01-13 00:14:10', 8.95983, 54.1521, 32.5269);
INSERT INTO `sensor_history` VALUES (782, 11, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 12.7654, 65.5874, 35.2338);
INSERT INTO `sensor_history` VALUES (783, 12, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 13.8977, 66.9643, 29.9697);
INSERT INTO `sensor_history` VALUES (784, 13, '2025-01-13 00:14:20', '2025-01-13 00:14:25', 2.59902, 63.1608, 43.127);
INSERT INTO `sensor_history` VALUES (785, 11, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 13.5938, 59.1876, 28.0546);
INSERT INTO `sensor_history` VALUES (786, 12, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 7.04955, 69.8819, 44.8753);
INSERT INTO `sensor_history` VALUES (787, 13, '2025-01-13 00:14:35', '2025-01-13 00:14:40', 4.46402, 57.362, 28.4672);
INSERT INTO `sensor_history` VALUES (788, 11, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 3.50665, 51.5081, 37.7623);
INSERT INTO `sensor_history` VALUES (789, 12, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 4.38421, 58.1905, 41.7095);
INSERT INTO `sensor_history` VALUES (790, 13, '2025-01-13 00:14:50', '2025-01-13 00:14:55', 5.26804, 68.2316, 26.7404);
INSERT INTO `sensor_history` VALUES (791, 11, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 2.15065, 69.0927, 27.031);
INSERT INTO `sensor_history` VALUES (792, 12, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 4.58461, 59.287, 36.9192);
INSERT INTO `sensor_history` VALUES (793, 13, '2025-01-13 00:15:05', '2025-01-13 00:15:10', 7.04283, 54.6594, 39.8402);
INSERT INTO `sensor_history` VALUES (794, 11, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 3.86618, 64.1833, 32.9362);
INSERT INTO `sensor_history` VALUES (795, 12, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 6.04799, 64.0011, 42.7709);
INSERT INTO `sensor_history` VALUES (796, 13, '2025-01-13 00:15:20', '2025-01-13 00:15:25', 5.21068, 62.1982, 31.4811);
INSERT INTO `sensor_history` VALUES (797, 11, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 9.22811, 69.6863, 43.6825);
INSERT INTO `sensor_history` VALUES (798, 12, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 12.9589, 62.6525, 39.5363);
INSERT INTO `sensor_history` VALUES (799, 13, '2025-01-13 00:15:35', '2025-01-13 00:15:40', 13.93, 52.0933, 34.1432);

-- ----------------------------
-- Table structure for worker
-- ----------------------------
DROP TABLE IF EXISTS `worker`;
CREATE TABLE `worker`  (
  `worker_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `current_area_x` int NOT NULL,
  `current_area_y` int NOT NULL,
  PRIMARY KEY (`worker_id`) USING BTREE,
  INDEX `idx_current_area`(`current_area_x` ASC, `current_area_y` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of worker
-- ----------------------------
INSERT INTO `worker` VALUES (50, '黄豆豆', 0, 1);
INSERT INTO `worker` VALUES (51, '陆阳', 2, 1);
INSERT INTO `worker` VALUES (52, '孟孙', 0, 1);
INSERT INTO `worker` VALUES (53, '周二蛋', 3, 1);
INSERT INTO `worker` VALUES (54, '周扒皮', 3, 3);
INSERT INTO `worker` VALUES (55, '赵构', 3, 2);
INSERT INTO `worker` VALUES (56, '李璇', 2, 3);
INSERT INTO `worker` VALUES (57, '黑二', 0, 2);
INSERT INTO `worker` VALUES (58, '矿主', 1, 1);
INSERT INTO `worker` VALUES (59, '程陈', 4, 1);
INSERT INTO `worker` VALUES (60, '刘秋', 7, 0);
INSERT INTO `worker` VALUES (61, '刘某', 6, 0);
INSERT INTO `worker` VALUES (62, '孙全', 4, 3);

SET FOREIGN_KEY_CHECKS = 1;
