#DROP SCHEMA IF ALREADY EXISTS
DROP SCHEMA IF EXISTS HOTEL_ANALYSIS; 

#CREATE NEW SCHEMA 
CREATE SCHEMA HOTEL_ANALYSIS;

#Select Schema to use 
USE HOTEL_ANALYSIS;

#DROP IF ALREADY EXISTS
DROP TABLE IF EXISTS HOTEL_2018;

#CREATE TABLE 2018
CREATE TABLE HOTEL_2018(
hotel VARCHAR(50),
is_canceled	INT,
lead_time	INT,
arrival_date_year INT,
arrival_date_month VARCHAR(50),
arrival_date_week_number INT,
arrival_date_day_of_month INT,
stays_in_weekend_nights INT,
stays_in_week_nights INT,
adults INT,
children INT,
babies INT,
meal VARCHAR(10),
country	VARCHAR(20),
market_segment VARCHAR(100),
distribution_channel VARCHAR(10),	
is_repeated_guest INT,
previous_cancellations INT,
previous_bookings_not_canceled INT,
reserved_room_type VARCHAR(10),
assigned_room_type VARCHAR(10),
booking_changes	INT,
deposit_type VARCHAR(100),
agent INT,
company	INT,
days_in_waiting_list INT,
customer_type VARCHAR(100),
adr	DOUBLE,
required_car_parking_spaces	INT,
total_of_special_requests INT,
reservation_status VARCHAR(100),
reservation_status_date DATE #make sure to use yyyy-mm-dd format. MySQL uses long date format
);

#DROP TABLE IF ALREADY EXISTS
DROP TABLE IF EXISTS HOTEL_2019;

#CRAETE TABLE 2019
CREATE TABLE HOTEL_2019(
hotel VARCHAR(50),
is_canceled	INT,
lead_time	INT,
arrival_date_year INT,
arrival_date_month VARCHAR(50),
arrival_date_week_number INT,
arrival_date_day_of_month INT,
stays_in_weekend_nights INT,
stays_in_week_nights INT,
adults INT,
children INT,
babies INT,
meal VARCHAR(10),
country	VARCHAR(20),
market_segment VARCHAR(100),
distribution_channel VARCHAR(10),	
is_repeated_guest INT,
previous_cancellations INT,
previous_bookings_not_canceled INT,
reserved_room_type VARCHAR(10),
assigned_room_type VARCHAR(10),
booking_changes	INT,
deposit_type VARCHAR(100),
agent INT,
company	INT,
days_in_waiting_list INT,
customer_type VARCHAR(100),
adr	DOUBLE,
required_car_parking_spaces	INT,
total_of_special_requests INT,
reservation_status VARCHAR(100),
reservation_status_date DATE #make sure to use yyyy-mm-dd format. MySQL uses long date format
);

#DROP TABLE IF ALREADY EXISTS
DROP TABLE IF EXISTS HOTEL_2020;

#CREATE TABLE 2020 
CREATE TABLE HOTEL_2020(
hotel VARCHAR(50),
is_canceled	INT,
lead_time	INT,
arrival_date_year INT,
arrival_date_month VARCHAR(50),
arrival_date_week_number INT,
arrival_date_day_of_month INT,
stays_in_weekend_nights INT,
stays_in_week_nights INT,
adults INT,
children INT,
babies INT,
meal VARCHAR(10),
country	VARCHAR(20),
market_segment VARCHAR(100),
distribution_channel VARCHAR(10),	
is_repeated_guest INT,
previous_cancellations INT,
previous_bookings_not_canceled INT,
reserved_room_type VARCHAR(10),
assigned_room_type VARCHAR(10),
booking_changes	INT,
deposit_type VARCHAR(100),
agent INT,
company	INT,
days_in_waiting_list INT,
customer_type VARCHAR(100),
adr	DOUBLE,
required_car_parking_spaces	INT,
total_of_special_requests INT,
reservation_status VARCHAR(100),
reservation_status_date DATE #make sure to use yyyy-mm-dd format. MySQL uses long date format
);

#DROP TABLE IF ALREADY EXISTS
DROP TABLE IF EXISTS MEAL_COSTS;

#CREATE TABLE MEAL_COST
CREATE TABLE MEAL_COST(
cost DOUBLE,
meal varchar(50)
);

#DROP TABLE IF ALREADY EXISTS
DROP TABLE IF EXISTS MARKET_SEGMENT;

#CREATE TABLE MARKET_SEGMENT
CREATE TABLE MARKET_SEGMENT(
discount DOUBLE,
market_segment VARCHAR(100)
);

#DO NOT EXECUTE FOLLOWING COMMANDS UNLESS YOU IMPORT THE DATA USING IMPORT WIZARD.
#IF YOU DO NOT KNOW HOW TO USE IMPORT WIZARD ON MYSQL, PLEASE FOLLOW BELOW STEPS
#Data import wizard steps:
# 1.	Expand Schema, Expand Tables
# 2.	Right Click on the table in which data will be imported
# 3.	Select Table Data Import Wizard
# 4.	Browse for the CSV file to import
# 5.	Select apppriate destination columns and complete import

#Let's confirm data is imported correctly

SELECT * FROM HOTEL_2018
LIMIT 10;

SELECT * FROM HOTEL_2019
LIMIT 10;

SELECT * FROM HOTEL_2020
LIMIT 10;

SELECT * FROM MARKET_SEGMENT;
SELECT * FROM MEAL_COST;

#Business Analysis 
#The total number of nights spent (check-out) 
#Canceled reservations 
#The average occupancy 
#Length of stay 
#Lead time: period of time between the reservation made and the actual arrival/check-in date 
#Revenue per year

#The total number of nights spent
SELECT arrival_date_year AS Year,
		hotel AS Property, 
        SUM(stays_in_weekend_nights + stays_in_week_nights) AS 'Guests Stayed at Property'
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year, hotel
UNION ALL
SELECT arrival_date_year AS Year,
		hotel AS Property, 
        SUM(stays_in_weekend_nights + stays_in_week_nights) AS 'Guests Stayed at Property'
FROM HOTEL_2019
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year, hotel
UNION ALL 
SELECT arrival_date_year AS Year,
		hotel AS Property, 
        SUM(stays_in_weekend_nights + stays_in_week_nights) AS 'Guests Stayed at Property'
FROM HOTEL_2020
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year, hotel
ORDER BY Year;

#How much revenue generated per year
#adr = avg daily rate 
SELECT Property,
		`Year`,
        `Total Revenue`
FROM
(
SELECT h18.hotel AS Property,
		h18.arrival_date_year AS `Year`,
        CONCAT('$', FORMAT(SUM((((h18.stays_in_weekend_nights+h18.stays_in_week_nights)*h18.adr)+mc.cost)*(1-ms.discount)),2)) AS `Total Revenue`
FROM HOTEL_2018 h18
LEFT JOIN MEAL_COST mc
ON mc.meal=h18.meal
LEFT JOIN MARKET_SEGMENT ms
ON ms.market_segment=h18.market_segment
WHERE h18.reservation_status = 'Check-Out'
GROUP BY Property, `Year`
UNION ALL
SELECT h19.hotel AS Property,
		h19.arrival_date_year AS `Year`,
        CONCAT('$', FORMAT(SUM((((h19.stays_in_weekend_nights+h19.stays_in_week_nights)*h19.adr)+mc1.cost)*(1-ms1.discount)),2)) AS `Total Revenue`
FROM HOTEL_2019 h19
LEFT JOIN MEAL_COST mc1
ON mc1.meal=h19.meal
LEFT JOIN MARKET_SEGMENT ms1
ON ms1.market_segment=h19.market_segment
WHERE h19.reservation_status = 'Check-Out'
GROUP BY Property, `Year`
UNION ALL
SELECT h20.hotel AS Property,
		h20.arrival_date_year AS `Year`,
        CONCAT('$', FORMAT(SUM((((h20.stays_in_weekend_nights+h20.stays_in_week_nights)*h20.adr)+mc2.cost)*(1-ms2.discount)),2)) AS `Total Revenue`
FROM HOTEL_2020 h20
LEFT JOIN MEAL_COST mc2
ON mc2.meal=h20.meal
LEFT JOIN MARKET_SEGMENT ms2
ON ms2.market_segment=h20.market_segment
WHERE h20.reservation_status = 'Check-Out'
GROUP BY Property, `Year`
) AS TRY
GROUP BY Property, `Year`, `Total Revenue`
ORDER BY `Total Revenue` DESC;


#The average occupancy
SELECT arrival_date_year AS Year,
       ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights)) AS 'Average Occupancy'
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year
UNION ALL
SELECT arrival_date_year AS Year,
       ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights)) AS 'Average Occupancy'
FROM HOTEL_2019
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year
UNION ALL 
SELECT arrival_date_year AS Year,
       ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights)) AS 'Average Occupancy'
FROM HOTEL_2020
WHERE reservation_status = 'Check-Out'
GROUP BY arrival_date_year;

#Year on Year Occupancy by Property 
SELECT Year, 
       Property,
       Month,
       SUM(`Number of Days Guest Stayed`) AS `Total Occupancy`
FROM (
    SELECT arrival_date_year as Year, 
           hotel as Property,
           arrival_date_month AS Month,
           SUM(stays_in_weekend_nights+stays_in_week_nights) AS `Number of Days Guest Stayed`
    FROM HOTEL_2018
    WHERE reservation_status = 'Check-Out'
    GROUP BY arrival_date_year, hotel, arrival_date_month
    UNION ALL
    SELECT arrival_date_year as Year, 
           hotel as Property,
           arrival_date_month AS Month,
           SUM(stays_in_weekend_nights+stays_in_week_nights) AS `Number of Days Guest Stayed`
    FROM HOTEL_2019
    WHERE reservation_status = 'Check-Out'
    GROUP BY arrival_date_year, hotel, arrival_date_month
    UNION ALL
    SELECT arrival_date_year as Year, 
           hotel as Property,
           arrival_date_month AS Month,
           SUM(stays_in_weekend_nights+stays_in_week_nights) AS `Number of Days Guest Stayed`
    FROM HOTEL_2020
    WHERE reservation_status = 'Check-Out'
    GROUP BY arrival_date_year, hotel, arrival_date_month
) AS subquery
GROUP BY Year, Property, Month;

#Max Lead Time
SELECT Year, 
		Property,
        `Checked in Month` AS 'Check in Month',
        MAX(`Lead Time`) AS 'Advanced Booking in Days'
FROM (
    SELECT arrival_date_year AS Year,
           hotel AS Property,
           arrival_date_month AS `Checked in Month`,
           MAX(lead_time) AS `Lead Time`
    FROM HOTEL_2018
    WHERE reservation_status = 'Check-Out'
    GROUP BY  arrival_date_year, hotel, arrival_date_month
    UNION ALL
    SELECT arrival_date_year AS Year,
           hotel AS Property,
           arrival_date_month AS `Checked in Month`,
           MAX(lead_time) AS `Lead Time`
    FROM HOTEL_2019
    WHERE reservation_status = 'Check-Out'
    GROUP BY  arrival_date_year, hotel, arrival_date_month
    UNION ALL
    SELECT arrival_date_year AS Year,
           hotel AS Property,
           arrival_date_month AS `Checked in Month`,
           MAX(lead_time) AS `Lead Time`
    FROM HOTEL_2020
    WHERE reservation_status = 'Check-Out'
    GROUP BY  arrival_date_year, hotel, arrival_date_month
) AS lead_times
GROUP BY Year, Property, `Checked in Month`
ORDER BY 'Advanced Booking in Days' DESC;


#How many cancel reservations by year

SELECT Year,
		Property,
        `Reservation Status`,
        `Canceled Reservations`
FROM(
SELECT arrival_date_year as Year,
hotel AS Property,
reservation_status as `Reservation Status`,
COUNT(*) AS `Canceled Reservations`
FROM HOTEL_2018 
WHERE reservation_status = 'canceled'
GROUP BY arrival_date_year, hotel, reservation_status
UNION ALL
SELECT arrival_date_year as Year,
hotel AS Property,
reservation_status as `Reservation Status`,
COUNT(*) AS `Canceled Reservations`
FROM HOTEL_2019
WHERE reservation_status = 'canceled'
GROUP BY arrival_date_year, hotel, reservation_status
UNION ALL
SELECT arrival_date_year as Year,
hotel AS Property,
reservation_status as `Reservation Status`,
COUNT(*) AS `Canceled Reservations`
FROM HOTEL_2020
WHERE reservation_status = 'canceled'
GROUP BY arrival_date_year, hotel, reservation_status
) AS canc
GROUP BY Year,
		Property,
        `Reservation Status`,
        `Canceled Reservations`
ORDER BY `Canceled Reservations` DESC;


#Which country customers have most bookings

SELECT 
		`Citizen of`,
        SUM(`Count of Bookings`) AS `Bookings`
FROM(

SELECT 
		country AS `Citizen of`,
        COUNT(*) AS `Count of Bookings`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out' AND country IS NOT NULL
GROUP BY hotel, country
UNION ALL
SELECT 
		country AS `Citizen of`,
        COUNT(*) AS `Count of Bookings`
FROM HOTEL_2019
WHERE reservation_status = 'Check-Out' AND country IS NOT NULL
GROUP BY hotel, country
UNION ALL
SELECT 
		country AS `Citizen of`,
        COUNT(*) AS `Count of Bookings`
FROM HOTEL_2020
WHERE reservation_status = 'Check-Out' AND country IS NOT NULL
GROUP BY hotel, country
) AS tot
GROUP BY 
		`Citizen of`
ORDER BY `Bookings` DESC;
        
#Special Requests from Suits
SELECT `Guests' Suite`,
		SUM(`Requests Count`) AS `Total Special Requests`
FROM 
(
SELECT assigned_room_type AS `Guests' Suite`,
        COUNT(total_of_special_requests) AS `Requests Count`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY assigned_room_type
UNION ALL
SELECT assigned_room_type AS `Guests' Suite`,
        COUNT(total_of_special_requests) AS `Requests Count`
FROM HOTEL_2019
WHERE reservation_status = 'Check-Out'
GROUP BY assigned_room_type
UNION ALL 
SELECT assigned_room_type AS `Guests' Suite`,
        COUNT(total_of_special_requests) AS `Requests Count`
FROM HOTEL_2020
WHERE reservation_status = 'Check-Out'
GROUP BY assigned_room_type
) AS Spc
GROUP BY `Guests' Suite`
ORDER BY `Total Special Requests` DESC;

#How many booking changes 
SELECT `Country` AS `Customer's Country`,
		`Suit` AS `Assigned Suite`,
		SUM(`Changes`) AS `Change Requests`
FROM
(
SELECT country AS `Country`,
		assigned_room_type AS `Suit`,
		COUNT(booking_changes) AS `Changes`
FROM HOTEL_2018
GROUP BY country, assigned_room_type
UNION ALL 
SELECT country AS `Country`,
		assigned_room_type AS `Suit`,
		COUNT(booking_changes) AS `Changes`
FROM HOTEL_2019
GROUP BY country, assigned_room_type
UNION ALL 
SELECT country AS `Country`,
		assigned_room_type AS `Suit`,
		COUNT(booking_changes) AS `Changes`
FROM HOTEL_2020
GROUP BY country, assigned_room_type
) AS Chng
GROUP BY `Customer's Country`, `Assigned Suite`
ORDER BY `Change Requests` DESC;

#Count of Bookings by Market Segment
SELECT `Segments`,
		`Number of Bookings`,
        `Property`
FROM(
SELECT distribution_channel AS `Segments`,
		COUNT(*) AS `Number of Bookings`,
        hotel AS `Property`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY hotel, distribution_channel
UNION ALL
SELECT distribution_channel AS `Segments`,
		COUNT(*) AS `Number of Bookings`,
        hotel AS `Property`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY hotel, distribution_channel
UNION ALL 
SELECT distribution_channel AS `Segments`,
		COUNT(*) AS `Number of Bookings`,
        hotel AS `Property`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY hotel, distribution_channel
) AS Mkt
GROUP BY `Segments`,
		`Number of Bookings`,
        `Property`
ORDER BY `Number of Bookings` DESC;


#Which Market_segment has highest lead_time
SELECT `Segment`,
		SUM(`Lead Time`) AS `Total Lead Time`
FROM
(
SELECT market_segment AS `Segment`,
		SUM(lead_time) AS `Lead Time`
FROM HOTEL_2018
WHERE reservation_status = 'Check-Out'
GROUP BY market_segment
UNION ALL
SELECT market_segment AS `Segment`,
		SUM(lead_time) AS `Lead Time`
FROM HOTEL_2019
WHERE reservation_status = 'Check-Out'
GROUP BY market_segment
UNION ALL 
SELECT market_segment AS `Segment`,
		SUM(lead_time) AS `Lead Time`
FROM HOTEL_2020
WHERE reservation_status = 'Check-Out'
GROUP BY market_segment
) AS Mkttime
GROUP BY `Segment`
ORDER BY `Total Lead Time` DESC;
