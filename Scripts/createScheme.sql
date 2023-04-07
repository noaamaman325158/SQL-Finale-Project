SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
-- SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- SET global time_zone = '-5:00'; -- commented out in this version

SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
  
-- DROP SCHEMA IF EXISTS mavenmovies; -- commenting out for Maven Course to avoid concerning warning message
-- CREATE SCHEMA 
USE MamansAnalysis;

CREATE TABLE pages(
	page_id TINYINT NOT NULL,
	pageview_url VARCHAR(50) NOT NULL,
    PRIMARY KEY(page_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;
--
-- Creating an empty shell for the table 'website_sessions'. We will populate it later. 
--
CREATE TABLE Users(
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (user_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE device(
  device_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_type VARCHAR(50) NOT NULL,
  PRIMARY KEY (device_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;
--
CREATE TABLE products (
  product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  product_name VARCHAR(50) NOT NULL,
  category_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (product_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE categories(
  category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (category_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE products (
  product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  product_name VARCHAR(50) NOT NULL,
  KEY products_category_id (category_id),
  PRIMARY KEY (product_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE website_sessions (
  website_session_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  is_repeat_session SMALLINT UNSIGNED NOT NULL, 
  utm_source VARCHAR(12), 
  utm_campaign VARCHAR(20),
  utm_content VARCHAR(15), 
  device_id BIGINT UNSIGNED NOT NULL,
  http_referer VARCHAR(30),
  PRIMARY KEY (website_session_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (device_id) REFERENCES device(device_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


-- Creating an empty shell for the table 'website_pageviews'. We will populate it later. 
--

CREATE TABLE website_pageviews (
  website_pageview_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  pageview_url VARCHAR(50) NOT NULL,
  PRIMARY KEY (website_pageview_id),
  FOREIGN KEY (website_session_id) REFERENCES website_sessions (website_session_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  primary_product_id SMALLINT UNSIGNED NOT NULL,
  items_purchased SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (website_session_id) REFERENCES website_sessions (website_session_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'order_items'. We will populate it later. 
--

CREATE TABLE order_items (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  is_primary_item SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'order_item_refunds'. We will populate it later. 
--

CREATE TABLE order_item_refunds (
  order_item_refund_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_item_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  refund_amount_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_refund_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;




--
-- Inserting the data for our categories table table. 
--

INSERT INTO products VALUES 
(1,'2012-03-19 08:00:00','The Original Mr. Fuzzy',2),
(2,'2013-01-06 13:00:00','The Forever Love Bear',3),
(3,'2013-12-12 09:00:00','The Birthday Sugar Panda',4),
(4,'2014-02-05 10:00:00','The Hudson River Mini bear',1);

INSERT INTO device VALUES
(1,'mobile'),
(2,'desktop');

INSERT INTO website_sessions VALUES 
(1,'2012-03-19 08:04:16',1,0,'gsearch','nonbrand','g_ad_1',1,'https://www.gsearch.com'),
(2,'2012-03-19 08:16:49',2,0,'gsearch','nonbrand','g_ad_1',2,'https://www.gsearch.com'),
(3,'2012-03-19 08:26:55',3,0,'gsearch','nonbrand','g_ad_1',2,'https://www.gsearch.com'),
(301364,'2014-08-13 12:43:33',256243,0,'bsearch','nonbrand','b_ad_1',2,'https://www.bsearch.com'),
(4,'2012-03-19 08:37:33',4,0,'gsearch','nonbrand','g_ad_1',2,'https://www.gsearch.com'),
(301645,'2014-08-13 18:15:51',256471,0,'bsearch','nonbrand','b_ad_1',2,'https://www.bsearch.com'),
(5,'2012-03-19 09:00:55',5,0,'gsearch','nonbrand','g_ad_1',1,'https://www.gsearch.com'),
(6,'2012-03-19 09:05:46',6,0,'gsearch','nonbrand','g_ad_1',2,'https://www.gsearch.com'),
(301363,'2014-08-13 12:43:08',256242,0,'bsearch','nonbrand','b_ad_1',1,'https://www.bsearch.com'),
(301743,'2014-08-13 21:33:43',256555,0,NULL,NULL,NULL,1,NULL),
(252950,'2014-05-23 15:43:03',216874,0,'bsearch','brand','b_ad_2',2,'https://www.bsearch.com'),
(252951,'2014-05-23 15:44:15',216875,0,'bsearch','nonbrand','b_ad_1',2,'https://www.bsearch.com');


INSERT INTO pages VALUES
(1,'/home'),
(2,'/products'),
(3,'/cart'),
(4,'/shipping'),
(5,'/billing'),
(6,'/thank-you-for-your-order');

INSERT INTO website_pageviews VALUES
(1,'2012-03-19 08:04:16',1,1),
(2,'2012-03-19 08:16:49',2,1),
(3,'2012-03-19 08:26:55',3,1),
(4,'2012-03-19 08:37:33',4,1),
(5,'2012-03-19 09:00:55',5,1),
(6,'2012-03-19 09:05:46',6,1),
(7,'2012-03-19 09:06:27',7,1),
(8,'2012-03-19 09:10:08',6,2),
(9,'2012-03-19 09:14:02',6,3),
(10,'2012-03-19 09:16:52',6,4),
(11,'2012-03-19 09:19:52',6,5),
(12,'2012-03-19 10:42:46',20,6);

INSERT INTO users VALUE 
(1,"lia","lankary"),
(2,"shir","ratzon"),
(3,"almog","cohen"),
(4,"liel","zecharia"),
(5,"noaa","maman"),
(6,"zehava","jackobson"),
(252950,"Justin","Perez"),
(216874,"Steven","Baker"),
(216875,"Gregory","Baker"),
(256242,"Miguel","Trujillo"),
(256243,"Kenneth","Miller"),
(256471,"Paul","Bowen"),
(256555,"Justin","Ross");

INSERT INTO categories VALUES
(1,'category1'),
(2,'category2'),
(3,'category3'),
(4,'category4');

