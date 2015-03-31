CREATE DATABASE IF NOT EXISTS `flowerty`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE `flowerty`;
    
DROP TABLE IF EXISTS `flowerty`.`address`;

CREATE TABLE `flowerty`.`address` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TOWN` VARCHAR(20) DEFAULT NULL,
  `STREET` VARCHAR(20) DEFAULT NULL,
  `HOUSE` VARCHAR(10) DEFAULT NULL,
  `FLAT` VARCHAR(10) DEFAULT NULL,
  `COUNTRY` VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `flowerty`.`company`;

CREATE TABLE `flowerty`.`company` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(20) DEFAULT NULL,
  `WEBSITE` VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`contact`;

CREATE TABLE `flowerty`.`contact` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(20) NOT NULL,
  `SURNAME` VARCHAR(20) NOT NULL,
  `FATHERNAME` VARCHAR(20) DEFAULT NULL,
  `BIRTHDAY` DATE DEFAULT NULL,
  `EMAIL` VARCHAR(50) DEFAULT NULL,
  `ADDRESS_ID` INT(10) UNSIGNED NOT NULL,
  `COMPANY_ID` INT(10) UNSIGNED NOT NULL,
  CONSTRAINT `contact_address_id`
  FOREIGN KEY (`ADDRESS_ID` )
  REFERENCES `flowerty`.`address` (`ID` )
  ON DELETE CASCADE
  ON UPDATE RESTRICT,
  CONSTRAINT `contact_company_id`
  FOREIGN KEY (`COMPANY_ID` )
  REFERENCES `flowerty`.`company` (`ID` )
  ON DELETE CASCADE
  ON UPDATE RESTRICT,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;


DROP TABLE IF EXISTS `flowerty`.`flower`;
CREATE TABLE `flowerty`.`flower` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`goods`;

CREATE TABLE `flowerty`.`goods` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PRICE` DOUBLE UNSIGNED DEFAULT NULL,
  `FLOWER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `COMPANY_ID` INT(10) UNSIGNED DEFAULT NULL,
  `REMAIN` INT(10) UNSIGNED DEFAULT NULL,
   CONSTRAINT `goods_flower_id` FOREIGN KEY (`FLOWER_ID`) REFERENCES `flowerty`.`flower` (`ID`),
  CONSTRAINT `goods_company_id` FOREIGN KEY (`COMPANY_ID`) REFERENCES `flowerty`.`company` (`ID`),
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;


DROP TABLE IF EXISTS `flowerty`.`state`;
CREATE TABLE `flowerty`.`state` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `DESCRYPTION` ENUM('NEW','ACCEPTED','PROCESSING','READY','DELIVERY','IMPOSSIBLE','CANCELED','CLOSED') DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`right`;
 CREATE TABLE `flowerty`.`right` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` ENUM('CREATE_ORDER','CREATE_CONTACT','EDIT_CONTACT','SEARCH_CONTACT','COMMENT_ORDER','SETTINGS','CREATE_USER','DELETE_USER','EDIT_USER','ASSIGN_ROLE','VIEW_ORDERS_READY','VIEW_ORDERS_ACCEPTED','VIEW_ORDERS_ALL') NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`role`; 
CREATE TABLE `flowerty`.`role` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NAME` ENUM('ORDERS_MANAGER','ORDERS_PROCESSOR','DELIVERY_MANAGER','SUPERVISOR','ADMIN') NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`role_right`;
CREATE TABLE `flowerty`.`role_right` (
  `ROLE_ID` INT(10) UNSIGNED NOT NULL,
  `RIGHT_ID` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`RIGHT_ID`),
  CONSTRAINT `role_right_role_id`
    FOREIGN KEY (`ROLE_ID` )
    REFERENCES  `flowerty`.`role` (`ID` )
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `role_right_right_id`
    FOREIGN KEY (`RIGHT_ID`)
    REFERENCES  `flowerty`.`right` (`ID` )
    ON DELETE CASCADE
    ON UPDATE RESTRICT
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`user`;
CREATE TABLE `flowerty`.`user` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `LOGIN` VARCHAR(20) NOT NULL,
  `PASSWORD` VARCHAR(20) NOT NULL,
  `CONTACT_ID` INT(10) UNSIGNED NOT NULL,
  `ROLE_ID` INT(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `user_contact_id` FOREIGN KEY (`CONTACT_ID`) REFERENCES `flowerty`.`contact` (`ID`),
  CONSTRAINT `user_role_id` FOREIGN KEY (`ROLE_ID`) REFERENCES `flowerty`.`role` (`ID`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`purchase`;
CREATE TABLE `flowerty`.`purchase` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CUSTOMER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `DESCRIPTION` TEXT,
  `MANAGER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `COST` DOUBLE UNSIGNED DEFAULT NULL,
  `STAFF_ID` INT(10) UNSIGNED DEFAULT NULL,
  `DELIVERY_MANAGER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `RECEIVER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `STATE_ID` INT(10) UNSIGNED DEFAULT NULL,
  CONSTRAINT `order_customer_id` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `flowerty`.`contact` (`ID`),
  CONSTRAINT `order_staff_id` FOREIGN KEY (`STAFF_ID`) REFERENCES `flowerty`.`user` (`ID`),
  CONSTRAINT `order_delivery_manager_id` FOREIGN KEY (`DELIVERY_MANAGER_ID`) REFERENCES `flowerty`.`user` (`ID`),
  CONSTRAINT `order_receiver_id` FOREIGN KEY (`RECEIVER_ID`) REFERENCES `flowerty`.`contact` (`ID`),
  CONSTRAINT `order_manager_id` FOREIGN KEY (`MANAGER_ID`) REFERENCES `flowerty`.`user` (`ID`),
  CONSTRAINT `order_state_id` FOREIGN KEY (`STATE_ID`) REFERENCES `flowerty`.`state` (`ID`),
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`item`;
CREATE TABLE `flowerty`.`item` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FLOWER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `ORDER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `QUANTITY` INT(10) UNSIGNED DEFAULT NULL,
   CONSTRAINT `item_flower_id` FOREIGN KEY (`FLOWER_ID`) REFERENCES `flowerty`.`flower` (`ID`),
  CONSTRAINT `item_order_id` FOREIGN KEY (`ORDER_ID`) REFERENCES `flowerty`.`purchase` (`ID`),
  PRIMARY KEY (`ID`)
 ) ENGINE=INNODB;


DROP TABLE IF EXISTS `flowerty`.`order_altering`;
CREATE TABLE `flowerty`.`order_altering` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `DATE` TIMESTAMP NULL DEFAULT NULL,
  `STATE_ID` INT(10) UNSIGNED DEFAULT NULL,
  `USER_ID` INT(10) UNSIGNED DEFAULT NULL,
  `COMMENT` VARCHAR(100) DEFAULT NULL,
  `ORDER_ID` INT(10) UNSIGNED NOT NULL,
  CONSTRAINT `order_altering_state_id` FOREIGN KEY (`STATE_ID`) REFERENCES `state` (`ID`),
  CONSTRAINT `order_altering_user_id` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `order_altering_order_id` FOREIGN KEY (`ORDER_ID`) REFERENCES `purchase` (`ID`) ON DELETE CASCADE,
  PRIMARY KEY (`ID`)
) ENGINE=INNODB;

DROP TABLE IF EXISTS `flowerty`.`phone`;
CREATE TABLE `flowerty`.`phone` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `COUNTRY` VARCHAR(5) DEFAULT NULL,
  `OPERATOR` VARCHAR(5) DEFAULT NULL,
  `NUMBER` VARCHAR(10) DEFAULT NULL,
  `TYPE` ENUM('HOME','CELL') DEFAULT NULL,
  `COMMENT` VARCHAR(50) DEFAULT NULL,
  `CONTACT_ID` INT(10) UNSIGNED DEFAULT NULL,
  CONSTRAINT `phone_contact_id` FOREIGN KEY (`CONTACT_ID`) REFERENCES `flowerty`.`contact` (`ID`) ON DELETE CASCADE,
  PRIMARY KEY (`ID`)
 ) ENGINE=INNODB;
 
 
DROP TABLE IF EXISTS `flowerty`.`user_role`;


INSERT  INTO `company`(`ID`,`NAME`,`WEBSITE`) VALUES (1,'f&j','www.fj.com');
INSERT  INTO `company`(`ID`,`NAME`,`WEBSITE`) VALUES (2,'your flowers','www.yourflowers.com');



INSERT  INTO `address`(`ID`,`TOWN`,`STREET`,`HOUSE`,`FLAT`,`COUNTRY`) VALUES (1,'Minsk',NULL,'10',NULL, NULL);
INSERT  INTO `address`(`ID`,`TOWN`,`STREET`,`HOUSE`,`FLAT`,`COUNTRY`) VALUES (2,'Minsk','Kirova','11','12','Belarus');
INSERT  INTO `address`(`ID`,`TOWN`,`STREET`,`HOUSE`,`FLAT`,`COUNTRY`) VALUES (3,'Moscow','Lermontov','1','2','Russia');


INSERT  INTO `flower`(`ID`,`NAME`) VALUES (1,'Red Rose');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (2,'White Rose');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (3,'Tea Rose');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (4,'Yellow Tulip');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (5,'Red Tulip');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (6,'Camomile');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (7,'Violet');
INSERT  INTO `flower`(`ID`,`NAME`) VALUES (8,'Iris');


INSERT  INTO `goods`(`ID`,`PRICE`,`FLOWER_ID`,`COMPANY_ID`,`REMAIN`) VALUES (1,10.2,1,1,100);
INSERT  INTO `goods`(`ID`,`PRICE`,`FLOWER_ID`,`COMPANY_ID`,`REMAIN`) VALUES (2,12,2,1,50);
INSERT  INTO `goods`(`ID`,`PRICE`,`FLOWER_ID`,`COMPANY_ID`,`REMAIN`) VALUES (3,15,3,2,100);

INSERT  INTO `right`(`ID`,`NAME`) VALUES (1,'ASSIGN_ROLE');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (2,'COMMENT_ORDER');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (3,'CREATE_CONTACT');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (4,'CREATE_ORDER');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (5,'CREATE_USER');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (6,'DELETE_USER');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (7,'EDIT_CONTACT');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (8,'EDIT_USER');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (9,'SEARCH_CONTACT');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (10,'SETTINGS');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (11,'VIEW_ORDERS_ACCEPTED');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (12,'VIEW_ORDERS_READY');
INSERT  INTO `right`(`ID`,`NAME`) VALUES (13,'VIEW_ORDERS_ALL');


INSERT  INTO `role`(`ID`,`NAME`) VALUES (1,'ADMIN');
INSERT  INTO `role`(`ID`,`NAME`) VALUES (2,'DELIVERY_MANAGER');
INSERT  INTO `role`(`ID`,`NAME`) VALUES (3,'ORDERS_MANAGER');
INSERT  INTO `role`(`ID`,`NAME`) VALUES (4,'ORDERS_PROCESSOR');
INSERT  INTO `role`(`ID`,`NAME`) VALUES (5,'SUPERVISOR');

INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (1,1);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (5,2);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (3,3);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (5,3);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (3,4);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (1,5);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (1,6);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (3,7);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (5,7);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (1,8);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (3,9);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (5,9);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (1,10);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (4,11);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (2,12);
INSERT  INTO `role_right`(`ROLE_ID`,`RIGHT_ID`) VALUES (5,13);

INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (1,'ACCEPTED');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (2,'CANCELED');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (3,'CLOSED');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (4,'DELIVERY');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (5,'IMPOSSIBLE');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (6,'NEW');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (7,'PROCESSING');
INSERT  INTO `state`(`ID`,`DESCRYPTION`) VALUES (8,'READY');

INSERT  INTO `contact`(`ID`,`NAME`,`SURNAME`,`FATHERNAME`,`BIRTHDAY`,`EMAIL`,`ADDRESS_ID`,`COMPANY_ID`) VALUES (1,'TestName','TestSurname',NULL,NULL,NULL,1,1);
INSERT  INTO `contact`(`ID`,`NAME`,`SURNAME`,`FATHERNAME`,`BIRTHDAY`,`EMAIL`,`ADDRESS_ID`,`COMPANY_ID`) VALUES (2,'Sergey','Sergeev','Sergeevich','1974-06-12','sergey@mail.com',2,1);


INSERT  INTO `user`(`ID`,`LOGIN`,`PASSWORD`,`CONTACT_ID`,`ROLE_ID`) VALUES (1,'sergeM','sergeM',2,2);
INSERT  INTO `user`(`ID`,`LOGIN`,`PASSWORD`,`CONTACT_ID`,`ROLE_ID`) VALUES (2,'test','test',1,3);