SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
-- SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- SET global time_zone = '-5:00'; -- commented out in this version

SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
  
-- DROP SCHEMA IF EXISTS mavenmovies; -- commenting out for Maven Course to avoid concerning warning message
CREATE SCHEMA FinaleSqlProject;
USE FinaleSqlProject;

--
-- Creating an empty shell for the table 'website_sessions'. We will populate it later. 
--


CREATE TABLE device (
  device_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  device_name VARCHAR(12),
  PRIMARY KEY (device_id)
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
  KEY website_sessions_user_id (user_id),
  KEY website_sessions_device_id (device_id),
  CONSTRAINT fk_website_sessions_device_id FOREIGN KEY (device_id) REFERENCES device(device_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'website_pageviews'. We will populate it later. 
--
CREATE TABLE pages(
  page_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  page_relative_url VARCHAR(50) NOT NULL,
  PRIMARY KEY (page_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE website_pageviews (
  website_pageview_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  page_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (website_pageview_id),
  KEY website_pageviews_website_session_id (website_session_id),
  KEY website_pageviews_page_id(page_id),
  CONSTRAINT fk_website_pageviews_website_session_id FOREIGN KEY (website_session_id) REFERENCES website_sessions(website_session_id),
  CONSTRAINT fk_website_pageviews_page_id FOREIGN KEY (page_id) REFERENCES pages(page_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'products'. We will populate it later. 
--

CREATE TABLE categories (
  category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (category_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE products (
  product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  product_name VARCHAR(50) NOT NULL,
  category_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT fk_products_category_id FOREIGN KEY (category_id) REFERENCES categories(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  primary_product_id BIGINT UNSIGNED NOT NULL,
  items_purchased SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_id),
  KEY orders_website_session_id (website_session_id),
  CONSTRAINT fk_orders_primary_product_id FOREIGN KEY (primary_product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE order_items (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  is_primary_item SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_id),
  KEY order_items_order_id (order_id),
  CONSTRAINT fk_order_items_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE order_item_refunds (
  order_item_refund_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_item_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  refund_amount_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_refund_id),
  KEY order_item_refunds_order_id (order_id),
  KEY order_item_refunds_order_item_id (order_item_id),
  CONSTRAINT fk_order_item_refunds_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_order_item_refunds_order_item_id FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

