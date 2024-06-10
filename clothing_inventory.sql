-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 10, 2024 at 09:35 AM
-- Server version: 8.2.0
-- PHP Version: 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `clothing_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `cust_id` int NOT NULL AUTO_INCREMENT,
  `cust_name` varchar(25) DEFAULT NULL,
  `username` varchar(25) DEFAULT NULL,
  `cust_email` varchar(25) DEFAULT NULL,
  `cust_contact` varchar(15) DEFAULT NULL,
  `payment_mode` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`cust_id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`cust_id`, `cust_name`, `username`, `cust_email`, `cust_contact`, `payment_mode`) VALUES
(11, 'New Name', 'newname', 'newname@gmail.com', '765895432', 'UPI'),
(8, 'Kusha Makapur', 'kushamakapur', 'kusha@gmail.com', '99567894532', 'UPI'),
(7, 'Likitha B.K', 'likithabk', 'likitha@gmail.com', '9965083412', 'UPI'),
(6, 'Manas S Kulkarni', 'manaskulkarni', 'kulkarni0703@gmail.com', '+919945401508', 'CREDIT/DEBIT'),
(10, 'Palati Revanth', 'palatirevanth', 'revanth@gmail.com', '9390241856', 'NET BANKING'),
(12, 'Ashrith Vasist', 'ashrithvasist', 'ashrith@gmail.com', '9765834521', 'NET BANKING'),
(13, 'Aisha Kumar', 'aishakumar', 'aisha@gmail.com', '9765834522', 'NET BANKING'),
(14, 'Ayush Kumar', 'ayushkumar', 'ayush@gmail.com', '9765834523', 'NET BANKING'),
(15, 'ROKALLA', 'ROKALLA', 'rokalla@gmail.com', '8899007766', 'CASH'),
(16, 'Rokalla Teja', 'rokallateja', 'rokallateja@gmail.com', '9067544753', 'CREDIT/DEBIT');

--
-- Triggers `customers`
--
DROP TRIGGER IF EXISTS `update_inventory_trigger`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger` AFTER INSERT ON `customers` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_customers = (SELECT COUNT(*) FROM Customers),
        total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_4`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_4` AFTER UPDATE ON `customers` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_customers = (SELECT COUNT(*) FROM Customers),
        total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_7`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_7` AFTER DELETE ON `customers` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_customers = (SELECT COUNT(*) FROM Customers),
        total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `emp_id` int NOT NULL AUTO_INCREMENT,
  `emp_name` varchar(25) DEFAULT NULL,
  `emp_phone` varchar(15) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `emp_salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `emp_name`, `emp_phone`, `date_of_joining`, `emp_salary`) VALUES
(1, 'Amit Kumar', '+91-9876543210', '2022-01-01', 50000.00),
(2, 'Sneha Sharma', '+91-9876543211', '2022-02-15', 55000.00),
(3, 'Rahul Singh', '+91-9876543212', '2022-03-20', 60000.00),
(4, 'Priya Verma', '+91-9876543213', '2022-04-10', 52000.00),
(5, 'Vikas Patel', '+91-9876543214', '2022-05-05', 58000.00),
(6, 'Kavita Gupta', '+91-9876543215', '2022-06-30', 62000.00),
(7, 'Ravi Rajput', '+91-9876543216', '2022-07-12', 54000.00),
(8, 'Shivani Singh Bhadani', '+91-9876543217', '2022-08-25', 56000.00),
(9, 'Ajay Sharma K', '+91-9876543218', '2022-09-18', 58000.00),
(10, 'Anita Yadav', '+91-9876543219', '2022-10-22', 60000.00),
(11, 'Manoj Vishwas', '8445093211', '2024-01-29', 49999.00);

--
-- Triggers `employees`
--
DROP TRIGGER IF EXISTS `update_inventory_trigger_3`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_3` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_employees = (SELECT COUNT(*) FROM Employees);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_6`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_6` AFTER UPDATE ON `employees` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_employees = (SELECT COUNT(*) FROM Employees);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_9`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_9` AFTER DELETE ON `employees` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_employees = (SELECT COUNT(*) FROM Employees);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `garments`
--

DROP TABLE IF EXISTS `garments`;
CREATE TABLE IF NOT EXISTS `garments` (
  `g_id` varchar(15) NOT NULL,
  `garment_type` varchar(25) DEFAULT NULL,
  `garment_category` varchar(25) DEFAULT NULL,
  `available_quantity` int DEFAULT NULL,
  `g_size` int DEFAULT NULL,
  `g_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`g_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `garments`
--

INSERT INTO `garments` (`g_id`, `garment_type`, `garment_category`, `available_quantity`, `g_size`, `g_price`) VALUES
('G001', 'Shirt', 'GENTS', 50, 30, 29.99),
('G002', 'Shirt', 'GENTS', 30, 32, 29.99),
('G003', 'Shirt', 'GENTS', 30, 34, 34.99),
('G004', 'Shirt', 'GENTS', 50, 36, 29.99),
('G005', 'Shirt', 'GENTS', 50, 38, 29.99),
('G006', 'Shirt', 'GENTS', 30, 40, 29.99),
('G007', 'TShirt', 'GENTS', 30, 30, 34.99),
('G008', 'TShirt', 'GENTS', 30, 32, 34.99),
('G009', 'TShirt', 'GENTS', 30, 34, 34.99),
('G0010', 'TShirt', 'GENTS', 30, 36, 34.99),
('G0011', 'TShirt', 'GENTS', 30, 38, 40.00),
('G0012', 'TShirt', 'GENTS', 30, 40, 34.99),
('G0013', 'Jeans', 'LADIES', 20, 30, 39.99),
('G0014', 'Jeans', 'LADIES', 10, 32, 39.99),
('G0015', 'Jeans', 'LADIES', 15, 34, 39.99),
('G0016', 'Jeans', 'LADIES', 20, 36, 39.99),
('G0017', 'Jeans', 'LADIES', 20, 38, 39.99),
('G0018', 'Jeans', 'LADIES', 40, 40, 39.99),
('G0019', 'Trousers', 'GENTS', 40, 30, 34.99),
('G0020', 'Trousers', 'GENTS', 20, 32, 34.99),
('G0021', 'Trousers', 'GENTS', 40, 34, 34.99),
('G0022', 'Trousers', 'GENTS', 40, 36, 34.99),
('G0023', 'Trousers', 'GENTS', 40, 38, 34.99),
('G0024', 'Trousers', 'GENTS', 40, 40, 34.99),
('G0025', 'T-shirt', 'LADIES', 20, 28, 29.99),
('G0026', 'T-shirt', 'LADIES', 35, 30, 29.99),
('G0027', 'T-shirt', 'LADIES', 35, 32, 29.99),
('G0028', 'T-shirt', 'LADIES', 35, 34, 29.99),
('G0029', 'T-shirt', 'LADIES', 25, 36, 29.99),
('G0030', 'T-shirt', 'LADIES', 35, 38, 29.99),
('G0031', 'Jacket', 'GENTS', 10, 36, 59.99),
('G0032', 'Jacket', 'GENTS', 10, 38, 59.99),
('G0033', 'Jacket', 'GENTS', 10, 40, 59.99),
('G0034', 'Jacket', 'GENTS', 10, 42, 59.99),
('G0035', 'Jacket', 'GENTS', 10, 44, 59.99),
('G0036', 'Sweater', 'LADIES', 12, 32, 44.99),
('G0037', 'Sweater', 'LADIES', 10, 34, 44.99),
('G0038', 'Sweater', 'LADIES', 12, 36, 44.99),
('G0039', 'Sweater', 'LADIES', 12, 38, 44.99),
('G0040', 'Sweater', 'LADIES', 2, 40, 44.99),
('G0041', 'Shorts', 'GENTS', 22, 30, 14.99),
('G0042', 'Shorts', 'GENTS', 22, 32, 14.99),
('G0043', 'Shorts', 'GENTS', 22, 34, 14.99),
('G0044', 'Shorts', 'GENTS', 22, 36, 14.99),
('G0045', 'Blazer', 'GENTS', 20, 40, 74.99),
('G0046', 'Blazer', 'GENTS', 10, 42, 74.99),
('G0047', 'Blazer', 'GENTS', 10, 44, 74.99),
('G0048', 'Cardigan', 'LADIES', 8, 34, 54.99),
('G0049', 'Cardigan', 'LADIES', 8, 36, 54.99),
('G0050', 'Cardigan', 'LADIES', 8, 38, 54.99),
('G0051', 'Cardigan', 'LADIES', 4, 40, 54.99),
('G0052', 'Coat', 'GENTS', 5, 42, 89.99),
('G0053', 'Coat', 'GENTS', 5, 44, 89.99),
('G0054', 'Coat', 'GENTS', 5, 46, 89.99),
('G0055', 'Pants', 'LADIES', 25, 30, 34.99),
('G0056', 'Pants', 'LADIES', 25, 32, 34.99),
('G0057', 'Pants', 'LADIES', 25, 34, 34.99),
('G0058', 'Pants', 'LADIES', 25, 36, 34.99),
('G0059', 'Hoodie', 'GENTS', 20, 34, 44.99),
('G0060', 'Hoodie', 'GENTS', 10, 36, 44.99),
('G0061', 'Hoodie', 'GENTS', 20, 38, 44.99),
('G0062', 'Hoodie', 'GENTS', 20, 40, 44.99),
('G0063', 'Hoodie', 'LADIES', 20, 34, 44.99),
('G0064', 'Hoodie', 'LADIES', 20, 36, 44.99),
('G0065', 'Hoodie', 'LADIES', 20, 38, 44.99),
('G0066', 'Hoodie', 'LADIES', 20, 40, 44.99),
('G0067', 'Cap', 'LADIES', 20, 36, 19.99);

--
-- Triggers `garments`
--
DROP TRIGGER IF EXISTS `prevent_negative_quantity`;
DELIMITER $$
CREATE TRIGGER `prevent_negative_quantity` BEFORE UPDATE ON `garments` FOR EACH ROW BEGIN
    IF NEW.available_quantity < 0 THEN
        SET NEW.available_quantity = 0;
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_10`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_10` AFTER INSERT ON `garments` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_products = current_products + 1;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_insert` AFTER INSERT ON `garments` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET current_products = current_products + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
CREATE TABLE IF NOT EXISTS `inventory` (
  `inventory_name` varchar(30) NOT NULL,
  `current_products` int DEFAULT NULL,
  `categories` varchar(30) DEFAULT NULL,
  `current_customers` int DEFAULT NULL,
  `current_employees` int DEFAULT NULL,
  `total_orders` int DEFAULT NULL,
  PRIMARY KEY (`inventory_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inventory_name`, `current_products`, `categories`, `current_customers`, `current_employees`, `total_orders`) VALUES
('ClothingInventory', 21, 'LADIES and GENTS', 10, 11, 28);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `order_number` int NOT NULL AUTO_INCREMENT,
  `order_date` date DEFAULT NULL,
  `bill_amt` decimal(10,2) DEFAULT NULL,
  `cust_id` int DEFAULT NULL,
  `ordered_by` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`order_number`),
  KEY `fk_cust` (`cust_id`)
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_number`, `order_date`, `bill_amt`, `cust_id`, `ordered_by`) VALUES
(27, '2024-02-28', 689.82, 6, 'Manas S Kulkarni'),
(15, '2024-02-22', 149.95, 8, 'Kusha Makapur'),
(16, '2024-02-24', 149.95, 8, 'Kusha Makapur'),
(17, '2024-02-26', 659.82, 7, 'Likitha B.K'),
(30, '2024-02-28', 1564.63, 6, 'Manas S Kulkarni'),
(7, '2024-02-19', 299.90, 8, 'Kusha Makapur'),
(18, '2024-02-26', 499.90, 7, 'Likitha B.K'),
(10, '2024-02-21', 199.90, 9, 'Tejas Kumar'),
(11, '2024-02-21', 199.90, 9, 'Tejas Kumar'),
(12, '2024-02-21', 199.90, 9, 'Tejas Kumar'),
(13, '2024-02-21', 199.90, 9, 'Tejas Kumar'),
(14, '2024-02-22', 649.80, 8, 'Kusha Makapur'),
(31, '2024-02-28', 74.95, 6, 'Manas S Kulkarni'),
(33, '2024-03-06', 549.85, 7, 'Likitha B.K'),
(34, '2024-03-06', 549.85, 7, 'Likitha B.K'),
(35, '2024-03-06', 324.92, 6, 'Manas S Kulkarni'),
(36, '2024-03-11', 709.82, 6, 'Manas S Kulkarni'),
(37, '2024-03-25', 449.85, 14, 'Ayush Kumar'),
(38, '2024-03-25', 449.85, 14, 'Ayush Kumar'),
(44, '2024-05-15', 334.95, 6, 'Manas S Kulkarni'),
(43, '2024-03-26', 999.75, 6, 'Manas S Kulkarni'),
(45, '2024-05-15', 334.95, 6, 'Manas S Kulkarni'),
(46, '2024-05-15', 334.95, 6, 'Manas S Kulkarni'),
(47, '2024-05-15', 334.95, 6, 'Manas S Kulkarni'),
(48, '2024-05-15', 404.91, 7, 'Likitha B.K'),
(49, '2024-05-15', 404.91, 7, 'Likitha B.K'),
(50, '2024-06-05', 374.95, 16, 'Rokalla Teja'),
(51, '2024-06-05', 374.95, 16, 'Rokalla Teja');

--
-- Triggers `orders`
--
DROP TRIGGER IF EXISTS `update_inventory_trigger_2`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_2` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_5`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_5` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `update_inventory_trigger_8`;
DELIMITER $$
CREATE TRIGGER `update_inventory_trigger_8` AFTER DELETE ON `orders` FOR EACH ROW BEGIN
    UPDATE Inventory 
    SET total_orders = (SELECT COUNT(*) FROM Orders);
END
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
