# rentaride-populate.sql, which for now will
# populate our schema with sample instances

#
# insert some rows into the person table
#
INSERT INTO person (firstName, lastName, userName, password, email, address, createdOn, status)
VALUES ('Buffy', 'Summers', 'vampireslayer@mbox.com', 'teamspike', 'vampireslayer@mbox.com', '1630 Revello Dr., Sunnydale, CA. 87888', 'ACTIVE' ) \g
INSERT INTO person (firstName, lastName, userName, password, email, address, createdOn, status)
VALUES ('Marty', 'McFly', 'chicken@mbox.com', 'fluxcapacitor', 'chicken@mbox.com', '9303 Lyon Drive., Hill Valley, CA. 77888', 'ACTIVE' ) \g
INSERT INTO person (firstName, lastName, userName, password, email, address, createdOn, status)
VALUES ('Mal', 'Reynolds', 'browncoat@mbox.com', 'canttakethesky', 'browncoat@mbox.com', '42 Serenity Way., Firefly, MN. 23934', 'ACTIVE' ) \g
INSERT INTO person (firstName, lastName, userName, password, email, address, createdOn, status)
VALUES ('Leia', 'Organa', 'princessbunhead@mbox.com', 'itsgeneralnow', 'princessbunhead@mbox.com', '12 Kessel Run , Alderaan, GA. 77888', 'ACTIVE' ) \g

#
# add some administrators
#
insert into administrator (adminRights, id)
select
        b'1' as adminRights,
        (select id from person where userName = 'vampireslayer@mbox.com') as id;

insert into administrator (adminRights, id)
select
        b'1' as adminRights,
        (select id from person where userName = 'chicken@mbox.com') as id;



#
# add some customers
#
insert into customer (memberUntilDate, licenseState, licenseNumber, creditCardNumber, creditCardExpiration, id)
select
        '2018-09-28 08:59:02' as memberUntilDate,
        'MN' as licenseState,
        'GONE2SOON' as licenseNumber,
        '1230981098023058' as creditCardNumber,
        '2020-04-23 12:00:02' as creditCardExpiration,
        (select id from person where userName = 'browncoat@mbox.com') as id;

insert into customer (memberUntilDate, licenseState, licenseNumber, creditCardNumber, creditCardExpiration, id)
select
        '2019-01-13 11:48:02' as memberUntilDate,
        'GA' as licenseState,
        'NERFH3RDER' as licenseNumber,
        '2393381098010051' as creditCardNumber,
        '2022-12-15 6:00:02' as creditCardExpiration,
        (select id from person where userName = 'princessbunhead@mbox.com') as id;



#
# insert some rows into the rentalLocation table
#
INSERT INTO rentalLocation (name, address, maxCapacity)
VALUES ('East Side', '323 Barnett Rd., Albany, NY. 88888', 20) \g
INSERT INTO rentalLocation (name, address, maxCapacity)
VALUES ('Normaltown', '41 Prince St., Ithaca, NY. 55555', 40) \g



#
# insert some rows into the hourlyPrice table
#
INSERT INTO hourlyPrice (maxHours, price)
VALUES (24, 15) \g
INSERT INTO hourlyPrice (maxHours, price)
VALUES (48, 10) \g
INSERT INTO hourlyPrice (maxHours, price)
VALUES (24, 18) \g
INSERT INTO hourlyPrice (maxHours, price)
VALUES (48, 12) \g


#
# insert some rows into the vehicleType table
#
insert into vehicleType (name, numSeats, hourPrice1, hourPrice2)
select 
       'Truck' as name,
       4 as numSeats,
       (select price from hourlyPrice where price = 15) as hourPrice1,
       (select price from hourlyPrice where price = 10) as hourPrice2;

insert into vehicleType (name, numSeats, hourPrice1, hourPrice2)
select
        'Sedan' as name,
        5 as numSeats,
        (select price from hourlyPrice where price = 18) as hourPrice1,
        (select price from hourlyPrice where price = 12) as hourPrice2;



#
# insert some rows into the vehicle table
#
insert into vehicle (tagNum, make, model, vehicleYear, vehicleCondition, lastServicedDate, currentMileage, status, vType, rentalLocation)
select
        'FJ87FG' as tagNum,
        'Toyota' as make,
        'Tacoma' as model,
        '1997' as vehicleYear,
        'good' as vehicleCondition,
        '2016-10-10 9:00:00' as  lastServicedDate,
        156000 as currentMileage,
        b'0' as status,
        (select name from vehicleType where name = 'Truck') as vType,
        (select name from rentalLocation where name = 'Normaltown') as rentalLocation;

insert into vehicle (tagNum, make, model, vehicleYear, vehicleCondition, lastServicedDate, currentMileage, status, vType, rentalLocation)
select
        'DKJ38J' as tagNum,
        'Ford' as make,
        'F-150' as model,
        '2011' as vehicleYear,
        'minor scratches' as vehicleCondition,
        '2015-3-10 12:00:00' as  lastServicedDate,
        52000 as currentMileage,
        b'1' as status, 
        (select name from vehicleType where name = 'Truck') as vType,
        (select name from rentalLocation where name = 'East Side') as rentalLocation;

insert into vehicle (tagNum, make, model, vehicleYear, vehicleCondition, lastServicedDate, currentMileage, status, vType, rentalLocation)
select
        'AB39FJ' as tagNum,
        'Honda' as make,
        'Accord' as model,
        '2004' as vehicleYear,
        'dented bumper' as vehicleCondition,
        '2017-1-11 11:00:00' as  lastServicedDate,
        131000 as currentMileage,
        b'0' as status, 
        (select name from vehicleType where name = 'Sedan') as vType,
        (select name from rentalLocation where name = 'East Side') as rentalLocation;

insert into vehicle (tagNum, make, model, vehicleYear, vehicleCondition, lastServicedDate, currentMileage, status, vType, rentalLocation)
select
        'ZZ39JF' as tagNum,
        'Tesla' as make,
        'Model S' as model,
        '2016' as vehicleYear,
        'flawless' as vehicleCondition,
        '2016-5-25 10:00:00' as  lastServicedDate,
        14000 as currentMileage,
        b'0' as status, 
        (select name from vehicleType where name = 'Sedan') as vType,
        (select name from rentalLocation where name = 'Normaltown') as rentalLocation;



#
# sample reservations
#
# reservation by Leia for F-150 (has rental as well)
insert into reservation (pickUp, length, resNum, rentalLocation, vType, custId)
select
        '2017-10-25 10:00:00' as pickUp,
        4 as length,
        (select name from rentalLocation where name = 'East Side') as rentalLocation,
        (select name from vehicleType where name = 'Truck') as vType,
        (select id from customer where firstName = 'Leia') as custId;

# reservation by Leia for Model S
insert into reservation (pickUp, length, resNum, rentalLocation, vType, custId)
select
        '2017-12-15 19:00:00' as pickUp,
        3 as length,
        (select name from rentalLocation where name = 'Normaltown') as rentalLocation,
        (select name from vehicleType where name = 'Sedan') as vType,
        (select id from customer where firstName = 'Leia') as custId;

# reservation by Mal for Accord (has rental as well)
insert into reservation (pickUp, length, resNum, rentalLocation, vType, custId)
select
        '2018-3-25 8:00:00' as pickUp,
        12 as length,
        (select name from rentalLocation where name = 'East Side') as rentalLocation,
        (select name from vehicleType where name = 'Sedan') as vType,
        (select id from customer where firstName = 'Mal') as custId;

# reservation by Mal for Tacoma
insert into reservation (pickUp, length, resNum, rentalLocation, vType, custId)
select
        '2018-1-14 14:00:00' as pickUp,
        8 as length,
        (select name from rentalLocation where name = 'Normaltown') as rentalLocation,
        (select name from vehicleType where name = 'Truck') as vType,
        (select id from customer where firstName = 'Mal') as custId;



#
# sample rentals
#
# rental by Leia of F-150
insert into rental (pickUpDate, returnDate, charges, timeExceeded, vehicleCondition, rentalNum, vehicle, custId)
select
        '2017-10-25 10:00:00' as pickUpDate,
        '2017-10-25 14:00:00' as returnDate,
        30.00 as charges,
        00:00:00 as timeExceeded,
        'not a scratch' as vehicleCondition,
        (select resNum from reservation where pickUp = '2017-10-25 10:00:00') as rentalNum,
        (select tagNum from vehicle where tagNum = 'DKJ38J') as vehicle,
        (select id from customer where firstName = 'Leia') as custId;

# rental by Mal of Accord
insert into rental (pickUpDate, returnDate, charges, timeExceeded, vehicleCondition, rentalNum, vehicle, custId)
select
        '2018-3-25 8:00:00' as pickUpDate,
        '2018-3-26 1:00:00' as returnDate,
        130.00 as charges,
        05:00:00 as timeExceeded,
        'still driving' as vehicleCondition,
        (select resNum from reservation where pickUp = ''2018-3-25 8:00:00'') as rentalNum,
        (select tagNum from vehicle where tagNum = 'AB39FJ') as vehicle,
        (select id from customer where firstName = 'Mal') as custId;



#
# sample comments
#
insert into comment (text, commentDate, custId, rentalNum)
select
        'scruffy looking interior' as text,
        '2017-10-25 14:00:00' as commentDate,
        (select id from customer where firstName = 'Leia') as custId,
        (select rentalNum from rental where pickUpDate = '2017-10-25 10:00:00') as rentalNum;

insert into comment (text, commentDate, custId, rentalNum)
select
        'Handled like a leaf on the wind!' as text,
        '2018-3-26 1:00:00' as commentDate,
        (select id from customer where firstName = 'Mal') as custId,
        (select rentalNum from rental where pickUpDate = '2018-3-26 1:00:00') as rentalNum;
