SET search_path TO uber, public;
DROP VIEW IF EXISTS otherdrivers, trained, traineddates, trainedearlydates,
trainedlatedates, trainedearlyaverages, trainedlateaverages, nottrained,
nottraineddates, nottrainedearlydates, nottrainedlatedates, 
nottrainedearlyaverages, nottrainedlateaverages cascade;

CREATE VIEW otherdrivers AS
SELECT Driver.driver_id as driver_id
FROM Driver, Request, Dispatch, Pickup, Dropoff
WHERE Driver.driver_id = Dispatch.driver_id AND
	Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id
GROUP BY Driver.driver_id
HAVING count(distinct(Dispatch.datetime::timestamp::date)) >= 10;

CREATE VIEW trained AS
SELECT Driver.driver_id as driver_id
FROM Driver, Request, Dispatch, Pickup, Dropoff
WHERE Driver.driver_id = Dispatch.driver_id AND
	Driver.trained = 't' AND
	Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id
GROUP BY Driver.driver_id
HAVING count(distinct(Dispatch.datetime::timestamp::date)) >= 10;

CREATE VIEW traineddates AS
SELECT driver.driver_id as driver_id, request.datetime, request.request_id as
 request_id, row_number() over (partition by driver.driver_id 
order by request.datetime ASC) as row
FROM trained, Driver, Request, Dispatch, Pickup, Dropoff
WHERE Driver.driver_id = trained.driver_id AND
        trained.driver_id = Dispatch.driver_id AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id
GROUP BY driver.driver_id, request.datetime, request.request_id;

CREATE VIEW trainedearlydates AS
SELECT *
FROM traineddates
WHERE row <= 5;

CREATE VIEW trainedlatedates AS
SELECT *
FROM traineddates
WHERE row > 5;

CREATE VIEW trainedearlyaverages AS
SELECT driver.driver_id as driver_id, avg(driverrating.rating) as earlyaverage 
FROM Driverrating, trainedearlydates, Request, Dispatch, Pickup, Dropoff, Driver
WHERE trainedearlydates.driver_id = Driver.driver_id AND 
	driver.driver_id = Dispatch.driver_id AND
	trainedearlydates.request_id = Request.request_id AND
	Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id AND
	Driverrating.request_id = Dropoff.request_id
GROUP BY driver.driver_id; 

CREATE VIEW trainedlateaverages AS
SELECT driver.driver_id as driver_id, avg(driverrating.rating) as lateaverage
FROM Driverrating, trainedlatedates, Request, Dispatch, Pickup, Dropoff, Driver
WHERE trainedlatedates.driver_id = Driver.driver_id AND
	driver.driver_id = Dispatch.driver_id AND
        trainedlatedates.request_id = Request.request_id AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id AND
        Driverrating.request_id = Dropoff.request_id
GROUP BY driver.driver_id;

CREATE VIEW nottrained AS
SELECT Driver.driver_id as driver_id
FROM Driver, Request, Dispatch, Pickup, Dropoff
WHERE Driver.driver_id = Dispatch.driver_id AND
        Driver.trained = 'f' AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id
GROUP BY Driver.driver_id
HAVING count(distinct(Dispatch.datetime::timestamp::date)) >= 10;

CREATE VIEW nottraineddates AS
SELECT driver.driver_id as driver_id, request.datetime, request.request_id 
as request_id, row_number() over (partition by driver.driver_id 
order by request.datetime ASC) as row 
FROM nottrained, Driver, Request, Dispatch, Pickup, Dropoff 
WHERE Driver.driver_id = nottrained.driver_id AND
        nottrained.driver_id = Dispatch.driver_id AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id
GROUP BY driver.driver_id, request.datetime, request.request_id;

CREATE VIEW nottrainedearlydates AS
SELECT * 
FROM nottraineddates
WHERE row <= 5;

CREATE VIEW nottrainedlatedates AS
SELECT * 
FROM nottraineddates
WHERE row > 5;

CREATE VIEW nottrainedearlyaverages AS
SELECT driver.driver_id as driver_id, avg(driverrating.rating) as earlyaverage
FROM Driverrating, nottrainedearlydates, Request, Dispatch, Pickup, Dropoff, 
Driver
WHERE nottrainedearlydates.driver_id = Driver.driver_id AND 
	Driver.driver_id = Dispatch.driver_id AND
        nottrainedearlydates.request_id = Request.request_id AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id AND
        Driverrating.request_id = Dropoff.request_id
GROUP BY driver.driver_id;

CREATE VIEW nottrainedlateaverages AS
SELECT driver.driver_id as driver_id, avg(driverrating.rating) as lateaverage
FROM Driverrating, nottrainedlatedates, Request, Dispatch, Pickup, Dropoff,
 Driver
WHERE nottrainedlatedates.driver_id = Driver.driver_id AND
	driver.driver_id = Dispatch.driver_id AND
        nottrainedlatedates.request_id = Request.request_id AND
        Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.request_id = Dropoff.request_id AND
        Driverrating.request_id = Dropoff.request_id
GROUP BY driver.driver_id;

(SELECT 'trained' as type, count(distinct(trained.driver_id)) as number, 
avg(trainedearlyaverages.earlyaverage) as early, 
avg(trainedlateaverages.lateaverage) as late 
FROM trained, trainedearlyaverages, trainedlateaverages
WHERE trained.driver_id = trainedearlyaverages.driver_id and 
trainedearlyaverages.driver_id = trainedlateaverages.driver_id 
GROUP BY type
ORDER BY type ASC)
UNION
(SELECT 'untrained' as type, count(distinct(nottrained.driver_id)) as number, 
avg(nottrainedearlyaverages.earlyaverage) as early, 
avg(nottrainedlateaverages.lateaverage) as late 
FROM nottrained, nottrainedearlyaverages, nottrainedlateaverages
WHERE nottrained.driver_id = nottrainedearlyaverages.driver_id and 
nottrainedearlyaverages.driver_id = nottrainedlateaverages.driver_id 
GROUP BY type
ORDER BY type ASC);
