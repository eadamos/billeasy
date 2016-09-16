-- phpMyAdmin SQL Dump
-- version 4.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 19, 2016 at 04:53 PM
-- Server version: 5.6.22
-- PHP Version: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `billeasy`
--

-- --------------------------------------------------------

--
-- Table structure for table `billers`
--

CREATE TABLE IF NOT EXISTS `billers` (
`biller_id` int(11) NOT NULL,
  `biller_name` varchar(50) NOT NULL,
  `datetime_registered` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `billers`
--

INSERT INTO `billers` (`biller_id`, `biller_name`, `datetime_registered`) VALUES
(1, 'Meralco', '0000-00-00 00:00:00'),
(2, 'Maynilad', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE IF NOT EXISTS `bills` (
`bill_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `biller_id` int(11) NOT NULL,
  `billing_date` date NOT NULL,
  `amount` decimal(10,0) NOT NULL,
  `paid` int(11) NOT NULL,
  `due_date` date NOT NULL,
  `total_kWh` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`bill_id`, `user_id`, `biller_id`, `billing_date`, `amount`, `paid`, `due_date`, `total_kWh`) VALUES
(1, 2, 1, '2016-08-19', '500', 0, '2016-10-19', 0),
(2, 2, 2, '2016-08-09', '200', 0, '2016-10-09', 0),
(3, 3, 1, '2016-08-10', '800', 0, '2016-10-10', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`user_id` int(11) NOT NULL,
  `user_name` varchar(11) NOT NULL,
  `password` varchar(50) NOT NULL,
  `class` text NOT NULL,
  `datetime_registered` datetime NOT NULL,
  `email` varchar(100) NOT NULL,
  `given_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `password`, `class`, `datetime_registered`, `email`, `given_name`, `middle_name`, `surname`) VALUES
(1, 'admin', 'password', 'admin', '0000-00-00 00:00:00', '', 'Edward', '', ''),
(2, 'eugene', 'raygun', 'user', '0000-00-00 00:00:00', '', 'Eugene', '', ''),
(3, 'goku', 'kamehamewave', 'user', '0000-00-00 00:00:00', '', 'Goku', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `billers`
--
ALTER TABLE `billers`
 ADD PRIMARY KEY (`biller_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
 ADD PRIMARY KEY (`bill_id`), ADD KEY `bill_id` (`bill_id`), ADD KEY `user_id` (`user_id`), ADD KEY `biller_id` (`biller_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`user_id`), ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `billers`
--
ALTER TABLE `billers`
MODIFY `biller_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
ADD CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`biller_id`) REFERENCES `billers` (`biller_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
