-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.2.18-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for staffmanager
DROP DATABASE IF EXISTS `staffmanager`;
CREATE DATABASE IF NOT EXISTS `staffmanager` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `staffmanager`;

-- Dumping structure for procedure staffmanager.account_login
DROP PROCEDURE IF EXISTS `account_login`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `account_login`(
	IN `account` VARCHAR(50),
	IN `passwd` VARCHAR(50),
	IN `login_time` DATETIME

)
BEGIN
DECLARE result int;
DECLARE types int;
DECLARE account_id int;
DECLARE md5pass varchar(50);
set md5pass=md5(passwd);
if exists(select * from admin_account where account_name=account and account_passwd=md5pass) then
	set result=1;
	update admin_account set last_login=login_time where account_name=account and account_passwd=md5pass;
	set types=(select account_type from admin_account where account_name=account and account_passwd=md5pass);
	set account_id=(select account_id from admin_account where account_name=account and account_passwd=md5pass); 
else 
	set result=-99;
	set types=-99;
	set account_id=-99;
end if;
select result,types,account_id;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.add_new_device_partner
DROP PROCEDURE IF EXISTS `add_new_device_partner`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_device_partner`(
	IN `name` VARCHAR(200),
	IN `phone` VARCHAR(200),
	IN `address` VARCHAR(200),
	IN `note` MEDIUMTEXT,
	IN `email` VARCHAR(200)
)
BEGIN
DECLARE result int;
if exists(select * from device_partner where partner_name=name) or exists(select * from device_partner where partner_phone=phone)
or exists(select * from device_partner where partner_email=name) then
set result=-99;
else
insert into device_partner(partner_name,partner_phone,partner_address,partner_note,partner_email) values
(name,phone,address,note,email);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.add_new_staff
DROP PROCEDURE IF EXISTS `add_new_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_staff`(
	IN `fullname` VARCHAR(200),
	IN `phone` VARCHAR(50),
	IN `email` VARCHAR(200),
	IN `address` VARCHAR(200),
	IN `birthday` DATETIME,
	IN `contract` INT,
	IN `status_staff` INT,
	IN `stafftype_id` INT,
	IN `department` INT,
	IN `workid` INT,
	IN `startat` DATETIME,
	IN `note` MEDIUMTEXT,
	IN `sex` INT,
	IN `modify_time` DATETIME






)
BEGIN
DECLARE result int;
DECLARE staffid int;
if exists(select * from staff_list where staff_email=email) then 
set result=-99;
else
SET FOREIGN_KEY_CHECKS=0;
insert into staff_list(staff_fullname,staff_phone,staff_email,staff_adress,staff_birthday,contract_time,staff_status,staff_type_id,departments_id,work_id,start_time,staff_note,staff_sex,last_modify) 
values (fullname,phone,email,address,birthday,contract,status_staff,stafftype_id,department,workid,startat,note,sex,modify_time);
SET FOREIGN_KEY_CHECKS=1;
set staffid=(select staff_list.staff_id from staff_list where staff_list.staff_email=email);
insert into staff_profile(staff_id) values (staffid);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.admin_account
DROP TABLE IF EXISTS `admin_account`;
CREATE TABLE IF NOT EXISTS `admin_account` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_type` int(11) DEFAULT NULL COMMENT '1-hr , 2 IT',
  `account_name` varchar(50) DEFAULT NULL,
  `account_passwd` varchar(50) DEFAULT NULL,
  `admin_name` varchar(50) DEFAULT NULL,
  `admin_email` varchar(50) DEFAULT NULL,
  `admin_phone` varchar(50) DEFAULT NULL,
  `last_login` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='tài khoản quản lý';

-- Dumping data for table staffmanager.admin_account: ~2 rows (approximately)
DELETE FROM `admin_account`;
/*!40000 ALTER TABLE `admin_account` DISABLE KEYS */;
INSERT INTO `admin_account` (`account_id`, `account_type`, `account_name`, `account_passwd`, `admin_name`, `admin_email`, `admin_phone`, `last_login`) VALUES
	(1, 1, 'hr', '202cb962ac59075b964b07152d234b70', 'HR', 'hr@abc.com', '0972142132', '2018-11-29 09:41:46'),
	(2, 2, 'it', '81dc9bdb52d04dc20036dbd8313ed055', 'IT', 'IT@abc.com', '0982142132', '2018-12-05 16:54:26');
/*!40000 ALTER TABLE `admin_account` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.change_admin_account_passwd
DROP PROCEDURE IF EXISTS `change_admin_account_passwd`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_admin_account_passwd`(
	IN `account` VARCHAR(50),
	IN `old_passwd` VARCHAR(200),
	IN `new_passwd` VARCHAR(200),
	IN `renew_passwd` VARCHAR(200)

)
BEGIN
DECLARE result int;
DECLARE oldpasswd,newpasswd,renewpasswd varchar(200);
set oldpasswd=md5(old_passwd);
set newpasswd=md5(new_passwd);
set renewpasswd=md5(renew_passwd);
if not exists(select * from admin_account where account_name=account and account_passwd=oldpasswd)   then 
set result=-99;
elseif exists(select * from admin_account where account_name=account and account_passwd=oldpasswd) and newpasswd!=renewpasswd then
set result=-10;
elseif exists(select * from admin_account where account_name=account and account_passwd=oldpasswd) and newpasswd=oldpasswd then
set result=-11;
elseif exists(select * from admin_account where account_name=account and account_passwd=oldpasswd) and newpasswd=renewpasswd then
set result=1;
update admin_account set account_passwd=newpasswd where account_name=account;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.check_id
DROP PROCEDURE IF EXISTS `check_id`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_id`(
	IN `id1` INT,
	IN `id2` INT
,
	IN `id3` INT
)
    COMMENT 'kiểm tra id phòng van , nhân viên đầu vào add-new-staff'
BEGIN
DECLARE result int;
if exists(select * from departments where departments_id=id1) and exists (select * from staff_type where type_id=id2) and exists (select * from work_type where work_id=id3) then
set result=1;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.delete_departments
DROP PROCEDURE IF EXISTS `delete_departments`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_departments`(
	IN `id` INT

)
BEGIN
DECLARE result int;
if exists(select * from staff_list where departments_id=id) and exists (select * from departments where departments_id=id) then
set result=-99;
elseif not exists(select * from staff_list where departments_id=id) and exists (select * from departments where departments_id=id) then
set result=1;
delete from departments where departments_id=id;
else
set result=-9;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.delete_staff
DROP PROCEDURE IF EXISTS `delete_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_staff`(
	IN `id` INT
)
BEGIN
DECLARE result int;
if exists ( select * from staff_list where staff_id=id) then
set result=1;
delete from staff_list where staff_id=id;
else 
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.delete_staff_type
DROP PROCEDURE IF EXISTS `delete_staff_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_staff_type`(
	IN `id` INT
)
BEGIN
DECLARE result int;
if exists(select * from staff_type where type_id=id) then
set result=1;
delete from staff_type where type_id=id;
else 
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.delete_work_type
DROP PROCEDURE IF EXISTS `delete_work_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_work_type`(
	IN `id` INT

)
BEGIN
DECLARE result int;
if exists(select * from work_type where work_id=id) and not exists(select * from staff_list where work_id=id) then 
set result=1;
delete from work_type where work_id=id;
else 
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.departments
DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments` (
  `departments_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `last_modify` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`departments_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='danh sách phòng ban';

-- Dumping data for table staffmanager.departments: ~8 rows (approximately)
DELETE FROM `departments`;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` (`departments_id`, `name`, `last_modify`) VALUES
	(14, 'Hành Chính Nhân Sự', '2018-12-03 09:22:08'),
	(15, 'Kế Toán', '2018-12-03 09:23:13'),
	(16, 'Kế Hoạch', '2018-12-03 09:23:25'),
	(17, 'Ban Giám Đốc', '2018-12-03 09:23:38'),
	(18, 'Software', '2018-12-03 09:25:06'),
	(19, 'Media', '2018-12-03 09:25:12'),
	(20, 'Marketing', '2018-12-03 09:25:28'),
	(21, 'Giáo Dục', '2018-12-03 09:25:45');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;

-- Dumping structure for table staffmanager.device_detail
DROP TABLE IF EXISTS `device_detail`;
CREATE TABLE IF NOT EXISTS `device_detail` (
  `device_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_types` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `device_name` varchar(200) DEFAULT NULL,
  `device_tag` varchar(50) NOT NULL DEFAULT '0',
  `device_info` mediumtext DEFAULT NULL COMMENT 'Cấu hình thiết bị',
  `device_price` int(11) DEFAULT NULL,
  `device_protection_time` int(11) DEFAULT NULL,
  `receive_time` datetime DEFAULT current_timestamp(),
  `device_status` int(10) DEFAULT 0 COMMENT '0 - it quản lý , 1 - bàn giao ',
  `modify_time` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`device_id`),
  KEY `FK_device_detail_device_type` (`device_types`),
  KEY `FK_device_detail_device_supplier` (`partner_id`),
  CONSTRAINT `FK_device_detail_device_supplier` FOREIGN KEY (`partner_id`) REFERENCES `device_partner` (`partner_id`),
  CONSTRAINT `FK_device_detail_device_type` FOREIGN KEY (`device_types`) REFERENCES `device_type` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COMMENT='chi tiết thiết bị';

-- Dumping data for table staffmanager.device_detail: ~96 rows (approximately)
DELETE FROM `device_detail`;
/*!40000 ALTER TABLE `device_detail` DISABLE KEYS */;
INSERT INTO `device_detail` (`device_id`, `device_types`, `partner_id`, `device_name`, `device_tag`, `device_info`, `device_price`, `device_protection_time`, `receive_time`, `device_status`, `modify_time`) VALUES
	(1, 16, 7, 'Canon LBP6230DN', '56LOGVLHM', '', 3300000, 3, '2018-12-17 00:00:00', 0, '2018-12-03 09:58:40'),
	(2, 16, 7, 'Canon LBP6230DN', 'LSHZBQ78K', '', 3300000, 3, '2018-12-17 00:00:00', 0, '2018-12-03 09:59:05'),
	(3, 16, 5, 'HP LaserJet Pro M15A - W2G50A', 'WTXQR94LS', '', 2290000, 12, '2018-11-25 00:00:00', 0, '2018-12-03 10:15:45'),
	(4, 16, 5, 'HP LaserJet Pro M15A - W2G50A', 'PFVBIND7Q', '', 2290000, 12, '2018-11-25 00:00:00', 0, '2018-12-03 10:15:45'),
	(5, 16, 5, 'HP LaserJet Pro M15A - W2G50A', 'OEJ6HDUTZ', '', 2290000, 12, '2018-11-25 00:00:00', 0, '2018-12-03 10:15:45'),
	(6, 16, 5, 'HP LaserJet Pro M15A - W2G50A', 'VF64MWG7D', '', 2290000, 12, '2018-11-25 00:00:00', 0, '2018-12-03 10:15:45'),
	(7, 11, 5, 'Dell Inspiron 3470-V8X6M1', 'CHCE8URS9', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(8, 11, 5, 'Dell Inspiron 3470-V8X6M1', '8OVVP5HMH', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(9, 11, 5, 'Dell Inspiron 3470-V8X6M1', '4R78NVTAC', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 1, '2018-12-03 10:21:46'),
	(10, 11, 5, 'Dell Inspiron 3470-V8X6M1', 'QQ1L93MQZ', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(11, 11, 5, 'Dell Inspiron 3470-V8X6M1', '9VMZVSYWT', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(12, 11, 5, 'Dell Inspiron 3470-V8X6M1', '1RQE907Q4', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(13, 11, 5, 'Dell Inspiron 3470-V8X6M1', '41VFIUZMB', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(14, 11, 5, 'Dell Inspiron 3470-V8X6M1', '5WDXNCRTH', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(15, 11, 5, 'Dell Inspiron 3470-V8X6M1', '2T07DK7SL', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(16, 11, 5, 'Dell Inspiron 3470-V8X6M1', '7BD1IOQ7V', 'https://www.phucanh.vn/may-tinh-de-ban-dell-inspiron-3470-v8x6m1.html', 8590000, 12, '2018-12-03 00:00:00', 0, '2018-12-03 10:21:46'),
	(17, 11, 5, 'HP slimline 290-P0024D 4LY06AA', '0ICQBJY93', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 1, '2018-12-03 10:23:36'),
	(18, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'OJ2CSRZQW', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:36'),
	(19, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'JZQ19KXV9', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:36'),
	(20, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'X0X0QUSK8', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:36'),
	(21, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'RFJEP7RPG', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:36'),
	(22, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'QLC7RHQ1T', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(23, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'FIIXOOVWC', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(24, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'JRCU0JSNT', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(25, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'NY43BJZR6', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(26, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'IOQSY4CEY', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(27, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'F2RSBNDHB', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(28, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'VT62D93X4', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(29, 11, 5, 'HP slimline 290-P0024D 4LY06AA', '1L87XIRYE', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 1, '2018-12-03 10:23:37'),
	(30, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'BT26TVR3N', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(31, 11, 5, 'HP slimline 290-P0024D 4LY06AA', '9Y9Z8F4UJ', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(32, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'TG1IXFZ1V', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(33, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'NRBF8BG9X', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(34, 11, 5, 'HP slimline 290-P0024D 4LY06AA', '34H9NHI83', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(35, 11, 5, 'HP slimline 290-P0024D 4LY06AA', 'NPAKJW32B', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(36, 11, 5, 'HP slimline 290-P0024D 4LY06AA', '9M8QD6DDZ', 'https://www.phucanh.vn/ma-y-ti-nh-de-ba-n-hp-slimline-290-p0024d-4ly06aa.html', 9190000, 12, '2018-12-28 00:00:00', 0, '2018-12-03 10:23:37'),
	(37, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'GCZU4T7N7', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(38, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'EN35O3Q8L', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(39, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'MOHABAOYA', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(40, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', '4P4ASR2NV', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(41, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'ZQFPRYK2B', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(42, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', '9DRJCP0L9', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(43, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'HG3AF5PRI', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(44, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'FMOPA05TA', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(45, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'FCQ6P4U0U', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(46, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', '8CDE0X6LE', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(47, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'XYIVQVDCN', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(48, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'U5344Y6AC', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(49, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'VHZOA1YKE', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(50, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'R4GERUUBH', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(51, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'GN2946YRT', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(52, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'CVU5M1PQ5', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(53, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'G18YFVYY6', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(54, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'N1H6QCW8L', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(55, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'E4MOIMF4P', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(56, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'OQS9OBQHV', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(57, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'LYVIPQUO0', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(58, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', '065NGYOHP', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(59, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'PA28B4LUT', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(60, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'ZZ9MTPH93', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(61, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'YV3X204HE', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(62, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'R4K8H7KZ6', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(63, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'YP00VUANI', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(64, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'GX4EGR18Z', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(65, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', 'VJV8BH3WG', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(66, 14, 5, 'Màn hình Dell P2319H 23.0Inch IPS', '3LC7HUITY', 'https://www.phucanh.vn/ma-n-hi-nh-dell-p2319h-23.0inch-ips.html', 3650000, 12, '2018-12-25 00:00:00', 0, '2018-12-03 10:26:06'),
	(67, 14, 5, 'Logitech M238 France (910-005410)', 'WHIAWY3SG', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(68, 14, 5, 'Logitech M238 France (910-005410)', 'U2ANM9W4K', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(69, 14, 5, 'Logitech M238 France (910-005410)', 'P5OKQJXRA', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(70, 14, 5, 'Logitech M238 France (910-005410)', 'LD183EI9O', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(71, 14, 5, 'Logitech M238 France (910-005410)', '0CXGSPQLH', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(72, 14, 5, 'Logitech M238 France (910-005410)', '5QENKF61Z', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(73, 14, 5, 'Logitech M238 France (910-005410)', 'X53N24B21', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(74, 14, 5, 'Logitech M238 France (910-005410)', 'VD7VZSEUK', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:18'),
	(75, 14, 5, 'Logitech M238 France (910-005410)', 'MRE6FD7R0', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(76, 14, 5, 'Logitech M238 France (910-005410)', '4ZVP9QO5E', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(77, 14, 5, 'Logitech M238 France (910-005410)', '49M0K4EQS', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(78, 14, 5, 'Logitech M238 France (910-005410)', 'PPD0MYTNG', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(79, 14, 5, 'Logitech M238 France (910-005410)', '4Q08UX4XT', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(80, 14, 5, 'Logitech M238 France (910-005410)', 'DAAUQMDWF', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(81, 14, 5, 'Logitech M238 France (910-005410)', 'BW3AVLAXS', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(82, 14, 5, 'Logitech M238 France (910-005410)', '7IYRYDQUK', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(83, 14, 5, 'Logitech M238 France (910-005410)', '18QDYB49B', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(84, 14, 5, 'Logitech M238 France (910-005410)', 'PUIYOOY8W', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(85, 14, 5, 'Logitech M238 France (910-005410)', 'KOC0EKOC7', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(86, 14, 5, 'Logitech M238 France (910-005410)', 'QSWW21EIF', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(87, 14, 5, 'Logitech M238 France (910-005410)', 'MQ577UM4B', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(88, 14, 5, 'Logitech M238 France (910-005410)', 'SD3PMS2CZ', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(89, 14, 5, 'Logitech M238 France (910-005410)', '71DU6769N', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(90, 14, 5, 'Logitech M238 France (910-005410)', 'FVB12FN7P', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(91, 14, 5, 'Logitech M238 France (910-005410)', 'B6D158JAF', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(92, 14, 5, 'Logitech M238 France (910-005410)', 'VK8L0OL6L', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(93, 14, 5, 'Logitech M238 France (910-005410)', '5WDFP1GHM', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(94, 14, 5, 'Logitech M238 France (910-005410)', 'G79XDBIJB', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(95, 14, 5, 'Logitech M238 France (910-005410)', 'DBSQWE01U', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19'),
	(96, 14, 5, 'Logitech M238 France (910-005410)', 'KBDAHUR0D', 'https://www.phucanh.vn/chuot-khong-day-logitech-m238-france-910-005410.html', 349000, 12, '2018-12-12 00:00:00', 0, '2018-12-03 10:27:19');
/*!40000 ALTER TABLE `device_detail` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.device_detail_id
DROP PROCEDURE IF EXISTS `device_detail_id`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_detail_id`(
	IN `id` INT
)
BEGIN
DECLARE result int;
DECLARE name varchar(200);
DECLARE partner varchar(200);
DECLARE tag varchar(200);
DECLARE statu int;
DECLARE staff varchar(200);

if exists(select * from device_detail where device_detail.device_id=id) then
set name=(select device_detail.device_name
from device_partner,device_detail where device_detail.partner_id=device_partner.partner_id
and device_detail.device_id=id);
set partner=(select device_partner.partner_name
from device_partner,device_detail where device_detail.partner_id=device_partner.partner_id
and device_detail.device_id=id);
set tag=(select device_detail.device_tag
from device_partner,device_detail where device_detail.partner_id=device_partner.partner_id
and device_detail.device_id=id);
set statu=(select device_detail.device_status
from device_partner,device_detail where device_detail.partner_id=device_partner.partner_id
and device_detail.device_id=id);
set staff=(select staff_list.staff_fullname from staff_list,device_tranfers where staff_list.staff_id=device_tranfers.staff_id 
and device_tranfers.device_id=id group by staff_list.staff_fullname);
set result=1;
else 
set result=-99;
end if;
select result,name,partner,tag,statu,staff; 
END//
DELIMITER ;

-- Dumping structure for table staffmanager.device_liquidated
DROP TABLE IF EXISTS `device_liquidated`;
CREATE TABLE IF NOT EXISTS `device_liquidated` (
  `device_id` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT 0 COMMENT '1 - đã nộp kt , 0 - chưa nộp kt',
  KEY `FK__device_detail` (`device_id`),
  CONSTRAINT `FK__device_detail` FOREIGN KEY (`device_id`) REFERENCES `device_detail` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='thiết bị thanh lý';

-- Dumping data for table staffmanager.device_liquidated: ~0 rows (approximately)
DELETE FROM `device_liquidated`;
/*!40000 ALTER TABLE `device_liquidated` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_liquidated` ENABLE KEYS */;

-- Dumping structure for view staffmanager.device_no_tranfer_list
DROP VIEW IF EXISTS `device_no_tranfer_list`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `device_no_tranfer_list` (
	`device_name` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`device_tag` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`device_protection_time` INT(11) NULL,
	`receive_time` DATETIME NULL,
	`device_id` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for table staffmanager.device_partner
DROP TABLE IF EXISTS `device_partner`;
CREATE TABLE IF NOT EXISTS `device_partner` (
  `partner_id` int(11) NOT NULL AUTO_INCREMENT,
  `partner_name` varchar(200) DEFAULT NULL,
  `partner_phone` varchar(50) DEFAULT NULL,
  `partner_address` varchar(50) DEFAULT NULL,
  `partner_note` mediumtext DEFAULT NULL,
  `partner_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='nhà cung cấp thiết bị';

-- Dumping data for table staffmanager.device_partner: ~4 rows (approximately)
DELETE FROM `device_partner`;
/*!40000 ALTER TABLE `device_partner` DISABLE KEYS */;
INSERT INTO `device_partner` (`partner_id`, `partner_name`, `partner_phone`, `partner_address`, `partner_note`, `partner_email`) VALUES
	(4, 'Công ty Cổ Phần Máy Tính Hà Nội', '0213781281', 'Hà Nội', '', 'kinhdoanhle.lethanhnghi@hanoicomputer.co'),
	(5, 'Công ty TNHH Kỹ nghệ Phúc Anh', '02435737347', 'Hà NỘi', '', 'banhangonline@phucanh.com.vn'),
	(6, 'Công Ty TNHH Siêu Siêu Nhỏ', '0213781282', 'Hồ Chí Minh', '', 'info@sieuthimaychu.vn'),
	(7, 'Nguyễn Kim', '082173812213', 'chamsoc@nguyenkim.com', '', 'chamsoc@nguyenkim.com');
/*!40000 ALTER TABLE `device_partner` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.device_partner_list
DROP PROCEDURE IF EXISTS `device_partner_list`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_partner_list`()
BEGIN
select partner_id,partner_name,partner_phone,partner_email,partner_address from device_partner ORDER BY partner_id DESC;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.device_receive
DROP PROCEDURE IF EXISTS `device_receive`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_receive`(
	IN `name` VARCHAR(200),
	IN `tag` VARCHAR(50),
	IN `price` INT,
	IN `info` MEDIUMTEXT,
	IN `types` INT,
	IN `partner` INT,
	IN `timereceive` DATETIME,
	IN `update_time` DATETIME
,
	IN `protection_time` INT
)
BEGIN
DECLARE result int;
if exists(select * from device_detail where device_tag=tag) then
set result=-99;
else
insert into device_detail(device_name,device_tag,device_price,device_info,device_types,partner_id,receive_time,modify_time,device_protection_time) values (name,tag,price,info,types,partner,timereceive,update_time,protection_time);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for view staffmanager.device_staff_to_it_list
DROP VIEW IF EXISTS `device_staff_to_it_list`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `device_staff_to_it_list` (
	`staff_fullname` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`device_name` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`device_tag` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`tranfer_time` DATETIME NULL
) ENGINE=MyISAM;

-- Dumping structure for table staffmanager.device_tranfers
DROP TABLE IF EXISTS `device_tranfers`;
CREATE TABLE IF NOT EXISTS `device_tranfers` (
  `departments_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `devicetype_id` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT 0,
  `qrcode_url` varchar(100) DEFAULT NULL,
  `tranfer_status` int(11) DEFAULT 1,
  `tranfers_time` datetime DEFAULT NULL,
  KEY `FK_device_tranfers_departments` (`departments_id`),
  KEY `FK_device_tranfers_staff_list` (`staff_id`),
  KEY `FK_device_tranfers_device_type` (`devicetype_id`),
  KEY `FK_device_tranfers_device_detail` (`device_id`),
  CONSTRAINT `FK_device_tranfers_departments` FOREIGN KEY (`departments_id`) REFERENCES `departments` (`departments_id`),
  CONSTRAINT `FK_device_tranfers_device_detail` FOREIGN KEY (`device_id`) REFERENCES `device_detail` (`device_id`),
  CONSTRAINT `FK_device_tranfers_device_type` FOREIGN KEY (`devicetype_id`) REFERENCES `device_type` (`type_id`),
  CONSTRAINT `FK_device_tranfers_staff_list` FOREIGN KEY (`staff_id`) REFERENCES `staff_list` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ban giao thiet bi cho nhan vien';

-- Dumping data for table staffmanager.device_tranfers: ~8 rows (approximately)
DELETE FROM `device_tranfers`;
/*!40000 ALTER TABLE `device_tranfers` DISABLE KEYS */;
INSERT INTO `device_tranfers` (`departments_id`, `staff_id`, `devicetype_id`, `device_id`, `qrcode_url`, `tranfer_status`, `tranfers_time`) VALUES
	(15, 11, 11, 9, '/qrcode/4R78NVTAC.png', 1, '2018-12-04 16:29:43'),
	(16, 12, 11, 18, '/qrcode/OJ2CSRZQW.png', 0, '2018-12-04 17:36:16'),
	(15, 11, 11, 17, '/qrcode/0ICQBJY93.png', 1, '2018-12-05 11:14:54'),
	(17, 7, 11, 29, '/qrcode/1L87XIRYE.png', 1, '2018-12-05 11:15:02'),
	(15, 10, 11, 13, '/qrcode/41VFIUZMB.png', 0, '2018-12-05 11:15:13'),
	(15, 11, 11, 18, '/qrcode/OJ2CSRZQW.png', 1, '2018-12-05 12:11:49'),
	(16, 13, 11, 13, '/qrcode/41VFIUZMB.png', 0, '2018-12-05 12:12:18'),
	(16, 12, 11, 13, '/qrcode/41VFIUZMB.png', 0, '2018-12-05 14:32:28');
/*!40000 ALTER TABLE `device_tranfers` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.device_tranfers_to_staff
DROP PROCEDURE IF EXISTS `device_tranfers_to_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_tranfers_to_staff`(
	IN `departmentsid` INT,
	IN `staff` INT,
	IN `devicetype` INT,
	IN `devicetid` VARCHAR(50)
,
	IN `url` VARCHAR(100),
	IN `times` DATETIME

)
BEGIN
DECLARE result int;
DECLARE deviceid int;
if exists(select * from device_tranfers,device_detail where device_detail.device_id=device_tranfers.device_id and device_detail.device_status!=0 and device_tranfers.device_id=devicetid) then
set result=-99;
else
insert into device_tranfers(departments_id,staff_id,devicetype_id,device_id,qrcode_url,tranfers_time)
values (departmentsid,staff,devicetype,devicetid,url,times);
update device_detail set device_status=1 where device_id=devicetid;
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for view staffmanager.device_tranfer_list
DROP VIEW IF EXISTS `device_tranfer_list`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `device_tranfer_list` (
	`staff_fullname` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`device_name` VARCHAR(200) NULL COLLATE 'utf8_general_ci',
	`device_tag` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`tranfers_time` DATETIME NULL,
	`qrcode_url` VARCHAR(100) NULL COLLATE 'utf8_general_ci',
	`device_id` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for table staffmanager.device_tranfer_staff_to_it
DROP TABLE IF EXISTS `device_tranfer_staff_to_it`;
CREATE TABLE IF NOT EXISTS `device_tranfer_staff_to_it` (
  `departments_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  `tranfer_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='nhan vien ban giao lai cho it';

-- Dumping data for table staffmanager.device_tranfer_staff_to_it: ~1 rows (approximately)
DELETE FROM `device_tranfer_staff_to_it`;
/*!40000 ALTER TABLE `device_tranfer_staff_to_it` DISABLE KEYS */;
INSERT INTO `device_tranfer_staff_to_it` (`departments_id`, `staff_id`, `device_id`, `tranfer_time`) VALUES
	(16, 12, 13, '2018-12-05 14:33:13');
/*!40000 ALTER TABLE `device_tranfer_staff_to_it` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.device_tranfer_staff_to_it_exe
DROP PROCEDURE IF EXISTS `device_tranfer_staff_to_it_exe`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_tranfer_staff_to_it_exe`(
	IN `department` INT,
	IN `staff` INT,
	IN `device` INT,
	IN `times` DATETIME

)
BEGIN
DECLARE result int;
DECLARE tag varchar(20);
if exists(select * from device_tranfers where device_tranfers.departments_id=department and device_tranfers.staff_id=staff and device_tranfers.device_id=device and 
device_tranfers.tranfer_status=1) then
insert into device_tranfer_staff_to_it(departments_id,staff_id,device_id,tranfer_time) values (department,staff,device,times);
update device_tranfers set device_tranfers.tranfer_status=0 where device_tranfers.device_id=device;
update device_detail set device_detail.device_status=0 where device_detail.device_id=device;
set result=1;
set tag=(select device_detail.device_tag from device_detail where device_detail.device_id=device);
else
set result=-99;
end if;
select result,tag;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.device_type
DROP TABLE IF EXISTS `device_type`;
CREATE TABLE IF NOT EXISTS `device_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='phân loại thiết bị';

-- Dumping data for table staffmanager.device_type: ~8 rows (approximately)
DELETE FROM `device_type`;
/*!40000 ALTER TABLE `device_type` DISABLE KEYS */;
INSERT INTO `device_type` (`type_id`, `device_name`) VALUES
	(10, 'Laptop'),
	(11, 'Desktop'),
	(12, 'Server'),
	(13, 'Thiết bị mạng'),
	(14, 'Linh kiện'),
	(15, 'Smart Phone'),
	(16, 'Máy in'),
	(17, 'Máy chiếu');
/*!40000 ALTER TABLE `device_type` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.device_type_add
DROP PROCEDURE IF EXISTS `device_type_add`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_type_add`(
	IN `name` VARCHAR(200)
)
BEGIN
DECLARE result int;
if exists(select * from device_type where device_type.device_name=name) then 
set result=-99;
else
insert into device_type(device_name) values (name);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.device_type_all_id
DROP PROCEDURE IF EXISTS `device_type_all_id`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_type_all_id`(
	IN `id` INT
)
BEGIN
select device_detail.device_id,device_detail.device_name,device_detail.device_tag from device_detail where device_detail.device_types=id;
END//
DELIMITER ;

-- Dumping structure for view staffmanager.device_type_list
DROP VIEW IF EXISTS `device_type_list`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `device_type_list` (
	`type_id` INT(11) NOT NULL,
	`device_name` VARCHAR(200) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Dumping structure for procedure staffmanager.device_type_report
DROP PROCEDURE IF EXISTS `device_type_report`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_type_report`()
BEGIN
SELECT type_id,device_name from device_type;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.get_work_type_name
DROP PROCEDURE IF EXISTS `get_work_type_name`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_work_type_name`(
	IN `id` INT

)
BEGIN
DECLARE result int;
DECLARE current_name varchar(200);
if exists(select * from work_type where work_id=id) then
set result=1;
set current_name=(select work_name from work_type where work_id=id);
else
set result=-99;
set current_name='not found';
end if;
select result,current_name;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.hr_report
DROP PROCEDURE IF EXISTS `hr_report`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `hr_report`()
BEGIN
DECLARE count_staff int;
DECLARE count_departments int;
DECLARE count_staff_full_profile int;
DECLARE count_staff_quit int;
set count_staff=(select count(staff_list.staff_id) from staff_list where staff_list.staff_status!=-1 );
set count_departments=(select count(departments.departments_id) from departments);
set count_staff_full_profile=(select count(staff_profile.staff_id) from staff_profile where staff_profile.staff_certificate=1 and staff_profile.staff_health_certificate=1 and staff_profile.staff_papers=1);
set count_staff_quit=(select count(staff_list.staff_id) from staff_list where staff_list.staff_status=-1);
select count_staff,count_departments,count_staff_full_profile,count_staff_quit;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.info_department
DROP PROCEDURE IF EXISTS `info_department`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `info_department`(
	IN `id` INT
)
BEGIN
DECLARE result int;
DECLARE current_name varchar(200);
if exists(select * from departments where departments_id=id) then
set result=10;
set current_name=(select name from departments where departments_id=id);
else
set result=-99;
set current_name='not found';
end if;
select result,current_name;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.info_staff_type
DROP PROCEDURE IF EXISTS `info_staff_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `info_staff_type`(
	IN `id` INT

)
BEGIN
DECLARE result int;
DECLARE current_name varchar(200);
if exists(select * from staff_type where type_id=id) then
set result=10;
set current_name=(select type_name from staff_type where type_id=id);
else
set result=-99;
set current_name='';
end if;
select result,current_name;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_all_staff
DROP PROCEDURE IF EXISTS `list_all_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_all_staff`()
BEGIN
select staff_list.staff_id as id,staff_list.staff_fullname,departments.name,staff_type.type_name,work_type.work_name from staff_list,staff_type,work_type,departments
where staff_list.departments_id=departments.departments_id and staff_list.staff_type_id=staff_type.type_id and work_type.work_id=staff_list.work_id order by id;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_device_staff_use
DROP PROCEDURE IF EXISTS `list_device_staff_use`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_device_staff_use`(
	IN `id` INT

)
BEGIN
select device_detail.device_id,device_detail.device_name from device_detail,device_tranfers where device_detail.device_id=device_tranfers.device_id and device_tranfers.staff_id=id
and device_detail.device_status=1;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_probationary_staff
DROP PROCEDURE IF EXISTS `list_probationary_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_probationary_staff`()
BEGIN
select staff_list.staff_id as id,staff_list.staff_fullname,departments.name,staff_type.type_name,work_type.work_name from staff_list,staff_type,work_type,departments
where staff_list.departments_id=departments.departments_id and 
staff_list.staff_type_id=staff_type.type_id and work_type.work_id=staff_list.work_id 
and staff_list.staff_status=0 order by id;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_staff_departments
DROP PROCEDURE IF EXISTS `list_staff_departments`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_staff_departments`(
	IN `id` INT
)
BEGIN
select staff_list.staff_id,staff_list.staff_fullname from staff_list,departments where departments.departments_id=staff_list.departments_id and staff_list.departments_id=id
and staff_list.staff_status!=0;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_staff_type
DROP PROCEDURE IF EXISTS `list_staff_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_staff_type`()
BEGIN
select type_id,type_name from staff_type;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.list_work_type
DROP PROCEDURE IF EXISTS `list_work_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_work_type`()
BEGIN
select work_id,work_name from work_type;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.modify_departments
DROP PROCEDURE IF EXISTS `modify_departments`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_departments`(
	IN `id_departments` INT,
	IN `new_name` VARCHAR(200),
	IN `modify_time` DATETIME


)
BEGIN
DECLARE result int;
if exists(select * from departments where departments_id=id_departments and name!=new_name) then
set result=1;
update departments set name=new_name , last_modify=modify_time where departments_id=id_departments;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.modify_staff_type
DROP PROCEDURE IF EXISTS `modify_staff_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_staff_type`(
	IN `id` INT,
	IN `name` VARCHAR(200),
	IN `modify_time` DATETIME
)
BEGIN
DECLARE result int;
if exists(select * from staff_type where type_id=id and type_name!=name) then 
set result=1;
update staff_type set type_name=name , last_update=modify_time where type_id=id;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.modify_work_type
DROP PROCEDURE IF EXISTS `modify_work_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_work_type`(
	IN `id` INT,
	IN `name` VARCHAR(200)

)
BEGIN
DECLARE result int;
if exists(select * from work_type where work_id=id and work_name!=name) then 
set result=1;
update work_type set work_name=name  where work_id=id;
elseif not exists(select * from work_type where work_id=id) then
set result=-1;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.new_departments
DROP PROCEDURE IF EXISTS `new_departments`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_departments`(
	IN `new_departments` VARCHAR(200),
	IN `time_create` DATETIME
)
BEGIN
DECLARE result int;
if exists(select * from departments where name=new_departments) then
set result=-99;
else
set result=1;
insert into departments(name,last_modify) values (new_departments,time_create);
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.new_staff_type
DROP PROCEDURE IF EXISTS `new_staff_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_staff_type`(
	IN `name` VARCHAR(200),
	IN `time` DATETIME
)
BEGIN
DECLARE result int;
if exists(select * from staff_type where type_name=name) then
set result=-99;
else
insert into staff_type(type_name,last_update) values (name,time);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.new_work_type
DROP PROCEDURE IF EXISTS `new_work_type`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_work_type`(
	IN `type` VARCHAR(200)

)
BEGIN
DECLARE result int;
if exists(select * from work_type where work_name=type) then 
set result=-99;
else
insert into work_type(work_name) values (type);
set result=1;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.qrcode_get_info
DROP PROCEDURE IF EXISTS `qrcode_get_info`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `qrcode_get_info`(
	IN `departmentsid` INT,
	IN `staffid` INT,
	IN `deviceid` INT
)
BEGIN
DECLARE result int;
DECLARE departmentsname varchar(200);
DECLARE stafffullname varchar(200);
DECLARE staffphone varchar(200);
DECLARE staffemail varchar(200);
DECLARE devicetag varchar(200);
if exists(select departments.name,staff_list.staff_fullname,staff_list.staff_phone,staff_list.staff_email from departments,staff_list 
where departments.departments_id=staff_list.departments_id and departments.departments_id=departmentsid and staff_list.staff_id=staffid)
and exists(select device_detail.device_tag from device_detail where device_detail.device_id=deviceid) then
set departmentsname=(select departments.name from departments,staff_list 
where departments.departments_id=staff_list.departments_id and departments.departments_id=departmentsid and staff_list.staff_id=staffid);
set stafffullname=(select staff_list.staff_fullname from departments,staff_list 
where departments.departments_id=staff_list.departments_id and departments.departments_id=departmentsid and staff_list.staff_id=staffid);
set staffphone=(select staff_list.staff_phone from departments,staff_list 
where departments.departments_id=staff_list.departments_id and departments.departments_id=departmentsid and staff_list.staff_id=staffid);
set staffemail=(select staff_list.staff_email from departments,staff_list 
where departments.departments_id=staff_list.departments_id and departments.departments_id=departmentsid and staff_list.staff_id=staffid);
set devicetag=(select device_detail.device_tag from device_detail where device_detail.device_id=deviceid);
set result=1;
else
set result=-1;
end if;
select result,departmentsname,stafffullname,staffphone,staffemail,devicetag;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.select_departments
DROP PROCEDURE IF EXISTS `select_departments`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_departments`()
BEGIN
select departments_id,name from departments;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.service_rent_detail
DROP TABLE IF EXISTS `service_rent_detail`;
CREATE TABLE IF NOT EXISTS `service_rent_detail` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_type` int(11) DEFAULT NULL,
  `service_supplier` int(11) DEFAULT NULL,
  `service_name` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT current_timestamp(),
  `end_time` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`service_id`),
  KEY `FK__service_rent_type` (`service_type`),
  KEY `FK__service_rent_supplier` (`service_supplier`),
  CONSTRAINT `FK__service_rent_supplier` FOREIGN KEY (`service_supplier`) REFERENCES `service_rent_supplier` (`supplier_id`),
  CONSTRAINT `FK__service_rent_type` FOREIGN KEY (`service_type`) REFERENCES `service_rent_type` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Chi tiết thông tin dịch vụ thuê ngoài';

-- Dumping data for table staffmanager.service_rent_detail: ~0 rows (approximately)
DELETE FROM `service_rent_detail`;
/*!40000 ALTER TABLE `service_rent_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_rent_detail` ENABLE KEYS */;

-- Dumping structure for table staffmanager.service_rent_supplier
DROP TABLE IF EXISTS `service_rent_supplier`;
CREATE TABLE IF NOT EXISTS `service_rent_supplier` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(200) DEFAULT NULL,
  `supplier_address` mediumtext DEFAULT NULL,
  `supplier_phone` varchar(50) DEFAULT NULL,
  `supplier_email` varchar(50) DEFAULT NULL,
  `note` mediumtext DEFAULT NULL,
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='danh sách nhà cung cấp dịch vụ';

-- Dumping data for table staffmanager.service_rent_supplier: ~0 rows (approximately)
DELETE FROM `service_rent_supplier`;
/*!40000 ALTER TABLE `service_rent_supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_rent_supplier` ENABLE KEYS */;

-- Dumping structure for table staffmanager.service_rent_type
DROP TABLE IF EXISTS `service_rent_type`;
CREATE TABLE IF NOT EXISTS `service_rent_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` int(11) DEFAULT 0,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='danh sách dịch vụ đi thuê ';

-- Dumping data for table staffmanager.service_rent_type: ~0 rows (approximately)
DELETE FROM `service_rent_type`;
/*!40000 ALTER TABLE `service_rent_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_rent_type` ENABLE KEYS */;

-- Dumping structure for table staffmanager.setting
DROP TABLE IF EXISTS `setting`;
CREATE TABLE IF NOT EXISTS `setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gmail_send` varchar(50) DEFAULT NULL,
  `gmail_passwd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table staffmanager.setting: ~0 rows (approximately)
DELETE FROM `setting`;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.show_info_admin_account
DROP PROCEDURE IF EXISTS `show_info_admin_account`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_info_admin_account`(
	IN `account` VARCHAR(50)
)
BEGIN
DECLARE result int;
DECLARE name,email,phone varchar(200);
DECLARE lastlogin datetime;
if exists(select * from admin_account where account_name=account) then
set name =(select admin_name from admin_account where account_name=account);
set email =(select admin_email from admin_account where account_name=account);
set phone =(select admin_phone from admin_account where account_name=account);
set lastlogin =(select last_login from admin_account where account_name=account);
set result=1;
else 
set result=-99;
end if;
select result,name,email,phone,lastlogin;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.staff_info
DROP PROCEDURE IF EXISTS `staff_info`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_info`(
	IN `id` INT


)
BEGIN
DECLARE result int;
DECLARE val varchar (200);
if exists(select * from staff_list where staff_id=id) then
select staff_list.staff_fullname,staff_list.staff_phone,staff_list.staff_email,staff_list.staff_adress,staff_list.staff_sex,staff_list.staff_note,
departments.name,work_type.work_name,staff_type.type_name,staff_list.staff_birthday,staff_list.contract_time,staff_list.staff_status,staff_list.start_time from staff_list,departments,work_type,staff_type where staff_list.staff_id=id 
and staff_list.staff_type_id=staff_type.type_id and staff_list.departments_id=departments.departments_id 
and staff_list.work_id=work_type.work_id;
set result=1;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.staff_list
DROP TABLE IF EXISTS `staff_list`;
CREATE TABLE IF NOT EXISTS `staff_list` (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_fullname` varchar(200) DEFAULT NULL,
  `staff_phone` varchar(50) DEFAULT NULL,
  `staff_email` varchar(50) DEFAULT NULL,
  `staff_adress` mediumtext DEFAULT NULL,
  `staff_birthday` datetime DEFAULT NULL,
  `contract_time` int(11) DEFAULT 0 COMMENT 'tháng',
  `staff_status` int(11) DEFAULT 0 COMMENT '0- thử việc , 1- chính thức , -1 nghỉ việc',
  `staff_type_id` int(10) DEFAULT 0,
  `departments_id` int(10) DEFAULT 0,
  `work_id` int(10) DEFAULT 0,
  `start_time` datetime DEFAULT current_timestamp(),
  `staff_note` mediumtext DEFAULT NULL,
  `staff_sex` int(11) DEFAULT NULL,
  `last_modify` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`staff_id`),
  KEY `FK_staff_staff_type` (`staff_type_id`),
  KEY `FK_staff_departments` (`departments_id`),
  KEY `FK_staff_list_work_type` (`work_id`),
  CONSTRAINT `FK_staff_departments` FOREIGN KEY (`departments_id`) REFERENCES `departments` (`departments_id`),
  CONSTRAINT `FK_staff_list_work_type` FOREIGN KEY (`work_id`) REFERENCES `work_type` (`work_id`),
  CONSTRAINT `FK_staff_staff_type` FOREIGN KEY (`staff_type_id`) REFERENCES `staff_type` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='danh sách nhân viên\r\n\r\n';

-- Dumping data for table staffmanager.staff_list: ~14 rows (approximately)
DELETE FROM `staff_list`;
/*!40000 ALTER TABLE `staff_list` DISABLE KEYS */;
INSERT INTO `staff_list` (`staff_id`, `staff_fullname`, `staff_phone`, `staff_email`, `staff_adress`, `staff_birthday`, `contract_time`, `staff_status`, `staff_type_id`, `departments_id`, `work_id`, `start_time`, `staff_note`, `staff_sex`, `last_modify`) VALUES
	(7, 'Đỗ Văn Mạnh', '0998213897', 'manhdv@gmail.com', 'Hà Nội', '1978-11-26 00:00:00', 36, 1, 24, 17, 17, '2015-11-29 00:00:00', '', 1, '2018-12-03 09:28:54'),
	(8, 'Nguyễn Thùy Linh', '0123871289', 'linhnt@gmail.com', 'Hà Nội', '1978-12-12 00:00:00', 36, 1, 25, 17, 17, '2016-11-28 00:00:00', '', 0, '2018-12-03 09:30:29'),
	(9, 'Hoàng Mạnh Linh', '0891236721', 'linhm@gmail.com', 'Hà Nội', '1987-11-26 00:00:00', 36, 1, 26, 14, 17, '2016-11-27 00:00:00', '', 1, '2018-12-03 09:32:05'),
	(10, 'Trần Văn Hải', '0891273891', 'haitv@gmail.com', 'Hà Nội', '1987-11-27 00:00:00', 36, 1, 26, 15, 17, '2017-12-06 00:00:00', '', 1, '2018-12-03 09:32:50'),
	(11, 'Mai Thu Trang', '0128937189', 'trangmt@gmail.com', 'Hà Nội', '1991-12-01 00:00:00', 24, 1, 29, 15, 17, '2017-12-04 00:00:00', '', 0, '2018-12-03 09:34:38'),
	(12, 'Trần Tuấn', '0182738912', 'tuan@gmail.com', 'Ha Noi', '1991-11-27 00:00:00', 24, 1, 29, 16, 17, '2017-12-31 00:00:00', '', 1, '2018-12-03 09:35:19'),
	(13, 'Nguyễn Thúy Hiên', '0817237128', 'hiennt@gmail.com', 'Ha Noi', '1981-11-26 00:00:00', 36, 1, 26, 16, 17, '2015-12-31 00:00:00', '', 0, '2018-12-03 09:36:01'),
	(14, 'Đoàn Mạnh Ba', '0182378192', 'badm@gmail.com', 'Ha Noi', '1987-11-26 00:00:00', 24, 1, 29, 15, 17, '2017-12-31 00:00:00', '', 1, '2018-12-03 09:36:54'),
	(15, 'Trần Thu Giang', '0812738912', 'giangtt@gmail.com', 'Hà Nam', '1993-11-29 00:00:00', 3, 0, 29, 15, 22, '2018-11-24 00:00:00', '', 0, '2018-12-03 09:37:56'),
	(16, 'Bùi Tuấn Ngọc', '0891278371', 'ngoncnt@gmail.com', 'Bình Định', '1985-12-06 00:00:00', 36, 1, 26, 21, 17, '2017-12-24 00:00:00', '', 1, '2018-12-03 09:39:47'),
	(17, 'Đỗ Ngọc Lan', '0189278192', 'landn@gmail.com', 'Ha Noi', '1994-11-26 00:00:00', 24, 1, 29, 21, 18, '2018-12-24 00:00:00', '', 0, '2018-12-03 09:40:21'),
	(18, 'Hoàng Thanh Thủy', '0891728371', 'thuyht@gmail.com', 'hà nam', '1994-10-11 00:00:00', 24, -1, 29, 18, 17, '2018-12-11 00:00:00', '', 0, '2018-12-03 09:41:06'),
	(19, 'Vũ Nguyên Hà', '0189273812', 'havn@gmail.com', 'Ha Noi', '1993-11-27 00:00:00', 3, 0, 29, 15, 17, '2018-12-17 00:00:00', '', 1, '2018-12-03 09:42:39'),
	(20, 'Hoàng Đỗ Mạnh', '0817238172', 'thalia@gmail.com', 'Hòa Bình', '1994-12-13 00:00:00', 12, 1, 29, 14, 19, '2018-12-31 00:00:00', '', 1, '2018-12-03 09:43:25');
/*!40000 ALTER TABLE `staff_list` ENABLE KEYS */;

-- Dumping structure for table staffmanager.staff_profile
DROP TABLE IF EXISTS `staff_profile`;
CREATE TABLE IF NOT EXISTS `staff_profile` (
  `staff_id` int(10) NOT NULL,
  `staff_certificate` int(11) NOT NULL DEFAULT 0,
  `staff_health_certificate` int(11) NOT NULL DEFAULT 0,
  `staff_papers` int(11) NOT NULL DEFAULT 0,
  `staff_marital_status` int(11) NOT NULL DEFAULT 0,
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `FK_staff_profile_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff_list` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='giấy tờ nhân viên';

-- Dumping data for table staffmanager.staff_profile: ~14 rows (approximately)
DELETE FROM `staff_profile`;
/*!40000 ALTER TABLE `staff_profile` DISABLE KEYS */;
INSERT INTO `staff_profile` (`staff_id`, `staff_certificate`, `staff_health_certificate`, `staff_papers`, `staff_marital_status`) VALUES
	(7, 1, 1, 1, -1),
	(8, 1, 1, 1, -1),
	(9, 0, 0, 0, 0),
	(10, 0, 0, 0, 0),
	(11, 0, 0, 0, 0),
	(12, 0, 0, 0, 0),
	(13, 0, 0, 0, 0),
	(14, 0, 0, 0, 0),
	(15, 0, 0, 0, 0),
	(16, 0, 0, 0, 0),
	(17, 0, 0, 0, 0),
	(18, 0, 0, 0, 0),
	(19, 0, 0, 0, 0),
	(20, 0, 0, 0, 0);
/*!40000 ALTER TABLE `staff_profile` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.staff_profile_list
DROP PROCEDURE IF EXISTS `staff_profile_list`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_profile_list`()
BEGIN
select staff_list.staff_id,staff_list.staff_fullname,staff_list.staff_email,staff_profile.staff_certificate,staff_profile.staff_health_certificate,staff_profile.staff_papers
,staff_profile.staff_marital_status from staff_profile,staff_list where staff_profile.staff_id=staff_list.staff_id and staff_list.staff_status!=-1 
and (staff_profile.staff_certificate=0 or staff_profile.staff_health_certificate=0 or staff_profile.staff_papers=0 or staff_profile.staff_marital_status=0);
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.staff_quit
DROP PROCEDURE IF EXISTS `staff_quit`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_quit`(
	IN `id` INT

)
BEGIN
DECLARE result int;
if exists(select * from staff_list where staff_list.staff_id=id) 
and not exists(select * from device_tranfers where device_tranfers.staff_id=id and device_tranfers.tranfer_status=1 ) then
update staff_list set staff_status=-1 where staff_id=id;
set result=1;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.staff_quit_list
DROP PROCEDURE IF EXISTS `staff_quit_list`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `staff_quit_list`()
BEGIN
select staff_list.staff_id as id,staff_list.staff_fullname,departments.name,staff_type.type_name,work_type.work_name from staff_list,staff_type,work_type,departments
where staff_list.departments_id=departments.departments_id and staff_list.staff_type_id=staff_type.type_id and work_type.work_id=staff_list.work_id and staff_list.staff_status=-1  order by id;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.staff_type
DROP TABLE IF EXISTS `staff_type`;
CREATE TABLE IF NOT EXISTS `staff_type` (
  `type_id` int(10) NOT NULL AUTO_INCREMENT,
  `type_name` text DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='nhân viên thử việc , chính thức , thời vụ ,';

-- Dumping data for table staffmanager.staff_type: ~7 rows (approximately)
DELETE FROM `staff_type`;
/*!40000 ALTER TABLE `staff_type` DISABLE KEYS */;
INSERT INTO `staff_type` (`type_id`, `type_name`, `last_update`) VALUES
	(24, 'Giám đốc', '2018-12-03 09:25:59'),
	(25, 'Phó giám đốc', '2018-12-03 09:26:05'),
	(26, 'Trưởng phòng', '2018-12-03 09:26:09'),
	(27, 'Phó phòng', '2018-12-03 09:26:14'),
	(28, 'Trưởng nhóm', '2018-12-03 09:26:18'),
	(29, 'Nhân viên', '2018-12-03 09:26:23'),
	(30, 'Khác', '2018-12-03 09:27:02');
/*!40000 ALTER TABLE `staff_type` ENABLE KEYS */;

-- Dumping structure for procedure staffmanager.top_10_device_partner
DROP PROCEDURE IF EXISTS `top_10_device_partner`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `top_10_device_partner`()
BEGIN
select partner_id,partner_name,partner_phone,partner_email from device_partner ORDER BY partner_id DESC  limit 10;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.top_50_new_staff
DROP PROCEDURE IF EXISTS `top_50_new_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `top_50_new_staff`()
BEGIN
select staff_list.staff_id,staff_list.staff_fullname,departments.name,staff_type.type_name from staff_list,departments,staff_type
where staff_list.departments_id=departments.departments_id and staff_list.staff_type_id=staff_type.type_id order by staff_list.staff_id DESC limit 50;
END//
DELIMITER ;

-- Dumping structure for procedure staffmanager.upgrade_probationary_staff
DROP PROCEDURE IF EXISTS `upgrade_probationary_staff`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `upgrade_probationary_staff`(
	IN `id` INT
)
BEGIN
DECLARE result int;
if exists(select * from staff_list where staff_id=id and staff_status=0) then
update staff_list set staff_status=1,contract_time=12 where staff_id=id;
set result=1;
else
set result=-99;
end if;
select result;
END//
DELIMITER ;

-- Dumping structure for table staffmanager.work_type
DROP TABLE IF EXISTS `work_type`;
CREATE TABLE IF NOT EXISTS `work_type` (
  `work_id` int(11) NOT NULL AUTO_INCREMENT,
  `work_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`work_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- Dumping data for table staffmanager.work_type: ~7 rows (approximately)
DELETE FROM `work_type`;
/*!40000 ALTER TABLE `work_type` DISABLE KEYS */;
INSERT INTO `work_type` (`work_id`, `work_name`) VALUES
	(17, 'Toàn thời gian cố định'),
	(18, 'Toàn thời gian tạm thời'),
	(19, 'Bán thời gian cố định'),
	(20, 'Bán thời gian tạm thời'),
	(21, 'Theo hợp đồng / tư vấn'),
	(22, 'Thực tập'),
	(23, 'Khác');
/*!40000 ALTER TABLE `work_type` ENABLE KEYS */;

-- Dumping structure for view staffmanager.device_no_tranfer_list
DROP VIEW IF EXISTS `device_no_tranfer_list`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `device_no_tranfer_list`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `device_no_tranfer_list` AS SELECT device_name,device_tag,device_protection_time,receive_time,device_id
from device_detail where device_status=0 ;

-- Dumping structure for view staffmanager.device_staff_to_it_list
DROP VIEW IF EXISTS `device_staff_to_it_list`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `device_staff_to_it_list`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `device_staff_to_it_list` AS select staff_list.staff_fullname,departments.name,device_detail.device_name,device_detail.device_tag,device_tranfer_staff_to_it.tranfer_time
from departments,staff_list,device_detail,device_tranfer_staff_to_it
where device_tranfer_staff_to_it.departments_id=departments.departments_id and staff_list.staff_id=device_tranfer_staff_to_it.staff_id
and device_detail.device_id=device_tranfer_staff_to_it.device_id ;

-- Dumping structure for view staffmanager.device_tranfer_list
DROP VIEW IF EXISTS `device_tranfer_list`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `device_tranfer_list`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `device_tranfer_list` AS select staff_list.staff_fullname,departments.name,device_detail.device_name,device_detail.device_tag,device_tranfers.tranfers_time,device_tranfers.qrcode_url,device_detail.device_id
from device_tranfers,departments,staff_list,device_detail
where device_tranfers.departments_id=departments.departments_id and staff_list.staff_id=device_tranfers.staff_id
and device_detail.device_id=device_tranfers.device_id and device_tranfers.tranfer_status=1 ;

-- Dumping structure for view staffmanager.device_type_list
DROP VIEW IF EXISTS `device_type_list`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `device_type_list`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `device_type_list` AS SELECT type_id,device_name from device_type ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
