SET search_path TO uber, public;
DROP VIEW IF EXISTS info cascade;

CREATE VIEW info AS
SELECT request.request_id, request.client_id as client_id, dispatch.driver_id 
as driver_id, clientrating.rating as client_rating, driverrating.rating 
as driver_rating
FROM Request, Dispatch, Pickup, Dropoff, Driverrating, Clientrating
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id AND
	Dropoff.request_id = Driverrating.request_id AND
	Driverrating.request_id = Clientrating.request_id;  

SELECT info.client_id as client_id, count(info.driver_rating) as reciprocals, 
avg(info.driver_rating - info.client_rating) as difference
FROM info
GROUP BY info.client_id
ORDER BY difference ASC;
