-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`airport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`airport` (
  `apcode` CHAR(3) NOT NULL,
  `apname` VARCHAR(30) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `country` VARCHAR(20) NULL,
  PRIMARY KEY (`apcode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`aircraft`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`aircraft` (
  `airid` VARCHAR(5) NOT NULL,
  `airtype` VARCHAR(20) NOT NULL,
  `seats` SMALLINT(5) NOT NULL,
  PRIMARY KEY (`airid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`crew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`crew` (
  `crewid` CHAR(4) NOT NULL,
  `crewname` VARCHAR(30) NOT NULL,
  `role` ENUM('Captain', 'FO', 'Cabin') NOT NULL,
  PRIMARY KEY (`crewid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`route`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`route` (
  `rid` CHAR(4) NOT NULL,
  `origin_apcode` CHAR(3) NOT NULL,
  `dest_apcode` CHAR(3) NOT NULL,
  `distance` INT NULL,
  `airport_apcode` CHAR(3) NOT NULL,
  `airport_apcode1` CHAR(3) NOT NULL,
  PRIMARY KEY (`rid`, `airport_apcode`),
  INDEX `fk_route_airport1_idx` (`airport_apcode` ASC) VISIBLE,
  INDEX `fk_route_airport2_idx` (`airport_apcode1` ASC) VISIBLE,
  CONSTRAINT `fk_route_airport1`
    FOREIGN KEY (`airport_apcode`)
    REFERENCES `mydb`.`airport` (`apcode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_route_airport2`
    FOREIGN KEY (`airport_apcode1`)
    REFERENCES `mydb`.`airport` (`apcode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`flight`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`flight` (
  `fid` CHAR(6) NOT NULL,
  `rid` CHAR(4) NOT NULL,
  `airid` CHAR(5) NULL,
  `fdate` DATE NULL,
  `ftime` TIME NULL,
  `captain` CHAR(4) NULL,
  `fo` CHAR(4) NULL,
  `route_rid` CHAR(4) NOT NULL,
  `aircraft_airid` VARCHAR(5) NOT NULL,
  `crew_crewid` CHAR(4) NOT NULL,
  `crew_crewid1` CHAR(4) NOT NULL,
  PRIMARY KEY (`fid`, `route_rid`, `aircraft_airid`, `crew_crewid`, `crew_crewid1`),
  INDEX `fk_flight_route_idx` (`route_rid` ASC) VISIBLE,
  INDEX `fk_flight_aircraft1_idx` (`aircraft_airid` ASC) VISIBLE,
  INDEX `fk_flight_crew1_idx` (`crew_crewid` ASC) VISIBLE,
  INDEX `fk_flight_crew2_idx` (`crew_crewid1` ASC) VISIBLE,
  CONSTRAINT `fk_flight_route`
    FOREIGN KEY (`route_rid`)
    REFERENCES `mydb`.`route` (`rid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_aircraft1`
    FOREIGN KEY (`aircraft_airid`)
    REFERENCES `mydb`.`aircraft` (`airid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_crew1`
    FOREIGN KEY (`crew_crewid`)
    REFERENCES `mydb`.`crew` (`crewid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_crew2`
    FOREIGN KEY (`crew_crewid1`)
    REFERENCES `mydb`.`crew` (`crewid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`passenger`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`passenger` (
  `pid` CHAR(6) NOT NULL,
  `fname` VARCHAR(30) NOT NULL,
  `lname` VARCHAR(30) NOT NULL,
  `phone` CHAR(10) NULL,
  `email` VARCHAR(50) NULL,
  PRIMARY KEY (`pid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`booking` (
  `bid` CHAR(6) NOT NULL,
  `pid` CHAR(6) NULL,
  `fid` CHAR(6) NULL,
  `bdate` DATE NULL,
  `status` ENUM('CONFIRMED', 'CANCELLED') NULL,
  `passenger_pid` CHAR(6) NOT NULL,
  PRIMARY KEY (`bid`, `passenger_pid`),
  INDEX `fk_booking_passenger1_idx` (`passenger_pid` ASC) VISIBLE,
  CONSTRAINT `fk_booking_passenger1`
    FOREIGN KEY (`passenger_pid`)
    REFERENCES `mydb`.`passenger` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payment` (
  `payid` CHAR(6) NOT NULL,
  `bid` CHAR(6) NOT NULL,
  `amount` DECIMAL(8,2) NOT NULL,
  `paydate` DATE NULL,
  `method` ENUM('CARD', 'UPI', 'NETBANKING') NULL,
  `booking_bid` CHAR(6) NOT NULL,
  `booking_passenger_pid` CHAR(6) NOT NULL,
  PRIMARY KEY (`payid`, `booking_bid`, `booking_passenger_pid`),
  INDEX `fk_payment_booking1_idx` (`booking_bid` ASC, `booking_passenger_pid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_booking1`
    FOREIGN KEY (`booking_bid` , `booking_passenger_pid`)
    REFERENCES `mydb`.`booking` (`bid` , `passenger_pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`seat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`seat` (
  `seatid` CHAR(5) NOT NULL,
  `fid` CHAR(6) NULL,
  `seatno` CHAR(4) NULL,
  `class` ENUM('ECONOMY', 'BUSINESS') NULL,
  `flight_fid` CHAR(6) NOT NULL,
  `flight_route_rid` CHAR(4) NOT NULL,
  `flight_aircraft_airid` VARCHAR(5) NOT NULL,
  `flight_crew_crewid` CHAR(4) NOT NULL,
  `flight_crew_crewid1` CHAR(4) NOT NULL,
  PRIMARY KEY (`seatid`, `flight_fid`, `flight_route_rid`, `flight_aircraft_airid`, `flight_crew_crewid`, `flight_crew_crewid1`),
  INDEX `fk_seat_flight1_idx` (`flight_fid` ASC, `flight_route_rid` ASC, `flight_aircraft_airid` ASC, `flight_crew_crewid` ASC, `flight_crew_crewid1` ASC) VISIBLE,
  CONSTRAINT `fk_seat_flight1`
    FOREIGN KEY (`flight_fid` , `flight_route_rid` , `flight_aircraft_airid` , `flight_crew_crewid` , `flight_crew_crewid1`)
    REFERENCES `mydb`.`flight` (`fid` , `route_rid` , `aircraft_airid` , `crew_crewid` , `crew_crewid1`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`seat_allocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`seat_allocation` (
  `allocid` CHAR(6) NOT NULL,
  `seatid` CHAR(5) NOT NULL,
  `bid` CHAR(6) NULL,
  `seat_seatid` CHAR(5) NOT NULL,
  `seat_flight_fid` CHAR(6) NOT NULL,
  `seat_flight_route_rid` CHAR(4) NOT NULL,
  `seat_flight_aircraft_airid` VARCHAR(5) NOT NULL,
  `seat_flight_crew_crewid` CHAR(4) NOT NULL,
  `seat_flight_crew_crewid1` CHAR(4) NOT NULL,
  `booking_bid` CHAR(6) NOT NULL,
  `booking_passenger_pid` CHAR(6) NOT NULL,
  PRIMARY KEY (`allocid`, `seat_seatid`, `seat_flight_fid`, `seat_flight_route_rid`, `seat_flight_aircraft_airid`, `seat_flight_crew_crewid`, `seat_flight_crew_crewid1`, `booking_bid`, `booking_passenger_pid`),
  INDEX `fk_seat_allocation_seat1_idx` (`seat_seatid` ASC, `seat_flight_fid` ASC, `seat_flight_route_rid` ASC, `seat_flight_aircraft_airid` ASC, `seat_flight_crew_crewid` ASC, `seat_flight_crew_crewid1` ASC) VISIBLE,
  INDEX `fk_seat_allocation_booking1_idx` (`booking_bid` ASC, `booking_passenger_pid` ASC) VISIBLE,
  CONSTRAINT `fk_seat_allocation_seat1`
    FOREIGN KEY (`seat_seatid` , `seat_flight_fid` , `seat_flight_route_rid` , `seat_flight_aircraft_airid` , `seat_flight_crew_crewid` , `seat_flight_crew_crewid1`)
    REFERENCES `mydb`.`seat` (`seatid` , `flight_fid` , `flight_route_rid` , `flight_aircraft_airid` , `flight_crew_crewid` , `flight_crew_crewid1`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_seat_allocation_booking1`
    FOREIGN KEY (`booking_bid` , `booking_passenger_pid`)
    REFERENCES `mydb`.`booking` (`bid` , `passenger_pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`baggage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`baggage` (
  `bagid` VARCHAR(6) NOT NULL,
  `bid` CHAR(6) NOT NULL,
  `weight` SMALLINT NULL,
  `type` ENUM('CHECKIN', 'CABIN') NULL,
  PRIMARY KEY (`bagid`),
  INDEX `fk_baggage_booking_idx` (`bid` ASC) VISIBLE,
  CONSTRAINT `fk_baggage_booking`
    FOREIGN KEY (`bid`)
    REFERENCES `mydb`.`booking` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`loyaltymember`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`loyaltymember` (
  `lid` CHAR(6) NOT NULL,
  `pid` CHAR(6) NOT NULL,
  `tier` ENUM('BLUE', 'SILVER', 'GOLD', 'PLATINUM') NULL,
  `points` INT NULL,
  `loyaltymembercol` VARCHAR(45) NULL,
  PRIMARY KEY (`lid`),
  INDEX `fk_loyalty_passenger_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_loyalty_passenger`
    FOREIGN KEY (`pid`)
    REFERENCES `mydb`.`passenger` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`addonservice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`addonservice` (
  `idaddonservice` CHAR(4) NOT NULL,
  `aname` CHAR(30) NULL,
  `price` DECIMAL(6,2) NULL,
  PRIMARY KEY (`idaddonservice`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bookingaddon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`bookingaddon` (
  `idbookingaddon` CHAR(6) NOT NULL,
  `bid` CHAR(6) NULL,
  `aid` CHAR(4) NULL,
  PRIMARY KEY (`idbookingaddon`),
  INDEX `fk_bookingaddon_booking_idx` (`bid` ASC) VISIBLE,
  INDEX `fk_bookingaddon_service_idx` (`aid` ASC) VISIBLE,
  CONSTRAINT `fk_bookingaddon_booking`
    FOREIGN KEY (`bid`)
    REFERENCES `mydb`.`booking` (`bid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bookingaddon_service`
    FOREIGN KEY (`aid`)
    REFERENCES `mydb`.`addonservice` (`idaddonservice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ticket` (
  `ticketid` CHAR(8) NOT NULL,
  `bid` CHAR(6) NULL,
  `issue_date` DATE NULL,
  `seatid` CHAR(5) NULL,
  PRIMARY KEY (`ticketid`),
  INDEX `fk_ticket_booking_idx` (`bid` ASC) VISIBLE,
  INDEX `fk_ticket_seat_idx` (`seatid` ASC) VISIBLE,
  CONSTRAINT `fk_ticket_booking`
    FOREIGN KEY (`bid`)
    REFERENCES `mydb`.`bookingaddon` (`idbookingaddon`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_seat`
    FOREIGN KEY (`seatid`)
    REFERENCES `mydb`.`seat_allocation` (`allocid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO airport (apcode, apname, city, country) VALUES
('DEL', 'Indira Gandhi Intl', 'Delhi', 'India'),
('BOM', 'Chhatrapati Shivaji', 'Mumbai', 'India');

INSERT INTO aircraft (airid, airtype, seats) VALUES
('A320', 'Airbus A320', 180),
('B738', 'Boeing 737-800', 189);

INSERT INTO crew (crewid, crewname, role) VALUES
('C001', 'Raj Mehta', 'Captain'),
('C002', 'Amit Shah', 'FO'),
('C101', 'Riya Sharma', 'Cabin'),
('C102', 'Neha Patel', 'Cabin');

INSERT INTO route (rid, origin_apcode, dest_apcode, distance, airport_apcode, airport_apcode1) VALUES
('R001', 'DEL', 'BOM', 1150, 'DEL', 'BOM'),
('R002', 'BOM', 'DEL', 1150, 'BOM', 'DEL');

INSERT INTO flight (fid, rid, airid, fdate, ftime, captain, fo, route_rid, aircraft_airid, crew_crewid, crew_crewid1)
VALUES
('F10001', 'R001', 'A320', '2025-12-15', '10:00:00', 'C001', 'C002', 'R001', 'A320', 'C101', 'C102');

INSERT INTO passenger (pid, fname, lname, phone, email) VALUES
('P001', 'Aadya', 'Ratan', '9876543210', 'aadya@mail.com'),
('P002', 'Arjun', 'Singh', '9123456780', 'arjun@mail.com');

INSERT INTO booking (bid, pid, fid, bdate, status, passenger_pid)
VALUES
('B001', 'P001', 'F10001', '2025-12-01', 'CONFIRMED', 'P001');

INSERT INTO payment (payid, bid, amount, paydate, method, booking_bid, booking_passenger_pid)
VALUES
('PAY01', 'B001', 5500.00, '2025-12-01', 'CARD', 'B001', 'P001');

INSERT INTO seat (seatid, fid, seatno, class, flight_fid, flight_route_rid, flight_aircraft_airid, flight_crew_crewid, flight_crew_crewid1)
VALUES
('S01A', 'F10001', '01A', 'ECONOMY', 'F10001', 'R001', 'A320', 'C101', 'C102');

INSERT INTO seat_allocation (
    allocid, seatid, bid,
    seat_seatid, seat_flight_fid, seat_flight_route_rid,
    seat_flight_aircraft_airid, seat_flight_crew_crewid, seat_flight_crew_crewid1,
    booking_bid, booking_passenger_pid
) VALUES
('AL001', 'S01A', 'B001',
 'S01A', 'F10001', 'R001', 'A320', 'C101', 'C102',
 'B001', 'P001');

INSERT INTO baggage (bagid, bid, weight, type)
VALUES
('BG001', 'B001', 18, 'CHECKIN');

INSERT INTO loyaltymember (lid, pid, tier, points)
VALUES
('L001', 'P001', 'GOLD', 12000);

INSERT INTO addonservice (idaddonservice, aname, price)
VALUES
('A001', 'Extra Baggage', 1200.00),
('A002', 'Priority Boarding', 800.00);

INSERT INTO bookingaddon (idbookingaddon, bid, aid)
VALUES
('BA001', 'B001', 'A001');

INSERT INTO ticket (ticketid, bid, issue_date, seatid)
VALUES
('T000001', 'BA001', '2025-12-01', 'AL001');
