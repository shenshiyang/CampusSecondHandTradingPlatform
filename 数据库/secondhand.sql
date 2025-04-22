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

 Date: 22/04/2025 11:07:39
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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, '张三', '江西省红谷滩区', '13520109202', 2);
INSERT INTO `address` VALUES (2, '张三', '江西省红谷滩区', '13520109202', 2);
INSERT INTO `address` VALUES (3, '李四', '江西省红谷滩区', '18634208045', 1);
INSERT INTO `address` VALUES (4, '李四', '河南省郑州市中原区无名小区', '18634208045', 1);
INSERT INTO `address` VALUES (5, '李四', '河北', '17512341234', 3);
INSERT INTO `address` VALUES (6, 'chusheng', '江西省南昌市南昌大学前湖校区', '12345609897', 5);
INSERT INTO `address` VALUES (7, 'yjy', '南昌大学', '1213', 7);
INSERT INTO `address` VALUES (8, 'gkn', '南昌大学前湖校区天健园27栋', '123123123', 9);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '123456', '管理员', '18634208045', '123@qq.com', 'http://localhost:9090/files/1727056854376-curr-user.png', 'ADMIN');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '电子产品');
INSERT INTO `category` VALUES (2, '家居用品');
INSERT INTO `category` VALUES (3, '书籍');
INSERT INTO `category` VALUES (4, '服装与配饰');
INSERT INTO `category` VALUES (5, '运动与户外');

-- ----------------------------
-- Table structure for chat_group
-- ----------------------------
DROP TABLE IF EXISTS `chat_group`;
CREATE TABLE `chat_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_user_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

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

-- ----------------------------
-- Table structure for chat_info
-- ----------------------------
DROP TABLE IF EXISTS `chat_info`;
CREATE TABLE `chat_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_user_id` int NOT NULL,
  `user_id` int NOT NULL,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `isread` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N',
  `time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_info
-- ----------------------------
INSERT INTO `chat_info` VALUES (1, 2, 1, '你好', '是', '2025-03-23 10:55:22');
INSERT INTO `chat_info` VALUES (2, 2, 1, '耳机还在吗？\n', '是', '2025-03-23 10:55:35');
INSERT INTO `chat_info` VALUES (3, 1, 2, '在的', '是', '2025-03-23 10:56:02');
INSERT INTO `chat_info` VALUES (4, 1, 3, '你好', '是', '2025-03-23 10:57:41');
INSERT INTO `chat_info` VALUES (5, 1, 3, '你好手机还在吗？\n', '是', '2025-03-23 10:59:16');
INSERT INTO `chat_info` VALUES (6, 3, 1, '你好', '是', '2025-04-10 11:19:40');
INSERT INTO `chat_info` VALUES (7, 1, 3, '你好', 'N', '2025-04-10 14:11:58');
INSERT INTO `chat_info` VALUES (8, 2, 1, '能小刀吗', '是', '2025-04-08 21:02:00');
INSERT INTO `chat_info` VALUES (9, 2, 1, '士大夫', '是', '2025-04-07 21:16:38');
INSERT INTO `chat_info` VALUES (10, 2, 1, '人\n', '是', '2025-04-04 21:17:14');
INSERT INTO `chat_info` VALUES (11, 8, 2, '在哪自提啊', 'N', '2025-04-11 10:10:53');
INSERT INTO `chat_info` VALUES (12, 2, 7, '能自提吗', 'N', '2025-04-11 10:32:47');
INSERT INTO `chat_info` VALUES (13, 5, 1, '111\n', '是', '2025-04-19 15:19:39');
INSERT INTO `chat_info` VALUES (14, 1, 5, '怎么卖的\n', '是', '2025-04-19 20:12:52');
INSERT INTO `chat_info` VALUES (15, 8, 1, '滴滴\n', 'N', '2025-04-19 20:52:39');
INSERT INTO `chat_info` VALUES (16, 8, 1, '能送到22栋楼下吗\n', 'N', '2025-04-19 20:52:52');
INSERT INTO `chat_info` VALUES (17, 1, 9, '11', 'N', '2025-04-19 23:54:56');
INSERT INTO `chat_info` VALUES (18, 5, 1, '司马\n', '是', '2025-04-20 00:14:42');
INSERT INTO `chat_info` VALUES (19, 5, 1, '222', '是', '2025-04-20 00:15:08');
INSERT INTO `chat_info` VALUES (20, 1, 9, '111', 'N', '2025-04-21 16:40:50');
INSERT INTO `chat_info` VALUES (21, 8, 9, '11', 'N', '2025-04-21 17:56:08');
INSERT INTO `chat_info` VALUES (22, 9, 1, '11', 'N', '2025-04-21 18:03:27');
INSERT INTO `chat_info` VALUES (23, 1, 9, '滴滴', 'N', '2025-04-21 18:06:17');
INSERT INTO `chat_info` VALUES (24, 2, 9, '11', 'N', '2025-04-21 18:07:43');
INSERT INTO `chat_info` VALUES (25, 2, 9, '11', 'N', '2025-04-21 18:07:49');

-- ----------------------------
-- Table structure for circles
-- ----------------------------
DROP TABLE IF EXISTS `circles`;
CREATE TABLE `circles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of circles
-- ----------------------------
INSERT INTO `circles` VALUES (1, 'http://localhost:9090/files/1727056973418-remind-fill.png', '二手图书圈');
INSERT INTO `circles` VALUES (2, 'http://localhost:9090/files/1727059273416-Snipaste_2024-09-23_10-41-00.png', '书友会');
INSERT INTO `circles` VALUES (3, 'http://localhost:9090/files/1727059329001-Snipaste_2024-09-23_10-42-02.png', '运动爱好者');
INSERT INTO `circles` VALUES (4, 'http://localhost:9090/files/1727059387963-Snipaste_2024-09-23_10-43-01.png', '美食分享圈');

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
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (1, 5, 1, 'goods');
INSERT INTO `collect` VALUES (2, 3, 2, 'goods');
INSERT INTO `collect` VALUES (4, 8, 2, 'goods');
INSERT INTO `collect` VALUES (5, 9, 7, 'goods');
INSERT INTO `collect` VALUES (23, 9, 9, 'goods');
INSERT INTO `collect` VALUES (32, 8, 9, 'goods');

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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------
INSERT INTO `feedback` VALUES (1, '网站登录问题', '我在尝试登录网站时遇到了一些问题。每次输入正确的用户名和密码后，都会收到错误提示：“账户名或密码错误”。我已经多次重试并确认了我的输入是正确的，所以我认为可能是系统出现了故障。我希望你们能够调查一下这个问题，并尽快修复。谢谢！', '18634208045', '123@qq.com', '目前已经修复好了', '2025-04-02 10:25:38', 1);
INSERT INTO `feedback` VALUES (2, '测试', '测试', '18634208045', '123@qq.com', NULL, '2025-04-01 14:14:41', 3);
INSERT INTO `feedback` VALUES (3, '求购一个鼠标', '急用，价格好商量', '12345678901', 'chushengbangbangshou@outlook.com', NULL, '2025-04-10 20:48:46', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '苹果 iPhone 13 Pro Max', 5000.00, '<h3>商品概述</h3><p>这是一部经过精心保养的二手iPhone 13 Pro Max，外观成色良好，无明显划痕或磨损。设备功能正常，所有硬件组件均处于良好的工作状态。这部手机已解锁，可兼容任何运营商网络。我正在寻找一位对这款设备感兴趣的买家，希望它能带给您同样出色的体验。</p><h3>设备状况</h3><ul><li><strong>屏幕</strong>：无裂纹或刮痕，显示清晰明亮。</li><li><strong>背面及边框</strong>：轻微使用痕迹，不影响整体美观。</li><li><strong>摄像头</strong>：拍摄效果出色，无模糊或损坏。</li><li><strong>电池健康度</strong>：超过80%，剩余寿命充足。</li><li><strong>软件</strong>：运行 iOS 15.x 版本，无越狱或其他非法操作。</li><li><strong>配件</strong>：附带原装充电线和适配器（如有）</li></ul><h3>交易说明</h3><ul><li><strong>价格</strong>：由于是二手商品，价格比全新版本优惠很多。</li><li><strong>保修期</strong>：无官方保修，但我会提供一周内无理由退换货保障。</li><li><strong>支付方式</strong>：支持支付宝、微信支付等多种付款方式。</li><li><strong>配送</strong>：全国包邮，采用顺丰快递，确保安全送达。</li></ul>', '北京市朝阳区', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '2025-04-01 00:00:00', '通过', '电子产品', 1, '上架', 10, NULL, NULL, 0, 0, 0, 0, 9);
INSERT INTO `goods` VALUES (3, '苹果 iPhone 13', 4000.00, '<h3>商品概述</h3><p>这是一部经过精心保养的二手iPhone 13 Pro Max，外观成色良好，无明显划痕或磨损。设备功能正常，所有硬件组件均处于良好的工作状态。这部手机已解锁，可兼容任何运营商网络。我正在寻找一位对这款设备感兴趣的买家，希望它能带给您同样出色的体验。</p><h3>设备状况</h3><ul><li><strong>屏幕</strong>：无裂纹或刮痕，显示清晰明亮。</li><li><strong>背面及边框</strong>：轻微使用痕迹，不影响整体美观。</li><li><strong>摄像头</strong>：拍摄效果出色，无模糊或损坏。</li><li><strong>电池健康度</strong>：超过80%，剩余寿命充足。</li><li><strong>软件</strong>：运行 iOS 15.x 版本，无越狱或其他非法操作。</li><li><strong>配件</strong>：附带原装充电线和适配器（如有）</li></ul><h3>交易说明</h3><ul><li><strong>价格</strong>：由于是二手商品，价格比全新版本优惠很多。</li><li><strong>保修期</strong>：无官方保修，但我会提供一周内无理由退换货保障。</li><li><strong>支付方式</strong>：支持支付宝、微信支付等多种付款方式。</li><li><strong>配送</strong>：全国包邮，采用顺丰快递，确保安全送达。</li></ul>', '北京市朝阳区', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '2025-04-01 00:00:00', '通过', '电子产品', 1, '上架', 16, NULL, NULL, 0, 0, 0, 0, 6);
INSERT INTO `goods` VALUES (4, '二手Apple AirPods Pro无线耳机', 500.00, '<p># Apple AirPods Pro 无线蓝牙耳机\n\n- **品牌**：Apple\n- **型号**：AirPods Pro\n- **颜色**：白色\n- **成色**：九五成新\n- **功能**：主动降噪、透明模式、触摸控制、防水防汗\n- **配件**：充电盒、耳塞（S/M/L三副）、数据线\n\n这款AirPods Pro是我去年购买的，一直很爱惜，几乎每天都用，但由于最近换了新款，所以打算出掉。耳机没有任何损伤，音质和降噪效果都非常棒。充电盒电量足，续航持久。\n\n![AirPods Pro实物图]()\n\n价格可小刀，有意者私聊，非诚勿扰。支持当面交易或者邮寄，运费自理。<br/></p>', '北京市朝阳区', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '2025-04-01 00:00:00', '通过', '电子产品', 2, '上架', 17, NULL, NULL, 0, 0, 0, 0, 7);
INSERT INTO `goods` VALUES (5, '二手Apple AirPods无线耳机', 400.00, '<p># Apple AirPods Pro 无线蓝牙耳机\n\n- **品牌**：Apple\n- **型号**：AirPods Pro\n- **颜色**：白色\n- **成色**：九五成新\n- **功能**：主动降噪、透明模式、触摸控制、防水防汗\n- **配件**：充电盒、耳塞（S/M/L三副）、数据线\n\n这款AirPods Pro是我去年购买的，一直很爱惜，几乎每天都用，但由于最近换了新款，所以打算出掉。耳机没有任何损伤，音质和降噪效果都非常棒。充电盒电量足，续航持久。\n\n![AirPods Pro实物图]()\n\n价格可小刀，有意者私聊，非诚勿扰。支持当面交易或者邮寄，运费自理。<br/></p>', '北京市朝阳区', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '2025-04-01 00:00:00', '通过', '电子产品', 2, '上架', 32, NULL, NULL, 0, 0, 0, 0, 9);
INSERT INTO `goods` VALUES (7, '龙族', 58.00, '', '南昌大学前湖校区天健园27栋', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '2025-04-10 00:00:00', '通过', '书籍', 1, '上架', 25, NULL, NULL, 0, 0, 0, 0, 2);
INSERT INTO `goods` VALUES (8, '大疆pocket3', 2888.00, '<p>推荐自提</p>', '南昌大学前湖校区', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '2025-04-11 00:00:00', '通过', '电子产品', 8, '上架', 61, NULL, NULL, 0, 0, 0, 0, 1);
INSERT INTO `goods` VALUES (9, '大疆', 1213.00, '', '南昌大学', 'http://localhost:9090/files/1744338698282-OIP.jpg', '2025-04-11 00:00:00', '通过', '电子产品', 2, '上架', 39, NULL, NULL, 0, 0, 0, 0, 1);
INSERT INTO `goods` VALUES (10, '狗屁王二代', 288.00, '<p>99新，可以送货上门</p>', '南昌大学前湖校区天健园19栋', 'http://localhost:9090/files/1745204069678-OIP (1).jpg', '2025-04-21 00:00:00', '待审核', '电子产品', 9, '上架', 0, NULL, NULL, 0, 0, 0, 0, 9);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of help
-- ----------------------------
INSERT INTO `help` VALUES (1, '二手笔记本电脑求购', '本人欲求购一台二手笔记本电脑，要求如下：\n\n处理器：Intel Core i5 或更高\n内存：至少 8GB RAM\n存储：SSD，容量大于 256GB\n显卡：独立显卡，NVIDIA GeForce GTX 1050 及以上\n屏幕尺寸：15.6 英寸及以上\n系统：Windows 10 或 macOS\n成色：外观良好，无明显划痕或破损\n价格范围：不超过 3000 元人民币\n如果有符合以上条件的笔记本电脑，请联系我，谢谢！', 'http://localhost:9090/files/1727057971430-Snipaste_2024-09-23_10-19-25.png', '通过', 1, '2025-04-01 10:19:32', '未解决');
INSERT INTO `help` VALUES (2, '二手单反相机求购', '我想购买一款二手单反相机，具体要求如下：\n\n品牌：佳能或尼康\n型号：佳能 EOS 80D 或尼康 D7500\n镜头：18-135mm 或类似套装\n快门次数：低于 5,000 次\n包装：完整包装，包括相机、镜头、电池、充电器、说明书等\n成色：外观良好，无明显划痕或破损\n价格范围：不超过 4000 元人民币\n如果有符合条件的相机，请联系我，非常感谢！', 'http://localhost:9090/files/1727058054460-Snipaste_2024-09-23_10-20-48.png', '通过', 1, '2025-04-01 10:20:57', '未解决');
INSERT INTO `help` VALUES (3, ' 测试', '测试', 'http://localhost:9090/files/1727071896109-Snipaste_2024-09-05_14-26-31.png', '通过', 3, '2024-09-23 14:11:38', '未解决');
INSERT INTO `help` VALUES (4, '1', '1', 'http://localhost:9090/files/1745235418634-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', '通过', 9, '2025-04-21 19:37:04', '未解决');

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
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of likes
-- ----------------------------
INSERT INTO `likes` VALUES (1, 5, 1, 'goods');
INSERT INTO `likes` VALUES (2, 3, 2, 'goods');
INSERT INTO `likes` VALUES (4, 8, 2, 'goods');
INSERT INTO `likes` VALUES (5, 9, 7, 'goods');
INSERT INTO `likes` VALUES (6, 4, 9, 'goods');
INSERT INTO `likes` VALUES (29, 9, 9, 'goods');
INSERT INTO `likes` VALUES (31, 8, 9, 'goods');

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (41, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451647366916784600', 2888.00, '2025-04-20 23:58:56', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (42, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451652582029470568', 2888.00, '2025-04-21 00:07:38', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (43, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451654182065303526', 2888.00, '2025-04-21 00:10:18', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (44, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451654915111589819', 2888.00, '2025-04-21 00:11:31', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (45, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451656285616824945', 2888.00, '2025-04-21 00:13:48', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (46, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17451660326254129838', 58.00, '2025-04-21 00:20:32', NULL, NULL, 7, '南昌大学', '1213', NULL, '已取消', 1, 7);
INSERT INTO `orders` VALUES (47, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451673604603740758', 2888.00, '2025-04-21 00:42:40', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (48, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451674328314544856', 2888.00, '2025-04-21 00:43:52', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (49, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17451674636316944276', 2888.00, '2025-04-21 00:44:23', NULL, NULL, 1, '江西省红谷滩区', '18634208045', NULL, '待支付', 8, 8);
INSERT INTO `orders` VALUES (50, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451996083719734562', 500.00, '2025-04-21 09:40:08', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 4);
INSERT INTO `orders` VALUES (51, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451996768766552332', 500.00, '2025-04-21 09:41:16', '2025042122001419600506105719', '2025-04-21 09:42:22', 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '待发货', 2, 4);
INSERT INTO `orders` VALUES (52, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17451997729488428468', 400.00, '2025-04-21 09:42:52', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 5);
INSERT INTO `orders` VALUES (53, '苹果 iPhone 13 Pro Max', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452030638053838687', 5000.00, '2025-04-21 10:37:43', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 1, 1);
INSERT INTO `orders` VALUES (54, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452421716716093210', 2888.00, '2025-04-21 21:29:31', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (55, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17452423807456230529', 58.00, '2025-04-21 21:33:00', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 1, 7);
INSERT INTO `orders` VALUES (56, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452425325702592241', 2888.00, '2025-04-21 21:35:32', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (57, '大疆pocket3', 'http://localhost:9090/files/1744336831286-ab9b91538fe65eb8.jpg', '17452428866455679387', 2888.00, '2025-04-21 21:41:26', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 8, 8);
INSERT INTO `orders` VALUES (58, '大疆', 'http://localhost:9090/files/1744338698282-OIP.jpg', '17452433794468025531', 1213.00, '2025-04-21 21:49:39', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 9);
INSERT INTO `orders` VALUES (59, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452438734711844430', 400.00, '2025-04-21 21:57:53', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 5);
INSERT INTO `orders` VALUES (60, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452445688630806286', 500.00, '2025-04-21 22:09:28', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 4);
INSERT INTO `orders` VALUES (61, '苹果 iPhone 13 Pro Max', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452451635090133730', 5000.00, '2025-04-21 22:19:23', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 1, 1);
INSERT INTO `orders` VALUES (62, '龙族', 'http://localhost:9090/files/1744299023812-IMG_1536.JPG', '17452460434903548030', 58.00, '2025-04-21 22:34:03', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 1, 7);
INSERT INTO `orders` VALUES (63, '二手Apple AirPods Pro无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452462680271858202', 500.00, '2025-04-21 22:37:48', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 4);
INSERT INTO `orders` VALUES (64, '二手Apple AirPods无线耳机', 'http://localhost:9090/files/1727058824743-Snipaste_2024-09-23_10-33-36.png', '17452464806744115523', 400.00, '2025-04-21 22:41:20', NULL, NULL, 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '已取消', 2, 5);
INSERT INTO `orders` VALUES (65, '苹果 iPhone 13', 'http://localhost:9090/files/1727057665712-Snipaste_2024-09-23_10-14-17.png', '17452467334428904227', 4000.00, '2025-04-21 22:45:33', '2025042122001419600506116222', '2025-04-21 22:45:55', 9, '南昌大学前湖校区天健园27栋', '123123123', NULL, '待发货', 1, 3);

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
INSERT INTO `posts` VALUES (1, '《Python编程：从入门到实践》二手书转让', '<h1>Python编程：从入门到实践</h1><p>这本书非常适合初学者，内容详实且易于理解。我已经完成了所有的练习，现在想把它转让给有需要的人。</p><h2>书籍详情</h2><ul><li>作者：<a href=\"https://www.amazon.cn/dp/B07CJ5B8HR\" target=\"_blank\">Mark Lutz</a></li><li>出版社：人民邮电出版社</li><li>ISBN：9787115448829</li><li>第几版：第三版</li><li>成色：九成新，无笔记，无折页</li></ul>', 'http://localhost:9090/files/1727058165548-Snipaste_2024-09-23_10-22-26.png', 1, '2025-04-01 10:22:59', '二手图书圈', '因学习需要购买，现已完成阅读，特此转售给有需要的同学。', 1, '通过');
INSERT INTO `posts` VALUES (2, '《JavaScript高级程序设计》第四版低价转让', '<h1>JavaScript高级程序设计 第四版</h1><p>本书是我学习前端开发的重要参考资料，现因更新至第五版，故低价转让第四版。</p><h2>书籍详情</h2><ul><li>作者：<a href=\"https://www.amazon.cn/dp/B00KQOZGDA\" target=\"_blank\">Nicholas C. Zakas</a></li><li>出版社：人民邮电出版社</li><li>ISBN：9787115448829</li><li>第几版：第四版</li><li>成色：八成新，部分章节有少量笔记</li></ul><p><img alt=\"\" src=\"https://tongyi.aliyun.com/qianwen/book-cover.jpg\"/><br/></p>', 'http://localhost:9090/files/1727058273709-Snipaste_2024-09-23_10-24-05.png', 1, '2025-04-01 10:24:44', '二手图书圈', '因升级至最新版，现低价转让旧版教材。', 2, '通过');
INSERT INTO `posts` VALUES (3, '《红楼梦》读书笔记', '<p>大家好！我刚刚开始阅读《红楼梦》，虽然只看了一部分，但是我已经有了很多感悟。今天我想跟大家分享一下我对林黛玉这个人物的理解...\n\n在我看来，林黛玉是一个非常复杂的人物。她聪明、敏感，同时又有些许忧郁。她的诗词才华让我惊叹不已，而她在贾府中的处境又让人感到同情。我希望我们能一起讨论这个角色以及书中其他的角色和情节。\n\n另外，我还拍了一张我正在阅读《红楼梦》的照片，大家可以看看。这本书真的值得一读！\n\n[插入图片]\n\n期待你们的回复！<br/></p>', 'http://localhost:9090/files/1727059776656-Snipaste_2024-09-23_10-49-31.png', 1, '2025-04-01 10:49:38', '书友会', '最近我在阅读《红楼梦》，发现这本书非常精彩，有很多值得探讨的地方。我想通过这篇帖子分享我的一些读书笔记和思考。', 0, '通过');
INSERT INTO `posts` VALUES (4, '周末跑步计划', '<p>大家好！我是新来的，一直热爱运动，特别是跑步。我发现我们的“运动爱好者”圈子很活跃，所以决定发起一个周末跑步计划。\n\n每周六早上8点，我会在公园集合，邀请大家一起参加晨跑。希望这不仅能帮助我们保持健康，还能结交志同道合的朋友。\n\n如果有任何建议或者想法，请随时留言。期待见到你们！\n\n[插入图片]<br/></p>', 'http://localhost:9090/files/1727059862663-Snipaste_2024-09-23_10-50-55.png', 1, '2025-04-01 10:51:04', '运动爱好者', '让我们一起动起来！', 3, '通过');
INSERT INTO `posts` VALUES (5, '自制披萨大挑战', '<p>大家好！我一直都是个披萨迷，尝试过各种口味。最近，我决定自己动手做披萨，结果出乎意料的好吃！\n\n步骤很简单：&nbsp;</p><p>1. 准备面团...\n2. 添加配料...\n3. 烤箱预热至200度，烤15分钟...&nbsp;</p><p>&nbsp;这就是我的成果，看起来是不是很有食欲？\n\n如果你也喜欢披萨，不妨试试看。期待看到你们的作品！<br/></p>', 'http://localhost:9090/files/1727059924724-Snipaste_2024-09-23_10-51-58.png', 1, '2025-04-01 10:52:06', '美食分享圈', '谁说外卖比萨最好吃？我自己做的才最棒！', 3, '通过');
INSERT INTO `posts` VALUES (6, '测试', '<p>测试</p>', 'http://localhost:9090/files/1727072104748-Snipaste_2024-09-05_14-26-16.png', 3, '2024-09-23 14:15:08', '二手图书圈', '测试', 0, '待审核');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'user', '123', '用户1', '17512341234', '123@qq.com', 'http://localhost:9090/files/1727056755503-cat.png', 'USER');
INSERT INTO `user` VALUES (2, 'zhangsan', '123', '张三', '13520109202', '123@qq.com', 'http://localhost:9090/files/1727056824767-menu-pet.png', 'USER');
INSERT INTO `user` VALUES (3, 'lisi', '123', 'lisi', '13520109202', '123@qq.com', 'http://localhost:9090/files/1727060318691-Snipaste_2024-09-05_14-26-16.png', 'USER');
INSERT INTO `user` VALUES (4, 'zhang', '123', '张三峰', '3520109202', '123@qq.com', 'http://localhost:9090/files/1727071828481-Snipaste_2024-09-05_14-26-16.png', 'USER');
INSERT INTO `user` VALUES (5, 'chusheng', '123', 'chusheng', '123123123', 'jbzyjknn@gmail.com', 'http://localhost:9090/files/1742993996898-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (6, 'zmy', '123', 'zmy', NULL, NULL, NULL, 'USER');
INSERT INTO `user` VALUES (7, 'yjy', '123', 'yjy', NULL, NULL, 'http://localhost:9090/files/1745159895336-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (8, 'xty', '123', 'xty', '19787562345', NULL, 'http://localhost:9090/files/1744337230568-31a273df-c448-4157-ae31-70c5a7b2655a.jpeg', 'USER');
INSERT INTO `user` VALUES (9, 'gkn', '123', 'gkn', NULL, NULL, 'http://localhost:9090/files/1745078423451-t01f0194bbef0dbb36a.png', 'USER');

SET FOREIGN_KEY_CHECKS = 1;
