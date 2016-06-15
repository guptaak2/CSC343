SET search_path TO uber, public;
DROP VIEW IF EXISTS months, clients cascade;

CREATE VIEW months as
SELECT to_char(request.datetime, 'YYYY FMMM') as month, 
request_id as months_request_id
FROM Request;

CREATE VIEW clients as
SELECT Request.client_id, month
FROM Request, Dispatch, Pickup, Dropoff, months
WHERE Request.request_id = Dispatch.request_id AND 
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id AND
	Dropoff.request_id = months.months_request_id; 

SELECT DISTINCT Client.client_id, email, 
count(distinct(clients.month)) as months 
FROM Client LEFT OUTER JOIN clients 
ON Client.client_id = clients.client_id 
GROUP BY Client.client_id
ORDER BY months DESC;







