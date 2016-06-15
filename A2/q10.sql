SET search_path TO uber, public;
DROP VIEW IF EXISTS temp1, months, basic, billings2014,
billings2015, almost, almostdone CASCADE;

CREATE VIEW temp1 AS
SELECT driver.driver_id, place1.location <@> place2.location as distance,
to_char(request.datetime, 'MM') as month, to_char(request.datetime, 'YYYY')
as year, dropoff.request_id as request_id, billed.amount as billings
FROM Dispatch, Request, Driver, Place place1, Place place2, Billed, Dropoff
WHERE place1.name = request.source AND
	place2.name = request.destination AND
	driver.driver_id = dispatch.driver_id AND
	request.request_id = dispatch.request_id AND
	dispatch.request_id = dropoff.request_id AND
	dropoff.request_id = billed.request_id;

CREATE VIEW months AS
SELECT to_char(DATE '2014-01-01' + 
(interval '1' month * generate_series(0,11)), 'MM') as mo;

CREATE VIEW basic AS
SELECT DISTINCT driver.driver_id, months.mo as month 
FROM Driver, months
ORDER BY driver.driver_id ASC;

CREATE VIEW billings2014 AS
SELECT temp1.driver_id, temp1.month, temp1.distance as mileage2014,
temp1.billings as billings_2014
FROM temp1 
WHERE temp1.year = '2014';

CREATE VIEW billings2015 AS
SELECT temp1.driver_id, temp1.month, temp1.distance as mileage2015,
temp1.billings as billings_2015
FROM temp1
WHERE temp1.year = '2015';

CREATE VIEW almost AS
SELECT basic.driver_id, basic.month, coalesce(billings2014.mileage2014, 0)
as mileage_2014, coalesce(billings2014.billings_2014, 0) as billings_2014
FROM basic LEFT OUTER JOIN billings2014
ON basic.driver_id = billings2014.driver_id AND
	basic.month = billings2014.month;

CREATE VIEW almostdone AS
SELECT almost.driver_id, almost.month, almost.mileage_2014,
almost.billings_2014, coalesce(billings2015.mileage2015, 0) as
mileage_2015, coalesce(billings2015.billings_2015, 0) as billings_2015
FROM almost LEFT OUTER JOIN billings2015
ON almost.driver_id = billings2015.driver_id AND
	almost.month = billings2015.month;

SELECT almostdone.driver_id, almostdone.month, almostdone.mileage_2014,
almostdone.billings_2014, almostdone.mileage_2015, almostdone.billings_2015,
(almostdone.billings_2015 - almostdone.billings_2014) as billings_increase,
(almostdone.mileage_2015 - almostdone.mileage_2014) as mileage_increase
FROM almostdone
ORDER BY almostdone.driver_id ASC, almostdone.month ASC;  
