SET search_path TO uber, public;
DROP VIEW IF EXISTS rides, breaks1, breaks2, breaks, totalrides,
totalbreak cascade; 

CREATE VIEW rides as
SELECT driver_id, sum(dropoff.datetime::timestamp - pickup.datetime::timestamp)
 as duration, pickup.datetime::timestamp::date as date
FROM Dispatch, Pickup, Dropoff, Request
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id AND
	Pickup.datetime::timestamp::date = Dropoff.datetime::timestamp::date
GROUP BY driver_id, pickup.datetime::timestamp::date;

CREATE VIEW breaks1 as
SELECT driver_id, sum(pickup.datetime::timestamp - dropoff.datetime::timestamp)
 as break, pickup.datetime::timestamp::date as date 
FROM Dispatch, Pickup, Dropoff, Request
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
        Pickup.datetime::timestamp::date = Dropoff.datetime::timestamp::date AND
	Pickup.datetime::timestamp > Dropoff.datetime::timestamp AND
	Pickup.datetime::timestamp - Dropoff.datetime::timestamp 
< INTERVAL '00:15:00' 
GROUP BY driver_id, pickup.datetime::timestamp::date;

CREATE VIEW breaks2 as
SELECT driver_id, INTERVAL '00:00:00' as break, pickup.datetime::timestamp::date
 as date
FROM Dispatch, Pickup, Dropoff, Request
WHERE Request.request_id = Dispatch.request_id AND
        Dispatch.request_id = Pickup.request_id AND
        Pickup.datetime::timestamp::date = Dropoff.datetime::timestamp::date
GROUP BY driver_id, pickup.datetime::timestamp::date
HAVING count(pickup.request_id) = 1;

CREATE VIEW breaks as
SELECT * FROM BREAKS1
UNION
SELECT * FROM BREAKS2;

CREATE VIEW totalrides as
SELECT a.driver_id as driver, a.date as start, sum(a.duration + b.duration
 + c.duration) as driving
FROM rides a, rides b, rides c
WHERE a.driver_id = b.driver_id AND 
	b.driver_id = c.driver_id AND
	a.duration >= '12:00:00' AND
	b.duration >= '12:00:00' AND
	c.duration >= '12:00:00' AND
	b.date = a.date::timestamp::date + interval '1' day AND
	c.date = b.date::timestamp::date + interval '1' day
GROUP BY a.driver_id, a.date
ORDER BY driving DESC;

CREATE VIEW totalbreak as
SELECT a.driver_id as driver, sum(a.break + b.break + c.break) as breaks,
 a.date as start
FROM breaks a, breaks b, breaks c
WHERE a.driver_id = b.driver_id AND
	b.driver_id = c.driver_id AND
	b.date = a.date::timestamp::date + interval '1' day  AND
	c.date = b.date::timestamp::date + interval '1' day
GROUP BY a.driver_id, a.date
ORDER BY breaks ASC;

SELECT totalrides.driver as driver, totalrides.start as start, 
totalrides.driving as driving, totalbreak.breaks as breaks
FROM totalrides, totalbreak
WHERE totalrides.driver = totalbreak.driver AND
	totalrides.start = totalbreak.start
GROUP BY totalrides.driver, totalrides.start, totalrides.driving, 
totalbreak.breaks
ORDER BY driving DESC, breaks ASC; 
