CREATE DATABASE /*!32312 IF NOT EXISTS*/ `user_service_db` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `user_service_db`;

-- MySQL dump 10.13  Distrib 8.0.31, for macos12.6 (arm64)
--
-- Host: g1t3-sharedmysql.c9u4ynvjssqf.us-east-2.rds.amazonaws.com    Database: user_service_db
-- ------------------------------------------------------
-- Server version	5.7.38-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_waffleuser'),(22,'Can change user',6,'change_waffleuser'),(23,'Can delete user',6,'delete_waffleuser'),(24,'Can view user',6,'view_waffleuser');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_user_waffleuser_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_user_waffleuser_id` FOREIGN KEY (`user_id`) REFERENCES `user_waffleuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(5,'sessions','session'),(6,'user','waffleuser');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2022-10-26 11:59:57.097302'),(2,'contenttypes','0002_remove_content_type_name','2022-10-26 12:00:00.395483'),(3,'auth','0001_initial','2022-10-26 12:00:04.648264'),(4,'auth','0002_alter_permission_name_max_length','2022-10-26 12:00:05.497618'),(5,'auth','0003_alter_user_email_max_length','2022-10-26 12:00:06.179966'),(6,'auth','0004_alter_user_username_opts','2022-10-26 12:00:06.727136'),(7,'auth','0005_alter_user_last_login_null','2022-10-26 12:00:07.522148'),(8,'auth','0006_require_contenttypes_0002','2022-10-26 12:00:08.130905'),(9,'auth','0007_alter_validators_add_error_messages','2022-10-26 12:00:08.749072'),(10,'auth','0008_alter_user_username_max_length','2022-10-26 12:00:09.418166'),(11,'auth','0009_alter_user_last_name_max_length','2022-10-26 12:00:10.080378'),(12,'auth','0010_alter_group_name_max_length','2022-10-26 12:00:10.945166'),(13,'auth','0011_update_proxy_permissions','2022-10-26 12:00:12.631316'),(14,'auth','0012_alter_user_first_name_max_length','2022-10-26 12:00:13.377433'),(15,'user','0001_initial','2022-10-26 12:00:18.580598'),(16,'admin','0001_initial','2022-10-26 12:00:20.837701'),(17,'admin','0002_logentry_remove_auto_add','2022-10-26 12:00:21.524085'),(18,'admin','0003_logentry_add_action_flag_choices','2022-10-26 12:00:22.294373'),(19,'sessions','0001_initial','2022-10-26 12:00:24.110889');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('z6af3y86ovatcfl7u8hkjeo5v0oe0000','.eJxVzDkOwjAQheG7uMaW1_GYkp4zRGN7TFiUSFkqxN1JpBRQv-9_b9HRuvTdOvPU3as4ixizs1izJAdZ-maaJO2DjAGIdU0loBen3yxTefKwt_VBw21UZRyW6Z7VTtSxzuo6Vn5dDvt30NPcb3UD6yqCAWwtBDDFsqtMpVlvdeJkwGezIdSOEFuy3HQkIIOZMdgoPl_sfkDK:1opkxZ:nCBU0w2QduAjMKTvb7uNeug8xlDpRFG8w0uCRwyPNY4','2022-11-15 06:41:17.664070');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_waffleuser`
--

DROP TABLE IF EXISTS `user_waffleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_waffleuser` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `id` char(32) NOT NULL,
  `telegram_username` longtext,
  `telegram_id` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_waffleuser`
--

LOCK TABLES `user_waffleuser` WRITE;
/*!40000 ALTER TABLE `user_waffleuser` DISABLE KEYS */;
INSERT INTO `user_waffleuser` VALUES ('pbkdf2_sha256$390000$07fO72fAlXxcPCFnbIOnW9$6nLiKypGoVbvXjDq6ZERNLEkglD6qS59znlcb8hlsGc=','2022-11-01 08:08:47.737606',0,'testing@test.com','','','testing@test.com',0,1,'2022-11-01 06:53:27.311139','055434f08bc241ee934958fa8df1e0d3',NULL,NULL),('pbkdf2_sha256$390000$M01GJhGoTZFrAJRfVXvsLG$LdwkRaMEdt1zS0YI8wKgNxsNhXdS64cz7af6OlqBGXs=','2022-11-02 15:32:10.824554',0,'minhtest@gmail.com','','','minhtest@gmail.com',0,1,'2022-11-02 15:12:47.435482','541ef27dd06e4375af8754e260659026','VuQuangMinh317','1205271847'),('pbkdf2_sha256$390000$QeuGlELCUzuvO5kWdjvOBJ$N1s9huvcWEjZmBCwbqtECMUL58LojiR/aS99wPHF5/w=',NULL,0,'minh@gmail.com','','','minh@gmail.com',0,1,'2022-11-02 15:09:32.458604','5a118be92c294a48b1d2b45d0404b20b',NULL,NULL),('pbkdf2_sha256$390000$5wYtrE3SvDC0GUyWl94SHv$sq4etwovObwmK6GbcNceuqDggJ1xXnoTV1abzuLcMWg=','2022-11-01 06:50:02.633818',1,'test','','','test@testing.com',1,1,'2022-11-01 06:41:09.356395','77b328dba36b4f1fa045756ae0d9c584',NULL,NULL),('pbkdf2_sha256$390000$N87cgqkTYbY6HynhczQFYQ$99dVHk0TDu5gVT3SHaCTRCioT9rsry+bGX57cOxbRT8=','2022-11-01 09:45:33.031858',0,'jeistory1@gmail.com','','','jeistory1@gmail.com',0,1,'2022-11-01 06:45:27.340692','bf7e777fe3b74c5e939ddc2bd237b185','jenpoer','1179533573'),('pbkdf2_sha256$390000$fCxcH3qz3GapxMN5F2YlN5$MFIrteMc6AqDAJKUClJ+aS51qrZdoTtzhSQWlOQOOOw=',NULL,0,'test@test.com','','','test@test.com',0,1,'2022-11-01 07:33:03.984607','fecf90343a71423f8e7a7a78be416e95',NULL,NULL);
/*!40000 ALTER TABLE `user_waffleuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_waffleuser_groups`
--

DROP TABLE IF EXISTS `user_waffleuser_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_waffleuser_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `waffleuser_id` char(32) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_waffleuser_groups_waffleuser_id_group_id_bee7989d_uniq` (`waffleuser_id`,`group_id`),
  KEY `user_waffleuser_groups_group_id_3e231161_fk_auth_group_id` (`group_id`),
  CONSTRAINT `user_waffleuser_grou_waffleuser_id_7b2c78ed_fk_user_waff` FOREIGN KEY (`waffleuser_id`) REFERENCES `user_waffleuser` (`id`),
  CONSTRAINT `user_waffleuser_groups_group_id_3e231161_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_waffleuser_groups`
--

LOCK TABLES `user_waffleuser_groups` WRITE;
/*!40000 ALTER TABLE `user_waffleuser_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_waffleuser_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_waffleuser_user_permissions`
--

DROP TABLE IF EXISTS `user_waffleuser_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_waffleuser_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `waffleuser_id` char(32) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_waffleuser_user_per_waffleuser_id_permission_fcd7e49e_uniq` (`waffleuser_id`,`permission_id`),
  KEY `user_waffleuser_user_permission_id_9fcf198b_fk_auth_perm` (`permission_id`),
  CONSTRAINT `user_waffleuser_user_permission_id_9fcf198b_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_waffleuser_user_waffleuser_id_0087235d_fk_user_waff` FOREIGN KEY (`waffleuser_id`) REFERENCES `user_waffleuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_waffleuser_user_permissions`
--

LOCK TABLES `user_waffleuser_user_permissions` WRITE;
/*!40000 ALTER TABLE `user_waffleuser_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_waffleuser_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-02 23:41:47


CREATE DATABASE /*!32312 IF NOT EXISTS*/ `payment_service_db` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `payment_service_db`;
-- MySQL dump 10.13  Distrib 8.0.31, for macos12.6 (arm64)
--
-- Host: g1t3-sharedmysql.c9u4ynvjssqf.us-east-2.rds.amazonaws.com    Database: payment_service_db
-- ------------------------------------------------------
-- Server version	5.7.38-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Accounts`
--

DROP TABLE IF EXISTS `Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Accounts` (
  `userId` varchar(255) NOT NULL,
  `connectedAccountId` varchar(255) NOT NULL,
  `customerId` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accounts`
--

LOCK TABLES `Accounts` WRITE;
/*!40000 ALTER TABLE `Accounts` DISABLE KEYS */;
INSERT INTO `Accounts` VALUES ('a9a57429-9e5c-4630-ada3-36d6498da033','acct_1LyrYWRDIwsG34TK','cus_MiI8zlq5aT1Ryz','2022-10-31 06:33:10','2022-10-31 06:33:10'),('bf7e777f-e3b7-4c5e-939d-dc2bd237b185','acct_1LzEDzIzrFod7QW0','cus_MifZyxmHsJifl1','2022-11-01 06:45:30','2022-11-01 06:45:30'),('ec136f99-ffdb-4700-a17c-0e5e8c1f6cef','acct_1LyrQURTdsCkQDa6','cus_MiI0jJUdzXttro','2022-10-31 06:24:53','2022-10-31 06:24:53'),('f3edc518-279f-43ce-81d4-7151012d377a','acct_1LyrcCIOTywtGlOG','cus_MiICs94aR9iPlm','2022-10-31 06:36:58','2022-10-31 06:36:58');
/*!40000 ALTER TABLE `Accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payments` (
  `bidId` varchar(255) NOT NULL,
  `paymentIntentId` varchar(255) NOT NULL,
  `buyerId` varchar(255) NOT NULL,
  `runnerId` varchar(255) NOT NULL,
  `amountPaid` double NOT NULL,
  `status` varchar(255) NOT NULL,
  `transferred` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`bidId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payments`
--

LOCK TABLES `Payments` WRITE;
/*!40000 ALTER TABLE `Payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `Payments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-02 23:39:32

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `order_service_db` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `order_service_db`;

-- MySQL dump 10.13  Distrib 8.0.31, for macos12.6 (arm64)
--
-- Host: g1t3-sharedmysql.c9u4ynvjssqf.us-east-2.rds.amazonaws.com    Database: order_service_db
-- ------------------------------------------------------
-- Server version	5.7.38-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` varchar(40) NOT NULL,
  `bid_id` varchar(40) DEFAULT NULL,
  `orderer_user_id` varchar(40) NOT NULL,
  `runner_user_id` varchar(40) DEFAULT NULL,
  `orderer_username` varchar(32) NOT NULL,
  `runner_username` varchar(32) DEFAULT NULL,
  `flavour` varchar(128) NOT NULL,
  `quantity` int(11) NOT NULL,
  `delivery_info` varchar(128) NOT NULL,
  `creation_datetime` datetime NOT NULL,
  `expiry_datetime` datetime NOT NULL,
  `final_bid_price` float DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES ('12345678-abcd-abcd-abcd-12345678ord1','12345678-abcd-abcd-abcd-12345678bid1','12345678-abcd-abcd-abcd-12345678usr1','12345678-abcd-abcd-abcd-12345678usr2','user1','user2','Cheese',1,'Deliver to SOE','2022-10-14 08:00:00','2022-10-14 12:00:00',2.5),('12345678-abcd-abcd-abcd-12345678ord2','12345678-abcd-abcd-abcd-12345678bid2','12345678-abcd-abcd-abcd-12345678usr1','12345678-abcd-abcd-abcd-12345678usr2','user1','user2','Strawberry',3,'Deliver to SCIS gate','2022-10-14 08:00:00','2022-10-14 12:05:00',8),('12345678-abcd-abcd-abcd-12345678ord3',NULL,'12345678-abcd-abcd-abcd-12345678usr2',NULL,'user2',NULL,'Kaya',2,'SOA L2','2022-10-14 08:00:00','2022-10-14 12:10:00',NULL),('12345678-abcd-abcd-abcd-12345678ord4',NULL,'12345678-abcd-abcd-abcd-12345678usr3',NULL,'user3',NULL,'PB',1,'SCIS SR 2-1','2022-10-14 08:00:00','2022-10-14 12:15:00',NULL),('12345678-abcd-abcd-abcd-12345678ord5',NULL,'12345678-abcd-abcd-abcd-12345678usr4',NULL,'user4',NULL,'Blueberry Cheese',4,'LKS L1','2022-10-14 08:00:00','2022-10-14 12:20:00',NULL);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-02 23:42:25

CREATE DATABASE `bid_service_db`;
USE `bid_service_db`;

DROP TABLE IF EXISTS `bid`;

CREATE TABLE `bid` (
  `bid_id` varchar(40) NOT NULL,
  `order_id` varchar(40),
  `creation_datetime` DATETIME NOT NULL,
  `expiry_datetime` DATETIME NOT NULL,
  `bid_price` float NOT NULL,
  `bid_status` varchar(32) NOT NULL,
  `last_updated` DATETIME NOT NULL,
  PRIMARY KEY (`bid_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

INSERT INTO `bid` VALUES 
('12345678-abcd-abcd-abcd-12345678bid1','12345678-abcd-abcd-abcd-12345678ord1','2022-10-14 08:00:00', '2022-10-14 12:00:00',2.5,'OPEN','2022-10-14 08:00:00');