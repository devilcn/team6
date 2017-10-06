#rentaride-schema.sql


##REMOVAL AND DEFINITION OF TABLES MATTERS
###DEPENDING ON FOREIGN KEYS

#remove the existing tables

DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS rentalLocation;
DROP TABLE IF EXISTS vehicleType;
DROP TABLE IF EXISTS hourlyPrice;
DROP TABLE IF EXISTS administrator;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS person;

#Table definition for 'person'

CREATE TABLE person (
        id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        firstName       VARCHAR(255) NOT NULL,
        lastName        VARCHAR(255) NOT NULL,
        userName        VARCHAR(255) NOT NULL UNIQUE,
        password        VARCHAR(255) NOT NULL,
        email           VARCHAR(255) NOT NULL,
        address         VARCHAR(255),
        createdOn       DATETIME,
        status          VARCHAR(225)
)ENGINE= InnoDB;

#Table definition for 'customer'

CREATE TABLE customer (
        memberUntilDate                 DATETIME,
        licenseState                    VARCHAR(255) NOT NULL,
        licenseNumber                   VARCHAR(255) NOT NULL,
        creditCardNumber                VARCHAR(255) NOT NULL,
        creditCardExpiration    	DATETIME,
        id                              INT UNSIGNED NOT NULL,

        FOREIGN KEY (id) REFERENCES person(id)
)ENGINE= InnoDB;

#Table definition for 'administrator'

CREATE TABLE administrator (
        adminRights     BIT NOT NULL,
        id              INT UNSIGNED NOT NULL,

        FOREIGN KEY (id) REFERENCES person(id)
)ENGINE= InnoDB;

#Table definition for 'hourlyPrice'

CREATE TABLE hourlyPrice (
       maxHours        INT,
        price           INT PRIMARY KEY
)ENGINE= InnoDB;

#Table definition for 'vehicleType'

CREATE TABLE vehicleType (
        name            VARCHAR(255) PRIMARY KEY,
        numSeats        INT,
        hourPrice1      INT,
	hourPrice2	INT,

        FOREIGN KEY (hourPrice1) REFERENCES hourlyPrice(price),
	FOREIGN KEY (hourPrice2) REFERENCES hourlyPrice(price)
)ENGINE= InnoDB;

#Table definition for rentalLocation

CREATE TABLE rentalLocation (
        name                    VARCHAR(225) PRIMARY KEY,
        address                 VARCHAR(225) NOT NULL,
        maxCapacity             INT
)ENGINE= InnoDB;

#Table definition for 'vehicle'

CREATE TABLE vehicle (
        tagNum                          VARCHAR(255) PRIMARY KEY,
        make                            VARCHAR(255) NOT NULL,
        model                           VARCHAR(255) NOT NULL,
        vehicleYear                     VARCHAR(255),
        vehicleCondition                VARCHAR(255),
        lastServicedDate                DATETIME,
        currentMileage                  INT,
        status                          BIT NOT NULL,
        vType                           VARCHAR(255),
        rentalLocation                  VARCHAR(255),

        FOREIGN KEY (vType) REFERENCES vehicleType(name),
        FOREIGN KEY (rentalLocation) REFERENCES rentalLocation(name)
)ENGINE= InnoDB;

#Table definition for 'reservation'

CREATE TABLE reservation (
        pickUp                  DATETIME,
        length                  INT,
        resNum                  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        rentalLocation  	VARCHAR(255) NOT NULL,
        vType                   VARCHAR(255) NOT NULL,
        custId                  INT UNSIGNED,

        FOREIGN KEY (rentalLocation) REFERENCES rentalLocation(name),
        FOREIGN KEY (vType) REFERENCES vehicleType(name),
        FOREIGN KEY (custId) REFERENCES customer(id)
)ENGINE= InnoDB;

#Table definition for 'rental'

CREATE TABLE rental (
        pickUpDate                      DATETIME,
        returnDate                      DATETIME,
        charges                         FLOAT,
        timeExceeded            	TIME,
        vehicleCondition        	VARCHAR(255),
        rentalNum                       INT UNSIGNED,
        vehicle                         VARCHAR(255),
        custId                          INT UNSIGNED,

        FOREIGN KEY (rentalNum) REFERENCES reservation(resNum),
        FOREIGN KEY (vehicle) REFERENCES vehicle(tagNum),
        FOREIGN KEY (custId) REFERENCES customer(id)
)ENGINE= InnoDB;

#Table definition for 'comment'

CREATE TABLE comment (
        text            VARCHAR(225),
        commentDate     DATETIME,
        custId          INT UNSIGNED,
        rentalNum       INT UNSIGNED,


        FOREIGN KEY (custId) REFERENCES customer(id),
        FOREIGN KEY (rentalNum) REFERENCES rental(rentalNum)
)ENGINE= InnoDB;
