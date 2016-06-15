SET search_path TO uber, public;
DROP VIEW IF EXISTS years cascade;

CREATE VIEW years AS
SELECT DISTINCT EXTRACT (YEAR FROM request.datetime) as year, Client.client_id
 as client_id 
FROM Request, Dispatch, Pickup, Dropoff, Client
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id
GROUP BY client.client_id, year
ORDER BY year ASC;

SELECT years.client_id as client_id, years.year as year, 
coalesce(count(request.request_id), 0) as rides
FROM years LEFT OUTER JOIN request ON
years.year = extract (year from request.datetime) AND
years.client_id = request.client_id
GROUP BY years.year, years.client_id
ORDER BY rides DESC, years.year ASC, years.client_id ASC;
