SET search_path TO uber, public;
DROP VIEW IF EXISTS temp1, temp2, wanted cascade;

CREATE VIEW temp1 AS
SELECT Request.request_id, dispatch.driver_id, client.client_id
FROM Client, Request, Dispatch, Pickup, Dropoff
WHERE client.client_id = request.client_id AND
	request.request_id = dispatch.request_id AND
	dispatch.request_id = pickup.request_id AND
	pickup.request_id = dropoff.request_id;

CREATE VIEW temp2 AS
SELECT temp1.request_id, temp1.driver_id, temp1.client_id, 
driverrating.request_id as driver_request
FROM temp1 left outer join driverrating ON
	temp1.request_id = driverrating.request_id;

CREATE VIEW wanted  AS
(SELECT client.client_id
FROM Client)
EXCEPT 
(SELECT temp2.client_id
FROM temp2
GROUP BY temp2.client_id
HAVING count(temp2.request_id) > count(temp2.driver_request) AND
	count(distinct(temp2.driver_id)) > count(temp2.driver_request));

SELECT client.client_id, client.email
FROM wanted, client
WHERE client.client_id = wanted.client_id
ORDER BY client.email ASC;
