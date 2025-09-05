create database AirData;
use AirData;
CREATE TABLE indian_Airdata (
    Station_id VARCHAR(10),
    `From Date` DATE,
    `To Date` DATE,
    `PM2.5 (ug/m3)` FLOAT,
    `PM10 (ug/m3)` FLOAT,
    `NO (ug/m3)` FLOAT,
    `NO2 (ug/m3)` FLOAT,
    `NOx (ppb)` FLOAT,
    `NH3 (ug/m3)` FLOAT,
    `SO2 (ug/m3)` FLOAT,
    `CO (mg/m3)` FLOAT,
    `Ozone (ug/m3)` FLOAT,
    `Benzene (ug/m3)` FLOAT,
    `Toluene (ug/m3)` FLOAT,
    `Temp (degree C)` FLOAT,
    `RH (%)` FLOAT,
    `WS (m/s)` FLOAT,
    `WD (deg)` FLOAT,
    `SR (W/mt2)` FLOAT,
    `RF (mm)` FLOAT,
    `AT (degree C)` FLOAT,
    `AQI` INT,
    `AQI_Category` VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Air Quality DataSets/combined_Clean_Data.csv'
INTO TABLE indian_Airdata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  `Station_id`, `From Date`, `To Date`,
  @pm25, @pm10, @no, @no2, @nox, @nh3, @so2, @co, @ozone,
  @benzene, @toluene, @temp, @rh, @ws, @wd, @sr, @rf, @at, @AQI, @AQI_Category
)
SET
  `PM2.5 (ug/m3)` = NULLIF(@pm25, ''),
  `PM10 (ug/m3)` = NULLIF(@pm10, ''),
  `NO (ug/m3)` = NULLIF(@no, ''),
  `NO2 (ug/m3)` = NULLIF(@no2, ''),
  `NOx (ppb)` = NULLIF(@nox, ''),
  `NH3 (ug/m3)` = NULLIF(@nh3, ''),
  `SO2 (ug/m3)` = NULLIF(@so2, ''),
  `CO (mg/m3)` = NULLIF(@co, ''),
  `Ozone (ug/m3)` = NULLIF(@ozone, ''),
  `Benzene (ug/m3)` = NULLIF(@benzene, ''),
  `Toluene (ug/m3)` = NULLIF(@toluene, ''),
  `Temp (degree C)` = NULLIF(@temp, ''),
  `RH (%)` = NULLIF(@rh, ''),
  `WS (m/s)` = NULLIF(@ws, ''),
  `WD (deg)` = NULLIF(@wd, ''),
  `SR (W/mt2)` = NULLIF(@sr, ''),
  `RF (mm)` = NULLIF(@rf, ''),
  `AT (degree C)` = NULLIF(@at, ''),
  `AQI` = NULLIF(@AQI, ''),
  `AQI_Category` = NULLIF(@AQI_Category, '');
  
select *  from indian_Airdata limit 5;
select City from indian_Airdata where City is null;
alter table indian_Airdata  add column City varchar(25);

set sql_safe_updates = 0;
UPDATE indian_Airdata
SET City = CASE
    WHEN station_id = 'AS001' THEN 'Guwahati'
    WHEN station_id = 'BR001' THEN 'Patna'
    WHEN station_id = 'CG001' THEN 'Bilaspur'
    WHEN station_id = 'CH002' THEN 'Chandigarh'
    WHEN station_id = 'DL006' THEN 'Delhi'
    WHEN station_id = 'HP001' THEN 'Baddi'
    WHEN station_id = 'GJ001' THEN 'Ahmedabad'
    WHEN station_id = 'JK001' THEN 'Srinagar'
    WHEN station_id = 'KA001' THEN 'Bengaluru'
    WHEN station_id = 'KL007' THEN 'Kollam'
    WHEN station_id = 'MH002' THEN 'Mumbai'
    WHEN station_id = 'MP005' THEN 'Mandideep'
    WHEN station_id = 'PB001' THEN 'Amritsar'
    WHEN station_id = 'RJ002' THEN 'Jaipur'
    WHEN station_id = 'TN003' THEN 'Chennai'
    WHEN station_id = 'UK001' THEN 'Dehradun'
    WHEN station_id = 'UP002' THEN 'Lucknow'
    WHEN station_id = 'UP007' THEN 'Noida'
    WHEN station_id = 'WB002' THEN 'Kolkata'
    ELSE City
END
WHERE station_id IN (
    'AS001', 'BR001', 'CG001', 'CH002', 'DL006', 'HP001',
    'GJ001', 'JK001', 'KA001', 'KL007', 'MH002', 'MP005',
    'PB001', 'RJ002', 'TN003', 'UK001', 'UP002', 'UP007', 'WB002'
);
show columns from indian_airdata;

select * from indian_airdata limit 5;

alter table indian_airdata
add column Country varchar(10);

update indian_airdata 
set Country = 'India';

-- just showing the serial number in result not add permanently in table
select row_number() over (order by station_id) as SerialNo, 
indian_airdata.* 
from indian_airdata;

-- for permanently adding a SerialNo column in table 
alter table indian_airdata
add column SerialNo bigint first;

set @row_num = 0;
update indian_airdata
set SerialNo = (@row_num := @row_num +1)
order by station_id;
alter table indian_airdata drop column `AT (degree C)`;

select * from indian_airdata
INTO outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Air Quality DataSets/Clean_Indian_AirData.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '\n';

