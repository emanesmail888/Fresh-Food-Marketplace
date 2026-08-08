-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 30 يوليو 2026 الساعة 20:31
-- إصدار الخادم: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `order_payment_api`
--

-- --------------------------------------------------------

--
-- بنية الجدول `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `address_line1`, `address_line2`, `city`, `state`, `postal_code`, `country`, `phone`, `created_at`, `updated_at`) VALUES
(1, 14, 'eldabousy mansoura sherbin', 'mansoura', 'Sherbin', 'Mansoura', '147851', 'Egypt', '+201003452188', '2026-07-10 19:10:51', '2026-07-10 19:11:22');

-- --------------------------------------------------------

--
-- بنية الجدول `carts`
--

CREATE TABLE `carts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active',
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `carts`
--

INSERT INTO `carts` (`id`, `session_id`, `user_id`, `status`, `processed_at`, `created_at`, `updated_at`) VALUES
(4, NULL, 4, 'completed', '2026-07-26 23:19:12', '2026-07-15 21:16:43', '2026-07-26 23:19:12'),
(5, NULL, 14, 'completed', '2026-07-18 03:31:04', '2026-07-15 21:22:05', '2026-07-18 03:31:04'),
(6, 'wJ3IMJpzBFUKNBe3lbZbIXu4kI3slrJh08ATYN2s', NULL, 'active', NULL, '2026-07-16 00:12:36', '2026-07-16 00:12:36'),
(7, 'PAH7HogfYY9XHrjiLoP1trBkfhMH01hdAInpbk9n', NULL, 'active', NULL, '2026-07-16 00:12:48', '2026-07-16 00:12:48'),
(8, 'qQpMgisWPdstWZazPUogOZn9uxKnwo9aSXex9oBx', NULL, 'active', NULL, '2026-07-16 00:13:06', '2026-07-16 00:13:06'),
(9, 'pcof8cqML44cwEuMiIyLLd8yoI2YgRu4SFQhqpJs', NULL, 'active', NULL, '2026-07-16 00:13:12', '2026-07-16 00:13:12'),
(10, 'jYF36pHXHG5w0MmET9ZKLDz2AjJFOstphYXU8oLA', NULL, 'active', NULL, '2026-07-16 00:49:02', '2026-07-16 00:49:02'),
(11, 'HufRc4NrAYSubTJ8qx2i4or8GKcxbjMQbEfC49oz', NULL, 'active', NULL, '2026-07-16 00:49:07', '2026-07-16 00:49:07'),
(12, 'D0bDOHNz02Onp1kMJ4PwHnKewDtnRngBD8378V7L', NULL, 'active', NULL, '2026-07-16 00:49:11', '2026-07-16 00:49:11'),
(14, 'IElD9WeEq5OwoeeCUoePSmY9T4bDlWWbL6O4IbHb', NULL, 'active', NULL, '2026-07-18 00:59:43', '2026-07-18 00:59:43'),
(15, 'hpx9DKkNIVo5hVNcP40W0pWqj5lj0Q45WWl5kywd', NULL, 'active', NULL, '2026-07-18 00:59:51', '2026-07-18 00:59:51'),
(17, 'a8RFjVmC0azabzB2H7KKT4m2rS01ponxAqwsPnW0', NULL, 'active', NULL, '2026-07-18 02:58:07', '2026-07-18 02:58:07'),
(18, 'lzoByj4aDuhP2JO9oI7EpvcL25kMgxRK7fGEknZP', NULL, 'active', NULL, '2026-07-20 19:57:50', '2026-07-20 19:57:50'),
(19, 'KsgtZOkNIDzgvArgKRcuUvkKfHuG8urKyHRlhIVz', NULL, 'active', NULL, '2026-07-20 19:58:07', '2026-07-20 19:58:07'),
(20, 'OUXRg7TmU6ebZn5xaOeNYA8cqc4wrkF3IOpgFqQZ', NULL, 'active', NULL, '2026-07-20 19:58:12', '2026-07-20 19:58:12'),
(21, '8wlM1qITIBSQ5eb77tHw2GXdmS4S0hzM9HK21ceX', NULL, 'active', NULL, '2026-07-20 20:08:18', '2026-07-20 20:08:26'),
(22, 'EqVH8lyNuAzwvtVcqSFSRMvFtH6A8XsSRwQ8l1oZ', NULL, 'active', NULL, '2026-07-22 23:06:12', '2026-07-22 23:06:12'),
(23, 'HNYxd1XgFp5FVoA4cbY98iMZyY06acsKnvCIQWA2', NULL, 'active', NULL, '2026-07-22 23:06:16', '2026-07-22 23:06:16'),
(24, 'IX1aFGvn2rfuWVPs9xQfP5zOBXATUgEtignAIp5p', NULL, 'active', NULL, '2026-07-22 23:06:18', '2026-07-22 23:06:18'),
(25, 'xmsoQAHCiHLc2zUjkC4oeivFuE1rB8jZcaB33TZt', NULL, 'active', NULL, '2026-07-22 23:06:45', '2026-07-22 23:06:45'),
(26, 'lMV8cvux9Pswyl00LH8IciBFQ9ThJSawfEBe5oVt', NULL, 'active', NULL, '2026-07-22 23:06:50', '2026-07-22 23:06:50'),
(27, 'kIA9NOBEWrmitik2St8ecP7nhx3EgrMX6jIliW98', NULL, 'active', NULL, '2026-07-22 23:06:51', '2026-07-23 01:13:56'),
(28, 'u2nyUkj2K9Jz1B2D0eeGG6NTsK9KRxsncD7JAnih', NULL, 'active', NULL, '2026-07-22 23:52:52', '2026-07-22 23:52:52'),
(29, '8w0p2DiNtOygKeFxkq7oUSOISkvXOdoHkOF30PpN', NULL, 'active', NULL, '2026-07-22 23:52:53', '2026-07-22 23:52:53'),
(30, '0aFPxbhh0L4cvXhrXpaI5UKJqntm2i2rHgA9vZBl', NULL, 'active', NULL, '2026-07-22 23:52:54', '2026-07-22 23:52:54'),
(31, 'HXmqV8wWqhd3GFU8LSWQ389JqIPu924h9NY5m3pa', NULL, 'active', NULL, '2026-07-23 00:23:41', '2026-07-23 00:23:41'),
(32, 'W79eQauVcywH75ZZjBcSqCHxsMHSNv03WjySn60d', NULL, 'active', NULL, '2026-07-23 00:34:59', '2026-07-23 01:27:53'),
(33, 'DSIXMnydufMJX3i89qth6qO5yiuVGvtOiFceUmQj', NULL, 'active', NULL, '2026-07-23 23:28:46', '2026-07-23 23:28:46'),
(34, 'gAlWObW4q3DJdAdYsOZ7108UIWNcnzeVBZPw9LS2', NULL, 'active', NULL, '2026-07-23 23:28:51', '2026-07-23 23:28:51'),
(35, 'o3UMolKbo8PylgD2aGsY1N73MLnXdGDq2BM1eRWW', NULL, 'active', NULL, '2026-07-24 00:28:14', '2026-07-24 00:28:14'),
(36, '8yz9Na0JLSCIJgQgSEoMJzaDXjBB3MPJfiyRa9n7', NULL, 'active', NULL, '2026-07-24 00:28:20', '2026-07-24 00:28:20'),
(37, 'GkS9fwylqenAJosEimhbiB4f4QsJgq55WB0conaT', NULL, 'active', NULL, '2026-07-24 00:39:00', '2026-07-24 00:39:00'),
(38, '7n9Bz0EH3HdTJk0fYKqjG8OtLNNKMT0Yd12MRykh', NULL, 'active', NULL, '2026-07-24 00:39:05', '2026-07-24 00:39:05'),
(39, 'NC6jqYYtox8bP01MgmCij5uvkCuxaqJowKC3PGaH', NULL, 'active', NULL, '2026-07-24 16:41:37', '2026-07-24 16:41:37'),
(40, 'wEBQicCJCwIUBZE4L5dsMzjGE4l2hISoEbvzRJL0', NULL, 'active', NULL, '2026-07-25 03:20:07', '2026-07-25 03:20:07'),
(41, 'gsXUUxKKfLgYlLpaLyIKf7q3fD9Fi4kLgCfypmRO', NULL, 'active', NULL, '2026-07-25 03:20:15', '2026-07-25 03:20:15'),
(42, 'sNlYcnJHZlRTq3fRj6xAbH0pPMldD1tJoHRwnL7Y', NULL, 'active', NULL, '2026-07-25 03:20:20', '2026-07-25 03:20:20'),
(43, 'MCnydLyc6eUaQIcCZxD6NuFPD6xgU9TruVBloV9L', NULL, 'active', NULL, '2026-07-25 03:20:26', '2026-07-25 03:20:26'),
(44, 'iYow7bxShduw2R9V2AUea7x0354odBLzXCRpYM2n', NULL, 'active', NULL, '2026-07-26 21:04:39', '2026-07-26 22:51:00'),
(45, '6FxDYBOAxBq3Ot6I8Aua4O90myjvxvytBfhqNpp4', NULL, 'active', NULL, '2026-07-26 21:04:46', '2026-07-26 21:04:46'),
(46, '1P3IEuwYPniLSUGvXNprm59j1T8retD1IqeegwGV', NULL, 'active', NULL, '2026-07-26 22:51:02', '2026-07-26 23:13:34'),
(47, 'uT4qKRWILmK4IM8plHn48hHuRMCIzzAJu2T8Msm9', NULL, 'active', NULL, '2026-07-26 23:13:35', '2026-07-26 23:13:35'),
(48, 'z8iUjVzRUUs8hzyrzgrlAHdDd6QNF3x3HBVcL0QB', NULL, 'active', NULL, '2026-07-26 23:16:13', '2026-07-27 00:26:34'),
(50, 'YWL8JwXIfLn1nxohqgunBgfs7xKtaWxGhyjLqhPm', NULL, 'active', NULL, '2026-07-26 23:36:02', '2026-07-26 23:36:02');

-- --------------------------------------------------------

--
-- بنية الجدول `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity_grams` decimal(12,3) NOT NULL DEFAULT 0.000,
  `price_at_add` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `quantity_grams`, `price_at_add`, `created_at`, `updated_at`) VALUES
(14, 20, 13, 500.000, 80.00, '2026-07-20 22:19:43', '2026-07-20 22:19:43'),
(20, 33, 2, 500.000, 10.00, '2026-07-24 03:46:37', '2026-07-24 03:46:37'),
(21, 33, 6, 500.000, 15.00, '2026-07-24 03:46:47', '2026-07-24 04:09:20'),
(22, 33, 7, 500.000, 8.00, '2026-07-24 04:09:13', '2026-07-24 04:09:13'),
(23, 33, 5, 1.000, 230.00, '2026-07-24 04:52:29', '2026-07-24 04:52:29'),
(27, 4, 9, 1000.000, 45.00, '2026-07-26 23:36:18', '2026-07-27 03:55:36'),
(29, 4, 12, 500.000, 20.00, '2026-07-26 23:41:52', '2026-07-27 00:35:22'),
(31, 4, 6, 1100.000, 15.00, '2026-07-26 23:50:48', '2026-07-27 01:29:35'),
(32, 4, 7, 2000.000, 8.00, '2026-07-26 23:52:11', '2026-07-27 03:55:36'),
(33, 4, 14, 1000.000, 25.00, '2026-07-26 23:52:50', '2026-07-27 03:55:36'),
(34, 4, 15, 1000.000, 60.00, '2026-07-26 23:56:20', '2026-07-26 23:56:20'),
(36, 4, 10, 1000.000, 10.00, '2026-07-27 00:10:33', '2026-07-27 00:10:33'),
(37, 4, 18, 1.000, 25.00, '2026-07-27 00:12:43', '2026-07-27 00:12:43'),
(38, 4, 20, 1.000, 5.00, '2026-07-27 02:04:07', '2026-07-27 03:55:36'),
(40, 4, 22, 2.000, 15.00, '2026-07-27 02:06:39', '2026-07-27 03:55:36'),
(41, 5, 20, 1.000, 5.00, '2026-07-27 04:26:51', '2026-07-27 04:26:51'),
(42, 5, 15, 1000.000, 60.00, '2026-07-27 04:26:58', '2026-07-27 04:27:11'),
(43, 5, 14, 1000.000, 25.00, '2026-07-27 04:27:08', '2026-07-27 04:27:21'),
(44, 5, 18, 1.000, 25.00, '2026-07-27 04:27:30', '2026-07-27 04:27:30');

-- --------------------------------------------------------

--
-- بنية الجدول `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_ar` varchar(255) DEFAULT NULL,
  `image` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `categories`
--

INSERT INTO `categories` (`id`, `name`, `name_ar`, `image`, `created_at`, `updated_at`) VALUES
(1, 'flowers', 'زهور', '/storage/Categories/1781757116_4770.webp', '2026-02-05 09:09:01', '2026-06-18 01:31:56'),
(2, 'vegetables', 'خضروات', '/storage/Categories/1781755161_2251.webp', '2026-02-05 08:23:07', '2026-06-18 00:59:21'),
(3, 'fruits', 'فواكه', '/storage/Categories/1781757096_7085.webp', '2026-02-05 08:26:10', '2026-06-18 01:31:36'),
(5, 'seeds', 'بذور', '/storage/Categories/1781757519_9294.webp', '2026-04-27 13:38:31', '2026-06-18 01:38:39'),
(6, 'Leafy vegetables', 'الخضروات الورقية', '/storage/Categories/1782296162_9784.webp', '2026-06-24 07:03:20', '2026-06-24 07:16:02'),
(7, 'Gardening tools', 'أدوات البستنة', '/storage/Categories/1784780203_9356.webp', '2026-07-23 01:16:50', '2026-07-23 01:16:50'),
(8, 'green legumes', 'البقوليات الخضراء', '/storage/Categories/1784960533_2068.webp', '2026-07-25 03:22:15', '2026-07-25 03:22:15');

-- --------------------------------------------------------

--
-- بنية الجدول `contacts`
--

CREATE TABLE `contacts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('pending','read','replied','archived') NOT NULL DEFAULT 'pending',
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `reply` text DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `replied_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `email`, `phone`, `subject`, `message`, `status`, `user_id`, `ip_address`, `user_agent`, `admin_notes`, `reply`, `read_at`, `replied_at`, `updated_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Eman Elgmal', 'emanzidanelgmal@gmail.com', '01003452188', 'first subject', 'first message', 'archived', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-06-23 03:55:30', 4, NULL, '2026-06-23 02:25:24', '2026-06-23 03:55:46');

-- --------------------------------------------------------

--
-- بنية الجدول `discounts`
--

CREATE TABLE `discounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `type` enum('percentage','fixed') NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT NULL,
  `max_discount_amount` decimal(10,2) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `discounts`
--

INSERT INTO `discounts` (`id`, `code`, `type`, `value`, `min_order_amount`, `max_discount_amount`, `expires_at`, `usage_limit`, `used_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'WELCOME10', 'percentage', 10.00, 100.00, 50.00, '2026-10-18 01:56:49', 100, 1, 1, '2026-07-18 01:56:49', '2026-07-18 03:31:03'),
(2, 'SAVE50', 'fixed', 50.00, 200.00, NULL, '2026-08-18 01:56:49', 50, 0, 1, '2026-07-18 01:56:49', '2026-07-18 01:56:49'),
(3, 'WELCOME20', 'percentage', 20.00, 4000.00, 800.00, '2026-12-18 02:56:49', 100, 0, 1, '2026-07-18 01:56:49', '2026-07-18 03:31:03');

-- --------------------------------------------------------

--
-- بنية الجدول `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2026_01_12_023811_create_categories_table', 2),
(7, '2026_01_12_023919_create_products_table', 2),
(8, '2026_01_14_124026_add_is_admin_to_users_table', 2),
(10, '2026_02_08_153159_create_cart_items_table', 3),
(14, '2026_02_16_151159_create_orders_table', 4),
(15, '2026_02_16_151208_create_order_items_table', 4),
(16, '2026_02_16_152631_create_payments_table', 5),
(17, '2026_02_08_153139_create_carts_table', 6),
(19, '2026_05_17_232859_create_settings_table', 7),
(20, '2026_06_11_162002_create_services_table', 8),
(21, '2026_06_23_045312_create_contacts_table', 9),
(22, '2026_06_28_101238_create_reviews_table', 10),
(23, '2026_06_30_193250_create_addresses_table', 11),
(24, '2026_06_30_193325_create_wishlists_table', 11),
(25, '2026_06_30_195749_add_fields_to_users_table', 12),
(26, '2026_07_18_042555_create_discounts_table', 13);

-- --------------------------------------------------------

--
-- بنية الجدول `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_number` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax` decimal(10,2) NOT NULL DEFAULT 0.00,
  `shipping_cost` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `currency` varchar(255) NOT NULL DEFAULT 'EGP',
  `discount_code` varchar(255) DEFAULT NULL,
  `discount_type` varchar(255) DEFAULT NULL,
  `currency_symbol` varchar(255) NOT NULL DEFAULT 'E£',
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `payment_status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `payment_method` varchar(255) DEFAULT NULL,
  `shipping_status` varchar(255) NOT NULL DEFAULT 'pending',
  `shipping_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`shipping_address`)),
  `billing_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`billing_address`)),
  `tracking_number` varchar(255) DEFAULT NULL,
  `shipping_carrier` varchar(255) DEFAULT NULL,
  `shipping_method` varchar(255) DEFAULT NULL,
  `shipping_notes` text DEFAULT NULL,
  `customer_notes` text DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `refunded_at` timestamp NULL DEFAULT NULL,
  `refunded_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `refund_reason` text DEFAULT NULL,
  `refund_status` varchar(255) DEFAULT NULL,
  `partial_refunds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`partial_refunds`)),
  `refunded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `cancelled_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `user_id`, `subtotal`, `tax`, `shipping_cost`, `discount`, `total`, `currency`, `discount_code`, `discount_type`, `currency_symbol`, `status`, `payment_status`, `payment_method`, `shipping_status`, `shipping_address`, `billing_address`, `tracking_number`, `shipping_carrier`, `shipping_method`, `shipping_notes`, `customer_notes`, `admin_notes`, `refunded_at`, `refunded_total`, `refund_reason`, `refund_status`, `partial_refunds`, `refunded_by`, `paid_at`, `shipped_at`, `delivered_at`, `cancelled_at`, `created_by`, `updated_by`, `cancelled_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'ORD-20260222-F2AVSU', 4, 30.50, 4.27, 12.00, 0.00, 46.77, 'EGP', '', '', 'E£', 'cancelled', 'refunded', 'stripe', 'cancelled', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'express', NULL, NULL, NULL, '2026-02-21 23:02:02', 0.00, NULL, NULL, NULL, NULL, '2026-02-21 23:01:06', NULL, NULL, '2026-02-21 23:02:02', 4, 4, NULL, '2026-02-21 23:00:23', '2026-06-22 05:14:48', NULL),
(2, 'ORD-20260228-CCTZVI', 4, 70.50, 9.87, 6.00, 0.00, 86.37, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-02-27 22:04:26', NULL, '2026-06-22 04:02:43', NULL, 4, 4, NULL, '2026-02-27 22:02:45', '2026-06-22 04:02:43', NULL),
(3, 'ORD-20260428-JW66VB', 4, 219803.00, 30772.42, 6.00, 0.00, 250581.42, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-06-22 03:53:16', NULL, '2026-06-22 03:53:16', NULL, 4, 4, NULL, '2026-04-28 09:33:45', '2026-06-22 03:53:16', NULL),
(4, 'ORD-20260428-ZGQYXR', 4, 450.00, 63.00, 6.00, 0.00, 519.00, 'EGP', '', '', 'E£', 'completed', 'unpaid', 'stripe', 'delivered', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-22 03:29:51', NULL, 4, 4, NULL, '2026-04-28 09:40:28', '2026-06-22 03:29:51', NULL),
(5, 'ORD-20260428-VJO4QX', 4, 450.00, 63.00, 6.00, 0.00, 519.00, 'EGP', '', '', 'E£', 'cancelled', 'refunded', 'stripe', 'cancelled', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, '2026-04-28 09:53:18', 0.00, NULL, NULL, NULL, NULL, '2026-04-28 09:47:29', NULL, NULL, '2026-04-28 09:53:18', 4, 4, NULL, '2026-04-28 09:46:43', '2026-06-22 04:02:00', NULL),
(6, 'ORD-20260504-8U61HC', 4, 450.00, 63.00, 6.00, 0.00, 519.00, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-06-22 03:47:02', NULL, '2026-06-22 03:47:02', NULL, 4, 4, NULL, '2026-05-04 14:51:19', '2026-06-22 03:47:02', NULL),
(7, 'ORD-20260504-HLLBZ2', 4, 933.00, 130.62, 6.00, 0.00, 1069.62, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-05-04 14:59:21', NULL, '2026-06-22 05:13:29', NULL, 4, 4, NULL, '2026-05-04 14:58:45', '2026-06-22 05:13:30', NULL),
(8, 'ORD-20260505-I2QMKZ', 4, 263.00, 36.82, 6.00, 0.00, 305.82, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"fatma zidan\",\"email\":\"emanesmail@yahoo.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"mansoura\",\"state\":\"Egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"fatma zidan\",\"email\":\"emanesmail@yahoo.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"mansoura\",\"state\":\"Egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-06-22 03:42:35', NULL, '2026-06-22 05:14:30', NULL, 4, 4, NULL, '2026-05-05 15:55:21', '2026-06-22 05:14:30', NULL),
(9, 'ORD-20260515-6H2EF5', 4, 923.00, 129.22, 6.00, 0.00, 1058.22, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629 \\u2014 Dakahlia Governorate\",\"postal_code\":\"12545\",\"country\":\"EG\"}', '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629 \\u2014 Dakahlia Governorate\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-05-14 23:00:35', NULL, '2026-06-22 03:26:15', NULL, 4, 4, NULL, '2026-05-14 22:59:42', '2026-06-22 03:26:15', NULL),
(10, 'ORD-20260622-TS9A5X', 4, 473.00, 66.22, 6.00, 0.00, 545.22, 'EGP', '', '', 'E£', 'cancelled', 'refunded', 'stripe', 'cancelled', '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, '2026-06-22 07:44:57', 0.00, NULL, NULL, NULL, NULL, '2026-06-22 07:42:26', NULL, NULL, '2026-06-22 07:44:57', 4, 4, NULL, '2026-06-22 07:41:34', '2026-06-22 07:46:05', NULL),
(11, 'ORD-20260711-J5G459', 14, 80.00, 11.20, 6.00, 0.00, 97.20, 'EGP', '', '', 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"egypt\",\"city\":\"mansoura\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"egypt\",\"city\":\"mansoura\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-11 00:08:48', NULL, '2026-07-11 00:14:48', NULL, 14, 4, NULL, '2026-07-11 00:07:51', '2026-07-11 00:14:48', NULL),
(12, 'ORD-20260715-SWXXDZ', 4, 80.00, 11.20, 6.00, 0.00, 97.20, 'EGP', '', '', 'E£', 'pending', 'unpaid', 'stripe', 'pending', '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452158\",\"address_line1\":\"egypt\",\"address_line2\":\"egypt\",\"city\":\"egypt\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452158\",\"address_line1\":\"egypt\",\"address_line2\":\"egypt\",\"city\":\"egypt\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-15 12:20:14', '2026-07-15 12:20:14', NULL),
(13, 'ORD-20260716-UHZVGB', 4, 140.00, 19.60, 6.00, 0.00, 165.60, 'EGP', '', '', 'E£', 'pending', 'paid', 'stripe', 'pending', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-15 21:02:03', NULL, NULL, NULL, 4, 4, NULL, '2026-07-15 21:00:37', '2026-07-15 21:02:03', NULL),
(14, 'ORD-20260716-V2AGZF', 4, 140.00, 19.60, 6.00, 0.00, 165.60, 'EGP', '', '', 'E£', 'pending', 'unpaid', 'cash_on_delivery', 'pending', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-15 21:17:58', '2026-07-15 21:17:58', NULL),
(15, 'ORD-20260716-97BNOY', 14, 60.00, 8.40, 6.00, 0.00, 74.40, 'EGP', '', '', 'E£', 'pending', 'paid', 'stripe', 'pending', '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"\\u0627\\u0644\\u062f\\u0628\\u0648\\u0633\\u0649 \\u0634\\u0631\\u0628\\u064a\\u0646 \\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"address_line2\":\"sherbin\",\"city\":\"\\u0634\\u0631\\u0628\\u064a\\u0646\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"\\u0627\\u0644\\u062f\\u0628\\u0648\\u0633\\u0649 \\u0634\\u0631\\u0628\\u064a\\u0646 \\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"address_line2\":\"sherbin\",\"city\":\"\\u0634\\u0631\\u0628\\u064a\\u0646\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-15 21:24:45', NULL, NULL, NULL, 14, 14, NULL, '2026-07-15 21:23:48', '2026-07-15 21:24:45', NULL),
(16, 'ORD-20260718-BU9DXE', 14, 165.00, 23.10, 6.00, 16.50, 177.60, 'EGP', 'WELCOME10', 'percentage', 'E£', 'pending', 'paid', 'stripe', 'pending', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-18 03:32:17', NULL, NULL, NULL, 14, 14, NULL, '2026-07-18 03:31:03', '2026-07-18 03:32:17', NULL),
(17, 'ORD-20260721-6DU2LI', 4, 35.00, 4.90, 6.00, 0.00, 45.90, 'EGP', NULL, NULL, 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-20 21:05:35', NULL, '2026-07-26 21:33:05', NULL, 4, 4, NULL, '2026-07-20 21:03:41', '2026-07-26 21:33:05', NULL),
(18, 'ORD-20260721-6XPIPX', 4, 40.00, 5.60, 6.00, 0.00, 51.60, 'EGP', NULL, NULL, 'E£', 'completed', 'paid', 'stripe', 'delivered', '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, '2026-07-21 01:07:59', NULL, '2026-07-26 21:48:04', NULL, 4, 4, NULL, '2026-07-21 01:03:17', '2026-07-26 21:48:04', NULL),
(19, 'ORD-20260727-QPDLNA', 4, 660.50, 92.47, 6.00, 0.00, 758.97, 'EGP', NULL, NULL, 'E£', 'pending', 'unpaid', 'stripe', 'pending', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, 'standard', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-26 23:19:12', '2026-07-26 23:19:12', NULL);

-- --------------------------------------------------------

--
-- بنية الجدول `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `unit_cost` decimal(10,2) DEFAULT NULL,
  `quantity_grams` decimal(12,3) NOT NULL DEFAULT 0.000,
  `total` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unit` varchar(255) NOT NULL DEFAULT 'kg',
  `weight` decimal(8,2) DEFAULT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `product_image`, `unit_price`, `unit_cost`, `quantity_grams`, `total`, `discount`, `unit`, `weight`, `options`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 1500.000, 19.50, 0.00, 'kg', 1.50, NULL, '2026-02-21 23:00:23', '2026-02-21 23:00:23'),
(2, 1, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 1100.000, 11.00, 0.00, 'kg', 1.10, NULL, '2026-02-21 23:00:23', '2026-02-21 23:00:23'),
(3, 2, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 2500.000, 25.00, 0.00, 'kg', 2.50, NULL, '2026-02-27 22:02:45', '2026-02-27 22:02:45'),
(4, 2, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 3500.000, 45.50, 0.00, 'kg', 3.50, NULL, '2026-02-27 22:02:45', '2026-02-27 22:02:45'),
(5, 3, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-04-28 09:33:45', '2026-04-28 09:33:45'),
(6, 3, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 1000.000, 13.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-04-28 09:33:45', '2026-04-28 09:33:45'),
(7, 3, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 999.000, 219780.00, 0.00, 'pack', 99.90, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":999,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"999 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-04-28 09:33:45', '2026-04-28 09:33:45'),
(8, 4, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 1.000, 220.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-04-28 09:40:28', '2026-04-28 09:40:28'),
(9, 4, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 1.000, 230.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-04-28 09:40:28', '2026-04-28 09:40:28'),
(10, 5, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 1.000, 220.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-04-28 09:46:43', '2026-04-28 09:46:43'),
(11, 5, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 1.000, 230.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-04-28 09:46:43', '2026-04-28 09:46:43'),
(12, 6, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 1.000, 220.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-04 14:51:20', '2026-05-04 14:51:20'),
(13, 6, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 1.000, 230.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-04 14:51:20', '2026-05-04 14:51:20'),
(14, 7, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 2000.000, 20.00, 0.00, 'kg', 2.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"2.00 kg\\\"}\"', '2026-05-04 14:58:45', '2026-05-04 14:58:45'),
(15, 7, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 1000.000, 13.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-05-04 14:58:45', '2026-05-04 14:58:45'),
(16, 7, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 2.000, 440.00, 0.00, 'pack', 0.20, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"2 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-04 14:58:45', '2026-05-04 14:58:45'),
(17, 7, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 2.000, 460.00, 0.00, 'pack', 0.20, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"2 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-04 14:58:45', '2026-05-04 14:58:45'),
(18, 8, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 2000.000, 20.00, 0.00, 'kg', 2.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"2.00 kg\\\"}\"', '2026-05-05 15:55:21', '2026-05-05 15:55:21'),
(19, 8, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 1000.000, 13.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-05-05 15:55:21', '2026-05-05 15:55:21'),
(20, 8, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 1.000, 230.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-05 15:55:21', '2026-05-05 15:55:21'),
(21, 9, 2, 'tomatoes', '/uploads/Products/1770289567_4044.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-05-14 22:59:42', '2026-05-14 22:59:42'),
(22, 9, 3, 'cucumber', '/uploads/Products/1770289830_9608.webp', 13.00, NULL, 1000.000, 13.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-05-14 22:59:42', '2026-05-14 22:59:42'),
(23, 9, 4, 'Cherry tomato seeds', '/uploads/Products/1777311815_8287.webp', 220.00, NULL, 2.000, 440.00, 0.00, 'pack', 0.20, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"2 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-14 22:59:42', '2026-05-14 22:59:42'),
(24, 9, 5, 'eggplant seeds', '/uploads/Products/1777311741_6139.webp', 230.00, NULL, 2.000, 460.00, 0.00, 'pack', 0.20, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"2 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-05-14 22:59:42', '2026-05-14 22:59:42'),
(25, 10, 2, 'tomatoes', '/storage/Products/1781913691_5067.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-06-22 07:41:34', '2026-06-22 07:41:34'),
(26, 10, 3, 'cucumber', '/storage/Products/1781924839_8364.webp', 13.00, NULL, 1000.000, 13.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-06-22 07:41:34', '2026-06-22 07:41:34'),
(27, 10, 4, 'Cherry tomato seeds', '/storage/Products/1781914463_2431.webp', 220.00, NULL, 1.000, 220.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-06-22 07:41:34', '2026-06-22 07:41:34'),
(28, 10, 5, 'eggplant seeds', '/storage/Products/1781914490_4537.webp', 230.00, NULL, 1.000, 230.00, 0.00, 'pack', 0.10, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"1 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-06-22 07:41:34', '2026-06-22 07:41:34'),
(29, 11, 12, 'orange', '/storage/Products/1783624726_1100.webp', 20.00, NULL, 1000.000, 20.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-11 00:07:51', '2026-07-11 00:07:51'),
(30, 11, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-11 00:07:51', '2026-07-11 00:07:51'),
(31, 12, 12, 'orange', '/storage/Products/1783624726_1100.webp', 20.00, NULL, 1000.000, 20.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 12:20:14', '2026-07-15 12:20:14'),
(32, 12, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 12:20:14', '2026-07-15 12:20:14'),
(33, 13, 13, 'red apples', '/storage/Products/1783625021_5456.webp', 80.00, NULL, 1000.000, 80.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:00:37', '2026-07-15 21:00:37'),
(34, 13, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:00:37', '2026-07-15 21:00:37'),
(35, 14, 13, 'red apples', '/storage/Products/1783625021_5456.webp', 80.00, NULL, 1000.000, 80.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:17:58', '2026-07-15 21:17:58'),
(36, 14, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:17:58', '2026-07-15 21:17:58'),
(37, 15, 6, 'Colored pepper', '/storage/Products/1782293047_3372.webp', 15.00, NULL, 1000.000, 15.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:23:48', '2026-07-15 21:23:48'),
(38, 15, 9, 'Green grapes', '/storage/Products/1783618190_1969.webp', 45.00, NULL, 1000.000, 45.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-15 21:23:48', '2026-07-15 21:23:48'),
(39, 16, 6, 'Colored pepper', '/storage/Products/1782293047_3372.webp', 15.00, NULL, 1000.000, 15.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-18 03:31:03', '2026-07-18 03:31:03'),
(40, 16, 2, 'tomatoes', '/storage/Products/1781913691_5067.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-18 03:31:03', '2026-07-18 03:31:03'),
(41, 16, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-18 03:31:03', '2026-07-18 03:31:03'),
(42, 16, 13, 'red apples', '/storage/Products/1783625021_5456.webp', 80.00, NULL, 1000.000, 80.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-18 03:31:04', '2026-07-18 03:31:04'),
(43, 17, 14, 'Banana', '/storage/Products/1783625254_4129.webp', 25.00, NULL, 1000.000, 25.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-20 21:03:41', '2026-07-20 21:03:41'),
(44, 17, 10, 'yellow onion', '/storage/Products/1783624378_5472.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-20 21:03:41', '2026-07-20 21:03:41'),
(45, 18, 10, 'yellow onion', '/storage/Products/1783624378_5472.webp', 10.00, NULL, 1000.000, 10.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-21 01:03:17', '2026-07-21 01:03:17'),
(46, 18, 14, 'Banana', '/storage/Products/1783625254_4129.webp', 30.00, NULL, 1000.000, 30.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-21 01:03:17', '2026-07-21 01:03:17'),
(47, 19, 15, 'Mangoes', '/storage/Products/1783635393_2665.webp', 60.00, NULL, 1000.000, 60.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12'),
(48, 19, 10, 'yellow onion', '/storage/Products/1783624378_5472.webp', 10.00, NULL, 1500.000, 15.00, 0.00, 'kg', 1.50, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1.5,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.50 kg\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12'),
(49, 19, 11, 'Red onion', '/storage/Products/1783624540_7654.webp', 12.00, NULL, 1500.000, 18.00, 0.00, 'kg', 1.50, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1.5,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.50 kg\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12'),
(50, 19, 14, 'Banana', '/storage/Products/1783625254_4129.webp', 25.00, NULL, 2500.000, 62.50, 0.00, 'kg', 2.50, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":2.5,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"2.50 kg\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12'),
(51, 19, 5, 'eggplant seeds', '/storage/Products/1781914490_4537.webp', 230.00, NULL, 2.000, 460.00, 0.00, 'pack', 0.20, '\"{\\\"unit_type\\\":\\\"pack\\\",\\\"quantity_value\\\":2,\\\"unit_label\\\":\\\"\\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\",\\\"quantity_display\\\":\\\"2 \\\\u062d\\\\u0632\\\\u0645\\\\u0629\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12'),
(52, 19, 9, 'Green grapes', '/storage/Products/1783618190_1969.webp', 45.00, NULL, 1000.000, 45.00, 0.00, 'kg', 1.00, '\"{\\\"unit_type\\\":\\\"kg\\\",\\\"quantity_value\\\":1,\\\"unit_label\\\":\\\"kg\\\",\\\"quantity_display\\\":\\\"1.00 kg\\\"}\"', '2026-07-26 23:19:12', '2026-07-26 23:19:12');

-- --------------------------------------------------------

--
-- بنية الجدول `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `payment_method` enum('stripe','paypal','cash_on_delivery','bank_transfer','wallet') NOT NULL DEFAULT 'stripe',
  `status` enum('pending','processing','completed','failed','refunded','partial_refunded','cancelled','on_hold') NOT NULL DEFAULT 'pending',
  `amount` decimal(10,2) NOT NULL,
  `refunded_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(255) NOT NULL DEFAULT 'EGP',
  `transaction_id` varchar(255) DEFAULT NULL,
  `payment_intent_id` varchar(255) DEFAULT NULL,
  `stripe_session_id` varchar(255) DEFAULT NULL,
  `stripe_charge_id` varchar(255) DEFAULT NULL,
  `paypal_order_id` varchar(255) DEFAULT NULL,
  `paypal_payer_id` varchar(255) DEFAULT NULL,
  `paypal_payment_id` varchar(255) DEFAULT NULL,
  `stripe_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stripe_response`)),
  `paypal_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`paypal_response`)),
  `cod_due_date` timestamp NULL DEFAULT NULL,
  `cod_collected_at` timestamp NULL DEFAULT NULL,
  `cod_collected_by` varchar(255) DEFAULT NULL,
  `cod_notes` text DEFAULT NULL,
  `payment_description` varchar(255) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_phone` varchar(255) DEFAULT NULL,
  `billing_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`billing_address`)),
  `shipping_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`shipping_address`)),
  `failure_reason` varchar(255) DEFAULT NULL,
  `failure_code` varchar(255) DEFAULT NULL,
  `failure_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`failure_response`)),
  `refunded_at` timestamp NULL DEFAULT NULL,
  `refund_amount` decimal(10,2) DEFAULT NULL,
  `refund_reason` text DEFAULT NULL,
  `refund_transaction_id` varchar(255) DEFAULT NULL,
  `stripe_refund_id` varchar(255) DEFAULT NULL,
  `refund_metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`refund_metadata`)),
  `refund_status` enum('pending','processing','completed','failed') DEFAULT NULL,
  `refund_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`refund_history`)),
  `refunded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `processed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `payment_method`, `status`, `amount`, `refunded_amount`, `currency`, `transaction_id`, `payment_intent_id`, `stripe_session_id`, `stripe_charge_id`, `paypal_order_id`, `paypal_payer_id`, `paypal_payment_id`, `stripe_response`, `paypal_response`, `cod_due_date`, `cod_collected_at`, `cod_collected_by`, `cod_notes`, `payment_description`, `metadata`, `customer_name`, `customer_email`, `customer_phone`, `billing_address`, `shipping_address`, `failure_reason`, `failure_code`, `failure_response`, `refunded_at`, `refund_amount`, `refund_reason`, `refund_transaction_id`, `stripe_refund_id`, `refund_metadata`, `refund_status`, `refund_history`, `refunded_by`, `paid_at`, `completed_at`, `created_by`, `updated_by`, `processed_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'stripe', 'refunded', 46.77, 0.00, 'EGP', 'pi_3T3R2gHRQ6zvO89h0s0wk57Z', 'pi_3T3R2gHRQ6zvO89h0s0wk57Z', 'cs_test_b1xgYcJC4ePrxF1Bi5caT4XfyV87MA5urMv22VnajJl6zGZYupIqmAYPzt', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1xgYcJC4ePrxF1Bi5caT4XfyV87MA5urMv22VnajJl6zGZYupIqmAYPzt\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":4677,\\\"amount_total\\\":4677,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"1\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"fatma Esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1771722028,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"fatma Esmail\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1771808427,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260222-F2AVSU\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3T3R2gHRQ6zvO89h0s0wk57Z\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260222-F2AVSU', NULL, 'fatma Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, '2026-02-21 23:02:02', 46.77, 'Cancelled by customer', 're_3T3R2gHRQ6zvO89h0HlFhBNd', 're_3T3R2gHRQ6zvO89h0HlFhBNd', NULL, NULL, NULL, NULL, '2026-02-21 23:01:05', '2026-02-21 23:01:05', 4, 4, NULL, '2026-02-21 23:00:23', '2026-02-21 23:02:02', NULL),
(2, 2, 'stripe', 'completed', 86.37, 0.00, 'EGP', 'pi_3T5b0zHRQ6zvO89h1bCrDcmE', 'pi_3T5b0zHRQ6zvO89h1bCrDcmE', 'cs_test_b1Q8fdPihSvAWrPNBKB1wKWWJTzzDrUVqpce8d8DkVtPtTaj64fzSAOEmG', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1Q8fdPihSvAWrPNBKB1wKWWJTzzDrUVqpce8d8DkVtPtTaj64fzSAOEmG\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":8637,\\\"amount_total\\\":8637,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"2\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"fatma Esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1772236967,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"fatma Esmail\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1772323367,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260228-CCTZVI\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3T5b0zHRQ6zvO89h1bCrDcmE\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260228-CCTZVI', NULL, 'fatma Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-27 22:04:25', '2026-02-27 22:04:25', 4, 4, NULL, '2026-02-27 22:02:45', '2026-02-27 22:04:25', NULL),
(3, 3, 'stripe', 'pending', 250581.42, 0.00, 'EGP', NULL, NULL, 'cs_test_b1TtpRvIZr4UyJcsMeJwExNQcTg1YLJjvAIR1TUd39mI7dhslrIpj7GayC', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1TtpRvIZr4UyJcsMeJwExNQcTg1YLJjvAIR1TUd39mI7dhslrIpj7GayC\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":5277942,\\\"amount_total\\\":5277942,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"3\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":null},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1777379628,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":null,\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":null,\\\"phone\\\":null,\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":null},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1777466028,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260428-JW66VB\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":null,\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"unpaid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"open\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":\\\"https:\\\\\\/\\\\\\/checkout.stripe.com\\\\\\/c\\\\\\/pay\\\\\\/cs_test_b1TtpRvIZr4UyJcsMeJwExNQcTg1YLJjvAIR1TUd39mI7dhslrIpj7GayC#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdicGRmZGhqaWBTZHdsZGtxJz8nZmprcXdqaScpJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRIT19zQk1XVDN%2Fc0o9PG1QRExydXJqSk5OZEhxYVBJTTVJMHd1YXVoN2N1QENITEJiSz1BNjxgUmtrUFdhV3EzN2tqX11oZ05uaXdGVTdXSWY1bGA0fGk1NWZhQzc0YjFyJyknY3dqaFZgd3Ngdyc%2FcXdwYCknZ2RmbmJ3anBrYUZqaWp3Jz8nJmNjY2NjYycpJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl\\\",\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260428-JW66VB', NULL, 'Eman Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-04-28 09:33:45', '2026-04-28 09:33:58', NULL),
(4, 4, 'stripe', 'pending', 519.00, 0.00, 'EGP', NULL, NULL, 'cs_test_b1Qz3bQ3haZjEuuatxBiFBRYRC5o5OgWQwjE4wvM2JSbi9yrSVczi2lD27', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1Qz3bQ3haZjEuuatxBiFBRYRC5o5OgWQwjE4wvM2JSbi9yrSVczi2lD27\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":11400,\\\"amount_total\\\":11400,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"4\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":null},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1777380031,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":null,\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":null,\\\"phone\\\":null,\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":null},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1777466430,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260428-ZGQYXR\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":null,\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"unpaid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"open\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":\\\"https:\\\\\\/\\\\\\/checkout.stripe.com\\\\\\/c\\\\\\/pay\\\\\\/cs_test_b1Qz3bQ3haZjEuuatxBiFBRYRC5o5OgWQwjE4wvM2JSbi9yrSVczi2lD27#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdicGRmZGhqaWBTZHdsZGtxJz8nZmprcXdqaScpJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRIT19zQk1XVDN%2Fc0o9PG1QRExydXJqSk5OZEhxYVBJTTVJMHd1YXVoN2N1QENITEJiSz1BNjxgUmtrUFdhV3EzN2tqX11oZ05uaXdGVTdXSWY1bGA0fGk1NWZhQzc0YjFyJyknY3dqaFZgd3Ngdyc%2FcXdwYCknZ2RmbmJ3anBrYUZqaWp3Jz8nJmNjY2NjYycpJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl\\\",\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260428-ZGQYXR', NULL, 'Eman Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-04-28 09:40:28', '2026-04-28 09:40:30', NULL),
(5, 5, 'stripe', 'refunded', 519.00, 0.00, 'EGP', 'pi_3TRB2rHRQ6zvO89h1r1jf2ok', 'pi_3TRB2rHRQ6zvO89h1r1jf2ok', 'cs_test_b1LW1rNvXsBrinKE5GqOyWKeJvbQXFAgTZ5YrFI4YyGgB4SUJj96Gdr1qB', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1LW1rNvXsBrinKE5GqOyWKeJvbQXFAgTZ5YrFI4YyGgB4SUJj96Gdr1qB\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":51900,\\\"amount_total\\\":51900,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"5\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"Eman Esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1777380405,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"Eman Esmail\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1777466805,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260428-VJO4QX\\\",\\\"order_total\\\":\\\"519.00\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TRB2rHRQ6zvO89h1r1jf2ok\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260428-VJO4QX', NULL, 'Eman Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, '2026-04-28 09:53:19', 519.00, 'Cancelled by customer', 're_3TRB2rHRQ6zvO89h1FAezuhd', 're_3TRB2rHRQ6zvO89h1FAezuhd', NULL, NULL, NULL, NULL, '2026-04-28 09:47:29', '2026-04-28 09:47:29', 4, 4, NULL, '2026-04-28 09:46:43', '2026-04-28 09:53:19', NULL),
(6, 6, 'stripe', 'pending', 519.00, 0.00, 'EGP', NULL, NULL, 'cs_test_b1M49HqXVfCjMDykSZ1xqfW4p8ljaDTJBVsqr6OYJv43ywcmcB1OvkQuLP', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1M49HqXVfCjMDykSZ1xqfW4p8ljaDTJBVsqr6OYJv43ywcmcB1OvkQuLP\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":51900,\\\"amount_total\\\":51900,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"6\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":null},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1777917082,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":null,\\\"business_name\\\":null,\\\"email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":null,\\\"phone\\\":null,\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":null},\\\"customer_email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1778003482,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260504-8U61HC\\\",\\\"order_total\\\":\\\"519.00\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":null,\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"unpaid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"open\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":\\\"https:\\\\\\/\\\\\\/checkout.stripe.com\\\\\\/c\\\\\\/pay\\\\\\/cs_test_b1M49HqXVfCjMDykSZ1xqfW4p8ljaDTJBVsqr6OYJv43ywcmcB1OvkQuLP#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdicGRmZGhqaWBTZHdsZGtxJz8nZmprcXdqaScpJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRIT19zQk1XVDN%2Fc0o9PG1QRExydXJqSk5OZEhxYVBJTTVJMHd1YXVoN2N1QENITEJiSz1BNjxgUmtrUFdhV3EzN2tqX11oZ05uaXdGVTdXSWY1bGA0fGk1NWZhQzc0YjFyJyknY3dqaFZgd3Ngdyc%2FcXdwYCknZ2RmbmJ3anBrYUZqaWp3Jz8nJmNjY2NjYycpJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl\\\",\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260504-8U61HC', NULL, 'eman esmail Elgmal', 'emanesmailzidan@gmail.com', '01003452188', NULL, '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-05-04 14:51:20', '2026-05-04 14:51:30', NULL),
(7, 7, 'stripe', 'completed', 1069.62, 0.00, 'EGP', 'pi_3TTQlwHRQ6zvO89h0IxlWuSi', 'pi_3TTQlwHRQ6zvO89h0IxlWuSi', 'cs_test_b1y1igPKhd1l0XWYfVkVSR99QntEFwzFu2HkDElIshhnZ9v6JcDtX2c6Fy', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1y1igPKhd1l0XWYfVkVSR99QntEFwzFu2HkDElIshhnZ9v6JcDtX2c6Fy\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":106962,\\\"amount_total\\\":106962,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"7\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0641\\\\u064a\\\\u0648\\\\u0645\\\"},\\\"name\\\":\\\"fatma Esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1777917527,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0641\\\\u064a\\\\u0648\\\\u0645\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"fatma Esmail\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1778003926,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260504-HLLBZ2\\\",\\\"order_total\\\":\\\"1069.62\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TTQlwHRQ6zvO89h0IxlWuSi\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260504-HLLBZ2', NULL, 'fatma Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"fatma Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"Egypt\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-04 14:59:21', '2026-05-04 14:59:21', 4, 4, NULL, '2026-05-04 14:58:45', '2026-05-04 14:59:21', NULL),
(8, 8, 'stripe', 'pending', 305.82, 0.00, 'EGP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260505-I2QMKZ', NULL, 'fatma zidan', 'emanesmail@yahoo.com', '01003452188', NULL, '{\"name\":\"fatma zidan\",\"email\":\"emanesmail@yahoo.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"mansoura\",\"state\":\"Egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-05-05 15:55:21', '2026-05-05 15:55:21', NULL),
(9, 9, 'stripe', 'completed', 1058.22, 0.00, 'EGP', 'pi_3TXB36HRQ6zvO89h1PnCbHeh', 'pi_3TXB36HRQ6zvO89h1PnCbHeh', 'cs_test_b1XOIovNEiYubZ9rVZRYPUV81njQYJpdpSGhWfuLTEnef2tHZsSEgmrK6v', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1XOIovNEiYubZ9rVZRYPUV81njQYJpdpSGhWfuLTEnef2tHZsSEgmrK6v\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":105822,\\\"amount_total\\\":105822,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"9\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"Eman Esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1778810384,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"Egypt\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"Egypt\\\",\\\"line2\\\":\\\"Egypt\\\",\\\"postal_code\\\":\\\"12545\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"Eman Esmail\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1778896784,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260515-6H2EF5\\\",\\\"order_total\\\":\\\"1058.22\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TXB36HRQ6zvO89h1PnCbHeh\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260515-6H2EF5', NULL, 'Eman Esmail', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"Eman Esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"Egypt\",\"city\":\"Egypt\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629 \\u2014 Dakahlia Governorate\",\"postal_code\":\"12545\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-14 23:00:34', '2026-05-14 23:00:34', 4, 4, NULL, '2026-05-14 22:59:42', '2026-05-14 23:00:34', NULL),
(10, 10, 'stripe', 'refunded', 545.22, 0.00, 'EGP', 'pi_3Tl5IwHRQ6zvO89h1QO5NLX0', 'pi_3Tl5IwHRQ6zvO89h1QO5NLX0', 'cs_test_b1bITNgwEoCUDisZY6rqPtaHniLpbM4Oay4wV7oZosFID7789q59BEVNdJ', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1bITNgwEoCUDisZY6rqPtaHniLpbM4Oay4wV7oZosFID7789q59BEVNdJ\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":54522,\\\"amount_total\\\":54522,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"10\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0648\\\\u0627\\\\u062f\\\\u064a \\\\u0627\\\\u0644\\\\u062c\\\\u062f\\\\u064a\\\\u062f\\\"},\\\"name\\\":\\\"Eman Elgmal\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1782124897,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0648\\\\u0627\\\\u062f\\\\u064a \\\\u0627\\\\u0644\\\\u062c\\\\u062f\\\\u064a\\\\u062f\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"Eman Elgmal\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1782211297,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260622-TS9A5X\\\",\\\"order_total\\\":\\\"545.22\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3Tl5IwHRQ6zvO89h1QO5NLX0\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260622-TS9A5X', NULL, 'Eman Elgmal', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, '2026-06-22 07:44:57', 545.22, 'Cancelled by customer', 're_3Tl5IwHRQ6zvO89h1tIbyiRT', 're_3Tl5IwHRQ6zvO89h1tIbyiRT', NULL, NULL, NULL, NULL, '2026-06-22 07:42:26', '2026-06-22 07:42:26', 4, 4, NULL, '2026-06-22 07:41:34', '2026-06-22 07:44:57', NULL),
(11, 11, 'stripe', 'completed', 97.20, 0.00, 'EGP', 'pi_3TrrHOHRQ6zvO89h0jAQKnFM', 'pi_3TrrHOHRQ6zvO89h0jAQKnFM', 'cs_test_b18NW2uBa1XdUEiHthmgTC92oivP2079h5WTi1ocuxhbTy0rlyT7nTv8hm', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b18NW2uBa1XdUEiHthmgTC92oivP2079h5WTi1ocuxhbTy0rlyT7nTv8hm\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":9720,\\\"amount_total\\\":9720,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"11\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"\\\\u0634\\\\u0631\\\\u0628\\\\u064a\\\\u0646\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0628\\\\u0648\\\\u0633\\\\u0649 \\\\u0634\\\\u0631\\\\u0628\\\\u064a\\\\u0646 \\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"35811\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"FATMA ALZAHRAA ESMAEL\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1783739273,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"\\\\u0634\\\\u0631\\\\u0628\\\\u064a\\\\u0646\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0628\\\\u0648\\\\u0633\\\\u0649 \\\\u0634\\\\u0631\\\\u0628\\\\u064a\\\\u0646 \\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"35811\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"FATMA ALZAHRAA ESMAEL\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1783825673,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260711-J5G459\\\",\\\"order_total\\\":\\\"97.20\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"14\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TrrHOHRQ6zvO89h0jAQKnFM\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260711-J5G459', NULL, 'FATMA ALZAHRAA ESMAEL', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"Egypt\",\"address_line2\":\"egypt\",\"city\":\"mansoura\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-11 00:08:48', '2026-07-11 00:08:48', 14, 14, NULL, '2026-07-11 00:07:51', '2026-07-11 00:08:48', NULL);
INSERT INTO `payments` (`id`, `order_id`, `payment_method`, `status`, `amount`, `refunded_amount`, `currency`, `transaction_id`, `payment_intent_id`, `stripe_session_id`, `stripe_charge_id`, `paypal_order_id`, `paypal_payer_id`, `paypal_payment_id`, `stripe_response`, `paypal_response`, `cod_due_date`, `cod_collected_at`, `cod_collected_by`, `cod_notes`, `payment_description`, `metadata`, `customer_name`, `customer_email`, `customer_phone`, `billing_address`, `shipping_address`, `failure_reason`, `failure_code`, `failure_response`, `refunded_at`, `refund_amount`, `refund_reason`, `refund_transaction_id`, `stripe_refund_id`, `refund_metadata`, `refund_status`, `refund_history`, `refunded_by`, `paid_at`, `completed_at`, `created_by`, `updated_by`, `processed_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(12, 12, 'stripe', 'pending', 97.20, 0.00, 'EGP', NULL, NULL, 'cs_test_b1Ao3gY6Wo6PBNXVdmMEcfvr04w6cGWnG83F8bpbNT9jRGu3KHsoQQpR6B', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1Ao3gY6Wo6PBNXVdmMEcfvr04w6cGWnG83F8bpbNT9jRGu3KHsoQQpR6B\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":9720,\\\"amount_total\\\":9720,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"12\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":null},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784128816,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":null,\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":null,\\\"phone\\\":null,\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":null},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784215216,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260715-SWXXDZ\\\",\\\"order_total\\\":\\\"97.20\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":null,\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"unpaid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"open\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":\\\"https:\\\\\\/\\\\\\/checkout.stripe.com\\\\\\/c\\\\\\/pay\\\\\\/cs_test_b1Ao3gY6Wo6PBNXVdmMEcfvr04w6cGWnG83F8bpbNT9jRGu3KHsoQQpR6B#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdicGRmZGhqaWBTZHdsZGtxJz8nZmprcXdqaScpJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRIT19zQk1XVDN%2Fc0o9PG1QRExydXJqSk5OZEhxYVBJTTVJMHd1YXVoN2N1QENITEJiSz1BNjxgUmtrUFdhV3EzN2tqX11oZ05uaXdGVTdXSWY1bGA0fGk1NWZhQzc0YjFyJyknY3dqaFZgd3Ngdyc%2FcXdwYCknZ2RmbmJ3anBrYUZqaWp3Jz8nJmNjY2NjYycpJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl\\\",\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260715-SWXXDZ', NULL, 'Eman Elgmal', 'emanzidanelgmal@gmail.com', '01003452158', NULL, '{\"name\":\"Eman Elgmal\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452158\",\"address_line1\":\"egypt\",\"address_line2\":\"egypt\",\"city\":\"egypt\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-15 12:20:14', '2026-07-15 12:20:28', NULL),
(13, 13, 'stripe', 'completed', 165.60, 0.00, 'EGP', 'pi_3TtckIHRQ6zvO89h1r44k8oc', 'pi_3TtckIHRQ6zvO89h1r44k8oc', 'cs_test_b11RnpLAXI8DmtTPY3cgxY4POyFaxi90SCoDFDw7oEoZLaxkPX0oPSzZl3', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b11RnpLAXI8DmtTPY3cgxY4POyFaxi90SCoDFDw7oEoZLaxkPX0oPSzZl3\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":16560,\\\"amount_total\\\":16560,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"13\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0641\\\\u064a\\\\u0648\\\\u0645\\\"},\\\"name\\\":\\\"eman esmail Elgmal\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784160040,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0641\\\\u064a\\\\u0648\\\\u0645\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"eman esmail Elgmal\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784246440,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260716-UHZVGB\\\",\\\"order_total\\\":\\\"165.60\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TtckIHRQ6zvO89h1r44k8oc\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260716-UHZVGB', NULL, 'eman esmail Elgmal', 'emanesmailzidan@gmail.com', '01003452188', NULL, '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-15 21:02:02', '2026-07-15 21:02:02', 4, 4, NULL, '2026-07-15 21:00:37', '2026-07-15 21:02:02', NULL),
(14, 14, 'cash_on_delivery', 'on_hold', 165.60, 0.00, 'EGP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-22 21:17:58', NULL, NULL, NULL, 'Order #ORD-20260716-V2AGZF', NULL, 'eman esmail Elgmal', 'emanesmailzidan@gmail.com', '01003452188', NULL, '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-15 21:17:58', '2026-07-15 21:17:58', NULL),
(15, 15, 'stripe', 'completed', 74.40, 0.00, 'EGP', 'pi_3Ttd6KHRQ6zvO89h1PRFybna', 'pi_3Ttd6KHRQ6zvO89h1PRFybna', 'cs_test_b10SR8URmJgk8FhiDIFr58OB4vR71iYCBz7bb3Tipqa1tgGt9mNA5d0dgC', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b10SR8URmJgk8FhiDIFr58OB4vR71iYCBz7bb3Tipqa1tgGt9mNA5d0dgC\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":7440,\\\"amount_total\\\":7440,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"15\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0648\\\\u0627\\\\u062f\\\\u064a \\\\u0627\\\\u0644\\\\u062c\\\\u062f\\\\u064a\\\\u062f\\\"},\\\"name\\\":\\\"eman esmail Elgmal\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784161429,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0648\\\\u0627\\\\u062f\\\\u064a \\\\u0627\\\\u0644\\\\u062c\\\\u062f\\\\u064a\\\\u062f\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"eman esmail Elgmal\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784247829,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260716-97BNOY\\\",\\\"order_total\\\":\\\"74.40\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"14\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3Ttd6KHRQ6zvO89h1PRFybna\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260716-97BNOY', NULL, 'FATMA ALZAHRAA ESMAEL', 'emanzidanelgmal@gmail.com', '01003452188', NULL, '{\"name\":\"FATMA ALZAHRAA ESMAEL\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"\\u0627\\u0644\\u062f\\u0628\\u0648\\u0633\\u0649 \\u0634\\u0631\\u0628\\u064a\\u0646 \\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"address_line2\":\"sherbin\",\"city\":\"\\u0634\\u0631\\u0628\\u064a\\u0646\",\"state\":\"\\u0627\\u0644\\u062f\\u0642\\u0647\\u0644\\u064a\\u0629\",\"postal_code\":\"35811\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-15 21:24:45', '2026-07-15 21:24:45', 14, 14, NULL, '2026-07-15 21:23:48', '2026-07-15 21:24:45', NULL),
(16, 16, 'stripe', 'completed', 177.60, 0.00, 'EGP', 'pi_3TuRnBHRQ6zvO89h10oFopmM', 'pi_3TuRnBHRQ6zvO89h10oFopmM', 'cs_test_b1pj0yMXa8GTmeJ4Rku07We7M5Xo6pmIew137CmvDGlkoAkDqYZrEQmgPf', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1pj0yMXa8GTmeJ4Rku07We7M5Xo6pmIew137CmvDGlkoAkDqYZrEQmgPf\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":19410,\\\"amount_total\\\":19410,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"16\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"name\\\":\\\"eman esmail Elgmal\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784356270,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"omr ibn elkhatab\\\",\\\"line2\\\":\\\"sherbin\\\",\\\"postal_code\\\":\\\"123456\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u062f\\\\u0642\\\\u0647\\\\u0644\\\\u064a\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"eman esmail Elgmal\\\",\\\"phone\\\":\\\"+201003452188\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784442670,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260718-BU9DXE\\\",\\\"order_total\\\":\\\"177.60\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"14\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TuRnBHRQ6zvO89h10oFopmM\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260718-BU9DXE', NULL, 'eman esmail Elgmal', 'emanesmailzidan@gmail.com', '01003452188', NULL, '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-18 03:32:17', '2026-07-18 03:32:17', 14, 14, NULL, '2026-07-18 03:31:04', '2026-07-18 03:32:17', NULL),
(17, 17, 'stripe', 'completed', 45.90, 0.00, 'EGP', 'pi_3TvRBTHRQ6zvO89h03GaNyZm', 'pi_3TvRBTHRQ6zvO89h03GaNyZm', 'cs_test_b1FxSQCjqEFuuYNvHPf3a8aLnQTpqqWH1NamAEEStq6WmOwZlMI65ew30j', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1FxSQCjqEFuuYNvHPf3a8aLnQTpqqWH1NamAEEStq6WmOwZlMI65ew30j\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":4590,\\\"amount_total\\\":4590,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"17\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"mansoura\\\",\\\"line2\\\":\\\"mansoura\\\",\\\"postal_code\\\":\\\"12345\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0642\\\\u0627\\\\u0647\\\\u0631\\\\u0629\\\"},\\\"name\\\":\\\"eman esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784592224,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"mansoura\\\",\\\"line2\\\":\\\"mansoura\\\",\\\"postal_code\\\":\\\"12345\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0642\\\\u0627\\\\u0647\\\\u0631\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"eman esmail\\\",\\\"phone\\\":\\\"+20100314521\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784678623,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260721-6DU2LI\\\",\\\"order_total\\\":\\\"45.90\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TvRBTHRQ6zvO89h03GaNyZm\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260721-6DU2LI', NULL, 'eman esmail', 'emanzidanelgmal@gmail.com', '0100314521', NULL, '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-20 21:05:35', '2026-07-20 21:05:35', 4, 4, NULL, '2026-07-20 21:03:41', '2026-07-20 21:05:35', NULL),
(18, 18, 'stripe', 'completed', 51.60, 0.00, 'EGP', 'pi_3TvUy7HRQ6zvO89h1SliIQE9', 'pi_3TvUy7HRQ6zvO89h1SliIQE9', 'cs_test_b1dO4XJT6RR1U53ly6sXDVI9T7bkfBaJ2kaCbUznxYwvnzgKhXgeJwYuaK', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1dO4XJT6RR1U53ly6sXDVI9T7bkfBaJ2kaCbUznxYwvnzgKhXgeJwYuaK\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":5160,\\\"amount_total\\\":5160,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"18\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"mansoura\\\",\\\"line2\\\":\\\"mansoura\\\",\\\"postal_code\\\":\\\"12345\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0642\\\\u0627\\\\u0647\\\\u0631\\\\u0629\\\"},\\\"name\\\":\\\"eman esmail\\\"}},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1784606599,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":{\\\"city\\\":\\\"mansoura\\\",\\\"country\\\":\\\"EG\\\",\\\"line1\\\":\\\"mansoura\\\",\\\"line2\\\":\\\"mansoura\\\",\\\"postal_code\\\":\\\"12345\\\",\\\"state\\\":\\\"\\\\u0627\\\\u0644\\\\u0642\\\\u0627\\\\u0647\\\\u0631\\\\u0629\\\"},\\\"business_name\\\":null,\\\"email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":\\\"eman esmail\\\",\\\"phone\\\":\\\"+20100314521\\\",\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":[]},\\\"customer_email\\\":\\\"emanzidanelgmal@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1784692999,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260721-6XPIPX\\\",\\\"order_total\\\":\\\"51.60\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":\\\"pi_3TvUy7HRQ6zvO89h1SliIQE9\\\",\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"paid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"complete\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":null,\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260721-6XPIPX', NULL, 'eman esmail', 'emanzidanelgmal@gmail.com', '0100314521', NULL, '{\"name\":\"eman esmail\",\"email\":\"emanzidanelgmal@gmail.com\",\"phone\":\"0100314521\",\"address_line1\":\"mansoura\",\"address_line2\":\"mansoura\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"12345\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-21 01:07:59', '2026-07-21 01:07:59', 4, 4, NULL, '2026-07-21 01:03:17', '2026-07-21 01:07:59', NULL),
(19, 19, 'stripe', 'pending', 758.97, 0.00, 'EGP', NULL, NULL, 'cs_test_b1fveEuq3RoFPYnpzCoeFZNiEGhdbOt2TBDmiOia0SPqbnUyQcxUJeh2VO', NULL, NULL, NULL, NULL, '\"{\\\"id\\\":\\\"cs_test_b1fveEuq3RoFPYnpzCoeFZNiEGhdbOt2TBDmiOia0SPqbnUyQcxUJeh2VO\\\",\\\"object\\\":\\\"checkout.session\\\",\\\"adaptive_pricing\\\":{\\\"enabled\\\":true},\\\"after_expiration\\\":null,\\\"allow_promotion_codes\\\":null,\\\"amount_subtotal\\\":75897,\\\"amount_total\\\":75897,\\\"automatic_tax\\\":{\\\"enabled\\\":false,\\\"liability\\\":null,\\\"provider\\\":null,\\\"status\\\":null},\\\"billing_address_collection\\\":null,\\\"branding_settings\\\":{\\\"background_color\\\":\\\"#ffffff\\\",\\\"border_style\\\":\\\"rounded\\\",\\\"button_color\\\":\\\"#0074d4\\\",\\\"display_name\\\":\\\"Fatma Esmail\\\",\\\"font_family\\\":\\\"default\\\",\\\"icon\\\":null,\\\"logo\\\":null},\\\"cancel_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\",\\\"client_reference_id\\\":\\\"19\\\",\\\"client_secret\\\":null,\\\"collected_information\\\":{\\\"business_name\\\":null,\\\"individual_name\\\":null,\\\"shipping_details\\\":null},\\\"consent\\\":null,\\\"consent_collection\\\":null,\\\"created\\\":1785118754,\\\"currency\\\":\\\"egp\\\",\\\"currency_conversion\\\":null,\\\"custom_fields\\\":[],\\\"custom_text\\\":{\\\"after_submit\\\":null,\\\"shipping_address\\\":null,\\\"submit\\\":null,\\\"terms_of_service_acceptance\\\":null},\\\"customer\\\":null,\\\"customer_account\\\":null,\\\"customer_creation\\\":\\\"if_required\\\",\\\"customer_details\\\":{\\\"address\\\":null,\\\"business_name\\\":null,\\\"email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"individual_name\\\":null,\\\"name\\\":null,\\\"phone\\\":null,\\\"tax_exempt\\\":\\\"none\\\",\\\"tax_ids\\\":null},\\\"customer_email\\\":\\\"emanesmailzidan@gmail.com\\\",\\\"discounts\\\":[],\\\"expires_at\\\":1785205154,\\\"integration_identifier\\\":null,\\\"invoice\\\":null,\\\"invoice_creation\\\":{\\\"enabled\\\":false,\\\"invoice_data\\\":{\\\"account_tax_ids\\\":null,\\\"custom_fields\\\":null,\\\"description\\\":null,\\\"footer\\\":null,\\\"issuer\\\":null,\\\"metadata\\\":[],\\\"rendering_options\\\":null}},\\\"livemode\\\":false,\\\"locale\\\":null,\\\"managed_payments\\\":{\\\"enabled\\\":false},\\\"metadata\\\":{\\\"order_number\\\":\\\"ORD-20260727-QPDLNA\\\",\\\"order_total\\\":\\\"758.97\\\",\\\"payment_method\\\":\\\"stripe\\\",\\\"user_id\\\":\\\"4\\\"},\\\"mode\\\":\\\"payment\\\",\\\"origin_context\\\":null,\\\"payment_intent\\\":null,\\\"payment_link\\\":null,\\\"payment_method_collection\\\":\\\"if_required\\\",\\\"payment_method_configuration_details\\\":null,\\\"payment_method_options\\\":{\\\"card\\\":{\\\"request_three_d_secure\\\":\\\"automatic\\\"}},\\\"payment_method_types\\\":[\\\"card\\\"],\\\"payment_status\\\":\\\"unpaid\\\",\\\"permissions\\\":null,\\\"phone_number_collection\\\":{\\\"enabled\\\":true},\\\"recovered_from\\\":null,\\\"saved_payment_method_options\\\":null,\\\"setup_intent\\\":null,\\\"shipping_address_collection\\\":{\\\"allowed_countries\\\":[\\\"EG\\\"]},\\\"shipping_cost\\\":null,\\\"shipping_options\\\":[],\\\"status\\\":\\\"open\\\",\\\"submit_type\\\":null,\\\"subscription\\\":null,\\\"success_url\\\":\\\"http:\\\\\\/\\\\\\/localhost:5173\\\\\\/checkout\\\\\\/success?session_id={CHECKOUT_SESSION_ID}\\\",\\\"total_details\\\":{\\\"amount_discount\\\":0,\\\"amount_shipping\\\":0,\\\"amount_tax\\\":0},\\\"ui_mode\\\":\\\"hosted\\\",\\\"url\\\":\\\"https:\\\\\\/\\\\\\/checkout.stripe.com\\\\\\/c\\\\\\/pay\\\\\\/cs_test_b1fveEuq3RoFPYnpzCoeFZNiEGhdbOt2TBDmiOia0SPqbnUyQcxUJeh2VO#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdicGRmZGhqaWBTZHdsZGtxJz8nZmprcXdqaScpJ2R1bE5gfCc%2FJ3VuWnFgdnFaMDRIT19zQk1XVDN%2Fc0o9PG1QRExydXJqSk5OZEhxYVBJTTVJMHd1YXVoN2N1QENITEJiSz1BNjxgUmtrUFdhV3EzN2tqX11oZ05uaXdGVTdXSWY1bGA0fGk1NWZhQzc0YjFyJyknY3dqaFZgd3Ngdyc%2FcXdwYCknZ2RmbmJ3anBrYUZqaWp3Jz8nJmNjY2NjYycpJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl\\\",\\\"wallet_options\\\":null}\"', NULL, NULL, NULL, NULL, NULL, 'Order #ORD-20260727-QPDLNA', NULL, 'eman esmail Elgmal', 'emanesmailzidan@gmail.com', '01003452188', NULL, '{\"name\":\"eman esmail Elgmal\",\"email\":\"emanesmailzidan@gmail.com\",\"phone\":\"01003452188\",\"address_line1\":\"omr ibn elkhatab\",\"address_line2\":\"sherbin\",\"city\":\"mansoura\",\"state\":\"egypt\",\"postal_code\":\"123456\",\"country\":\"EG\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4, NULL, '2026-07-26 23:19:12', '2026-07-26 23:19:19', NULL);

-- --------------------------------------------------------

--
-- بنية الجدول `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 4, 'main', 'e249a30613f096e1eaec8844ce5cad060a5992423ff18677494eff7fd676e1a0', '[\"*\"]', NULL, NULL, '2026-01-15 10:37:08', '2026-01-15 10:37:08'),
(2, 'App\\Models\\User', 4, 'main', '8bd8270bc57f83b07c1ced9292ff2fd2f644061e29dab0a5b0b53b56a9077ae5', '[\"*\"]', NULL, NULL, '2026-01-15 10:39:39', '2026-01-15 10:39:39'),
(3, 'App\\Models\\User', 4, 'main', '43f2570cb888eaa7e3ac7272d929354adfc8e2583a9f761b2e3f1ce12db02db1', '[\"*\"]', NULL, NULL, '2026-01-15 10:50:53', '2026-01-15 10:50:53'),
(14, 'App\\Models\\User', 4, 'main', 'aa683b51d02f3952eb6965cd86b71fa51cdf9ffc9fa6e60d62490546dba14c02', '[\"*\"]', '2026-01-23 10:49:38', NULL, '2026-01-23 10:43:50', '2026-01-23 10:49:38'),
(18, 'App\\Models\\User', 4, 'main', '8010aff408ea206852b288d6b97eca620a8d81c7bc1041dbe79c430a13d9d3c4', '[\"*\"]', '2026-02-05 02:07:06', NULL, '2026-02-04 08:07:42', '2026-02-05 02:07:06'),
(22, 'App\\Models\\User', 4, 'main', '326062bfd90948c407069905fb9a4543165506ab982dc0f55b2fa1d32e3ecb4d', '[\"*\"]', '2026-02-13 13:00:07', NULL, '2026-02-05 08:52:09', '2026-02-13 13:00:07'),
(23, 'App\\Models\\User', 4, 'main', '5a0f25d908dd444759fb36940cd6d3c14c2e337885b3c97d4494af56fe8c66ff', '[\"*\"]', '2026-02-06 04:19:12', NULL, '2026-02-05 09:17:09', '2026-02-06 04:19:12'),
(25, 'App\\Models\\User', 4, 'main', 'fd65e87e2dcb7c1a826d873c6bfaad8baa44f124efff19f1fbf9f77ec8d2390d', '[\"*\"]', NULL, NULL, '2026-02-06 05:46:55', '2026-02-06 05:46:55'),
(26, 'App\\Models\\User', 4, 'main', '226ff26775359c15fe6f06c69178bf3436e59cb9823066bf9cf178e78a703ca9', '[\"*\"]', '2026-02-06 07:39:13', NULL, '2026-02-06 07:34:25', '2026-02-06 07:39:13'),
(27, 'App\\Models\\User', 4, 'main', '1c70f345ea3d248fd4a25bc81ada17b4d178e422826c5b9dddb8d959590b2349', '[\"*\"]', '2026-02-07 06:44:49', NULL, '2026-02-06 15:06:55', '2026-02-07 06:44:49'),
(29, 'App\\Models\\User', 4, 'main', 'caac140423d06b045746a02ebcb40e6a4b857562fda47495a1389da9628ae2b6', '[\"*\"]', '2026-02-07 06:52:15', NULL, '2026-02-07 06:52:06', '2026-02-07 06:52:15'),
(30, 'App\\Models\\User', 4, 'main', 'c9611d2ee91628fdbeaed7f4c57416073b2d5fd6611c15567c0c3b92cba0fefe', '[\"*\"]', NULL, NULL, '2026-02-08 13:46:34', '2026-02-08 13:46:34'),
(33, 'App\\Models\\User', 4, 'main', '8cfa8d27f8918c0058759e4af358a85f1daf592163e4a3f7dd79f6f6f46e451f', '[\"*\"]', NULL, NULL, '2026-02-08 14:34:07', '2026-02-08 14:34:07'),
(34, 'App\\Models\\User', 4, 'main', 'fa79b070f8380d808640b6412a19cf036c4f0540b4910fe3ac3539497deb3637', '[\"*\"]', NULL, NULL, '2026-02-08 14:34:15', '2026-02-08 14:34:15'),
(35, 'App\\Models\\User', 4, 'main', 'e6452a145873e725dff4281ec65fbc0c88c1a74adebde4c9c1ebed54bd0ae521', '[\"*\"]', NULL, NULL, '2026-02-08 14:55:54', '2026-02-08 14:55:54'),
(36, 'App\\Models\\User', 4, 'main', '46d64d019e18e58eb708db87e9e2ee55bcf394117b06338f53419e986697c4b3', '[\"*\"]', NULL, NULL, '2026-02-08 14:56:26', '2026-02-08 14:56:26'),
(37, 'App\\Models\\User', 4, 'main', 'c98fe4cf53cfe47bbb5613d988ceaf1e90b112a748c943d27b150baf2b0ece66', '[\"*\"]', NULL, NULL, '2026-02-08 14:57:23', '2026-02-08 14:57:23'),
(38, 'App\\Models\\User', 4, 'main', 'e7f3b1d1b3c5c2997f4a39d77c8860e09a5e3019dcd849a05866f2bb3dd13463', '[\"*\"]', NULL, NULL, '2026-02-08 14:57:27', '2026-02-08 14:57:27'),
(39, 'App\\Models\\User', 4, 'main', '6bd92ed5ade6ee8d144f9edeeec4f9dbe9d282319276eb1d56837cd2824b3fb5', '[\"*\"]', NULL, NULL, '2026-02-08 14:57:51', '2026-02-08 14:57:51'),
(40, 'App\\Models\\User', 4, 'main', 'eec1a3bc5d970e3e3e9445ec174e9433476dec3606d6a0bc1d89969b77ebc5fe', '[\"*\"]', NULL, NULL, '2026-02-08 14:58:14', '2026-02-08 14:58:14'),
(41, 'App\\Models\\User', 4, 'main', '222771a49625f2e98cfbdd4da007e3e04e4a36187a7808616aaa82c754a30445', '[\"*\"]', NULL, NULL, '2026-02-08 14:59:31', '2026-02-08 14:59:31'),
(42, 'App\\Models\\User', 4, 'main', 'a500cff59b1a8bcbe5ea3e147d6950ceaf81814ccc7dd8cfef6c91b95db9641e', '[\"*\"]', '2026-02-13 05:45:36', NULL, '2026-02-08 15:00:14', '2026-02-13 05:45:36'),
(43, 'App\\Models\\User', 4, 'main', 'f13c86d9c3a89d04f4750e0be73436496327652936b07d9f5954191bfe5f8d91', '[\"*\"]', NULL, NULL, '2026-02-13 05:49:30', '2026-02-13 05:49:30'),
(44, 'App\\Models\\User', 4, 'main', 'a65397033540d2f032dee1238640604e3b13ad77eb00eb210dc527344eaa5ae6', '[\"*\"]', '2026-02-13 17:40:10', NULL, '2026-02-13 05:49:40', '2026-02-13 17:40:10'),
(45, 'App\\Models\\User', 4, 'main', 'fca88fdf7bef0b6d1130f77c0a7ac3bc28700b3bfe6706c88342dbeea8c63950', '[\"*\"]', '2026-02-13 19:36:52', NULL, '2026-02-13 17:59:56', '2026-02-13 19:36:52'),
(46, 'App\\Models\\User', 4, 'main', '3cf6748f39f8eb087fa7eb05b25030f13b32e2d7125fbef26b5f5aeceafcb29c', '[\"*\"]', NULL, NULL, '2026-02-13 19:37:27', '2026-02-13 19:37:27'),
(47, 'App\\Models\\User', 4, 'main', 'e3bf8c1579755146d3a51a8af289dc0ace845581e321ff69a7f988e2ec39eeee', '[\"*\"]', NULL, NULL, '2026-02-13 19:38:29', '2026-02-13 19:38:29'),
(48, 'App\\Models\\User', 4, 'main', '3f469d5541a5a0eacbbad50f173955d97702fc8adbccc0ebf10cbf1cd93e8701', '[\"*\"]', '2026-02-13 19:48:09', NULL, '2026-02-13 19:38:35', '2026-02-13 19:48:09'),
(51, 'App\\Models\\User', 4, 'main', '7b9bb160fd3b79bb0f07723789aaa423a36636d4e3031eccbce792f632e7f22e', '[\"*\"]', NULL, NULL, '2026-02-13 19:55:06', '2026-02-13 19:55:06'),
(52, 'App\\Models\\User', 4, 'main', '7833e4653e281db57d028b2a6872d3d579c8a24c98ab9c2b00f4ef3c69ff19f0', '[\"*\"]', NULL, NULL, '2026-02-13 19:57:50', '2026-02-13 19:57:50'),
(53, 'App\\Models\\User', 4, 'main', '3a85bfb9526b6335ab4b7ca46f8f6b5243d77b7f949ec27d84806251221b65c9', '[\"*\"]', '2026-02-13 20:15:48', NULL, '2026-02-13 20:03:31', '2026-02-13 20:15:48'),
(54, 'App\\Models\\User', 4, 'main', 'c5820752d2c0f3ebec59d7ab9f13ca27dd405122494d3d1dbc602aee48811c56', '[\"*\"]', '2026-02-13 20:23:52', NULL, '2026-02-13 20:16:31', '2026-02-13 20:23:52'),
(55, 'App\\Models\\User', 4, 'main', '3df1a63d1c0e24a901d846f6d18cfa896a60e0171ba78ac0fa29da8d8f47b046', '[\"*\"]', '2026-02-13 20:57:25', NULL, '2026-02-13 20:25:42', '2026-02-13 20:57:25'),
(56, 'App\\Models\\User', 4, 'main', 'da7e7707c9d405fca8489510be43ba1e65b02a14d3bd5bab085831e44cd1a655', '[\"*\"]', '2026-02-14 19:10:50', NULL, '2026-02-14 19:00:40', '2026-02-14 19:10:50'),
(57, 'App\\Models\\User', 4, 'main', 'df1d848abf252a7a36dbb31a57e1a4cd5c265ac5022970408bf250b6e598cbe5', '[\"*\"]', '2026-02-14 20:12:09', NULL, '2026-02-14 19:16:00', '2026-02-14 20:12:09'),
(58, 'App\\Models\\User', 4, 'main', '6bf50377af767769fa1a394fcad57a61a064bd9a062d1bcc035b282c04f65657', '[\"*\"]', '2026-02-14 19:18:13', NULL, '2026-02-14 19:18:04', '2026-02-14 19:18:13'),
(59, 'App\\Models\\User', 4, 'main', 'b5850854ab7fc483232350bc863c87ea3b046302f5d0e9727bb5805da3e0e577', '[\"*\"]', '2026-02-14 19:26:17', NULL, '2026-02-14 19:26:06', '2026-02-14 19:26:17'),
(60, 'App\\Models\\User', 4, 'main', '8e2d1cc8ff82f3933f23a1ba8c9f2ee3204951d5b9efef714b6372e573bd3522', '[\"*\"]', '2026-02-14 19:52:39', NULL, '2026-02-14 19:36:56', '2026-02-14 19:52:39'),
(61, 'App\\Models\\User', 4, 'main', '70a201ed12862e47032d42090a7fab6194b0286c7ad31b41e663a1bd1fece8f0', '[\"*\"]', '2026-02-19 13:31:47', NULL, '2026-02-14 19:54:22', '2026-02-19 13:31:47'),
(62, 'App\\Models\\User', 4, 'main', '74c343bd968694581c7a0651e1f06bcef9e6a317f78d62e7e3aed83696d5387d', '[\"*\"]', '2026-02-15 18:31:03', NULL, '2026-02-14 20:12:34', '2026-02-15 18:31:03'),
(63, 'App\\Models\\User', 4, 'main', '9de71e7183d3fb04d540338d16d8307b3e8dd2c62ec1f4844d53aa96966c168d', '[\"*\"]', '2026-02-18 00:17:24', NULL, '2026-02-16 12:30:23', '2026-02-18 00:17:24'),
(64, 'App\\Models\\User', 4, 'main', 'bc454db4924660020d890564f23228ab54077c301090bdb8105ebcdbc69fdbd6', '[\"*\"]', '2026-02-18 00:26:33', NULL, '2026-02-18 00:18:00', '2026-02-18 00:26:33'),
(65, 'App\\Models\\User', 4, 'main', '8869bd68411af7c12a328b62ab4a09f52d79d6e1e45e5a11b2510eae493324ee', '[\"*\"]', '2026-02-18 00:54:41', NULL, '2026-02-18 00:27:23', '2026-02-18 00:54:41'),
(66, 'App\\Models\\User', 4, 'main', '7301d0f09f98daaf0022ce0bb057d60b1447f309411aa212edc3cd18cd0dbaec', '[\"*\"]', '2026-02-18 01:13:16', NULL, '2026-02-18 01:09:39', '2026-02-18 01:13:16'),
(67, 'App\\Models\\User', 4, 'main', '66fdce09d56a99d65e405001b4dd3eee4374ed1bef0372ccdd97a0f414a3c36d', '[\"*\"]', '2026-02-18 01:14:54', NULL, '2026-02-18 01:13:54', '2026-02-18 01:14:54'),
(68, 'App\\Models\\User', 4, 'main', '8bfcf96b2342de6026f8f217cca483b30d1b215548c3f49b34d212eb132a6868', '[\"*\"]', '2026-02-18 01:38:02', NULL, '2026-02-18 01:15:38', '2026-02-18 01:38:02'),
(69, 'App\\Models\\User', 4, 'main', '46596a6f6729693583f89498eb2e45db98ed506de7399ccbbfb7db29a77785db', '[\"*\"]', '2026-02-18 03:37:38', NULL, '2026-02-18 01:39:09', '2026-02-18 03:37:38'),
(70, 'App\\Models\\User', 4, 'main', '3b206290cebe4703e2e2a1539b7215b926b9c47aacb2dc76dd9d06d0bf332e49', '[\"*\"]', '2026-02-21 23:02:16', NULL, '2026-02-18 03:38:12', '2026-02-21 23:02:16'),
(71, 'App\\Models\\User', 4, 'main', '660357160102371d95838359868539b5f5d17556f4681c28d7e1028daf6e5fe6', '[\"*\"]', '2026-02-19 13:45:58', NULL, '2026-02-19 13:34:05', '2026-02-19 13:45:58'),
(72, 'App\\Models\\User', 4, 'main', '29fb7a02d52e757d914abafd5bd8d761a9ad0a28e5e7d96acf70450bd14f4a6c', '[\"*\"]', '2026-02-19 13:53:19', NULL, '2026-02-19 13:46:28', '2026-02-19 13:53:19'),
(73, 'App\\Models\\User', 4, 'main', '108d8997123ae2ef1d1917ada9bfab1df00102d3dd888bf05f6b8eac94a217b9', '[\"*\"]', '2026-02-19 14:30:17', NULL, '2026-02-19 14:28:51', '2026-02-19 14:30:17'),
(74, 'App\\Models\\User', 4, 'main', 'e680ed6900689f9402e6b657e3cb90ede05ba56e7b020ab620ffd8af275f61e4', '[\"*\"]', '2026-02-19 14:41:57', NULL, '2026-02-19 14:41:09', '2026-02-19 14:41:57'),
(75, 'App\\Models\\User', 4, 'main', 'cf0d75af74a20722bd74ad3d0de1e79bad21618c8f74867cc5eb6e9fd28555e5', '[\"*\"]', '2026-02-19 14:55:57', NULL, '2026-02-19 14:55:20', '2026-02-19 14:55:57'),
(76, 'App\\Models\\User', 4, 'main', 'c0a078cd0ab25be91ac8f6213d06b2ec5861a188d155634520d3c983c5250848', '[\"*\"]', '2026-02-19 15:02:09', NULL, '2026-02-19 14:56:43', '2026-02-19 15:02:09'),
(77, 'App\\Models\\User', 4, 'main', 'd9eba1f1af31a2477283b1cc4afaec9657320635083fdc4a93c1b8c5ee8088a9', '[\"*\"]', '2026-02-19 16:55:25', NULL, '2026-02-19 15:15:52', '2026-02-19 16:55:25'),
(78, 'App\\Models\\User', 4, 'main', 'dde18d65f78df2882012d27782f7b85f697bf1164bb7b97520809459de3d6530', '[\"*\"]', '2026-02-19 17:20:54', NULL, '2026-02-19 17:15:38', '2026-02-19 17:20:54'),
(79, 'App\\Models\\User', 4, 'main', '13109e1a654ce37cb994815c75f22b29f6376bc64ab4e2a86f2bda2afc6621fe', '[\"*\"]', '2026-02-19 19:48:45', NULL, '2026-02-19 17:32:14', '2026-02-19 19:48:45'),
(80, 'App\\Models\\User', 4, 'main', '52a2ff6642324998e04ba9ee110b63117db9a820028b3a38e48f3fdbad23bc8a', '[\"*\"]', '2026-02-21 22:44:12', NULL, '2026-02-19 19:50:12', '2026-02-21 22:44:12'),
(82, 'App\\Models\\User', 4, 'main', '9faded3301cfa3e3bb702a8fcbfc20bb8ffe3e58d0e53aa26c77541170d83763', '[\"*\"]', NULL, NULL, '2026-02-24 19:23:40', '2026-02-24 19:23:40'),
(83, 'App\\Models\\User', 4, 'main', '1dc3be517a2e70be5b7e1ab2700914530a40b2cfd6ad9510527a3480c2ac80ff', '[\"*\"]', NULL, NULL, '2026-02-24 20:43:30', '2026-02-24 20:43:30'),
(84, 'App\\Models\\User', 4, 'main', '555d10b41f0207bde03255a14978e5493a101cf1f6315fbdb1646b822561b6a6', '[\"*\"]', NULL, NULL, '2026-02-26 03:49:57', '2026-02-26 03:49:57'),
(85, 'App\\Models\\User', 4, 'main', 'e1481b1056a97e5445d0cfbc95577cc1559fe3f7866c99b819c218259d7e1b35', '[\"*\"]', NULL, NULL, '2026-02-26 03:51:33', '2026-02-26 03:51:33'),
(86, 'App\\Models\\User', 4, 'main', '6d8faeba2dce0be460dfbc6178db44b229d662f02af8a9ceca58b5619ce97e0b', '[\"*\"]', NULL, NULL, '2026-02-26 03:57:22', '2026-02-26 03:57:22'),
(87, 'App\\Models\\User', 4, 'main', '92bbe9d2c472382596a965ee2272a6cce0e22b447f9423475ea8e05491b16737', '[\"*\"]', NULL, NULL, '2026-02-26 04:19:34', '2026-02-26 04:19:34'),
(88, 'App\\Models\\User', 4, 'main', 'b71bd36c07f101f9b431d74d47c889db136c6e2e961debf97840ee2309132cd2', '[\"*\"]', NULL, NULL, '2026-02-26 04:19:54', '2026-02-26 04:19:54'),
(89, 'App\\Models\\User', 4, 'main', 'e912b37ef494bf218e6bafe9fa31ab1ea5ae246be677140fc6adbde2aae8c6bd', '[\"*\"]', NULL, NULL, '2026-02-26 04:25:06', '2026-02-26 04:25:06'),
(90, 'App\\Models\\User', 4, 'main', 'f44f5895192ec04585157a21ecdc85d5c76c13850569a9dd988165a134641656', '[\"*\"]', NULL, NULL, '2026-02-26 04:28:54', '2026-02-26 04:28:54'),
(91, 'App\\Models\\User', 4, 'main', '4d47dc6cd46bedcc80f22da52532ccfd9aec4de674a40693944da7bb100fa388', '[\"*\"]', NULL, NULL, '2026-02-26 04:47:38', '2026-02-26 04:47:38'),
(92, 'App\\Models\\User', 4, 'main', '319741264a70ce437fe63e8ccee94fbe269bee44fd6be2822a91db87f6db40ff', '[\"*\"]', NULL, NULL, '2026-02-26 04:47:49', '2026-02-26 04:47:49'),
(93, 'App\\Models\\User', 4, 'main', 'fa9baeae60df7cb904036543852eeaa17f68df6ff4611fd6d935686758487670', '[\"*\"]', NULL, NULL, '2026-02-26 04:49:55', '2026-02-26 04:49:55'),
(94, 'App\\Models\\User', 4, 'main', '713726bd708cfa7f80b959aeadfa0cd6840c3e66e1237cb9c30e7e9f5185c76a', '[\"*\"]', NULL, NULL, '2026-02-26 04:56:00', '2026-02-26 04:56:00'),
(95, 'App\\Models\\User', 4, 'main', 'c04b1229360ff06b3b8cbe5333828519133c8aae687eb9b507702548fbd95d9c', '[\"*\"]', NULL, NULL, '2026-02-26 05:03:33', '2026-02-26 05:03:33'),
(96, 'App\\Models\\User', 4, 'main', '38e2f99ead1c13c14728425aed1e5aa22830dc7e16ac49f6a2a25f550cd839c1', '[\"*\"]', NULL, NULL, '2026-02-26 05:09:24', '2026-02-26 05:09:24'),
(97, 'App\\Models\\User', 4, 'main', 'bef22788d550cb14080bf5665e82c320b86d092de42a97df767b898ba3e33032', '[\"*\"]', '2026-04-21 00:48:55', NULL, '2026-02-27 21:54:10', '2026-04-21 00:48:55'),
(98, 'App\\Models\\User', 4, 'main', '0fd42f23253300d9d9b383ce4813fe9800979d91a08031e386b651c100554a85', '[\"*\"]', NULL, NULL, '2026-04-22 02:37:20', '2026-04-22 02:37:20'),
(99, 'App\\Models\\User', 4, 'main', 'c5466bde851ff485dd49b4f67c681c524cd62c739efda94a9c69424ec0ca034f', '[\"*\"]', NULL, NULL, '2026-04-27 13:25:17', '2026-04-27 13:25:17'),
(100, 'App\\Models\\User', 4, 'main', '889715a8feb4f6d8154450ce9fcae5b6eb125135053688064af49c499fd9acc7', '[\"*\"]', '2026-04-28 09:33:45', NULL, '2026-04-27 13:25:44', '2026-04-28 09:33:45'),
(101, 'App\\Models\\User', 4, 'main', 'dde56d81450f8d00913b8448f7d3522e78b6a03c8d8d9e3df09109d75ae3cf92', '[\"*\"]', '2026-05-04 14:56:52', NULL, '2026-04-28 09:38:49', '2026-05-04 14:56:52'),
(102, 'App\\Models\\User', 4, 'main', 'cb7e99fb14908f3153acefd11a05be1d7f4bae39e0847bc2ded27e121c515bd8', '[\"*\"]', '2026-05-14 18:15:28', NULL, '2026-05-04 14:57:20', '2026-05-14 18:15:28'),
(103, 'App\\Models\\User', 4, 'main', 'cd784a9756e892d5a600d461fe748b6ecfe35f87e0741db5b2c27ef816e8d0c7', '[\"*\"]', NULL, NULL, '2026-05-05 15:52:22', '2026-05-05 15:52:22'),
(104, 'App\\Models\\User', 4, 'main', '7b3b6b70f479ea7d744b782ae1a806b991ff7f28dd94342d59d207babe119079', '[\"*\"]', NULL, NULL, '2026-05-14 22:57:15', '2026-05-14 22:57:15'),
(105, 'App\\Models\\User', 4, 'main', '50b2c485804c9aec91f036ac3d124fcfb6acc083910603d02765cecd51e7a8dc', '[\"*\"]', NULL, NULL, '2026-05-15 17:17:04', '2026-05-15 17:17:04'),
(106, 'App\\Models\\User', 4, 'main', '8889000c0eabfdbcd7526df784d7d159cd88eb03e0d4c1f9d6334c2d95c1d83d', '[\"*\"]', NULL, NULL, '2026-05-15 19:35:32', '2026-05-15 19:35:32'),
(107, 'App\\Models\\User', 4, 'main', 'c4bc37d6febb2953de7afd30cdfbfd2dadf53664d4a4906d0f20cf1870a5fa91', '[\"*\"]', '2026-05-16 04:55:27', NULL, '2026-05-15 19:46:07', '2026-05-16 04:55:27'),
(108, 'App\\Models\\User', 4, 'main', '3a52bb68753b63c36b1bd7222164a9f7a325b97631c8f906ac1ce80fc6500635', '[\"*\"]', '2026-05-17 21:17:01', NULL, '2026-05-16 04:59:46', '2026-05-17 21:17:01'),
(109, 'App\\Models\\User', 4, 'main', 'd7b8253111589e5e34c92e8f098bcaaf3524b394498be676f75ea971a1754ab4', '[\"*\"]', NULL, NULL, '2026-05-17 02:41:45', '2026-05-17 02:41:45'),
(110, 'App\\Models\\User', 4, 'main', '96e78ed19f52dc1490f85da8ed4ab29e40642ba9c38a496b16b939a80b8a8fc3', '[\"*\"]', '2026-05-17 21:46:55', NULL, '2026-05-17 02:42:12', '2026-05-17 21:46:55'),
(111, 'App\\Models\\User', 4, 'main', '9232f5604598d52a62aa029ef3ef3c0d2cdde97201f6597eab27f8faa67812c6', '[\"*\"]', NULL, NULL, '2026-05-17 21:26:39', '2026-05-17 21:26:39'),
(112, 'App\\Models\\User', 4, 'main', '1f25450646454d2f75faac7ff3438b2cc48c3902e0daf7a2fe656dfad44a4136', '[\"*\"]', '2026-06-17 01:28:37', NULL, '2026-05-17 22:00:49', '2026-06-17 01:28:37'),
(114, 'App\\Models\\User', 4, 'main', 'f773f09d98f6414cf1204a5d414126047b77ad2fb6ed9663459c7c30d3f5deaf', '[\"*\"]', NULL, NULL, '2026-05-31 14:08:07', '2026-05-31 14:08:07'),
(115, 'App\\Models\\User', 4, 'main', '1800c7752ecb206e722c3edaaa374ffb40dc1fa7e197eb0587b8c223d5a75558', '[\"*\"]', NULL, NULL, '2026-05-31 14:08:17', '2026-05-31 14:08:17'),
(116, 'App\\Models\\User', 4, 'main', 'd3562ea369ef6ab0e7e27b19282ff98b98932a00fe4c9e6a8516c78108fc4aa0', '[\"*\"]', NULL, NULL, '2026-06-01 08:38:11', '2026-06-01 08:38:11'),
(117, 'App\\Models\\User', 4, 'main', 'a68bae82b87b9076fbd86482d3881bc8dfa863e688e68552cde663241308fad6', '[\"*\"]', '2026-06-03 11:17:01', NULL, '2026-06-01 08:47:23', '2026-06-03 11:17:01'),
(118, 'App\\Models\\User', 4, 'main', 'ee46701cc495f068fa85b201ca3a034ae2c47ab2829c8d600a481e8e23004f57', '[\"*\"]', NULL, NULL, '2026-06-01 09:26:45', '2026-06-01 09:26:45'),
(119, 'App\\Models\\User', 4, 'main', 'c97c9e89520cfbc67c6c1016dcb6ce98c2b94c36eda7c4954d7619bbef8f64a4', '[\"*\"]', NULL, NULL, '2026-06-01 10:20:14', '2026-06-01 10:20:14'),
(120, 'App\\Models\\User', 4, 'main', '99a05d084e5060c99e162a0ef78ce5c2e04c99b196c4ee0bc65358db83f0fb24', '[\"*\"]', '2026-06-12 23:00:00', NULL, '2026-06-01 19:43:56', '2026-06-12 23:00:00'),
(121, 'App\\Models\\User', 4, 'main', '6c070c160dd047488e62ab8f3fd80f67b8d981ba53fbbaadf7d7a80baaa58693', '[\"*\"]', '2026-06-12 23:44:49', NULL, '2026-06-12 23:35:21', '2026-06-12 23:44:49'),
(122, 'App\\Models\\User', 4, 'main', '5d48a66cd60543d5cc7f414f73cf42111f832b081c8fa21a7ae83e6ffb0cff95', '[\"*\"]', '2026-06-13 00:03:16', NULL, '2026-06-12 23:45:02', '2026-06-13 00:03:16'),
(123, 'App\\Models\\User', 4, 'main', '6a21c45d9b0bff5b05e8258f893f47a34d58e8d6f22f2ea2e4b0f9389924ff9d', '[\"*\"]', '2026-06-13 00:00:33', NULL, '2026-06-12 23:50:59', '2026-06-13 00:00:33'),
(124, 'App\\Models\\User', 4, 'main', '3a8c94834dc1f5b4df0e29773d9b1350f52b05900eeb1d20487dd5d8b46fece3', '[\"*\"]', NULL, NULL, '2026-06-13 00:01:00', '2026-06-13 00:01:00'),
(125, 'App\\Models\\User', 4, 'main', '5025d5c773fb888a88844259313fc3fb89bcda0f7742ee0094a0ac1d92e5ef97', '[\"*\"]', NULL, NULL, '2026-06-13 00:01:07', '2026-06-13 00:01:07'),
(127, 'App\\Models\\User', 4, 'main', 'fef5867235b59c31cf517b071d01738d7f7ee2926a4875384ba2d6f29c5436db', '[\"*\"]', NULL, NULL, '2026-06-13 00:18:04', '2026-06-13 00:18:04'),
(128, 'App\\Models\\User', 4, 'main', '98349e15307542c45772b9f7002cf2a1c57ed385520ab7975d67c411c68c8bbe', '[\"*\"]', '2026-06-14 21:46:26', NULL, '2026-06-13 00:18:12', '2026-06-14 21:46:26'),
(129, 'App\\Models\\User', 4, 'main', '0fb718c4066a04a40df04ede5beb0f59363554a00c4594a27632d801e9349f18', '[\"*\"]', '2026-06-14 21:07:52', NULL, '2026-06-13 00:30:23', '2026-06-14 21:07:52'),
(130, 'App\\Models\\User', 4, 'main', 'b8d44e7f66516f9f367efa5e9e64fbe0f867636b1219e0bdc437251476dd68f3', '[\"*\"]', NULL, NULL, '2026-06-14 21:10:05', '2026-06-14 21:10:05'),
(131, 'App\\Models\\User', 4, 'main', '529c90038db64cc6cb093d786cc2c2ead8c0145a2a319246256db891a789df44', '[\"*\"]', '2026-06-16 23:15:23', NULL, '2026-06-14 21:50:55', '2026-06-16 23:15:23'),
(132, 'App\\Models\\User', 4, 'main', '68ab61c77a4aed29cb870045badd574faaa23cad11814f53bf96ae27a9dfd2ef', '[\"*\"]', NULL, NULL, '2026-06-17 01:33:31', '2026-06-17 01:33:31'),
(133, 'App\\Models\\User', 4, 'main', 'd5a54d02ebbdfa1ef73b8b530ac645867b9e2c20867821ea38094d0f52e48fe9', '[\"*\"]', NULL, NULL, '2026-06-17 22:16:16', '2026-06-17 22:16:16'),
(134, 'App\\Models\\User', 4, 'main', '765f939497bfd4100c27450db66b2ef9a72986877c70049095aaa67732ec2c3f', '[\"*\"]', NULL, NULL, '2026-06-18 00:19:15', '2026-06-18 00:19:15'),
(136, 'App\\Models\\User', 4, 'main', 'bc454ccfac9d21336f5fd921e85c30299505c50065d959689fc000dbcae06f18', '[\"*\"]', NULL, NULL, '2026-06-19 21:24:42', '2026-06-19 21:24:42'),
(137, 'App\\Models\\User', 4, 'main', 'd882fe8f3c3da802b6cae0802fd3ff59960c71e61ba5db40ff2f22a899e6d250', '[\"*\"]', '2026-06-23 06:46:09', NULL, '2026-06-22 03:20:54', '2026-06-23 06:46:09'),
(139, 'App\\Models\\User', 4, 'main', 'd97bebafeb1134c73c2dedaeb1db9876a31d0cae72a50d496d5a07881cc820d9', '[\"*\"]', '2026-07-07 13:01:37', NULL, '2026-06-30 17:54:25', '2026-07-07 13:01:37'),
(140, 'App\\Models\\User', 14, 'main', '188c7dc5b9364925ca27853ebcb7920c979c6e3f9521237873b7c83e81716b79', '[\"*\"]', NULL, NULL, '2026-07-07 13:43:36', '2026-07-07 13:43:36'),
(141, 'App\\Models\\User', 14, 'main', '5ffd452032ecf766245c1c13d39fdab3650c3e3be496dd2af854a824ebddbc77', '[\"*\"]', NULL, NULL, '2026-07-07 14:08:52', '2026-07-07 14:08:52'),
(142, 'App\\Models\\User', 14, 'main', 'b2ecf4100326a3a1f7d91feb781e922457b3c87003de636900f4d3292122cd3a', '[\"*\"]', NULL, NULL, '2026-07-07 14:14:41', '2026-07-07 14:14:41'),
(144, 'App\\Models\\User', 4, 'main', '6b25c72102b199e44b53b217d9fae05095de752dac9df64674958e6ba5b26c9a', '[\"*\"]', NULL, NULL, '2026-07-07 14:26:47', '2026-07-07 14:26:47'),
(145, 'App\\Models\\User', 14, 'main', 'ad2fa5a134ad905566f62d351a9f7b0cf99fb64b841aaa89308e702e05a709b0', '[\"*\"]', NULL, NULL, '2026-07-07 14:27:42', '2026-07-07 14:27:42'),
(146, 'App\\Models\\User', 4, 'main', '051d26fe26179cbf368ab9694a3cb7f1d903abcef6426cf860579452f9224351', '[\"*\"]', NULL, NULL, '2026-07-09 13:49:39', '2026-07-09 13:49:39'),
(147, 'App\\Models\\User', 4, 'main', '625aafb79e970f19029ca52693916f93550d8de6e8f53b407486bd5b88fbddb4', '[\"*\"]', NULL, NULL, '2026-07-09 13:53:34', '2026-07-09 13:53:34'),
(149, 'App\\Models\\User', 4, 'main', '3f1f77c314694473f090e6fb85ed1851f39d1185b8e10d1d192a0342c80fc412', '[\"*\"]', NULL, NULL, '2026-07-10 19:05:11', '2026-07-10 19:05:11'),
(150, 'App\\Models\\User', 4, 'main', 'fc9b3816ed3aa23a15f95c89afad675c61d7b0fb65b0d5525fd14f1955c1b61a', '[\"*\"]', NULL, NULL, '2026-07-10 19:05:51', '2026-07-10 19:05:51'),
(151, 'App\\Models\\User', 14, 'main', '819570414a7368f4f826b9033e85e835f6b143dc9b912f20bcbe1388f6536ef2', '[\"*\"]', NULL, NULL, '2026-07-10 19:08:16', '2026-07-10 19:08:16'),
(152, 'App\\Models\\User', 14, 'main', '47b4d8ba9daa4cbde34b3103defd16b1431e1ee85303d698943f04c5795f24da', '[\"*\"]', NULL, NULL, '2026-07-10 19:09:16', '2026-07-10 19:09:16'),
(153, 'App\\Models\\User', 4, 'main', '12fe16dca14f28efbdf8a80fba573ffc0783939690ce04fcac8eb45bd3d12979', '[\"*\"]', NULL, NULL, '2026-07-10 20:05:21', '2026-07-10 20:05:21'),
(154, 'App\\Models\\User', 4, 'main', 'ee7743d20b4113b68f4980c314c03e428801d1fa80fa6610fe486f61fbfaebcf', '[\"*\"]', NULL, NULL, '2026-07-10 20:07:26', '2026-07-10 20:07:26'),
(155, 'App\\Models\\User', 4, 'main', '2d857d05fd501540437e129039ff079765ee6e4baebdc95e2a257eb82acab8b9', '[\"*\"]', NULL, NULL, '2026-07-10 20:07:54', '2026-07-10 20:07:54'),
(157, 'App\\Models\\User', 14, 'main', '73f8ba02a68753372da45e659e7c19dace8b6b16ed6f598c6721ed11c91966b7', '[\"*\"]', NULL, NULL, '2026-07-11 00:11:48', '2026-07-11 00:11:48'),
(158, 'App\\Models\\User', 4, 'main', '7501f556c12d0c2d764bdef46be5ac11efc892a74370f4a48f4afcfd68d76754', '[\"*\"]', NULL, NULL, '2026-07-11 00:12:11', '2026-07-11 00:12:11'),
(160, 'App\\Models\\User', 14, 'main', '565cf9888a160bc6bf46330cf9f451eeb243e9d8b05d168975a86e0d4bf6d8fa', '[\"*\"]', NULL, NULL, '2026-07-12 20:37:48', '2026-07-12 20:37:48'),
(162, 'App\\Models\\User', 4, 'main', 'c939db46b5f4558284f547404ac62c53bd3926980daba31fadbaf1fa28094af8', '[\"*\"]', '2026-07-15 12:26:44', NULL, '2026-07-13 18:52:32', '2026-07-15 12:26:44'),
(163, 'App\\Models\\User', 4, 'main', 'e38c533b8d13a522830b01f2eec708f2a6f5faf5110306c2380ccf2259aea890', '[\"*\"]', NULL, NULL, '2026-07-15 20:59:50', '2026-07-15 20:59:50'),
(164, 'App\\Models\\User', 4, 'main', '598071bbf9fd9e03e5976d8225210a83e760ff563a6b645d83e0523294923d10', '[\"*\"]', NULL, NULL, '2026-07-15 21:16:43', '2026-07-15 21:16:43'),
(165, 'App\\Models\\User', 14, 'main', '647659856589107c9e110a9686e1ae3ba569003450e7cdb5c315689d4d23b170', '[\"*\"]', '2026-07-16 00:28:58', NULL, '2026-07-15 21:20:03', '2026-07-16 00:28:58'),
(167, 'App\\Models\\User', 14, 'main', '228e166405d259684185034cc750a6362cf33bb1fb51982635e9241afeeeb9ff', '[\"*\"]', NULL, NULL, '2026-07-18 02:47:09', '2026-07-18 02:47:09'),
(169, 'App\\Models\\User', 4, 'main', 'd88e014f2707437c3af7f8166d61dde996ba09a34c7d4f1b4da42b63f64fdff7', '[\"*\"]', NULL, NULL, '2026-07-20 20:08:26', '2026-07-20 20:08:26'),
(170, 'App\\Models\\User', 4, 'main', '9c2c54bcaea9ca122d788367956ce2fcbcf263f983bb0bb01d5f191c69936d9d', '[\"*\"]', NULL, NULL, '2026-07-23 01:13:34', '2026-07-23 01:13:34'),
(171, 'App\\Models\\User', 4, 'main', '64266b5bd147c1d3f90f5648b91dd8e2e3c3652f77c6528029f1828bf143067b', '[\"*\"]', NULL, NULL, '2026-07-23 01:13:44', '2026-07-23 01:13:44'),
(173, 'App\\Models\\User', 4, 'main', '61d31521cdc8529eeb361c7fa3b547fcf2bda7c970a90b1ba353e62a1a2f8c3c', '[\"*\"]', '2026-07-24 00:38:28', NULL, '2026-07-23 01:27:53', '2026-07-24 00:38:28'),
(174, 'App\\Models\\User', 4, 'main', 'b04a6394f8db8a0e4f804fa531b8265077a8f61d7b48ead6a61c2c2d659557f2', '[\"*\"]', NULL, NULL, '2026-07-26 22:43:19', '2026-07-26 22:43:19'),
(175, 'App\\Models\\User', 4, 'main', '85876063d9f4c59d8cfbdb140366847f560abba37d0c8dceb4c11c926fe2b04f', '[\"*\"]', '2026-07-26 22:51:43', NULL, '2026-07-26 22:51:00', '2026-07-26 22:51:43'),
(176, 'App\\Models\\User', 4, 'main', '890698bec0dc0c39086f282610bbddcd2df8d145f2c927a37fdb5ac96f393aed', '[\"*\"]', NULL, NULL, '2026-07-26 22:52:21', '2026-07-26 22:52:21'),
(177, 'App\\Models\\User', 4, 'main', 'db3d0f83d099d428cca39a221c1115c3550ef5cb2358488a2825aabce7f87dfc', '[\"*\"]', NULL, NULL, '2026-07-26 22:56:17', '2026-07-26 22:56:17'),
(179, 'App\\Models\\User', 4, 'main', '474767fc3bf18762648a0cfb7ae1bf25e02819c000b65c28d536737d6718ef30', '[\"*\"]', NULL, NULL, '2026-07-26 23:16:43', '2026-07-26 23:16:43'),
(180, 'App\\Models\\User', 4, 'main', '9f8d4c31cc40d8bf0f74f5d982661a6a6085cd792f2081701e0787950dbdf7cb', '[\"*\"]', NULL, NULL, '2026-07-26 23:57:53', '2026-07-26 23:57:53'),
(181, 'App\\Models\\User', 4, 'main', 'a7107fbf295cb22408f4d438dfcb2d7881af8a1b81d9bcd1d906e81f98028720', '[\"*\"]', NULL, NULL, '2026-07-27 00:17:21', '2026-07-27 00:17:21'),
(182, 'App\\Models\\User', 4, 'main', '17a23ba0709c8cd4f08b56c4aa33244d51427796b07e790b1b5d0e49403354c9', '[\"*\"]', NULL, NULL, '2026-07-27 00:26:34', '2026-07-27 00:26:34'),
(183, 'App\\Models\\User', 4, 'main', '5d14de5af2fa65c08f1c1419fad50020ea5d8844ca7ace549561e6e01c644b3f', '[\"*\"]', NULL, NULL, '2026-07-27 03:55:35', '2026-07-27 03:55:35'),
(184, 'App\\Models\\User', 14, 'main', '44b00057b54537c0e9f779726d62649633011f0160d0f76915cac2ddac20f881', '[\"*\"]', NULL, NULL, '2026-07-27 04:16:02', '2026-07-27 04:16:02'),
(185, 'App\\Models\\User', 4, 'main', 'fff29daab219fe930b0a90d0db42caccb2066b62267e13f66937e2b4a3b27649', '[\"*\"]', NULL, NULL, '2026-07-27 04:36:34', '2026-07-27 04:36:34');

-- --------------------------------------------------------

--
-- بنية الجدول `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(2000) NOT NULL,
  `title_ar` varchar(500) DEFAULT NULL,
  `slug` varchar(2000) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `description_ar` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `new_arrival` tinyint(4) DEFAULT 0,
  `unit` enum('kg','g','piece','pack','bunch','liter') NOT NULL DEFAULT 'kg',
  `weight_per_unit` decimal(12,3) NOT NULL DEFAULT 1000.000,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deleted_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `products`
--

INSERT INTO `products` (`id`, `title`, `title_ar`, `slug`, `image`, `images`, `description`, `description_ar`, `price`, `sale_price`, `stock`, `category_id`, `new_arrival`, `unit`, `weight_per_unit`, `deleted_at`, `deleted_by`, `created_at`, `updated_at`) VALUES
(2, 'tomatoes', 'طماطم', 'tomatoes', '/storage/Products/1781913691_5067.webp', '[\"\\/storage\\/Products\\/1781913692_3557.webp\",\"\\/storage\\/Products\\/1781913692_7812.webp\",\"\\/storage\\/Products\\/1781913692_9201.webp\"]', 'A popular and versatile food that can be used in many different ways from hearty meals to light lunches and as a healthy snack. There are lots of different varieties from cherry tomatoes on the vine to the larger beef tomatoes. They are packed with nutrients too, such as vitamin C and beta-carotene.', 'طماطم شهيرة ومتعددة الاستخدامات، يمكن تحضيرها بطرق متنوعة، من وجبات دسمة إلى وجبات غداء خفيفة، وحتى كوجبة خفيفة صحية. تتنوع أنواعها، من الطماطم الكرزية الصغيرة إلى الطماطم الكبيرة. وهي غنية بالعناصر الغذائية، مثل فيتامين سي وبيتا كاروتين.', 10.00, NULL, 4998, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-02-05 09:06:08', '2026-07-18 03:31:03'),
(3, 'cucumber', 'خيار', 'cucumber', '/storage/Products/1781924839_8364.webp', '[\"\\/storage\\/Products\\/1781924839_7723.webp\",\"\\/storage\\/Products\\/1781924840_8743.webp\",\"\\/storage\\/Products\\/1781924840_7988.webp\"]', 'Cucumbers (Cucumis sativus) are creeping vine plants in the gourd family (Cucurbitaceae) that produce long, green,, high-water-content berries typically consumed as vegetables. They are widely cultivated,, often in gardens or greenhouses, for salads, pickling, or fresh eating. Cultivars are generally classified as slicing, pickling, or burpless, offering high hydration with low calories.', 'الخيار (Cucumis sativus) نبات متسلق من الفصيلة القرعية (Cucurbitaceae)، ينتج ثمارًا طويلة خضراء غنية بالماء، تُستهلك عادةً كخضار. يُزرع الخيار على نطاق واسع، غالبًا في الحدائق أو البيوت الزجاجية، لاستخدامه في السلطات أو التخليل أو تناوله طازجًا. تُصنف أصناف الخيار عمومًا إلى أصناف للتقطيع، وأصناف للتخليل، وأصناف قليلة السعرات الحرارية، تتميز جميعها بترطيبها العالي وسعراتها الحرارية المنخفضة.', 15.00, 13.00, 482, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-02-05 09:10:33', '2026-06-22 07:44:57'),
(4, 'Cherry tomato seeds', 'بذور الطماطم الكرزية', 'Cherry-tomato-seeds', '/storage/Products/1781914463_2431.webp', '[\"\\/storage\\/Products\\/1781914463_4599.webp\",\"\\/storage\\/Products\\/1781914463_1731.webp\"]', 'Cherry tomato seeds are easy-to-grow, prolific plants that thrive in full sun and well-draining soil, with seeds germinating in 5–10 days. Popular varieties include Gardeners Delight, Black Opal, and Sweetie. Sow seeds indoors 4–8 weeks before the last frost, keep soil moist at 60-80°F, and transplant to a sunny spot, staking plants for support.', 'بذور الطماطم الكرزية سهلة الزراعة، وهي نباتات غزيرة الإنتاج تزدهر في الشمس الكاملة والتربة جيدة التصريف، وتنبت بذورها في غضون 5-10 أيام. من الأصناف الشائعة: غاردنرز ديلايت، وبلاك أوبال، وسويتي. ازرع البذور في الداخل قبل 4-8 أسابيع من آخر موجة صقيع، وحافظ على رطوبة التربة عند درجة حرارة 16-27 درجة مئوية، ثم انقل الشتلات إلى مكان مشمس مع تدعيمها بدعامات.', 220.00, NULL, 382, 5, 1, 'pack', 1000.000, NULL, NULL, '2026-04-27 13:44:40', '2026-06-22 07:44:57'),
(5, 'eggplant seeds', 'بذور الباذنجان', 'eggplant-seeds', '/storage/Products/1781914490_4537.webp', '[\"\\/storage\\/Products\\/1781914491_1139.webp\",\"\\/storage\\/Products\\/1781914491_1076.webp\"]', 'Eggplant seeds are best started indoors 8-10 weeks before the last frost, requiring warm soil (\r\n\r\n\r\n) for germination, which takes 7-14 days. Plant seeds 1/8-1/4 inch deep in moist, well-draining soil. Transplant outdoors after hardening off, when soil is at least \r\n\r\n, spacing plants 24 inches apart. \r\nEden Brothers\r\nEden Brothers\r\n +3\r\nKey Growing Tips:\r\nConditions: Requires full sun and warm temperatures (\r\n\r\n\r\n\r\n).\r\nWater: Needs consistent moisture, about 1-2 inches per week.\r\nSupport: Stake plants, especially when fruit matures, to keep them from bending or touching the ground.\r\nHarvest: Ready in 70-100+ days, usually when skin is glossy and firm', 'يُفضل بدء زراعة بذور الباذنجان داخل المنزل قبل 8-10 أسابيع من آخر موجة صقيع، وتتطلب تربة دافئة (درجة حرارة منخفضة) للإنبات، والذي يستغرق من 7 إلى 14 يومًا. ازرع البذور على عمق 0.5 إلى 0.6 سم في تربة رطبة جيدة التصريف. انقل الشتلات إلى الخارج بعد تأقلمها، عندما تصل درجة حرارة التربة إلى 0.5 درجة مئوية على الأقل، مع ترك مسافة 60 سم بين كل شتلة وأخرى. نصائح إيدن براذرز للزراعة +3: الظروف: يتطلب أشعة الشمس الكاملة ودرجات حرارة دافئة (درجة حرارة منخفضة). الري: يحتاج إلى رطوبة مستمرة، حوالي 2.5 إلى 5 سم أسبوعيًا. الدعم: ادعم النباتات، خاصةً عند نضج الثمار، لمنعها من الانحناء أو ملامسة الأرض. الحصاد: جاهزة في غضون 70-100 يوم أو أكثر، عادةً عندما يصبح قشرها لامعًا وذا لون وردي فاتح.', 240.00, 230.00, 591, 5, 1, 'pack', 1000.000, NULL, NULL, '2026-04-27 14:03:11', '2026-07-26 23:19:12'),
(6, 'Colored pepper', 'الفلفل الملون', 'colored-pepper', '/storage/Products/1782293047_3372.webp', '[\"\\/storage\\/Products\\/1782293048_3307.webp\",\"\\/storage\\/Products\\/1782293048_2907.webp\",\"\\/storage\\/Products\\/1782293048_4924.webp\"]', 'Bell peppers are a vitamin-rich vegetable that can be prepared in many delicious ways. The most popular is oven-roasted peppers, which preserve their sweet flavor and nutritional benefits, or stuffed peppers with minced meat and rice for a hearty main dish.', 'الفلفل الحلو من الخضراوات الغنية بالفيتامينات، ويمكن تحضيره بطرق لذيذة ومتنوعة. من أشهرها الفلفل المشوي في الفرن، الذي يحافظ على نكهته الحلوة وفوائده الغذائية، أو الفلفل المحشو باللحم المفروم والأرز كطبق رئيسي شهي.', 15.00, NULL, 598, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-06-24 06:19:37', '2026-07-18 03:31:03'),
(7, 'carrot', 'جزر', 'carrot', '/storage/Products/1782293926_7239.webp', '[\"\\/storage\\/Products\\/1782293927_5069.webp\",\"\\/storage\\/Products\\/1782293928_2507.webp\",\"\\/storage\\/Products\\/1782293928_4383.webp\"]', 'The carrot (Daucus carota) is a root vegetable known for its crisp texture and high nutritional value. While the most common variety is bright orange, carrots also grow in purple, yellow, red, and white variations', 'الجزر (Daucus carota) هو نوع من الخضراوات الجذرية المعروفة بقوامه المقرمش وقيمته الغذائية العالية. وبينما يُعد اللون البرتقالي الزاهي هو الأكثر شيوعاً، إلا أن الجزر ينمو أيضاً بألوان أخرى مثل البنفسجي والأصفر والأحمر والأبيض.', 10.00, 8.00, 600, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-06-24 06:38:48', '2026-06-24 06:38:48'),
(8, 'The eggplant', 'الباذنجان', 'the-eggplant', '/storage/Products/1783618591_3471.webp', '[\"\\/storage\\/Products\\/1783618591_5335.webp\",\"\\/storage\\/Products\\/1783618592_7033.webp\",\"\\/storage\\/Products\\/1783618593_8684.webp\"]', '\"The eggplant is a tropical, perennial plant that is mostly cultivated as an annual vegetable. It belongs to the nightshade family. The fruit is typically large, egg-shaped, and covered with a glossy, dark purple skin. However, some varieties can be white, green, or striped. Inside, the flesh is spongy and white-to-cream colored, containing many small, edible seeds. Raw eggplant has a slightly bitter taste, but it becomes tender, rich, and savory when cooked, easily absorbing flavors and oils.\"', 'الباذنجان نبات استوائي معمر، يُزرع في الغالب كخضار سنوي. ينتمي إلى الفصيلة الباذنجانية. ثمرته عادةً كبيرة، بيضاوية الشكل، ومغطاة بقشرة لامعة داكنة اللون. مع ذلك، قد تكون بعض الأصناف بيضاء أو خضراء أو مخططة. أما لبّه، فهو إسفنجي اللون، يتراوح لونه بين الأبيض والكريمي، ويحتوي على العديد من البذور الصغيرة الصالحة للأكل. يتميز الباذنجان النيء بمذاق مرّ قليلاً، ولكنه يصبح طرياً وغنياً ولذيذاً عند طهيه، حيث يمتص النكهات والزيوت بسهولة.', 15.00, 14.00, 800, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-06-24 06:48:29', '2026-07-09 14:36:33'),
(9, 'Green grapes', 'عنب اخضر', 'green-grapes', '/storage/Products/1783618190_1969.webp', '[\"\\/storage\\/Products\\/1783618190_4164.webp\",\"\\/storage\\/Products\\/1783618191_6574.webp\",\"\\/storage\\/Products\\/1783618191_5554.webp\",\"\\/storage\\/Products\\/1783618191_4460.webp\"]', 'Grapes are botanically classified as berries and grow on deciduous, woody vines of the genus Vitis. Cultivated for thousands of years, they are enjoyed fresh, dried into raisins, or pressed for juice and wine. Grapes are also an excellent source of essential vitamins like Vitamin C and K.', 'يُصنّف العنب نباتياً ضمن فئة التوت، وينمو على كروم خشبية متساقطة الأوراق من جنس العنب (Vitis). يُزرع العنب منذ آلاف السنين، ويُستمتع بتناوله طازجاً، أو يُجفف على شكل زبيب، أو يُعصر لاستخراج العصير والنبيذ. كما يُعدّ العنب مصدراً ممتازاً للفيتامينات الأساسية مثل فيتامين ج وفيتامين ك.', 50.00, 45.00, 798, 3, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 14:29:51', '2026-07-26 23:19:12'),
(10, 'yellow onion', 'بصل اصفر', 'yellow-onion', '/storage/Products/1783624378_5472.webp', '[\"\\/storage\\/Products\\/1783624378_6660.webp\",\"\\/storage\\/Products\\/1783624378_2270.webp\",\"\\/storage\\/Products\\/1783624378_2805.webp\"]', 'Onions are a staple root vegetable in global cuisine, characterized by their pungent aroma resulting from organosulfur compounds. They are considered a health treasure trove due to their richness in vitamins and antioxidants. Onions have a long history in cooking and alternative medicine thanks to their diverse nutritional properties.', 'البصل هو أحد خضروات الجذور الأساسية في المطبخ العالمي، ويتميز برائحته النفاذة الناتجة عن مركبات الكبريت العضوية، ويُعد كنزاً صحياً لغناه بالفيتامينات ومضادات الأكسدة. يمتلك البصل تاريخاً طويلاً في الطهي والطب البديل بفضل خصائصه الغذائية المتنوعة.', 10.00, NULL, 797, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 16:12:58', '2026-07-26 23:19:12'),
(11, 'Red onion', 'بصل احمر', 'red-onion', '/storage/Products/1783624540_7654.webp', '[\"\\/storage\\/Products\\/1783624541_7646.webp\",\"\\/storage\\/Products\\/1783624541_3395.webp\",\"\\/storage\\/Products\\/1783624541_1803.webp\"]', 'Onions are a staple root vegetable in global cuisine, characterized by their pungent aroma resulting from organosulfur compounds. They are considered a health treasure trove due to their richness in vitamins and antioxidants. Onions have a long history in cooking and alternative medicine thanks to their diverse nutritional properties.', 'البصل هو أحد خضروات الجذور الأساسية في المطبخ العالمي، ويتميز برائحته النفاذة الناتجة عن مركبات الكبريت العضوية، ويُعد كنزاً صحياً لغناه بالفيتامينات ومضادات الأكسدة. يمتلك البصل تاريخاً طويلاً في الطهي والطب البديل بفضل خصائصه الغذائية المتنوعة.', 15.00, 12.00, 899, 2, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 16:15:41', '2026-07-26 23:19:12'),
(12, 'orange', 'برتقال', 'orange', '/storage/Products/1783624726_1100.webp', '[\"\\/storage\\/Products\\/1783624726_5952.webp\",\"\\/storage\\/Products\\/1783624726_8333.webp\",\"\\/storage\\/Products\\/1783624726_4668.webp\"]', 'Conversation in \"AI Mode\": Oranges. Your words: Oranges. Oranges are one of the most popular citrus fruits in the world, known for their refreshing taste and numerous health benefits.    Key Health Benefits: Boosting Immunity: Rich in Vitamin C, which protects cells. Improving Digestion: Contains fiber that supports gut health. Heart Health: The potassium it contains helps regulate blood pressure. Skin Radiance: Collagen helps fight wrinkles.    Popular Types of Oranges: Navel: Sweet, easy to peel, and seedless. Sugar: Characterized by very low acidity and extra sweetness.', 'محادثة في \"وضع AI\": برتقالكلامك: برتقالالبرتقال هو أحد أكثر الحمضيات شعبية في العالم، ويتميز بطعمه المنعش وفوائده الصحية الكثيرة.💡 أهم الفوائد الصحيةتعزيز المناعة: غني بفيتامين C الذي يحمي الخلايا.تحسين الهضم: يحتوي على ألياف تدعم صحة الأمعاء.صحة القلب: البوتاسيوم فيه يضبط ضغط الدم.نضارة البشرة: يساعد الكولاجين على محاربة التجاعيد.🍊 أشهر أنواع البرتقالأبو سرة: حلو المذاق، سهل التقشير، وبدون بذور.السكري: يتميز بنسبة حموضة منخفضة جداً وحلاوة زايدة.', 20.00, NULL, 798, 3, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 16:18:46', '2026-07-15 12:20:14'),
(13, 'red apples', 'تفاح احمر', 'red-apples', '/storage/Products/1783625021_5456.webp', '[\"\\/storage\\/Products\\/1783625022_4727.webp\",\"\\/storage\\/Products\\/1783625022_4464.webp\",\"\\/storage\\/Products\\/1783625023_4296.webp\"]', 'Red apples are among the most popular and widely consumed fruits worldwide, known for their sweet, crunchy taste and numerous health benefits. The health benefits of red apples include: promoting heart health (they contain soluble fiber, which helps lower bad cholesterol levels); improving digestion (they are rich in pectin, which acts as food for beneficial gut bacteria); supporting the immune system (they contain vitamin C and antioxidants that protect the body from disease); and aiding in weight management (their high water and fiber content promotes a feeling of fullness for extended periods).…', 'التفاح الأحمر هو أحد أشهر أنواع الفواكه وأكثرها استهلاكاً حول العالم، ويتميز بطعمه الحلو المقرمش وفوائده الصحية الكبيرة.الفوائد الصحية للتفاح الأحمريعزز صحة القلب: يحتوي على الألياف القابلة للذوبان التي تساعد على خفض مستويات الكوليسترول الضار.يحسن عملية الهضم: غني بمادة البكتين التي تعمل كغذاء للبكتيريا النافعة في الأمعاء.يدعم جهاز المناعة: يحتوي على فيتامين C ومضادات الأكسدة التي تحمي الجسم من الأمراض.يساعد في إدارة الوزن: يمنح شعوراً بالشبع لفترات طويلة بفضل محتواه العالي من الماء والألياف.أشهر أنواع التفاح الأحمرريد ديليشس (Red Delicious): يتميز بلونه الأحمر الداكن وشكله المخروطي وطعمه الخفيف.', 90.00, 80.00, 497, 3, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 16:23:43', '2026-07-18 03:31:04'),
(14, 'Banana', 'موز', 'banana', '/storage/Products/1783625254_4129.webp', '[\"\\/storage\\/Products\\/1783625254_6731.webp\",\"\\/storage\\/Products\\/1783625254_6548.webp\",\"\\/storage\\/Products\\/1783625254_8634.webp\"]', 'Bananas are one of the most popular and widely consumed fruits in the world, known for their high nutritional value and ease of consumption.    Health Benefits: Quick Energy: Rich in carbohydrates and natural sugars. Heart Health: High in potassium, which helps lower blood pressure. Improved Digestion: Rich in dietary fiber, especially pectin. Improved Mood: Contains vitamin B6 and tryptophan, which aid in serotonin production.', 'الموز هو أحد أكثر الفواكه شعبية واستهلاكاً في العالم، ويمتاز بفوائده الغذائية العالية وسهولة تناوله.🍌 الفوائد الصحيةطاقة سريعة: غني بالكربوهيدرات والسكريات الطبيعية.صحة القلب: يحتوي على نسبة عالية من البوتاسيوم الخافض لضغط الدم.تحسين الهضم: غني بالألياف الغذائية وخاصة البكتين.تحسين المزاج: يحتوي على فيتامين B6 والتريبتوفان المساعدين على إفراز السيروتونين.', 30.00, 25.00, 896, 3, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 16:27:34', '2026-07-26 23:19:12'),
(15, 'Mangoes', 'مانجو', 'mangoes', '/storage/Products/1783635393_2665.webp', '[\"\\/storage\\/Products\\/1783635393_8064.webp\",\"\\/storage\\/Products\\/1783635393_4302.webp\",\"\\/storage\\/Products\\/1783635393_9389.webp\"]', 'Mangoes are a popular tropical fruit known as the \"Queen of Fruits.\" They are characterized by their sweet taste and juicy texture, and offer significant health and economic benefits.    Key Facts About Mangoes: Origin: Southeast Asia and India. Season: They grow in the summer and require a warm, tropical climate. Popular Varieties: Fas, Owais, Sukari, Zebdia, and Timur.    Health Benefits: Boosting Immunity: Rich in Vitamin C and Vitamin A. Improving Digestion: Contains dietary fiber and digestive enzymes. Eye Health: Contains antioxidants that protect vision. Skin Radiance: Contains vitamins that contribute to healthy skin.…', 'المانجو هي فاكهة استوائية شهيرة تُعرف بلقب \"ملكة الفواكه\". تتميز بطعمها الحلو والقوام العصيري، ولها فوائد صحية واقتصادية كبيرة.💡 أهم المعلومات عن المانجوالموطن الأصلي: جنوب شرق آسيا والهند.المواسم: تنمو في فصل الصيف وتحتاج مناخاً مدارياً دافئاً.أشهر الأنواع: الفص، العويس، السكري، الزبدية، والتيمور.🍏 الفوائد الصحيةتعزيز المناعة: غنية بفيتامين C وفيتامين A.تحسين الهضم: تحتوي على ألياف غذائية وإنزيمات هاضمة.صحة العين: تحتوي على مضادات أكسدة تحمي الإبصار.نضارة البشرة: تساهم الفيتامينات الموجودة بها في إنتاج الكولاجين.', 60.00, NULL, 894, 3, 1, 'kg', 1000.000, NULL, NULL, '2026-07-09 19:16:34', '2026-07-26 23:19:12'),
(16, 'spinach', 'السبانخ', 'spinach', '/storage/Products/1784861647_9107.webp', '[\"\\/storage\\/Products\\/1784861647_2194.webp\",\"\\/storage\\/Products\\/1784861648_4159.webp\",\"\\/storage\\/Products\\/1784861648_9894.webp\"]', 'Spinach (Spinacia oleracea) is an annual green leafy vegetable belonging to the Amaranthaceae family. It is considered a nutrient-rich food that is low in calories. Native to Asia, its leaves are consumed fresh in salads or cooked in many international and Arabic dishes. Nutritional value (per 100g raw): Calories: 23 kcal; Water: 91.4g; Protein: 2.86g; Fiber: 2.2g; Iron: 2.71mg; Calcium: 99mg; Vitamins: Rich in vitamins A, C, K, and folic acid. Key health benefits: Supports weight loss   It contains fiber that increases satiety and is very low in calories. It promotes blood health by providing the body with iron to help prevent anemia. It has antioxidant properties, containing compounds that protect cells from damage and inflammation. It supports bone and vision health thanks to its high levels of vitamin K and vitamin A..…', 'السبانخ (Spinacia oleracea) هي نبات ورقي أخضر حولي ينتمي إلى الفصيلة القطيفية، وتعتبر من الأطعمة الغنية بالعناصر الغذائية الأساسية وقليلة السعرات الحرارية. موطنها الأصلي آسيا، وتُستهلك أوراقها طازجة في السلطات أو مطبوخة في العديد من الأطباق العالمية والعربية.القيمة الغذائية (لكل 100 غرام نيء)السعرات الحرارية: 23 سعرة.الماء: 91.4 غرام.البروتين: 2.86 غرام.الألياف: 2.2 غرام.الحديد: 2.71 ملغ.الكالسيوم: 99 ملغ.الفيتامينات: غنية بفيتامينات A، C، K وحمض الفوليك.الفوائد الصحية الرئيسيةدعم خسارة الوزن: تحتوي على ألياف تزيد الشبع وسعرات منخفضة جداً.تعزيز صحة الدم: تمد الجسم بالحديد للمساعدة في الوقاية من الأنيميا.مقاومة الأكسدة: تحتوي على مركبات تحمي الخلايا من التلف والالتهابات.صحة العظام والنظر: بفضل المستويات العالية من فيتامين K وفيتامين A', 15.00, NULL, 300, 6, 1, 'bunch', 1000.000, NULL, NULL, '2026-07-23 23:54:08', '2026-07-23 23:54:08'),
(17, 'lettuce', 'الخس', 'lettuce', '/storage/Products/1784862175_7865.webp', '[\"\\/storage\\/Products\\/1784862176_4315.webp\",\"\\/storage\\/Products\\/1784862176_5595.webp\",\"\\/storage\\/Products\\/1784862177_4487.webp\"]', 'Lettuce (Lactuca sativa) is an annual herbaceous plant belonging to the Asteraceae family. It is one of the most important leafy green vegetables eaten fresh in salads and sandwiches. It is characterized by its low calorie count and high water and fiber content, making it an ideal food for health and fitness. Some of the most popular types of lettuce include: Iceberg lettuce (cabbage): distinguished by its crisp, round head and tightly packed white to green leaves. Romaine lettuce: known for its long, dark leaves rich in vitamins and minerals.  Soft-leaf lettuce: its leaves unfold like flowers and come in a variety of colors, ranging from green to black  Celery lettuce: Grown specifically for its thick, edible stalks. Health benefits of lettuce: Boosting immunity: Rich in vitamin C and antioxidants that protect the body from illnesses and colds. Supporting pregnancy and the fetus: Contains a high percentage of folic acid, essential for preventing birth defects. Weight loss: Rich in water and fiber, which provides a quick feeling of fullness with very few calories. Regulating digestion: Its natural fiber helps improve bowel movements and treat constipation and hemorrhoids. Heart and bone health: Provides the body with vitamin K and calcium to strengthen bones and bones', 'الخس (Lactuca sativa) هو نبات عشبي حولي يتبع الفصيلة النجمية، ويعد من أهم الخضراوات الورقية التي تؤكل طازجة في السلطات والسندوتشات. يتميز بقلة سعراته الحرارية ومحتواه العالي من الماء والألياف، مما يجعله غذاءً مثالياً للصحة والرشاقة.أبرز أنواع الخس الشهيرةخس الآيسبرغ (كابوتشا): يتميز برأسه الكروي المقرمش وأوراقه المتراصة البيضاء والمائلة للخضرة.الخس الروماني: يمتاز بأوراقه الطويلة الداكنة الغنية بالفيتامينات والمعادن.الخس ذو الأوراق الرخوة: تنفتح أوراقه كالزهور وتتنوع ألوانها بين الأخضر والبنفسجي.خس الكرفس: يزرع خصيصاً من أجل سيقانه السميكة الصالحة للأكل.الفوائد الصحية للخستعزيز المناعة: غني بـ فيتامين سي ومضادات الأكسدة التي تحمي الجسم من الأمراض ونزلات البرد.دعم الحامل والجنين: يحتوي على نسبة عالية من حمض الفوليك الضروري لمنع التشوهات الخلقية للأجنة.إنقاص الوزن: غني بالماء والألياف التي تمنح شعوراً سريعاً بالشبع مع سعرات حرارية منخفضة جداً.تنظيم الهضم: تساعد أليافه الطبيعية في تحسين حركة الأمعاء وعلاج مشكلات الإمساك والبواسير.صحة القلب والعظام: يمد الجسم بـ فيتامين ك والكالسيوم لتقوية العظام، والبوتاسيوم لضبط ضغط الدم.أضرار ومحاذير الاستهلاكالتسمم الغذائي: قد تتلوث أوراقه ببكتيريا الإي كولاي أو طفيليات مثل السيكلوسبورا، لذا يجب غسله وتقشيره بعناية فائقة.تخثر الدم: الإفراط في تناوله قد يتعارض مع الأدوية المسيلة للدم بسبب غناه بـ فيتامين ك.', 10.00, NULL, 400, 6, 1, 'bunch', 1000.000, NULL, NULL, '2026-07-24 00:02:57', '2026-07-24 00:02:57'),
(18, 'cabbage', 'الكرنب', 'cabbage', '/storage/Products/1784862478_6400.webp', '[\"\\/storage\\/Products\\/1784862478_5217.webp\",\"\\/storage\\/Products\\/1784862478_7486.webp\",\"\\/storage\\/Products\\/1784862479_5838.webp\"]', 'Cabbage (or cabbage, as it\'s known in the Levant) is one of the most popular leafy vegetables belonging to the cruciferous family. It\'s characterized by its leaves stacked on top of each other in a round or cone-shaped head, and it\'s a staple food in Arab and international cuisines thanks to its nutritional benefits and the variety of ways it can be prepared. Common types of cabbage: Green and white cabbage: The most widespread type, with white inner leaves due to lack of sun exposure. Red (purple) cabbage: Distinguished by its bright color resulting from antioxidants (anthocyanins), it\'s frequently used in salads', 'الكرنب (أو الملفوف كما يُعرف في بلاد الشام) هو أحد أشهر الخضراوات الورقية التي تنتمي إلى الفصيلة الصليبية. يتميز بأوراقه المتراصة فوق بعضها في شكل رأس مستدير أو مخروطي، ويعد من الأطعمة الأساسية في المطابخ العربية والعالمية بفضل فوائده الغذائية وتعدد طرق تحضيره.الأنواع الشائعة للكرنبالكرنب الأخضر والأبيض: النوع الأكثر انتشاراً، وتكون أوراقه الداخلية بيضاء لعدم تعرضها للشمس.الكرنب الأحمر (البنفسجي): يتميز بلونه الزاهي الناتج عن مضادات الأكسدة (الأنثوسيانين)، ويُستخدم بكثرة في السلطات.الكرنب الساقي (أبو ركبة): نوع ينتج ساقاً منتفخة تُشبه القرنبيط في طعمها وتُؤكل نيئة أو مطبوخة.', 25.00, NULL, 400, 6, 1, 'piece', 1000.000, NULL, NULL, '2026-07-24 00:07:59', '2026-07-24 00:07:59'),
(19, 'parsley', 'البقدونس', 'parsley', '/storage/Products/1784862707_9763.webp', '[\"\\/storage\\/Products\\/1784862707_3419.webp\",\"\\/storage\\/Products\\/1784862708_1968.webp\",\"\\/storage\\/Products\\/1784862708_6702.webp\"]', 'Parsley is a popular herb belonging to the Apiaceae family, widely used in cooking and traditional medicine thanks to its richness in vitamins, minerals, and antioxidants. Health benefits include: Kidney cleansing: It acts as a natural diuretic and antiseptic, helping to flush out toxins and prevent kidney stones. Digestive support: It reduces gas and bloating and promotes the efficiency of the liver and digestive system. Bone strengthening: It provides a significant dose of vitamin K, essential for bone density. Blood sugar regulation: It effectively contributes to lowering and regulating blood glucose levels. Heart protection: It contains carotenoids and vitamin C.…', 'البقدونس هو نبات عشبي شعبي ينتمي إلى الفصيلة الخيمية، ويُستخدم على نطاق واسع في الطهي وصناعة العلاجات التقليدية بفضل غناه بالفيتامينات والمعادن ومضادات الأكسدة.الفوائد الصحيةتنظيف الكلى: يعمل كمدر طبيعي للبول ومطهر يساعد في طرد السموم ومنع حصوات الكلى.دعم الهضم: يقلل الغازات والانتفاخات ويعزز كفاءة الكبد والجهاز الهضمي.تقوية العظام: يوفر جرعة هائلة من فيتامين K الضروري لكثافة العظام.ضبط السكر: يساهم بفعالية في خفض وتنظيم مستويات الجلوكوز في الدم.حماية القلب: يحتوي على الكاروتينات وفيتامين C التي تدعم صحة الأوعية الدموية.طرق الاستخدام الشائعةطازج: يضاف مباشرة إلى السلطات (مثل التبولة) والأطباق اليومية.مغلي أو منقوع: تُغلى أوراقه في الماء ويُشرب دافئاً لتطهير الجسم.عصير أخضر: يُعصر مع الليمون أو الكرفس لتعزيز المناعة وحرق الدهون.', 5.00, NULL, 400, 6, 0, 'bunch', 1000.000, NULL, NULL, '2026-07-24 00:11:48', '2026-07-24 00:11:48'),
(20, 'Mint', 'النعناع', 'mint', '/storage/Products/1784863024_4376.webp', '[\"\\/storage\\/Products\\/1784863025_7281.webp\",\"\\/storage\\/Products\\/1784863025_8212.webp\",\"\\/storage\\/Products\\/1784863025_3846.webp\"]', 'Mint is a perennial herb with a pungent aroma, belonging to the mint family (Lamiaceae). It is known for its calming and refreshing properties due to its menthol content. It is used to treat digestive disorders, relieve nasal congestion and colds, in addition to its widespread use in cooking and beverages. Health Benefits of Mint: Mint has numerous health benefits, most notably: Improving digestion: It increases the activity of digestive enzymes and helps eliminate gas and indigestion. Relieving symptoms of irritable bowel syndrome (IBS): It relaxes the muscles of the digestive system, thus reducing spasms and pain In addition to its widespread use in cooking and beverages, mint offers numerous health benefits, most notably: Improved digestion: It increases the activity of digestive enzymes and helps relieve gas and indigestion. Relief from irritable bowel syndrome (IBS): It relaxes the muscles of the digestive system, reducing spasms and pain. Treatment of respiratory disorders: It helps break down phlegm and mucus, facilitating breathing and relieving throat and nasal congestion. Pain and headache relief: It helps alleviate muscle and stomach pain, and its aroma promotes relaxation and reduces stress', 'النعناع هو نبات عشبي معمر ذو رائحة نفاذة، ينتمي للفصيلة الشفوية. يشتهر بخصائصه المهدئة والمنعشة لاحتوائه على مادة \"المنثول\". يُستخدم في علاج اضطرابات الجهاز الهضمي، وتخفيف احتقان الأنف ونزلات البرد، بالإضافة إلى استخدامه الواسع في الطهي والمشروبات.فوائد النعناع الصحيةيمتلك النعناع فوائد متعددة للجسم، أبرزها:تحسين عملية الهضم: يزيد من نشاط الإنزيمات الهاضمة ويساعد في التخلص من الغازات وعسر الهضم.تخفيف أعراض القولون العصبي: يعمل على إرخاء عضلات الجهاز الهضمي، مما يقلل من التقلصات والألم.علاج اضطرابات التنفس: يساعد في تفتيت البلغم والمخاط، مما يسهل التنفس ويخفف من احتقان الحلق والأنف.تسكين الآلام والصداع: يساهم في تخفيف آلام العضلات والمعدة، كما تساعد رائحته على الاسترخاء وتقليل التوتر.استخدامات النعناعيدخل النعناع في مجالات متعددة بفضل طعمه ورائحته المميزة:المشروبات الساخنة والباردة: يعتبر شاي النعناع من المشروبات الشعبية الأساسية، كما يدخل في تحضير العصائر المنعشة مثل الليمون بالنعناع والموهيتو.الزيوت العطرية: يُستخرج زيت النعناع لاستخدامه في التدليك لتسكين الآلام، أو في العلاج بالروائح لتقليل الاكتئاب وتحسين المزاج.الطهي: يُضاف طازجاً أو مجففاً للسلطات، الشوربات، والأطباق المختلفة لإعطائها نكهة مميزة.', 5.00, NULL, 200, 6, 1, 'bunch', 1000.000, NULL, NULL, '2026-07-24 00:17:05', '2026-07-24 00:17:05'),
(21, 'Dill and coriander', 'الشبت والكزبرة', 'dill-and-coriander', '/storage/Products/1784863562_4125.webp', '[\"\\/storage\\/Products\\/1784863563_9219.webp\",\"\\/storage\\/Products\\/1784863563_9793.webp\",\"\\/storage\\/Products\\/1784863563_5072.webp\",\"\\/storage\\/Products\\/1784863563_7342.webp\",\"\\/storage\\/Products\\/1784863564_6748.webp\"]', 'Dill and coriander are among the most important herbs and leafy greens in the kitchen, sharing numerous health benefits as they are rich in vitamins and minerals. They also have wide-ranging uses, both in cooking and as beneficial herbal drinks. Benefits of Dill: Boosting Immunity and Digestion: Dill contains powerful antioxidants and antibacterial agents, helping to cleanse the body and reduce bloating and digestive disorders. Strengthening Bones: It helps protect bones from osteoporosis due to its high calcium content. Regulating Sleep: Dill seeds and leaves are used to help treat sleep disorders.…', 'يعتبر الشبت والكزبرة من أهم الأعشاب والخضروات الورقية في المطبخ، ويشتركان في العديد من الفوائد الصحية كونهما غنيين بالفيتامينات والمعادن، كما أن لهما استخدامات واسعة سواء في الطهي أو كمشروبات عشبية مفيدة للصحة.فوائد الشبتتعزيز المناعة والهضم: يحتوي الشبت على مضادات أكسدة قوية ومضادات للبكتيريا، ويساعد في تطهير الجسم وتقليل الانتفاخات واضطرابات الجهاز الهضمي.تقوية العظام: يساهم في حماية العظام من الهشاشة لاحتوائه على نسبة عالية من الكالسيوم.تنظيم النوم: تستخدم بذور الشبت وأوراقه للمساعدة في علاج الأرق واسترخاء الأعصاب.فوائد الكزبرةصحة القلب والأوعية الدموية: تساعد الكزبرة على خفض مستويات الكوليسترول الضار في الدم، مما يحمي صحة القلب.خفض السكر: تساهم في تنظيم مستويات السكر في الدم عن طريق تعزيز نشاط الإنزيمات التي تزيل السكر منه.تحسين جودة النوم وتقليل القلق: يساعد تناول مغلي الكزبرة أو إضافتها لنظامك الغذائي في محاربة الأرق وتهدئة الأعصاب.', 5.00, NULL, 300, 6, 1, 'bunch', 1000.000, NULL, NULL, '2026-07-24 00:25:04', '2026-07-24 00:26:04'),
(22, 'celery', 'الكرفس', 'celery', '/storage/Products/1784869006_7188.webp', '[\"\\/storage\\/Products\\/1784869006_1467.webp\",\"\\/storage\\/Products\\/1784869006_5109.webp\",\"\\/storage\\/Products\\/1784869006_7534.webp\",\"\\/storage\\/Products\\/1784869006_9770.webp\"]', 'Celery is a leafy green vegetable from the Apiaceae family (like parsley and fennel), known for its pungent flavor and high health benefits thanks to its richness in water, fiber, and nutrients.    Key Health Benefits: Hydration: Celery is composed of approximately 95% water, making it excellent for preventing dehydration. Improved Digestion: It contains both soluble and insoluble dietary fiber that supports digestive health. Anti-Inflammation: Rich in phenolic compounds and antioxidants that reduce inflammation in the body. Blood Pressure Regulation: Contains phthalides, which help regulate blood pressure   It contains phthalate compounds that help relax arteries and lower blood pressure. Weight loss: It is very low in calories and provides a long-lasting feeling of satiety.', 'الكرفس (Celery) هو خضار ورقي من فصيلة الخيميات (مثل البقدونس والشمر)، ويتميز بنكهته القوية وفوائده الصحية العالية بفضل غناه بالمياه والألياف والعناصر الغذائية.💡 الفوائد الصحية الرئيسيةترطيب الجسم: يتكون الكرفس من 95% من الماء تقريباً مما يجعله ممتازاً لمنع الجفاف.تحسين الهضم: يحتوي على ألياف غذائية قابلة للذوبان وغير قابلة للذوبان تدعم صحة الجهاز الهضمي.مكافحة الالتهابات: غني بمركبات الفينول ومضادات الأكسدة التي تقلل من التهابات الجسم.تنظيم ضغط الدم: يحتوي على مركبات الفثاليدات التي تساعد في إرخاء الشرايين وخفض الضغط.إنقاص الوزن: يتميز بأنه منخفض السعرات الحرارية جداً ويمنح شعوراً طويلاً بالشبع.', 20.00, 15.00, 300, 6, 1, 'bunch', 1000.000, NULL, NULL, '2026-07-24 01:56:47', '2026-07-24 01:56:47');

-- --------------------------------------------------------

--
-- بنية الجدول `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `user_id`, `rating`, `comment`, `is_verified`, `images`, `created_at`, `updated_at`) VALUES
(1, 3, 4, 4, 'this product is fresh', 1, NULL, '2026-06-28 07:53:55', '2026-06-28 07:53:55'),
(2, 6, 4, 5, 'very fresh', 0, '\"[\\\"\\\\\\/storage\\\\\\/Reviews\\\\\\/1782824178_3464.webp\\\",\\\"\\\\\\/storage\\\\\\/Reviews\\\\\\/1782824179_3987.webp\\\"]\"', '2026-06-30 06:02:03', '2026-06-30 09:56:19');

-- --------------------------------------------------------

--
-- بنية الجدول `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `title_ar` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `description_ar` varchar(255) DEFAULT NULL,
  `image` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `services`
--

INSERT INTO `services` (`id`, `title`, `title_ar`, `description`, `description_ar`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Shop', 'المتجر', 'Providing simple shopping cart flow for users and other services.', 'توفير تجربة سلة تسوق بسيطة للمستخدمين والخدمات الأخرى.', '/storage/Services/1781915522_3504.webp', '2026-06-11 22:13:20', '2026-06-19 21:32:02'),
(2, 'Relaxation', 'الاسترخاء', 'Bring nature in to your life, greater productivity and relaxation.', 'أدخل الطبيعة إلى حياتك، وحقق إنتاجية أكبر واسترخاءً أعمق.', '/storage/Services/1781915331_3657.webp', '2026-06-11 22:17:52', '2026-06-19 21:28:51'),
(3, '24/7 technical support', 'دعم فني 24/7', 'The online plant store offers 24/7 technical support.', 'متجر النباتات الإلكتروني يوفر دعمًا فنيًا متاحًا على مدار الساعة في جميع ايام الاسبوع .', '/storage/Services/1781915451_8164.webp', '2026-06-11 22:47:36', '2026-06-19 21:30:51'),
(4, 'Delivery', 'التوصيل', 'Delivery to your door, better mental wellbeing and happiness.', 'التوصيل إلى باب منزلك، صحة نفسية أفضل وسعادة أكبر.', '/storage/Services/1781915053_4384.webp', '2026-06-11 23:30:41', '2026-06-19 21:24:13'),
(5, 'Nursery Experts', 'خبراء المشاتل', 'Get experts tip to how you can care your plants in you home.', 'احصل على نصائح الخبراء حول كيفية العناية بنباتاتك في منزلك.', '/storage/Services/1781915655_6566.webp', '2026-06-11 23:50:04', '2026-06-19 21:34:15'),
(6, 'Quality', 'الجودة', 'Providing quality plants to gardeners. Decorates your home with plants.', 'توفير نباتات عالية الجودة للبستانيين. يزين منزلك بالنباتات.', '/storage/Services/1781915238_1501.webp', '2026-06-11 23:56:32', '2026-06-19 21:27:18');

-- --------------------------------------------------------

--
-- بنية الجدول `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `group` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` enum('text','image','video','multi_images') NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `settings`
--

INSERT INTO `settings` (`id`, `group`, `name`, `value`, `type`, `metadata`, `created_at`, `updated_at`) VALUES
(30, 'services_group', 'hero', 'hero rtexr', 'text', NULL, '2026-06-03 20:39:44', '2026-06-03 20:39:44'),
(31, 'home_setting', 'service_main_image', '/storage/settings/images/1781924953_4191.webp', 'image', NULL, '2026-06-12 03:44:06', '2026-06-20 00:09:13'),
(32, 'home_setting', 'hero_image', '/storage/settings/images/1784785125_7472.webp', 'image', NULL, '2026-06-18 21:11:41', '2026-07-23 02:38:46'),
(33, 'home_setting', 'hero_title_en', 'Fresh From Farm', 'text', NULL, '2026-06-19 00:00:10', '2026-06-19 00:00:10'),
(34, 'home_setting', 'hero_title_ar', 'طازج من المزرعة', 'text', NULL, '2026-06-19 00:00:31', '2026-06-19 00:00:31'),
(35, 'home_setting', 'hero_sub_title_en', 'To Your Table', 'text', NULL, '2026-06-19 00:01:10', '2026-06-19 00:01:10'),
(36, 'home_setting', 'hero_sub_title_ar', 'إلى طاولتك', 'text', NULL, '2026-06-19 00:01:30', '2026-06-19 00:01:30'),
(37, 'home_setting', 'hero_description_en', 'Premium quality seeds, organic products & exceptional services.\r\n          Grown with love, delivered with care.', 'text', NULL, '2026-06-19 00:02:15', '2026-06-19 00:02:15'),
(38, 'home_setting', 'hero_description_ar', 'بذور عالية الجودة، منتجات عضوية، وخدمات استثنائية. مزروعة بحب، ومُسلّمة بعناية.', 'text', NULL, '2026-06-19 00:02:55', '2026-06-19 00:02:55'),
(39, 'footer_settings', 'whatsapp', '+201003452188', 'text', NULL, '2026-07-13 18:59:24', '2026-07-13 18:59:24'),
(41, 'footer_settings', 'address_en', 'Cairo - Nasr City', 'text', NULL, '2026-07-13 19:02:29', '2026-07-13 19:02:29'),
(42, 'footer_settings', 'address_ar', 'القاهرة - مدينة نصر', 'text', NULL, '2026-07-13 19:03:02', '2026-07-13 19:03:02'),
(43, 'footer_settings', 'email', 'info@shop_plants.com', 'text', NULL, '2026-07-13 19:04:46', '2026-07-13 19:04:46'),
(44, 'about_settings', 'about_images', '[\"\\/storage\\/\\/settings\\/multi-images\\/1783985653_3192.webp\",\"\\/storage\\/\\/settings\\/multi-images\\/1783985655_9125.webp\",\"\\/storage\\/\\/settings\\/multi-images\\/1783985655_5722.webp\",\"\\/storage\\/\\/settings\\/multi-images\\/1783985656_4920.webp\"]', 'multi_images', NULL, '2026-07-13 20:34:16', '2026-07-13 20:34:16'),
(45, 'about_settings', 'fresh_plants', '/storage/settings/images/1784001110_5019.webp', 'image', NULL, '2026-07-14 00:51:50', '2026-07-14 00:51:50'),
(46, 'about_settings', 'story_image', '/storage/settings/images/1784001261_8601.webp', 'image', NULL, '2026-07-14 00:54:21', '2026-07-14 00:54:21'),
(47, 'about_settings', 'succulents', '/storage/settings/images/1784001611_9572.webp', 'image', NULL, '2026-07-14 01:00:11', '2026-07-14 01:00:11'),
(48, 'about_settings', 'flowering_plants', '/storage/settings/images/1784001778_7196.webp', 'image', NULL, '2026-07-14 01:02:59', '2026-07-14 01:02:59'),
(49, 'about_settings', 'fresh_herbs', '/storage/settings/images/1784001846_1837.webp', 'image', NULL, '2026-07-14 01:04:06', '2026-07-14 01:04:06'),
(50, 'about_settings', 'garden_tools', '/storage/settings/images/1784001962_9177.webp', 'image', NULL, '2026-07-14 01:06:02', '2026-07-14 01:06:02'),
(51, 'about_settings', 'premium_seeds', '/storage/settings/images/1784002125_3389.webp', 'image', NULL, '2026-07-14 01:08:45', '2026-07-14 01:08:45'),
(52, 'about_settings', 'indoor_plants', '/storage/settings/images/1784002190_2811.webp', 'image', NULL, '2026-07-14 01:09:51', '2026-07-14 01:09:51'),
(53, 'about_settings', 'pots_planters', '/storage/settings/images/1784002256_4250.webp', 'image', NULL, '2026-07-14 01:10:56', '2026-07-14 01:10:56');

-- --------------------------------------------------------

--
-- بنية الجدول `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `avatar`, `phone`, `email_verified_at`, `password`, `points`, `remember_token`, `created_at`, `updated_at`, `is_admin`) VALUES
(1, 'Test User', 'test@example.com', NULL, NULL, NULL, '$2y$12$jSt8/fPrr/7/Y9SKmZ9TpOqc0nRS6/SpO1favKRLC3EaITbNGa5DW', 160, NULL, '2025-10-27 10:08:23', '2025-10-27 10:19:39', 0),
(2, 'Dallas Nitzsche', 'michele.sauer@example.net', NULL, NULL, '2025-10-27 10:59:04', '$2y$04$lcimFVZgwZLd6m//mDbK1ei9kWOcvJS4eLVbwLmReBSbtXTf31ga.', 0, 'O8Yic8gz9h', '2025-10-27 10:59:04', '2025-10-27 10:59:04', 0),
(3, 'Mrs. Kaci McCullough IV', 'alysson.king@example.org', NULL, NULL, '2025-10-27 11:02:25', '$2y$04$oNhXUG.o4R53fJnG/6iiqe3s5x.C0sxbO0e5otviHBlPjTM0IddcG', 110, 'cNZ1TOGOj9', '2025-10-27 11:02:25', '2025-10-27 11:02:26', 0),
(4, 'Admin', 'emanzidanelgmal@gmail.com', NULL, '01003452188', '2026-01-14 12:45:06', '$2y$12$vCYf2VY00INbGMvAl2jDBu9Pmsw7OfFngwM/V9kcKlWjTcj1oba4K', 0, NULL, '2026-01-14 12:45:06', '2026-06-30 17:03:36', 1),
(13, 'Eman Esmail', 'emanesmailzidan@gmail.com', NULL, NULL, NULL, '$2y$12$K/HM254ddu.TQFDcnbebVedhX8LQDDP228OkyaQXganW2FE.jyWE6', 0, NULL, '2026-01-15 07:38:56', '2026-01-15 07:38:56', 1),
(14, 'eman esmail', 'clickshareservice@gmail.com', NULL, NULL, NULL, '$2y$12$I15qFFZWhCzKg.bUiqAJ/uWjM5sOkqWlsZ5q3zSrOU.SkvjinMWwy', 0, NULL, '2026-07-07 13:43:35', '2026-07-10 19:08:46', 0);

-- --------------------------------------------------------

--
-- بنية الجدول `wishlists`
--

CREATE TABLE `wishlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `wishlists`
--

INSERT INTO `wishlists` (`id`, `user_id`, `product_id`, `created_at`, `updated_at`) VALUES
(19, 4, 14, '2026-07-10 01:15:50', '2026-07-10 01:15:50'),
(20, 4, 6, '2026-07-10 18:49:24', '2026-07-10 18:49:24'),
(24, 4, 5, '2026-07-24 04:58:23', '2026-07-24 04:58:23'),
(26, 4, 19, '2026-07-24 04:59:18', '2026-07-24 04:59:18'),
(27, 4, 20, '2026-07-24 04:59:29', '2026-07-24 04:59:29'),
(28, 14, 13, '2026-07-27 04:17:18', '2026-07-27 04:17:18'),
(29, 14, 14, '2026-07-27 04:17:20', '2026-07-27 04:17:20'),
(30, 14, 12, '2026-07-27 04:18:43', '2026-07-27 04:18:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_user_id_foreign` (`user_id`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `carts_session_id_unique` (`session_id`),
  ADD KEY `carts_user_id_foreign` (`user_id`),
  ADD KEY `carts_session_id_user_id_index` (`session_id`,`user_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_items_cart_id_product_id_unique` (`cart_id`,`product_id`),
  ADD KEY `cart_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_name_index` (`name`),
  ADD KEY `categories_name_ar_index` (`name_ar`),
  ADD KEY `categories_created_at_index` (`created_at`),
  ADD KEY `categories_updated_at_index` (`updated_at`),
  ADD KEY `categories_name_name_ar_index` (`name`,`name_ar`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contacts_user_id_foreign` (`user_id`),
  ADD KEY `contacts_updated_by_foreign` (`updated_by`),
  ADD KEY `contacts_email_index` (`email`),
  ADD KEY `contacts_status_index` (`status`),
  ADD KEY `contacts_created_at_index` (`created_at`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `discounts_code_unique` (`code`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_refunded_by_foreign` (`refunded_by`),
  ADD KEY `orders_created_by_foreign` (`created_by`),
  ADD KEY `orders_updated_by_foreign` (`updated_by`),
  ADD KEY `orders_cancelled_by_foreign` (`cancelled_by`),
  ADD KEY `orders_order_number_index` (`order_number`),
  ADD KEY `orders_user_id_status_index` (`user_id`,`status`),
  ADD KEY `orders_payment_status_status_index` (`payment_status`,`status`),
  ADD KEY `orders_tracking_number_index` (`tracking_number`),
  ADD KEY `orders_shipping_status_index` (`shipping_status`),
  ADD KEY `orders_created_at_index` (`created_at`),
  ADD KEY `orders_refund_status_index` (`refund_status`),
  ADD KEY `orders_refunded_at_index` (`refunded_at`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`),
  ADD KEY `order_items_order_id_product_id_index` (`order_id`,`product_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payments_transaction_id_unique` (`transaction_id`),
  ADD UNIQUE KEY `payments_payment_intent_id_unique` (`payment_intent_id`),
  ADD UNIQUE KEY `payments_stripe_session_id_unique` (`stripe_session_id`),
  ADD UNIQUE KEY `payments_stripe_charge_id_unique` (`stripe_charge_id`),
  ADD UNIQUE KEY `payments_paypal_order_id_unique` (`paypal_order_id`),
  ADD KEY `payments_refunded_by_foreign` (`refunded_by`),
  ADD KEY `payments_created_by_foreign` (`created_by`),
  ADD KEY `payments_updated_by_foreign` (`updated_by`),
  ADD KEY `payments_processed_by_foreign` (`processed_by`),
  ADD KEY `payments_order_id_status_index` (`order_id`,`status`),
  ADD KEY `payments_payment_method_index` (`payment_method`),
  ADD KEY `payments_status_index` (`status`),
  ADD KEY `payments_transaction_id_index` (`transaction_id`),
  ADD KEY `payments_payment_intent_id_index` (`payment_intent_id`),
  ADD KEY `payments_stripe_session_id_index` (`stripe_session_id`),
  ADD KEY `payments_paypal_order_id_index` (`paypal_order_id`),
  ADD KEY `payments_created_at_index` (`created_at`),
  ADD KEY `payments_refund_status_index` (`refund_status`),
  ADD KEY `payments_refunded_at_index` (`refunded_at`),
  ADD KEY `payments_stripe_refund_id_index` (`stripe_refund_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_title_index` (`title`(768)),
  ADD KEY `products_created_at_index` (`created_at`),
  ADD KEY `products_updated_at_index` (`updated_at`),
  ADD KEY `products_unit_index` (`unit`),
  ADD KEY `products_deleted_at_index` (`deleted_at`),
  ADD KEY `products_category_id_index` (`category_id`),
  ADD KEY `products_unit_deleted_at_index` (`unit`,`deleted_at`),
  ADD KEY `products_category_id_deleted_at_index` (`category_id`,`deleted_at`),
  ADD KEY `products_created_at_deleted_at_index` (`created_at`,`deleted_at`),
  ADD KEY `products_price_sale_price_index` (`price`,`sale_price`),
  ADD KEY `title_ar_index` (`title_ar`),
  ADD KEY `description_ar_index` (`description_ar`(768));
ALTER TABLE `products` ADD FULLTEXT KEY `products_title_fulltext` (`title`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reviews_product_id_user_id_unique` (`product_id`,`user_id`),
  ADD KEY `reviews_user_id_foreign` (`user_id`),
  ADD KEY `reviews_product_id_rating_index` (`product_id`,`rating`),
  ADD KEY `reviews_created_at_index` (`created_at`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `services_description_index` (`description`),
  ADD UNIQUE KEY `services_description_ar_index` (`description_ar`),
  ADD UNIQUE KEY `services_image_index` (`image`) USING HASH,
  ADD KEY `services_title_index` (`title`),
  ADD KEY `services_title_ar_index` (`title_ar`),
  ADD KEY `services_title_title_ar_index` (`title`,`title_ar`),
  ADD KEY `services_created_at_index` (`created_at`),
  ADD KEY `services_updated_at_index` (`updated_at`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_group_name_unique` (`group`,`name`),
  ADD KEY `settings_group_index` (`group`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wishlists_user_id_product_id_unique` (`user_id`,`product_id`),
  ADD KEY `wishlists_product_id_foreign` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- قيود الجداول المُلقاة.
--

--
-- قيود الجداول `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- قيود الجداول `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `contacts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- قيود الجداول `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_cancelled_by_foreign` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_refunded_by_foreign` FOREIGN KEY (`refunded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_processed_by_foreign` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payments_refunded_by_foreign` FOREIGN KEY (`refunded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payments_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- قيود الجداول `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- قيود الجداول `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
