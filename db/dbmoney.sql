-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2016 at 04:25 PM
-- Server version: 10.1.8-MariaDB
-- PHP Version: 5.6.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbmoney`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `AccountId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `AccountName` varchar(255) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`AccountId`, `UserId`, `AccountName`) VALUES
(1, 1, 'Cash'),
(2, 1, 'Account'),
(3, 1, 'Card');

--
-- Triggers `account`
--
DELIMITER $$
CREATE TRIGGER `GenerateAccount` AFTER INSERT ON `account` FOR EACH ROW INSERT INTO totals(UserId, AccountId, totals) values (new.UserId, new.AccountId, '0')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `AssetsId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `Title` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Date` date NOT NULL,
  `CategoryId` int(5) NOT NULL,
  `AccountId` int(5) NOT NULL,
  `Amount` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Description` text CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `assets`
--
DELIMITER $$
CREATE TRIGGER `GenerateTotalAccount` AFTER INSERT ON `assets` FOR EACH ROW UPDATE totals SET totals.totals=totals.totals + new.amount where totals.userid=new.userid and totals.accountid=new.accountid
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `GenerateTotalUpdate` AFTER UPDATE ON `assets` FOR EACH ROW UPDATE totals SET totals.totals=(select sum(Amount) from assets where assets.userid=new.userid and assets.accountid=new.accountid) where totals.userid=new.userid and totals.accountid=new.accountid
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `BillsId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `Title` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Dates` date NOT NULL,
  `CategoryId` int(5) NOT NULL,
  `AccountId` int(5) NOT NULL,
  `Amount` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Description` text CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `bills`
--
DELIMITER $$
CREATE TRIGGER `GenerateExpense` AFTER INSERT ON `bills` FOR EACH ROW UPDATE totals SET totals.totals=totals.totals - new.amount where totals.userid=new.userid and totals.accountid=new.accountid
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `budget`
--

CREATE TABLE `budget` (
  `BudgetId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `CategoryId` int(5) NOT NULL,
  `Dates` date NOT NULL,
  `Amount` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `CategoryName` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Level` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryId`, `UserId`, `CategoryName`, `Level`) VALUES
(1, 1, 'Salary', 1),
(2, 1, 'Alowance', 1),
(3, 1, 'Petty Cash', 1),
(4, 1, 'Bonus', 1),
(5, 1, 'Food', 2),
(6, 1, 'Social Life', 2),
(7, 1, 'Self-Development', 2),
(8, 1, 'Transportation', 2),
(9, 1, 'Culture', 2),
(10, 1, 'Household', 2),
(11, 1, 'Apparel', 2),
(12, 1, 'Beauty', 2),
(13, 1, 'Health', 2),
(14, 1, 'Gift', 2);

-- --------------------------------------------------------

--
-- Table structure for table `totals`
--

CREATE TABLE `totals` (
  `TotalsId` int(5) NOT NULL,
  `UserId` int(5) NOT NULL,
  `AccountId` int(5) NOT NULL,
  `Totals` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `totals`
--

INSERT INTO `totals` (`TotalsId`, `UserId`, `AccountId`, `Totals`) VALUES
(1, 1, 1, 0),
(2, 1, 2, 0),
(3, 1, 3, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserId` int(5) NOT NULL,
  `FirstName` varchar(255) CHARACTER SET latin1 NOT NULL,
  `LastName` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Email` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Password` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserId`, `FirstName`, `LastName`, `Email`, `Password`, `Currency`) VALUES
(1, 'admin', 'admin', 'a@example.com', 'LjQIdwGE9y5PgLMZdbn8WtWcH8LFTpnoJ1Kx7HnpCes=', '$');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `GenerateDefaultAccount` AFTER INSERT ON `user` FOR EACH ROW INSERT INTO account (UserId, AccountName) VALUES (new.UserId, 'Cash'), (new.UserId, 'Account'), (new.UserId, 'Card')
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`AccountId`);

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`AssetsId`),
  ADD KEY `fk_test` (`AccountId`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`BillsId`),
  ADD KEY `fk_testt` (`AccountId`);

--
-- Indexes for table `budget`
--
ALTER TABLE `budget`
  ADD PRIMARY KEY (`BudgetId`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryId`);

--
-- Indexes for table `totals`
--
ALTER TABLE `totals`
  ADD PRIMARY KEY (`TotalsId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `AccountId` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `assets`
--
ALTER TABLE `assets`
  MODIFY `AssetsId` int(5) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `BillsId` int(5) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `budget`
--
ALTER TABLE `budget`
  MODIFY `BudgetId` int(5) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryId` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `totals`
--
ALTER TABLE `totals`
  MODIFY `TotalsId` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserId` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `assets`
--
ALTER TABLE `assets`
  ADD CONSTRAINT `fk_test` FOREIGN KEY (`AccountId`) REFERENCES `account` (`AccountId`) ON DELETE CASCADE;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `fk_testt` FOREIGN KEY (`AccountId`) REFERENCES `account` (`AccountId`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
