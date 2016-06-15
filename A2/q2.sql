SET search_path TO uber, public;
DROP VIEW IF EXISTS year, clients, clients2015, clients2014, c2014,
c2015, Bills, InBetween, Fewer cascade;

CREATE VIEW year as
SELECT EXTRACT (YEAR FROM datetime) as year, request_id as years_request_id,
 client_id as year_client_id
FROM Request;

CREATE VIEW clients as
SELECT Request.client_id, year, Dropoff.request_id
FROM Request, Dispatch, Pickup, Dropoff, Year
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id AND
	 Dropoff.request_id = year.years_request_id
AND year.year < 2014;

CREATE VIEW clients2015 as
SELECT Request.client_id, year, Dropoff.request_id
FROM Request, Dropoff, Year
WHERE Request.request_id = Dropoff.request_id
AND Request.request_id = year.years_request_id
AND year.year = 2015;

CREATE VIEW clients2014 as
SELECT Request.client_id, year, Dropoff.request_id
FROM Request, Dropoff, Year
WHERE Request.request_id = Dropoff.request_id
AND Request.request_id = year.years_request_id
AND year.year = 2014; 

CREATE VIEW c2014 as
SELECT clients2014.client_id, count(clients2014.request_id)
FROM clients2014
GROUP BY clients2014.client_id;

CREATE VIEW c2015 as
SELECT clients2015.client_id, count(clients2015.request_id)
FROM clients2015
GROUP BY clients2015.client_id;

CREATE VIEW Bills as
SELECT client_id, sum(billed.amount) as billed
FROM clients, billed
WHERE clients.request_id = billed.request_id
GROUP BY clients.client_id;

CREATE VIEW InBetween as
SELECT clients2014.client_id
FROM clients2014
GROUP BY clients2014.client_id
HAVING count(clients2014.request_id) BETWEEN 1 AND 10; 

CREATE VIEW Fewer as
SELECT c2015.client_id, (c2014.count - c2015.count) as decline
FROM c2015, c2014
WHERE c2015.client_id = c2014.client_id
GROUP BY c2015.client_id, c2014.client_id, c2015.count, c2014.count
HAVING c2015.count < c2014.count;

SELECT DISTINCT Bills.client_id, concat(firstname, ' ', surname) as name, 
coalesce(email, 'unknown') as email, billed, decline
FROM Bills, InBetween, Fewer, Client
WHERE Bills.client_id = InBetween.client_id AND
	InBetween.client_id = Fewer.client_id AND
	Fewer.client_id = client.client_id
GROUP BY Bills.client_id, InBetween.client_id, Fewer.client_id, 
Client.firstname, Client.surname, Bills.billed, Fewer.decline, Client.email
ORDER BY billed DESC
