-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2024 at 04:34 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `online_shoe_store`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `shoe_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `first_name`, `last_name`, `email`, `password`, `address`, `phone`) VALUES
(6, 'jack', 'daniels', 'jackdaniels@gmail.com', '$2y$10$aeogkk4b/CXhlo1NI5gBuO4UHkzO5XGmVfcj6Epf/g0hO8O2nt75y', 'mindanao', '01234567'),
(7, 'boss', 'idol', 'bossidol@gmail.com', '$2y$10$60HAO0LfYZD0ln0dFgRNUeAvzcnYwvbwwjFhxV3E/M7huUYwIcT5O', 'Balanga Bataan ', '555666');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `order_status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `shipping_address` varchar(255) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `delivery_fee` decimal(10,2) DEFAULT 0.00,
  `estimated_delivery` int(11) DEFAULT NULL,
  `delivery_method` varchar(50) DEFAULT 'standard',
  `payment_status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending',
  `payment_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `address`, `phone`, `payment_method`, `order_status`, `created_at`, `shipping_address`, `total_amount`, `delivery_fee`, `estimated_delivery`, `delivery_method`, `payment_status`, `payment_date`) VALUES
(83, 7, '', '89283785', 'cash_on_delivery', 'Pending', '2024-11-12 15:31:13', 'sermal, atulano, bataan', 15014.00, 15.00, NULL, 'express', 'pending', NULL),
(84, 6, '', '89283785', 'cash_on_delivery', 'Pending', '2024-11-12 15:32:08', 'sermal, atulano, bataan', 9004.75, 5.00, NULL, 'bike', 'pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `shoe_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `shoe_id`, `quantity`, `price`, `created_at`) VALUES
(97, 83, 3, 1, 14999.00, '2024-11-12 15:31:13'),
(98, 84, 2, 1, 8999.75, '2024-11-12 15:32:08');

-- --------------------------------------------------------

--
-- Table structure for table `shoes`
--

CREATE TABLE `shoes` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `size` decimal(4,1) NOT NULL DEFAULT 9.0,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shoes`
--

INSERT INTO `shoes` (`id`, `name`, `description`, `price`, `size`, `stock`, `image`) VALUES
(1, 'Air Jordan 1 Low ', 'Hidden Nike Air unit in the heel provides lightweight cushioning.', 12999.00, 10.0, 17, 'image1.jpg'),
(2, 'Nike Kobe 8', 'Engineered mesh on the upper is soft and pliable, wrapping around your foot and conforming to its shape.', 8999.75, 9.0, 61, 'image2.jpg'),
(3, 'Air Jordan 4', 'Elegant leather dress shoe', 14999.00, 11.0, 24, 'image3.jpg'),
(4, 'Air Jordan 1 low', 'Encapsulated Air unit provides lightweight cushioning.\r\nLeather and textile materials in the upper are light and durable.', 13999.00, 10.5, 38, 'image4.jpg'),
(5, 'Nike Air Max', 'Classic comfort with modern style', 7999.45, 10.0, 49, 'image5.jpg'),
(6, 'Adidas Ultraboost', 'Premium running shoes with responsive cushioning', 9989.45, 11.0, 50, 'image6.jpg'),
(7, 'Puma RS-X', 'Retro-inspired chunky sneakers', 6999.45, 9.0, 49, 'image7.jpg'),
(8, 'New Balance 574', 'Timeless design with modern comfort', 7499.45, 10.0, 50, 'image8.jpg'),
(9, 'Vans Old Skool', 'Classic skate shoes with style', 6499.45, 9.5, 49, 'image9.jpg'),
(10, 'Converse Chuck Taylor', 'Iconic high-top sneakers', 6999.45, 9.0, 50, 'image10.jpg'),
(11, 'Reebok Classic', 'Vintage-inspired lifestyle shoes', 7999.45, 8.5, 50, 'image11.jpg'),
(12, 'ASICS Gel-Kayano', 'Premium running shoes with superior support', 8879.45, 9.0, 49, 'image12.jpg'),
(13, 'Jordan 1 Low', 'Iconic basketball shoes with street style', 8659.45, 10.0, 50, 'image13.jpg'),
(14, 'Skechers D Lites', 'Comfortable chunky sneakers', 6884.45, 9.5, 49, 'image14.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `shoe_id` (`shoe_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user` (`user_id`),
  ADD KEY `idx_payment_status` (`payment_status`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `shoe_id` (`shoe_id`);

--
-- Indexes for table `shoes`
--
ALTER TABLE `shoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `shoes`
--
ALTER TABLE `shoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `orders_customer_fk` FOREIGN KEY (`user_id`) REFERENCES `customers` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
