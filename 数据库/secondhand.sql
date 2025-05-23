/*
 Navicat Premium Dump SQL

 Source Server         : 1
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : secondhand

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 23/05/2025 11:47:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `address` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (3, '李四', '江西省红谷滩区', '18634208045', 1);
INSERT INTO `address` VALUES (4, '李四', '河南省郑州市中原区无名小区', '18634208045', 1);
INSERT INTO `address` VALUES (5, '李四', '河北', '17512341234', 3);
INSERT INTO `address` VALUES (6, 'chusheng', '江西省南昌市南昌大学前湖校区', '12345609897', 5);
INSERT INTO `address` VALUES (7, 'yjy', '南昌大学', '1213', 7);
INSERT INTO `address` VALUES (8, 'gkn', '南昌大学前湖校区天健园27栋', '123123123', 9);
INSERT INTO `address` VALUES (9, '张三', '南昌大学前湖校区信工楼E119', '17807192211', 2);
INSERT INTO `address` VALUES (10, '张三', '南昌大学前湖校区天健园27栋', '17807192211', 2);
INSERT INTO `address` VALUES (11, 'zmy', '南昌大学前湖校区天健园27栋', '17807192211', 6);
INSERT INTO `address` VALUES (12, 'xyt', '南昌大学前湖校区天健园27栋', '17807192211', 8);

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '123456', '管理员', '18634208045', '123@qq.com', 'http://localhost:9090/files/1745998231199-ChatGPT Image 2025年4月25日 22_59_36.png', 'ADMIN');

-- ----------------------------
-- Table structure for ai_chat_history
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_history`;
CREATE TABLE `ai_chat_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `sender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发送方（user/ai）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '聊天内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与AI客服聊天记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_history
-- ----------------------------
INSERT INTO `ai_chat_history` VALUES (1, 5, 'user', '你好', '2025-05-23 11:38:42');
INSERT INTO `ai_chat_history` VALUES (2, 5, 'ai', '\n\n你好！有什么可以帮助你的吗？', '2025-05-23 11:38:50');
INSERT INTO `ai_chat_history` VALUES (3, 5, 'user', '我想购买一个耳机', '2025-05-23 11:39:06');
INSERT INTO `ai_chat_history` VALUES (4, 5, 'ai', '\n\n您好！您想购买一个耳机吗？这是一个非常实用的电子设备，可以帮助您放松心情、聆听音乐或收音。以下是关于如何购买耳机的一些建议：\n\n1. **价格范围**  \n   耳机通常售价在100元到200元左右，这是合理的预算范围。许多商家提供促销活动，您可以先查看是否有优惠券或折扣。\n\n2. **售后服务**  \n   耳朵是电子产品，如果出现问题（如声音不好、损坏等），您可以通过售后服务进行维修或更换。大多数耳机品牌都有明确的售后服务承诺。\n\n3. **购买渠道**  \n   - 网络购物平台：京东、天猫、淘宝等。\n   - 特色电商平台：一些专为耳机设计的网站和店铺。\n   - 线下商场：一些大商场也有专门的耳机销售店或品牌授权的店铺。\n\n4. **价格策略**  \n   100元到200元之间的价位适合大多数用户，价格合理且性价比高。许多商家提供会员优惠，可以进一步节省费用。\n\n希望这些信息能帮助您购买到合适的耳机！如果还有其他问题，请随时告诉我哦！', '2025-05-23 11:39:20');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '电子产品');
INSERT INTO `category` VALUES (2, '家居用品');
INSERT INTO `category` VALUES (3, '书籍');
INSERT INTO `category` VALUES (4, '服装与配饰');
INSERT INTO `category` VALUES (5, '运动与户外');
INSERT INTO `category` VALUES (7, '跑腿服务');

-- ----------------------------
-- Table structure for chat_group
-- ----------------------------
DROP TABLE IF EXISTS `chat_group`;
CREATE TABLE `chat_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_user_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_group
-- ----------------------------
INSERT INTO `chat_group` VALUES (2, 1, 2);
INSERT INTO `chat_group` VALUES (3, 1, 3);
INSERT INTO `chat_group` VALUES (5, 2, 1);
INSERT INTO `chat_group` VALUES (6, 1, 5);
INSERT INTO `chat_group` VALUES (7, 5, 1);
INSERT INTO `chat_group` VALUES (8, 8, 2);
INSERT INTO `chat_group` VALUES (9, 2, 8);
INSERT INTO `chat_group` VALUES (10, 2, 7);
INSERT INTO `chat_group` VALUES (11, 7, 2);
INSERT INTO `chat_group` VALUES (12, 8, 5);
INSERT INTO `chat_group` VALUES (13, 5, 8);
INSERT INTO `chat_group` VALUES (14, 8, 1);
INSERT INTO `chat_group` VALUES (15, 1, 8);
INSERT INTO `chat_group` VALUES (16, 1, 9);
INSERT INTO `chat_group` VALUES (17, 9, 1);
INSERT INTO `chat_group` VALUES (18, 2, 9);
INSERT INTO `chat_group` VALUES (19, 9, 2);
INSERT INTO `chat_group` VALUES (20, 8, 9);
INSERT INTO `chat_group` VALUES (21, 9, 8);
INSERT INTO `chat_group` VALUES (22, 9, 7);
INSERT INTO `chat_group` VALUES (23, 7, 9);
INSERT INTO `chat_group` VALUES (24, 8, 7);
INSERT INTO `chat_group` VALUES (25, 7, 8);
INSERT INTO `chat_group` VALUES (26, 1, 7);
INSERT INTO `chat_group` VALUES (27, 7, 1);
INSERT INTO `chat_group` VALUES (28, 9, 6);
INSERT INTO `chat_group` VALUES (29, 6, 9);

-- ----------------------------
-- Table structure for chat_info
-- ----------------------------
DROP TABLE IF EXISTS `chat_info`;
CREATE TABLE `chat_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_user_id` int NOT NULL,
  `user_id` int NOT NULL,
  `text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `isread` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N',
  `time` datetime NULL DEFAULT NULL,
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'text',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'text' COMMENT '消息类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 213 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_info
-- ----------------------------
INSERT INTO `chat_info` VALUES (1, 2, 1, '你好', '是', '2025-03-23 10:55:22', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (2, 2, 1, '耳机还在吗？\n', '是', '2025-03-23 10:55:35', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (3, 1, 2, '在的', '是', '2025-03-23 10:56:02', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (4, 1, 3, '你好', '是', '2025-03-23 10:57:41', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (5, 1, 3, '你好手机还在吗？\n', '是', '2025-03-23 10:59:16', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (6, 3, 1, '你好', '是', '2025-04-10 11:19:40', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (7, 1, 3, '你好', 'N', '2025-04-10 14:11:58', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (8, 2, 1, '能小刀吗', '是', '2025-04-08 21:02:00', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (9, 2, 1, '士大夫', '是', '2025-04-07 21:16:38', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (10, 2, 1, '人\n', '是', '2025-04-04 21:17:14', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (11, 8, 2, '在哪自提啊', '是', '2025-04-11 10:10:53', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (12, 2, 7, '能自提吗', 'N', '2025-04-11 10:32:47', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (13, 5, 1, '111\n', '是', '2025-04-19 15:19:39', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (14, 1, 5, '怎么卖的\n', '是', '2025-04-19 20:12:52', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (15, 8, 1, '滴滴\n', '是', '2025-04-19 20:52:39', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (16, 8, 1, '能送到22栋楼下吗\n', '是', '2025-04-19 20:52:52', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (17, 1, 9, '11', '是', '2025-04-19 23:54:56', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (18, 5, 1, '司马\n', '是', '2025-04-20 00:14:42', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (19, 5, 1, '222', '是', '2025-04-20 00:15:08', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (20, 1, 9, '111', '是', '2025-04-21 16:40:50', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (21, 8, 9, '11', '是', '2025-04-21 17:56:08', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (22, 9, 1, '11', '是', '2025-04-21 18:03:27', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (23, 1, 9, '滴滴', '是', '2025-04-21 18:06:17', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (24, 2, 9, '11', 'N', '2025-04-21 18:07:43', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (25, 2, 9, '11', 'N', '2025-04-21 18:07:49', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (26, 2, 7, 'q q', 'N', '2025-04-24 22:45:26', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (27, 8, 9, '11111', '是', '2025-04-26 20:16:34', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (28, 9, 8, '1111', '是', '2025-04-26 20:17:48', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (29, 8, 9, '111', '是', '2025-04-26 20:18:05', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (30, 8, 9, '111', '是', '2025-04-26 20:27:31', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (31, 8, 9, '000', '是', '2025-04-26 20:28:08', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (32, 8, 9, '000', '是', '2025-04-26 20:28:28', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (33, 9, 8, '???', '是', '2025-04-26 20:28:59', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (34, 8, 9, 'cccc', '是', '2025-04-26 20:30:25', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (35, 8, 9, 'dfsdf', '是', '2025-04-26 20:30:40', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (36, 7, 9, '1111', '是', '2025-04-26 20:32:23', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (37, 8, 9, '111', '是', '2025-04-26 20:32:26', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (38, 9, 7, '111', '是', '2025-04-26 20:32:50', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (39, 7, 9, '111', '是', '2025-04-26 20:33:21', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (40, 2, 9, '111', 'N', '2025-04-26 20:36:23', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (41, 7, 9, '111', '是', '2025-04-26 20:36:30', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (42, 7, 9, '1111', '是', '2025-04-26 20:36:44', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (43, 8, 9, '11111', '是', '2025-04-26 20:37:38', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (44, 9, 8, '@@@', '是', '2025-04-26 20:39:03', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (45, 2, 9, '11', 'N', '2025-04-26 20:54:54', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (46, 8, 9, '😋', '是', '2025-04-26 21:08:52', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (47, 8, 9, '🙂', '是', '2025-04-26 21:19:51', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (48, 8, 9, 'http://localhost:9090/files/1745674330456-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 21:32:10', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (49, 8, 9, 'http://localhost:9090/files/1745674334752-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 21:32:14', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (50, 8, 9, 'http://localhost:9090/files/1745674636822-下载 (1).jpg', '是', '2025-04-26 21:37:16', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (51, 7, 9, '111', '是', '2025-04-26 21:37:47', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (52, 7, 9, '😄', '是', '2025-04-26 21:39:16', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (53, 7, 9, 'http://localhost:9090/files/1745674761951-video2.mp4', '是', '2025-04-26 21:39:22', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (54, 8, 9, '111', '是', '2025-04-26 21:41:09', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (55, 9, 8, '1', '是', '2025-04-26 21:41:34', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (56, 8, 9, 'q', '是', '2025-04-26 21:44:59', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (57, 8, 9, 'http://localhost:9090/files/1745675105609-video2.mp4', '是', '2025-04-26 21:45:05', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (58, 8, 9, 'http://localhost:9090/files/1745675117890-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 21:45:17', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (59, 8, 9, 'http://localhost:9090/files/1745675147493-下载.jpg', '是', '2025-04-26 21:45:47', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (60, 7, 9, 'http://localhost:9090/files/1745675920531-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 21:58:40', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (61, 8, 9, '🥳', '是', '2025-04-26 21:58:53', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (62, 1, 9, 'http://localhost:9090/files/1745676021439-下载 (1).jpg', '是', '2025-04-26 22:00:21', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (63, 8, 9, 'http://localhost:9090/files/1745676028184-下载 (1).jpg', '是', '2025-04-26 22:00:28', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (64, 9, 8, 'http://localhost:9090/files/1745676047370-微信图片_20250404171748.png', '是', '2025-04-26 22:00:47', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (65, 9, 8, '🥳', '是', '2025-04-26 22:01:25', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (66, 8, 9, '111', '是', '2025-04-26 22:01:50', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (67, 8, 9, '6\n', '是', '2025-04-26 22:02:50', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (68, 8, 9, '111', '是', '2025-04-26 22:04:31', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (69, 9, 8, '111', '是', '2025-04-26 22:04:44', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (70, 8, 9, '1', '是', '2025-04-26 22:24:19', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (71, 9, 8, '1', '是', '2025-04-26 22:24:40', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (72, 8, 9, 'http://localhost:9090/files/1745677487401-下载.jpg', '是', '2025-04-26 22:24:47', 'text', NULL, 'text');
INSERT INTO `chat_info` VALUES (73, 8, 9, '1', '是', '2025-04-26 22:33:54', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (74, 9, 8, 'http://localhost:9090/files/1745678064213-微信图片_20250331195758.jpg', '是', '2025-04-26 22:34:24', NULL, NULL, 'image');
INSERT INTO `chat_info` VALUES (75, 8, 9, '1', '是', '2025-04-26 22:37:27', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (76, 8, 9, '1', '是', '2025-04-26 22:37:53', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (77, 8, 9, 'http://localhost:9090/files/1745678373099-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 22:39:33', 'unknown', 'http://localhost:9090/files/1745678373099-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'file');
INSERT INTO `chat_info` VALUES (78, 8, 9, 'http://localhost:9090/files/1745678373099-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 22:39:33', 'unknown', 'http://localhost:9090/files/1745678373099-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'file');
INSERT INTO `chat_info` VALUES (79, 8, 9, 'http://localhost:9090/files/1745678377646-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 22:39:37', 'image', 'http://localhost:9090/files/1745678377646-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'image');
INSERT INTO `chat_info` VALUES (80, 8, 9, 'http://localhost:9090/files/1745678377646-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 22:39:37', 'image', 'http://localhost:9090/files/1745678377646-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'image');
INSERT INTO `chat_info` VALUES (81, 8, 9, '1', '是', '2025-04-26 22:39:45', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (82, 8, 9, '1', '是', '2025-04-26 22:39:45', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (83, 9, 8, '1', '是', '2025-04-26 22:40:14', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (84, 9, 8, '1', '是', '2025-04-26 22:40:14', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (85, 8, 9, '😀', '是', '2025-04-26 22:40:22', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (86, 8, 9, '😀', '是', '2025-04-26 22:40:22', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (87, 8, 9, '1😀', '是', '2025-04-26 22:42:59', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (88, 8, 9, '1😀', '是', '2025-04-26 22:42:59', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (89, 9, 8, '1', '是', '2025-04-26 22:43:13', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (90, 9, 8, '1', '是', '2025-04-26 22:43:13', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (91, 8, 9, '1', '是', '2025-04-26 22:43:24', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (92, 8, 9, '1', '是', '2025-04-26 22:43:24', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (93, 9, 8, '1', '是', '2025-04-26 22:43:44', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (94, 9, 8, '1', '是', '2025-04-26 22:43:44', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (95, 8, 9, '1', '是', '2025-04-26 22:44:06', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (96, 8, 9, '1', '是', '2025-04-26 22:44:06', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (97, 8, 9, '1', '是', '2025-04-26 22:44:52', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (98, 8, 9, '1', '是', '2025-04-26 22:44:52', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (99, 8, 9, '😒', '是', '2025-04-26 22:44:55', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (100, 8, 9, '😒', '是', '2025-04-26 22:44:55', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (101, 9, 8, '1', '是', '2025-04-26 22:45:11', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (102, 9, 8, '1', '是', '2025-04-26 22:45:11', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (103, 8, 9, '1', '是', '2025-04-26 22:45:51', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (104, 8, 9, '1', '是', '2025-04-26 22:45:51', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (105, 9, 8, '😒', '是', '2025-04-26 22:46:00', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (106, 9, 8, '😒', '是', '2025-04-26 22:46:00', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (107, 8, 9, 'http://localhost:9090/files/1745678778573-下载 (1).jpg', '是', '2025-04-26 22:46:18', 'image', 'http://localhost:9090/files/1745678778573-下载 (1).jpg', 'image');
INSERT INTO `chat_info` VALUES (108, 8, 9, 'http://localhost:9090/files/1745678778573-下载 (1).jpg', '是', '2025-04-26 22:46:18', 'image', 'http://localhost:9090/files/1745678778573-下载 (1).jpg', 'image');
INSERT INTO `chat_info` VALUES (109, 8, 9, 'http://localhost:9090/files/1745678922937-ab9b91538fe65eb8.jpg', '是', '2025-04-26 22:48:42', 'image', 'http://localhost:9090/files/1745678922937-ab9b91538fe65eb8.jpg', 'image');
INSERT INTO `chat_info` VALUES (110, 8, 9, 'http://localhost:9090/files/1745678922937-ab9b91538fe65eb8.jpg', '是', '2025-04-26 22:48:42', 'image', 'http://localhost:9090/files/1745678922937-ab9b91538fe65eb8.jpg', 'image');
INSERT INTO `chat_info` VALUES (111, 8, 9, 'http://localhost:9090/files/1745679045323-下载.jpg', '是', '2025-04-26 22:50:45', 'image', 'http://localhost:9090/files/1745679045323-下载.jpg', 'image');
INSERT INTO `chat_info` VALUES (112, 8, 9, 'http://localhost:9090/files/1745679045323-下载.jpg', '是', '2025-04-26 22:50:45', 'image', 'http://localhost:9090/files/1745679045323-下载.jpg', 'image');
INSERT INTO `chat_info` VALUES (113, 7, 9, '11', '是', '2025-04-26 22:51:32', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (114, 7, 9, '11', '是', '2025-04-26 22:51:32', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (115, 7, 9, '1\n', '是', '2025-04-26 22:54:10', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (116, 7, 9, '1\n', '是', '2025-04-26 22:54:10', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (117, 7, 8, '1', '是', '2025-04-26 22:55:03', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (118, 7, 8, '1', '是', '2025-04-26 22:55:03', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (119, 7, 8, '1', '是', '2025-04-26 22:55:34', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (120, 7, 8, '1', '是', '2025-04-26 22:55:34', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (121, 7, 8, '😏', '是', '2025-04-26 22:55:44', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (122, 7, 8, '😏', '是', '2025-04-26 22:55:44', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (123, 7, 8, '2', '是', '2025-04-26 22:56:50', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (124, 7, 8, '2', '是', '2025-04-26 22:56:50', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (125, 7, 9, '1', '是', '2025-04-26 22:58:50', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (126, 7, 9, '2', '是', '2025-04-26 22:58:54', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (127, 7, 9, '2', '是', '2025-04-26 22:58:56', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (128, 7, 9, '3', '是', '2025-04-26 22:58:59', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (129, 7, 9, '3', '是', '2025-04-26 22:59:01', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (130, 7, 9, '3', '是', '2025-04-26 22:59:02', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (131, 7, 9, '3', '是', '2025-04-26 22:59:18', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (132, 7, 9, '1', '是', '2025-04-26 22:59:28', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (133, 7, 9, '1', '是', '2025-04-26 23:01:02', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (134, 7, 9, '1', '是', '2025-04-26 23:01:02', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (135, 7, 9, '😏', '是', '2025-04-26 23:01:07', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (136, 7, 9, '😏', '是', '2025-04-26 23:01:07', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (137, 7, 9, '1', '是', '2025-04-26 23:03:05', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (138, 8, 9, '1', '是', '2025-04-26 23:03:19', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (139, 9, 8, '🥳', '是', '2025-04-26 23:03:26', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (140, 8, 9, '1', '是', '2025-04-26 23:03:52', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (141, 9, 8, 'http://localhost:9090/files/1745679848544-屏幕截图 2025-03-16 102841.png', '是', '2025-04-26 23:04:08', 'unknown', 'http://localhost:9090/files/1745679848544-屏幕截图 2025-03-16 102841.png', 'file');
INSERT INTO `chat_info` VALUES (142, 9, 8, 'http://localhost:9090/files/1745679866230-屏幕截图 2025-04-10 211509.png', '是', '2025-04-26 23:04:26', 'image', 'http://localhost:9090/files/1745679866230-屏幕截图 2025-04-10 211509.png', 'image');
INSERT INTO `chat_info` VALUES (143, 8, 9, '1', '是', '2025-04-26 23:04:46', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (144, 9, 8, '1', '是', '2025-04-26 23:04:56', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (145, 9, 8, '1', '是', '2025-04-26 23:05:05', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (146, 9, 8, 'http://localhost:9090/files/1745679911050-屏幕截图 2025-04-10 211509.png', '是', '2025-04-26 23:05:11', 'image', 'http://localhost:9090/files/1745679911050-屏幕截图 2025-04-10 211509.png', 'image');
INSERT INTO `chat_info` VALUES (147, 8, 9, '1', '是', '2025-04-26 23:07:35', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (148, 9, 8, '1', '是', '2025-04-26 23:07:43', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (149, 8, 9, 'http://localhost:9090/files/1745680072524-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '是', '2025-04-26 23:07:52', 'image', 'http://localhost:9090/files/1745680072524-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'image');
INSERT INTO `chat_info` VALUES (150, 8, 9, '1', '是', '2025-04-26 23:08:15', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (151, 9, 8, '1', '是', '2025-04-26 23:08:36', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (152, 8, 9, '😌', '是', '2025-04-26 23:09:07', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (153, 9, 8, '1', '是', '2025-04-26 23:10:18', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (154, 8, 9, '😏', '是', '2025-04-26 23:10:25', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (155, 8, 9, 'http://localhost:9090/files/1745680236968-微信图片_20250404171748.png', '是', '2025-04-26 23:10:36', 'image', 'http://localhost:9090/files/1745680236968-微信图片_20250404171748.png', 'image');
INSERT INTO `chat_info` VALUES (156, 9, 8, '1', '是', '2025-04-26 23:13:29', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (157, 9, 8, '1', '是', '2025-04-26 23:13:37', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (158, 8, 9, 'http://localhost:9090/files/1745680426707-微信图片_20250331195808.jpg', '是', '2025-04-26 23:13:46', 'image', 'http://localhost:9090/files/1745680426707-微信图片_20250331195808.jpg', 'image');
INSERT INTO `chat_info` VALUES (159, 9, 8, '😀', '是', '2025-04-26 23:13:55', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (160, 8, 9, '1', '是', '2025-04-26 23:14:08', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (161, 8, 9, '1', '是', '2025-04-26 23:14:21', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (162, 9, 8, '🥳', '是', '2025-04-26 23:14:25', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (163, 9, 8, 'http://localhost:9090/files/1745680480190-初试成绩.pdf', '是', '2025-04-26 23:14:40', 'unknown', 'http://localhost:9090/files/1745680480190-初试成绩.pdf', 'file');
INSERT INTO `chat_info` VALUES (164, 8, 9, '1', '是', '2025-04-26 23:17:37', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (165, 8, 9, '1', '是', '2025-04-26 23:17:47', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (166, 9, 8, '1', '是', '2025-04-26 23:20:06', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (167, 9, 8, '1', '是', '2025-04-26 23:20:11', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (168, 8, 9, '🙁', '是', '2025-04-26 23:22:22', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (169, 8, 9, '😞', '是', '2025-04-26 23:22:28', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (170, 9, 8, '1', '是', '2025-04-26 23:24:34', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (171, 9, 8, '1', '是', '2025-04-26 23:25:00', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (172, 9, 8, '1', '是', '2025-04-26 23:27:26', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (173, 9, 8, '1', '是', '2025-04-26 23:27:41', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (174, 9, 8, '11', '是', '2025-04-26 23:41:31', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (175, 9, 8, '11', '是', '2025-04-26 23:41:46', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (176, 9, 8, '22', '是', '2025-04-26 23:43:12', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (177, 7, 9, '🙂', '是', '2025-04-27 09:45:09', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (178, 9, 7, '😀', '是', '2025-04-27 09:48:19', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (179, 7, 9, '1', '是', '2025-04-27 09:50:50', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (180, 7, 9, '1', '是', '2025-04-27 09:51:05', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (181, 7, 9, 'http://localhost:9090/files/1745718763924-R.png', '是', '2025-04-27 09:52:43', 'image', 'http://localhost:9090/files/1745718763924-R.png', 'image');
INSERT INTO `chat_info` VALUES (182, 7, 9, '1', '是', '2025-04-27 09:53:30', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (183, 7, 9, '1', '是', '2025-04-27 09:54:27', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (184, 7, 9, '1', '是', '2025-04-27 09:56:07', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (185, 7, 9, '1', '是', '2025-04-27 09:56:16', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (186, 7, 9, '😏', '是', '2025-04-27 09:59:02', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (187, 7, 9, '1', '是', '2025-04-27 09:59:14', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (188, 9, 7, 'hello\n', '是', '2025-04-27 10:00:33', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (189, 7, 9, '绅士杨\n', '是', '2025-04-27 10:02:30', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (190, 7, 9, '1', '是', '2025-04-27 10:02:49', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (191, 7, 9, '11', '是', '2025-04-27 10:02:56', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (192, 7, 9, '绅士杨\n', '是', '2025-04-27 10:03:02', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (193, 7, 9, '1', '是', '2025-04-27 10:03:20', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (194, 7, 9, '2\n', '是', '2025-04-27 10:03:28', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (195, 9, 7, '😃', '是', '2025-04-27 10:05:53', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (196, 9, 7, '1', '是', '2025-04-27 10:07:34', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (197, 7, 9, '1', '是', '2025-04-27 10:08:32', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (198, 7, 9, '1+1=2\n', '是', '2025-04-27 10:08:41', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (199, 9, 2, '1', '是', '2025-04-27 12:14:09', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (200, 9, 2, '😋', '是', '2025-04-27 12:15:45', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (201, 9, 2, '1', '是', '2025-04-27 12:15:51', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (202, 9, 2, 'http://localhost:9090/files/1745727366765-屏幕截图 2025-04-10 211509.png', '是', '2025-04-27 12:16:06', 'image', 'http://localhost:9090/files/1745727366765-屏幕截图 2025-04-10 211509.png', 'image');
INSERT INTO `chat_info` VALUES (203, 9, 7, 'hello\n', '是', '2025-04-27 19:22:30', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (204, 9, 7, '1\n', '是', '2025-04-27 19:22:42', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (205, 9, 7, '11\n', '是', '2025-04-27 19:22:55', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (206, 9, 7, 'http://localhost:9090/files/1745752985043-屏幕截图 2025-04-10 211509.png', '是', '2025-04-27 19:23:05', 'image', 'http://localhost:9090/files/1745752985043-屏幕截图 2025-04-10 211509.png', 'image');
INSERT INTO `chat_info` VALUES (207, 9, 7, '1\n', '是', '2025-04-27 19:23:13', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (208, 9, 6, '1', '是', '2025-04-28 19:31:41', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (209, 9, 1, 'http://localhost:9090/files/1745843737112-109eb7ec913a997762d09fdf.png', '是', '2025-04-28 20:35:37', 'image', 'http://localhost:9090/files/1745843737112-109eb7ec913a997762d09fdf.png', 'image');
INSERT INTO `chat_info` VALUES (210, 2, 1, '😍', '是', '2025-05-01 03:43:41', NULL, NULL, 'text');
INSERT INTO `chat_info` VALUES (211, 2, 1, 'http://localhost:9090/files/1746042226634-t01f0194bbef0dbb36a.png', '是', '2025-05-01 03:43:46', 'image', 'http://localhost:9090/files/1746042226634-t01f0194bbef0dbb36a.png', 'image');
INSERT INTO `chat_info` VALUES (212, 7, 1, 'http://localhost:9090/files/1746113191676-Shenshi 的笔记本.url', '是', '2025-05-01 23:26:31', 'unknown', 'http://localhost:9090/files/1746113191676-Shenshi 的笔记本.url', 'file');

-- ----------------------------
-- Table structure for circles
-- ----------------------------
DROP TABLE IF EXISTS `circles`;
CREATE TABLE `circles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of circles
-- ----------------------------
INSERT INTO `circles` VALUES (1, 'http://localhost:9090/files/1745843654369-OIP-C.jpg', '二手物品交流');
INSERT INTO `circles` VALUES (2, 'http://localhost:9090/files/1745850679923-OIP-C (1).jpg', '书友会');
INSERT INTO `circles` VALUES (3, 'http://localhost:9090/files/1745850726177-uHVUYdYtJv.jpg', '运动爱好者');
INSERT INTO `circles` VALUES (4, 'http://localhost:9090/files/1745850691934-OIP-C (2).jpg', '美食分享');
INSERT INTO `circles` VALUES (6, 'http://localhost:9090/files/1745850578330-cf1580f6d23cb34ce3caa6dd1f9a7392.png', '电影分享');

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fid` int NOT NULL,
  `user_id` int NOT NULL,
  `module` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (1, 5, 1, 'goods');
INSERT INTO `collect` VALUES (2, 3, 2, 'goods');
INSERT INTO `collect` VALUES (4, 8, 2, 'goods');
INSERT INTO `collect` VALUES (5, 9, 7, 'goods');
INSERT INTO `collect` VALUES (23, 9, 9, 'goods');
INSERT INTO `collect` VALUES (32, 8, 9, 'goods');
INSERT INTO `collect` VALUES (33, 11, 2, 'goods');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `user_id` int NOT NULL,
  `pid` int NULL DEFAULT NULL,
  `time` datetime NULL DEFAULT NULL,
  `fid` int NULL DEFAULT NULL,
  `module` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `root_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, '有图片吗？', 2, NULL, '2025-04-10 10:30:55', 2, 'posts', 1);
INSERT INTO `comment` VALUES (2, '有图片吗？\n', 2, NULL, '2025-04-10 10:31:14', 1, 'posts', 2);
INSERT INTO `comment` VALUES (3, '你好', 2, NULL, '2025-04-08 10:31:26', 2, 'help', 3);
INSERT INTO `comment` VALUES (4, '你好', 2, NULL, '2025-04-10 10:31:31', 1, 'help', 4);
INSERT INTO `comment` VALUES (5, '你好', 3, NULL, '2025-04-02 10:59:33', 2, 'help', 5);
INSERT INTO `comment` VALUES (6, '你好', 1, 5, '2025-04-10 11:19:15', 2, 'help', 5);
INSERT INTO `comment` VALUES (11, '你好', 3, NULL, '2025-04-10 14:14:13', 2, 'help', 11);
INSERT INTO `comment` VALUES (12, '你好', 3, NULL, '2025-04-10 14:14:23', 5, 'posts', 12);
INSERT INTO `comment` VALUES (13, '出', 1, NULL, '2025-03-26 21:07:24', 1, 'help', 13);
INSERT INTO `comment` VALUES (14, '能便宜点吗', 7, NULL, '2025-04-11 10:32:29', 9, 'goods', 14);
INSERT INTO `comment` VALUES (15, '带我一个\n', 5, NULL, '2025-04-19 14:17:54', 4, 'posts', 15);
INSERT INTO `comment` VALUES (16, '借出，楼主先出', 9, NULL, '2025-04-20 15:38:28', 7, 'goods', 16);
INSERT INTO `comment` VALUES (17, '1111', 9, 16, '2025-04-20 15:38:38', 7, 'goods', 16);
INSERT INTO `comment` VALUES (18, '像屁吃\n', 9, 15, '2025-04-21 17:31:58', 4, 'posts', 15);
INSERT INTO `comment` VALUES (19, '滴滴', 9, NULL, '2025-04-27 11:09:10', 5, 'help', 19);
INSERT INTO `comment` VALUES (20, '我有，可以免费给你', 1, NULL, '2025-05-01 04:50:45', 6, 'help', 20);
INSERT INTO `comment` VALUES (21, '感谢感谢，你真的太好了！！！', 2, 20, '2025-05-01 04:52:53', 6, 'help', 20);

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `reply` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `createtime` datetime NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------
INSERT INTO `feedback` VALUES (1, '网站登录问题', '我在尝试登录网站时遇到了一些问题。每次输入正确的用户名和密码后，都会收到错误提示：“账户名或密码错误”。我已经多次重试并确认了我的输入是正确的，所以我认为可能是系统出现了故障。我希望你们能够调查一下这个问题，并尽快修复。谢谢！', '18634208045', '123@qq.com', '目前已经修复好了', '2025-04-02 10:25:38', 1);
INSERT INTO `feedback` VALUES (2, '测试', '测试', '18634208045', '123@qq.com', NULL, '2025-04-01 14:14:41', 3);
INSERT INTO `feedback` VALUES (3, '求购一个鼠标', '急用，价格好商量', '12345678901', 'chushengbangbangshou@outlook.com', NULL, '2025-04-10 20:48:46', 1);
INSERT INTO `feedback` VALUES (4, '希望能开通客服功能', '有什么反馈回应不及时，希望能有ai客服可以解决一些小问题', '18186281993', 'chushengbangbangshou@outlook.com', NULL, '2025-04-25 20:34:58', 2);
INSERT INTO `feedback` VALUES (6, '无法及时收到消息', '希望能增加消息提示功能', '17807192211', '6109121067@email.ncu.edu.cn', '感谢您的宝贵意见，已经更新该功能。', '2025-04-27 11:03:18', 9);

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `date` datetime NULL DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_id` int NULL DEFAULT NULL,
  `sale_status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `read_count` int NULL DEFAULT 0,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `sort` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_likes` tinyint(1) NULL DEFAULT 0,
  `user_collect` tinyint(1) NULL DEFAULT 0,
  `likes_count` int NULL DEFAULT 0,
  `collect_count` int NULL DEFAULT 0,
  `stock` int NULL DEFAULT 1 COMMENT '商品库存',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '苹果 iPhone 13 Pro Max', 5000.00, '<h3>商品概述</h3><p>这是一部经过精心保养的二手iPhone 13 Pro Max，外观成色良好，无明显划痕或磨损。设备功能正常，所有硬件组件均处于良好的工作状态。这部手机已解锁，可兼容任何运营商网络。我正在寻找一位对这款设备感兴趣的买家，希望它能带给您同样出色的体验。</p><h3>设备状况</h3><ul><li><strong>屏幕</strong>：无裂纹或刮痕，显示清晰明亮。</li><li><strong>背面及边框</strong>：轻微使用痕迹，不影响整体美观。</li><li><strong>摄像头</strong>：拍摄效果出色，无模糊或损坏。</li><li><strong>电池健康度</strong>：超过80%，剩余寿命充足。</li><li><strong>软件</strong>：运行 iOS 15.x 版本，无越狱或其他非法操作。</li><li><strong>配件</strong>：附带原装充电线和适配器（如有）</li></ul><h3>交易说明</h3><ul><li><strong>价格</strong>：由于是二手商品，价格比全新版本优惠很多。</li><li><strong>保修期</strong>：无官方保修，但我会提供一周内无理由退换货保障。</li><li><strong>支付方式</strong>：支持支付宝、微信支付等多种付款方式。</li><li><strong>配送</strong>：全国包邮，采用顺丰快递，确保安全送达。</li></ul>', '北京市朝阳区', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '2025-04-01 00:00:00', '通过', '电子产品', 1, '上架', 21, NULL, NULL, 0, 0, 0, 0, 9);
INSERT INTO `goods` VALUES (3, '苹果 iPhone 13', 4000.00, '<h3>商品概述</h3><p>这是一部经过精心保养的二手iPhone 13 Pro Max，外观成色良好，无明显划痕或磨损。设备功能正常，所有硬件组件均处于良好的工作状态。这部手机已解锁，可兼容任何运营商网络。我正在寻找一位对这款设备感兴趣的买家，希望它能带给您同样出色的体验。</p><h3>设备状况</h3><ul><li><strong>屏幕</strong>：无裂纹或刮痕，显示清晰明亮。</li><li><strong>背面及边框</strong>：轻微使用痕迹，不影响整体美观。</li><li><strong>摄像头</strong>：拍摄效果出色，无模糊或损坏。</li><li><strong>电池健康度</strong>：超过80%，剩余寿命充足。</li><li><strong>软件</strong>：运行 iOS 15.x 版本，无越狱或其他非法操作。</li><li><strong>配件</strong>：附带原装充电线和适配器（如有）</li></ul><h3>交易说明</h3><ul><li><strong>价格</strong>：由于是二手商品，价格比全新版本优惠很多。</li><li><strong>保修期</strong>：无官方保修，但我会提供一周内无理由退换货保障。</li><li><strong>支付方式</strong>：支持支付宝、微信支付等多种付款方式。</li><li><strong>配送</strong>：全国包邮，采用顺丰快递，确保安全送达。</li></ul>', '北京市朝阳区', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '2025-04-01 00:00:00', '通过', '电子产品', 1, '上架', 24, NULL, NULL, 0, 0, 0, 0, 6);
INSERT INTO `goods` VALUES (4, '二手Apple AirPods Pro无线耳机', 500.00, '<p># Apple AirPods Pro 无线蓝牙耳机\n\n- **品牌**：Apple\n- **型号**：AirPods Pro\n- **颜色**：白色\n- **成色**：九五成新\n- **功能**：主动降噪、透明模式、触摸控制、防水防汗\n- **配件**：充电盒、耳塞（S/M/L三副）、数据线\n\n这款AirPods Pro是我去年购买的，一直很爱惜，几乎每天都用，但由于最近换了新款，所以打算出掉。耳机没有任何损伤，音质和降噪效果都非常棒。充电盒电量足，续航持久。\n\n![AirPods Pro实物图]()\n\n价格可小刀，有意者私聊，非诚勿扰。支持当面交易或者邮寄，运费自理。<br/></p>', '北京市朝阳区', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '2025-04-01 00:00:00', '通过', '电子产品', 2, '上架', 24, NULL, NULL, 0, 0, 0, 0, 6);
INSERT INTO `goods` VALUES (5, '二手Apple AirPods无线耳机', 400.00, '<p># Apple AirPods Pro 无线蓝牙耳机\n\n- **品牌**：Apple\n- **型号**：AirPods Pro\n- **颜色**：白色\n- **成色**：九五成新\n- **功能**：主动降噪、透明模式、触摸控制、防水防汗\n- **配件**：充电盒、耳塞（S/M/L三副）、数据线\n\n这款AirPods Pro是我去年购买的，一直很爱惜，几乎每天都用，但由于最近换了新款，所以打算出掉。耳机没有任何损伤，音质和降噪效果都非常棒。充电盒电量足，续航持久。\n\n![AirPods Pro实物图]()\n\n价格可小刀，有意者私聊，非诚勿扰。支持当面交易或者邮寄，运费自理。<br/></p>', '北京市朝阳区', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '2025-04-01 00:00:00', '通过', '电子产品', 2, '上架', 42, NULL, NULL, 0, 0, 0, 0, 9);
INSERT INTO `goods` VALUES (7, '龙族', 60.00, '', '南昌大学前湖校区天健园27栋', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '2025-04-10 00:00:00', '通过', '书籍', 1, '上架', 45, NULL, NULL, 0, 0, 0, 0, 10);
INSERT INTO `goods` VALUES (8, '大疆pocket3', 2888.00, '<p>推荐自提</p>', '南昌大学前湖校区', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '2025-04-11 00:00:00', '通过', '电子产品', 8, '上架', 92, NULL, NULL, 0, 0, 0, 0, 2);
INSERT INTO `goods` VALUES (9, '大疆', 1213.00, '', '南昌大学', 'http://localhost:9090/files/1744338698282-OIP.jpg', '2025-04-11 00:00:00', '通过', '电子产品', 2, '上架', 81, NULL, NULL, 0, 0, 0, 0, 2);
INSERT INTO `goods` VALUES (10, '狗屁王二代', 288.00, '<p>99新，可以送货上门</p>', '南昌大学前湖校区天健园19栋', 'http://localhost:9090/files/1745204069678-OIP (1).jpg', '2025-04-21 00:00:00', '通过', '电子产品', 9, '上架', 17, NULL, NULL, 0, 0, 0, 0, 10);
INSERT INTO `goods` VALUES (11, '飞利浦原装牙刷头', 20.00, '<p>天健这边可以送货上门，修贤建议自提</p>', '南昌大学前湖校区天健27栋', 'http://localhost:9090/files/1745583422738-下载.jpg', '2025-04-25 00:00:00', '通过', '家居用品', 9, '上架', 20, NULL, NULL, 0, 0, 0, 0, 6);

-- ----------------------------
-- Table structure for help
-- ----------------------------
DROP TABLE IF EXISTS `help`;
CREATE TABLE `help`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `time` datetime NULL DEFAULT NULL,
  `solved` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of help
-- ----------------------------
INSERT INTO `help` VALUES (1, '二手笔记本电脑求购', '本人欲求购一台二手笔记本电脑，要求如下：\n\n处理器：Intel Core i5 或更高\n内存：至少 8GB RAM\n存储：SSD，容量大于 256GB\n显卡：独立显卡，NVIDIA GeForce GTX 1050 及以上\n屏幕尺寸：15.6 英寸及以上\n系统：Windows 10 或 macOS\n成色：外观良好，无明显划痕或破损\n价格范围：不超过 3000 元人民币\n如果有符合以上条件的笔记本电脑，请联系我，谢谢！', 'http://localhost:9090/files/1727057971430-Snipaste_2024-09-23_10-19-25.png', '通过', 1, '2025-04-01 10:19:32', '未解决');
INSERT INTO `help` VALUES (2, '二手单反相机求购', '我想购买一款二手单反相机，具体要求如下：\n\n品牌：佳能或尼康\n型号：佳能 EOS 80D 或尼康 D7500\n镜头：18-135mm 或类似套装\n快门次数：低于 5,000 次\n包装：完整包装，包括相机、镜头、电池、充电器、说明书等\n成色：外观良好，无明显划痕或破损\n价格范围：不超过 4000 元人民币\n如果有符合条件的相机，请联系我，非常感谢！', 'http://localhost:9090/files/1727058054460-Snipaste_2024-09-23_10-20-48.png', '通过', 1, '2025-04-01 10:20:57', '未解决');
INSERT INTO `help` VALUES (3, ' 测试', '测试', 'http://localhost:9090/files/1727071896109-Snipaste_2024-09-05_14-26-31.png', '通过', 3, '2024-09-23 14:11:38', '未解决');
INSERT INTO `help` VALUES (4, '1', '1', 'http://localhost:9090/files/1745235418634-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '通过', 9, '2025-04-21 19:37:04', '已解决');
INSERT INTO `help` VALUES (5, '代打成绩单', '本人目前在外地实习，需要有人帮忙打印成绩单，有偿', 'http://localhost:9090/files/1745506562884-IMG_0418.png', '通过', 7, '2025-04-24 22:56:10', '未解决');
INSERT INTO `help` VALUES (6, '求购一颗布洛芬', '牙龈发炎了，剧痛无比，急需一颗布洛芬', 'http://localhost:9090/files/1745584858768-下载 (1).jpg', '通过', 2, '2025-04-25 20:41:03', '未解决');
INSERT INTO `help` VALUES (7, '代取快递', '本人五一期间不在校，需要有人到天健27栋代取快递，有偿', 'http://localhost:9090/files/1746188634615-R.png', '通过', 1, '2025-05-02 20:24:41', '未解决');

-- ----------------------------
-- Table structure for likes
-- ----------------------------
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fid` int NOT NULL,
  `user_id` int NOT NULL,
  `module` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of likes
-- ----------------------------
INSERT INTO `likes` VALUES (1, 5, 1, 'goods');
INSERT INTO `likes` VALUES (2, 3, 2, 'goods');
INSERT INTO `likes` VALUES (4, 8, 2, 'goods');
INSERT INTO `likes` VALUES (5, 9, 7, 'goods');
INSERT INTO `likes` VALUES (6, 4, 9, 'goods');
INSERT INTO `likes` VALUES (29, 9, 9, 'goods');
INSERT INTO `likes` VALUES (32, 11, 2, 'goods');
INSERT INTO `likes` VALUES (33, 7, 9, 'goods');
INSERT INTO `likes` VALUES (35, 8, 9, 'goods');

-- ----------------------------
-- Table structure for login_log
-- ----------------------------
DROP TABLE IF EXISTS `login_log`;
CREATE TABLE `login_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `login_time` datetime NOT NULL COMMENT '登录时间',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录IP',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'User-Agent 信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_login_time`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of login_log
-- ----------------------------
INSERT INTO `login_log` VALUES (1, 1, '2025-04-22 17:39:15', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0');
INSERT INTO `login_log` VALUES (2, 7, '2025-04-22 21:13:49', NULL, NULL);
INSERT INTO `login_log` VALUES (3, 7, '2025-04-22 21:14:03', NULL, NULL);
INSERT INTO `login_log` VALUES (4, 2, '2025-04-21 21:16:09', NULL, NULL);
INSERT INTO `login_log` VALUES (5, 2, '2025-04-19 21:16:26', NULL, NULL);
INSERT INTO `login_log` VALUES (6, 7, '2025-04-24 21:28:25', NULL, NULL);
INSERT INTO `login_log` VALUES (7, 7, '2025-04-24 21:33:51', NULL, NULL);
INSERT INTO `login_log` VALUES (8, 1, '2025-04-24 21:35:14', NULL, NULL);
INSERT INTO `login_log` VALUES (9, 1, '2025-04-24 22:32:06', NULL, NULL);
INSERT INTO `login_log` VALUES (10, 7, '2025-04-24 22:37:41', NULL, NULL);
INSERT INTO `login_log` VALUES (11, 9, '2025-04-24 22:56:28', NULL, NULL);
INSERT INTO `login_log` VALUES (12, 1, '2025-04-24 22:56:50', NULL, NULL);
INSERT INTO `login_log` VALUES (13, 1, '2025-04-25 13:16:41', NULL, NULL);
INSERT INTO `login_log` VALUES (14, 1, '2025-04-25 15:16:59', NULL, NULL);
INSERT INTO `login_log` VALUES (15, 1, '2025-04-25 17:25:09', NULL, NULL);
INSERT INTO `login_log` VALUES (16, 9, '2025-04-25 19:08:58', NULL, NULL);
INSERT INTO `login_log` VALUES (17, 1, '2025-04-25 20:19:09', NULL, NULL);
INSERT INTO `login_log` VALUES (18, 7, '2025-04-25 20:19:45', NULL, NULL);
INSERT INTO `login_log` VALUES (19, 2, '2025-04-25 20:21:37', NULL, NULL);
INSERT INTO `login_log` VALUES (20, 1, '2025-04-25 20:41:48', NULL, NULL);
INSERT INTO `login_log` VALUES (21, 2, '2025-04-25 20:51:24', NULL, NULL);
INSERT INTO `login_log` VALUES (22, 1, '2025-04-25 21:22:23', NULL, NULL);
INSERT INTO `login_log` VALUES (23, 1, '2025-04-25 21:22:24', NULL, NULL);
INSERT INTO `login_log` VALUES (24, 1, '2025-04-25 21:22:30', NULL, NULL);
INSERT INTO `login_log` VALUES (25, 9, '2025-04-25 21:28:26', NULL, NULL);
INSERT INTO `login_log` VALUES (26, 9, '2025-04-25 21:32:42', NULL, NULL);
INSERT INTO `login_log` VALUES (27, 9, '2025-04-25 21:34:42', NULL, NULL);
INSERT INTO `login_log` VALUES (28, 9, '2025-04-25 21:41:15', NULL, NULL);
INSERT INTO `login_log` VALUES (29, 1, '2025-04-25 22:51:17', NULL, NULL);
INSERT INTO `login_log` VALUES (30, 7, '2025-04-25 23:02:20', NULL, NULL);
INSERT INTO `login_log` VALUES (31, 9, '2025-04-26 09:37:27', NULL, NULL);
INSERT INTO `login_log` VALUES (32, 9, '2025-04-26 18:20:33', NULL, NULL);
INSERT INTO `login_log` VALUES (33, 9, '2025-04-26 18:36:18', NULL, NULL);
INSERT INTO `login_log` VALUES (34, 9, '2025-04-26 18:47:15', NULL, NULL);
INSERT INTO `login_log` VALUES (35, 9, '2025-04-26 18:47:52', NULL, NULL);
INSERT INTO `login_log` VALUES (36, 1, '2025-04-26 19:38:36', NULL, NULL);
INSERT INTO `login_log` VALUES (37, 8, '2025-04-26 20:17:36', NULL, NULL);
INSERT INTO `login_log` VALUES (38, 7, '2025-04-26 20:32:42', NULL, NULL);
INSERT INTO `login_log` VALUES (39, 8, '2025-04-26 20:37:48', NULL, NULL);
INSERT INTO `login_log` VALUES (40, 9, '2025-04-26 20:48:31', NULL, NULL);
INSERT INTO `login_log` VALUES (41, 9, '2025-04-26 21:08:46', NULL, NULL);
INSERT INTO `login_log` VALUES (42, 8, '2025-04-26 22:40:03', NULL, NULL);
INSERT INTO `login_log` VALUES (43, 9, '2025-04-26 23:10:05', NULL, NULL);
INSERT INTO `login_log` VALUES (44, 9, '2025-04-26 23:47:44', NULL, NULL);
INSERT INTO `login_log` VALUES (45, 9, '2025-04-27 09:45:01', NULL, NULL);
INSERT INTO `login_log` VALUES (46, 7, '2025-04-27 09:45:28', NULL, NULL);
INSERT INTO `login_log` VALUES (47, 1, '2025-04-27 11:21:12', NULL, NULL);
INSERT INTO `login_log` VALUES (48, 9, '2025-04-27 11:33:38', NULL, NULL);
INSERT INTO `login_log` VALUES (49, 2, '2025-04-27 11:48:31', NULL, NULL);
INSERT INTO `login_log` VALUES (50, 9, '2025-04-27 12:02:45', NULL, NULL);
INSERT INTO `login_log` VALUES (51, 9, '2025-04-27 19:15:00', NULL, NULL);
INSERT INTO `login_log` VALUES (52, 7, '2025-04-27 19:22:22', NULL, NULL);
INSERT INTO `login_log` VALUES (53, 1, '2025-04-27 20:13:22', NULL, NULL);
INSERT INTO `login_log` VALUES (54, 9, '2025-04-27 21:31:03', NULL, NULL);
INSERT INTO `login_log` VALUES (55, 9, '2025-04-27 21:31:16', NULL, NULL);
INSERT INTO `login_log` VALUES (56, 9, '2025-04-27 21:31:21', NULL, NULL);
INSERT INTO `login_log` VALUES (57, 9, '2025-04-27 21:31:26', NULL, NULL);
INSERT INTO `login_log` VALUES (58, 9, '2025-04-27 21:33:10', NULL, NULL);
INSERT INTO `login_log` VALUES (59, 9, '2025-04-27 21:34:24', NULL, NULL);
INSERT INTO `login_log` VALUES (60, 9, '2025-04-27 21:34:30', NULL, NULL);
INSERT INTO `login_log` VALUES (61, 1, '2025-04-27 21:34:57', NULL, NULL);
INSERT INTO `login_log` VALUES (62, 7, '2025-04-27 21:54:12', NULL, NULL);
INSERT INTO `login_log` VALUES (63, 9, '2025-04-27 23:36:25', NULL, NULL);
INSERT INTO `login_log` VALUES (64, 9, '2025-04-28 18:15:17', NULL, NULL);
INSERT INTO `login_log` VALUES (65, 9, '2025-04-28 18:18:40', NULL, NULL);
INSERT INTO `login_log` VALUES (66, 9, '2025-04-28 18:37:51', NULL, NULL);
INSERT INTO `login_log` VALUES (67, 1, '2025-04-28 18:42:55', NULL, NULL);
INSERT INTO `login_log` VALUES (68, 6, '2025-04-28 18:47:46', NULL, NULL);
INSERT INTO `login_log` VALUES (69, 7, '2025-04-28 19:03:34', NULL, NULL);
INSERT INTO `login_log` VALUES (70, 11, '2025-04-28 19:06:01', NULL, NULL);
INSERT INTO `login_log` VALUES (71, 9, '2025-04-28 19:22:46', NULL, NULL);
INSERT INTO `login_log` VALUES (72, 6, '2025-04-28 19:24:00', NULL, NULL);
INSERT INTO `login_log` VALUES (73, 9, '2025-04-28 19:32:26', NULL, NULL);
INSERT INTO `login_log` VALUES (74, 6, '2025-04-28 19:34:40', NULL, NULL);
INSERT INTO `login_log` VALUES (75, 9, '2025-04-28 19:38:04', NULL, NULL);
INSERT INTO `login_log` VALUES (76, 6, '2025-04-28 20:27:36', NULL, NULL);
INSERT INTO `login_log` VALUES (77, 9, '2025-04-28 20:27:50', NULL, NULL);
INSERT INTO `login_log` VALUES (78, 1, '2025-04-28 20:35:22', NULL, NULL);
INSERT INTO `login_log` VALUES (79, 1, '2025-04-28 20:44:48', NULL, NULL);
INSERT INTO `login_log` VALUES (80, 9, '2025-04-28 20:56:19', NULL, NULL);
INSERT INTO `login_log` VALUES (81, 6, '2025-04-28 21:36:04', NULL, NULL);
INSERT INTO `login_log` VALUES (82, 1, '2025-04-28 21:52:06', NULL, NULL);
INSERT INTO `login_log` VALUES (83, 2, '2025-04-28 21:52:44', NULL, NULL);
INSERT INTO `login_log` VALUES (84, 9, '2025-04-28 21:53:03', NULL, NULL);
INSERT INTO `login_log` VALUES (85, 1, '2025-04-28 21:53:36', NULL, NULL);
INSERT INTO `login_log` VALUES (86, 9, '2025-04-28 21:55:29', NULL, NULL);
INSERT INTO `login_log` VALUES (87, 8, '2025-04-28 21:56:23', NULL, NULL);
INSERT INTO `login_log` VALUES (88, 9, '2025-04-28 21:59:06', NULL, NULL);
INSERT INTO `login_log` VALUES (89, 8, '2025-04-28 21:59:39', NULL, NULL);
INSERT INTO `login_log` VALUES (90, 8, '2025-04-28 22:02:44', NULL, NULL);
INSERT INTO `login_log` VALUES (91, 6, '2025-04-28 22:05:54', NULL, NULL);
INSERT INTO `login_log` VALUES (92, 8, '2025-04-28 22:06:51', NULL, NULL);
INSERT INTO `login_log` VALUES (93, 9, '2025-04-28 22:07:35', NULL, NULL);
INSERT INTO `login_log` VALUES (94, 1, '2025-04-28 22:08:15', NULL, NULL);
INSERT INTO `login_log` VALUES (95, 9, '2025-04-28 22:08:46', NULL, NULL);
INSERT INTO `login_log` VALUES (96, 1, '2025-04-28 22:10:00', NULL, NULL);
INSERT INTO `login_log` VALUES (97, 1, '2025-04-30 14:12:28', NULL, NULL);
INSERT INTO `login_log` VALUES (98, 1, '2025-04-30 14:13:09', NULL, NULL);
INSERT INTO `login_log` VALUES (99, 1, '2025-04-30 20:31:46', NULL, NULL);
INSERT INTO `login_log` VALUES (100, 1, '2025-05-01 03:43:25', NULL, NULL);
INSERT INTO `login_log` VALUES (101, 2, '2025-05-01 04:51:57', NULL, NULL);
INSERT INTO `login_log` VALUES (102, 1, '2025-05-01 05:12:26', NULL, NULL);
INSERT INTO `login_log` VALUES (103, 1, '2025-05-01 23:19:18', NULL, NULL);
INSERT INTO `login_log` VALUES (104, 1, '2025-05-02 19:47:42', NULL, NULL);
INSERT INTO `login_log` VALUES (105, 1, '2025-05-02 20:09:17', NULL, NULL);
INSERT INTO `login_log` VALUES (106, 1, '2025-05-02 21:27:02', NULL, NULL);
INSERT INTO `login_log` VALUES (107, 1, '2025-05-02 21:37:48', NULL, NULL);
INSERT INTO `login_log` VALUES (108, 1, '2025-05-05 17:11:41', NULL, NULL);
INSERT INTO `login_log` VALUES (109, 1, '2025-05-21 23:07:57', NULL, NULL);
INSERT INTO `login_log` VALUES (110, 1, '2025-05-21 23:09:17', NULL, NULL);
INSERT INTO `login_log` VALUES (111, 1, '2025-05-22 17:37:25', NULL, NULL);
INSERT INTO `login_log` VALUES (112, 1, '2025-05-22 17:37:44', NULL, NULL);
INSERT INTO `login_log` VALUES (113, 1, '2025-05-22 17:42:04', NULL, NULL);
INSERT INTO `login_log` VALUES (114, 7, '2025-05-22 18:30:57', NULL, NULL);
INSERT INTO `login_log` VALUES (115, 1, '2025-05-22 22:20:45', NULL, NULL);
INSERT INTO `login_log` VALUES (116, 7, '2025-05-22 23:52:44', NULL, NULL);
INSERT INTO `login_log` VALUES (117, 1, '2025-05-23 00:21:23', NULL, NULL);
INSERT INTO `login_log` VALUES (118, 1, '2025-05-23 00:23:41', NULL, NULL);
INSERT INTO `login_log` VALUES (119, 5, '2025-05-23 11:08:34', NULL, NULL);
INSERT INTO `login_log` VALUES (120, 8, '2025-05-23 11:41:13', NULL, NULL);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `time` datetime NULL DEFAULT NULL,
  `user` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (2, '关于近期平台维护的通知', '尊敬的同学们，\n\n大家好！为了给大家提供更好的服务，我们的校园二手交易平台将于本月末进行一次系统维护升级。在此期间，平台的部分功能可能会受到影响，包括但不限于商品发布、搜索和交易等功能。\n\n维护时间定于本月最后一个星期六凌晨2点至早上8点。在这段时间里，平台将暂时无法访问。请大家提前做好相关安排，避免不必要的困扰。\n\n维护结束后，我们将以全新的面貌为大家带来更加流畅、便捷的服务。感谢大家的理解和支持，让我们一起期待更好的校园二手交易平台吧！\n\n如有疑问或紧急需求，请联系我们的客服团队，我们会尽力协助解决。\n\n顺祝商祺，\n校园二手交易平台管理团队', '2025-04-02 00:00:00', 'admin');
INSERT INTO `notice` VALUES (3, '冬季促销活动公告', '亲爱的用户们，\n\n随着冬天的到来，我们特别推出冬季促销活动！即日起至年底，凡是在平台上购买任意二手商品，均可享受满200减20的优惠。此外，如果您推荐朋友注册并完成首次交易，双方都将获得额外的50元代金券奖励。\n\n请注意，每个账号仅限使用一次优惠券，不可与其他折扣叠加使用。更多详情请参见活动规则页面。祝大家购物愉快！\n\n有任何问题，欢迎随时联系我们。祝大家在这个冬季找到心仪的好物！\n\n校园二手交易平台管理团队', '2025-04-02 00:00:00', 'admin');
INSERT INTO `notice` VALUES (4, '平台新增功能介绍', '各位同学，\n\n很高兴告诉大家，我们的校园二手交易平台已经上线了两个新的功能——“一键估价”和“预约看货”。\n\n“一键估价”：只需上传商品照片和简单描述，系统即可自动评估其价值，方便快捷；\n“预约看货”：买家可以在线预约看货时间，减少来回奔波，提高交易效率。\n欢迎大家积极使用这两个新功能，提升交易体验。如有任何建议或问题，欢迎随时向我们反馈。\n\n祝大家交易顺利！\n\n校园二手交易平台管理团队', '2024-09-23 00:00:00', 'admin');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `goods_img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `order_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `total` decimal(10, 2) NOT NULL,
  `time` datetime NULL DEFAULT NULL,
  `pay_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pay_time` datetime NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `address` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `sale_id` int NULL DEFAULT NULL,
  `goods_id` int NOT NULL COMMENT '商品id',
  `trade_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '交易地点',
  `trade_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '交易时间',
  `trade_status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '交易状态',
  `seller_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '卖家联系方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (41, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451647366916784600', 2888.00, '2025-05-19 23:58:56', NULL, NULL, 7, '南昌大学', '1213', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (42, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451652582029470568', 2888.00, '2025-05-21 00:07:38', NULL, NULL, 7, '南昌大学', '1213', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (43, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451654182065303526', 2888.00, '2025-04-21 00:10:18', NULL, NULL, 7, '南昌大学', '1213', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (44, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451654915111589819', 2888.00, '2025-04-21 00:11:31', NULL, NULL, 7, '南昌大学', '1213', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (45, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451656285616824945', 2888.00, '2025-04-21 00:13:48', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (46, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17451660326254129838', 58.00, '2025-04-21 00:20:32', NULL, NULL, 7, '南昌大学', '1213', NULL, '已完成', 1, 7, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (47, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451673604603740758', 2888.00, '2025-04-21 00:42:40', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (48, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451674328314544856', 2888.00, '2025-04-21 00:43:52', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '已取消', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (49, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451674636316944276', 2888.00, '2025-04-21 00:44:23', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (50, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451996083719734562', 500.00, '2025-04-21 09:40:08', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 4, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (51, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451996768766552332', 500.00, '2025-04-21 09:41:16', '2025042122001419600506105719', '2025-04-21 09:42:22', 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 2, 4, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (52, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451997729488428468', 400.00, '2025-04-21 09:42:52', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 2, 5, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (53, '苹果 iPhone 13 Pro Max', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452030638053838687', 5000.00, '2025-04-21 10:37:43', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (54, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452421716716093210', 2888.00, '2025-04-21 21:29:31', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (55, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17452423807456230529', 58.00, '2025-04-21 21:33:00', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 1, 7, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (56, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452425325702592241', 2888.00, '2025-04-21 21:35:32', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (57, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452428866455679387', 2888.00, '2025-05-22 21:41:26', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (58, '大疆', 'http://localhost:9090/files/1744338698282-OIP.jpg', '17452433794468025531', 1213.00, '2025-04-21 21:49:39', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 2, 9, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (59, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452438734711844430', 400.00, '2025-04-21 21:57:53', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 5, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (60, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452445688630806286', 500.00, '2025-04-21 22:09:28', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 4, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (61, '苹果 iPhone 13 Pro Max', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452451635090133730', 5000.00, '2025-04-21 22:19:23', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (62, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17452460434903548030', 58.00, '2025-05-23 22:34:03', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 1, 7, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (63, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452462680271858202', 500.00, '2025-05-02 22:37:48', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 2, 4, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (64, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452464806744115523', 400.00, '2025-04-21 22:41:20', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 2, 5, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (65, '苹果 iPhone 13', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452467334428904227', 4000.00, '2025-04-21 22:45:33', '2025042122001419600506116222', '2025-04-21 22:45:55', 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已完成', 1, 3, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (66, '大疆', 'http://localhost:9090/files/1744338698282-OIP.jpg', '17453224409037932997', 1213.00, '2025-04-22 19:47:20', '2025042222001419600506121819', '2025-04-22 19:47:45', 7, '南昌大学', '1213', NULL, '已完成', 2, 9, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (67, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17453236303815102883', 58.00, '2025-04-22 20:07:10', '2025042222001419600506118730', '2025-04-22 20:07:39', 7, '南昌大学', '1213', NULL, '已完成', 1, 7, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (68, '飞利浦原装牙刷头', 'http://localhost:9090/files/1745583422738-下载.jpg', '17455838299607556152', 20.00, '2025-04-25 20:23:49', NULL, NULL, 2, '南昌大学前湖校区天健园27栋', '17807192211', NULL, '已完成', 9, 11, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (69, '大疆', 'http://localhost:9090/files/1744338698282-OIP.jpg', '17457255410102579508', 1213.00, '2025-04-27 11:45:41', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 9, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (70, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17457261114306697483', 400.00, '2025-04-27 11:55:11', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 5, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (72, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17458474125661277092', 2888.00, '2025-04-28 21:36:52', '2025042822001419600506190885', '2025-04-28 21:37:11', 6, '南昌大学前湖校区天健园27栋', '17807192211', NULL, '已完成', 8, 8, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (73, '飞利浦原装牙刷头', 'http://localhost:9090/files/1745583422738-下载.jpg', '17458487036340186397', 20.00, '2025-04-28 21:58:23', '2025042822001419600506190886', '2025-04-28 21:58:42', 8, '南昌大学前湖校区天健园27栋', '17807192211', NULL, '已完成', 9, 11, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (74, '狗屁王二代', 'http://localhost:9090/files/1745204069678-OIP (1).jpg', '17458494540271438146', 288.00, '2025-05-23 00:10:54', NULL, NULL, 1, '江西省红谷滩区', '18634208045', '李四', '已完成', 9, 10, NULL, NULL, NULL, NULL);
INSERT INTO `orders` VALUES (75, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17460452694696151024', 500.00, '2025-05-01 04:34:29', '2025050122001419600506227078', '2025-05-01 04:35:03', 1, '江西省红谷滩区', '18634208045', '李四', '待发货', 2, 4, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `time` datetime NULL DEFAULT NULL,
  `circle` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `descr` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `read_count` int NULL DEFAULT 0,
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO `posts` VALUES (1, '《Python编程：从入门到实践》二手书转让', '<h1>Python编程：从入门到实践</h1><p>这本书非常适合初学者，内容详实且易于理解。我已经完成了所有的练习，现在想把它转让给有需要的人。</p><h2>书籍详情</h2><ul><li>作者：<a href=\"https://www.amazon.cn/dp/B07CJ5B8HR\" target=\"_blank\">Mark Lutz</a></li><li>出版社：人民邮电出版社</li><li>ISBN：9787115448829</li><li>第几版：第三版</li><li>成色：九成新，无笔记，无折页</li></ul>', 'http://localhost:9090/files/1727058165548-Snipaste_2024-09-23_10-22-26.png', 1, '2025-04-01 10:22:59', '二手物品交流', '因学习需要购买，现已完成阅读，特此转售给有需要的同学。', 1, '通过');
INSERT INTO `posts` VALUES (2, '《JavaScript高级程序设计》第四版低价转让', '<h1>JavaScript高级程序设计 第四版</h1><p>本书是我学习前端开发的重要参考资料，现因更新至第五版，故低价转让第四版。</p><h2>书籍详情</h2><ul><li>作者：<a href=\"https://www.amazon.cn/dp/B00KQOZGDA\" target=\"_blank\">Nicholas C. Zakas</a></li><li>出版社：人民邮电出版社</li><li>ISBN：9787115448829</li><li>第几版：第四版</li><li>成色：八成新，部分章节有少量笔记</li></ul><p><img alt=\"\" src=\"https://tongyi.aliyun.com/qianwen/book-cover.jpg\"/><br/></p>', 'http://localhost:9090/files/1727058273709-Snipaste_2024-09-23_10-24-05.png', 1, '2025-04-01 10:24:44', '二手物品交流', '因升级至最新版，现低价转让旧版教材。', 5, '通过');
INSERT INTO `posts` VALUES (3, '《红楼梦》读书笔记', '<p>大家好！我刚刚开始阅读《红楼梦》，虽然只看了一部分，但是我已经有了很多感悟。今天我想跟大家分享一下我对林黛玉这个人物的理解...\n\n在我看来，林黛玉是一个非常复杂的人物。她聪明、敏感，同时又有些许忧郁。她的诗词才华让我惊叹不已，而她在贾府中的处境又让人感到同情。我希望我们能一起讨论这个角色以及书中其他的角色和情节。\n\n另外，我还拍了一张我正在阅读《红楼梦》的照片，大家可以看看。这本书真的值得一读！\n\n[插入图片]\n\n期待你们的回复！<br/></p>', 'http://localhost:9090/files/1727059776656-Snipaste_2024-09-23_10-49-31.png', 1, '2025-04-01 10:49:38', '书友会', '最近我在阅读《红楼梦》，发现这本书非常精彩，有很多值得探讨的地方。我想通过这篇帖子分享我的一些读书笔记和思考。', 1, '通过');
INSERT INTO `posts` VALUES (4, '周末跑步计划', '<p>大家好！我是新来的，一直热爱运动，特别是跑步。我发现我们的“运动爱好者”圈子很活跃，所以决定发起一个周末跑步计划。\n\n每周六早上8点，我会在公园集合，邀请大家一起参加晨跑。希望这不仅能帮助我们保持健康，还能结交志同道合的朋友。\n\n如果有任何建议或者想法，请随时留言。期待见到你们！\n\n[插入图片]<br/></p>', 'http://localhost:9090/files/1727059862663-Snipaste_2024-09-23_10-50-55.png', 1, '2025-04-01 10:51:04', '运动爱好者', '让我们一起动起来！', 5, '通过');
INSERT INTO `posts` VALUES (5, '自制披萨大挑战', '<p>大家好！我一直都是个披萨迷，尝试过各种口味。最近，我决定自己动手做披萨，结果出乎意料的好吃！\n\n步骤很简单：&nbsp;</p><p>1. 准备面团...\n2. 添加配料...\n3. 烤箱预热至200度，烤15分钟...&nbsp;</p><p>&nbsp;这就是我的成果，看起来是不是很有食欲？\n\n如果你也喜欢披萨，不妨试试看。期待看到你们的作品！<br/></p>', 'http://localhost:9090/files/1727059924724-Snipaste_2024-09-23_10-51-58.png', 1, '2025-04-01 10:52:06', '美食分享圈', '谁说外卖比萨最好吃？我自己做的才最棒！', 9, '通过');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'user', '$2a$10$PzTOAZ2W1H9zmP0WSx.T9uJRMLpejllKugdr6f/8dQDpuq8L2xJYa', '用户1', '17512341234', '123@qq.com', 'http://localhost:9090/files/1727056755503-cat.png', 'USER');
INSERT INTO `user` VALUES (2, 'zhangsan', '$2a$10$WT.PWpJ86Ao67VUlGuodoelpd9K.kGisdYur/vV4J8/AI0hbpNKjG', '张三', '13520109202', '123@qq.com', 'http://localhost:9090/files/1727056824767-menu-pet.png', 'USER');
INSERT INTO `user` VALUES (5, 'chusheng', '$2a$10$4xMvZm70kKLCgV92PK8Ubu6rnuPdWwBIRHb4UOyH8oe1Eu419H9mW', 'chusheng', '123123123', 'jbzyjknn@gmail.com', 'http://localhost:9090/files/1742993996898-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (6, 'zmy', '$2a$10$Vtp6rrlkwN02uBRLkfpYTu444OT03WK/WA9NdMMay1mYShGeuq6Xm', 'zmy', NULL, NULL, 'http://localhost:9090/files/1745837299432-109eb7ec913a997762d09fdf.png', 'USER');
INSERT INTO `user` VALUES (7, 'yjy', '$2a$10$StvGSUBeK2azRdGXEUQkyOTw4Ax1s1yQC9iF1ZdH0IWS7T/PRHT5W', 'yjy', NULL, NULL, 'http://localhost:9090/files/1745159895336-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (8, 'xty', '$2a$10$N6k35nzbbG96TWLlw6o6q..FhFfltTSe7osoDSCNcC967O9t3HKuG', 'xty', '19787562345', NULL, 'http://localhost:9090/files/1744337230568-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (9, 'gkn', '$2a$10$iYMBThA2PmcsHWCVj3GhAuUv5MEg3xEXIvwmueFS4sZyJFodw13n.', 'gkn', NULL, NULL, 'http://localhost:9090/files/1745078423451-t01f0194bbef0dbb36a.png', 'USER');
INSERT INTO `user` VALUES (10, 'pxy', '$2a$10$negea3q9ayB28llEqyGne.y09Tpu3oiWuj2cOmzHcfjlFa2F0xP3e', 'pxy', '18186281993', 'pxy123@163.com', 'http://localhost:9090/files/1746049085320-109eb7ec913a997762d09fdf.png', 'USER');
INSERT INTO `user` VALUES (11, 'xhy', '$2a$10$olGS5Es98Jtvf7lPgugTPOUO3knsdryl2HqXjv.wZLx5TCXN0RLem', 'xhy', NULL, NULL, NULL, 'USER');

SET FOREIGN_KEY_CHECKS = 1;
