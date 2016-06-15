SET search_path TO uber, public;
DROP VIEW IF EXISTS rides, tempbilled, totalbilled, average, final cascade;

CREATE VIEW rides AS
SELECT DISTINCT Client.client_id as client_id, 
to_char(request.datetime, 'YYYY FMMM') as month, 
request.request_id as request_id
FROM Client, Dispatch, Request, Pickup, Dropoff
WHERE Request.request_id = Dispatch.request_id AND
	Dispatch.request_id = Pickup.request_id AND
	Pickup.request_id = Dropoff.request_id;

CREATE VIEW tempbilled AS
SELECT Request.client_id as client_id, Billed.request_id as request_id, 
Billed.amount
FROM Request, Client, Billed
WHERE Client.client_id = Request.client_id AND
	Request.request_id = Billed.request_id;

CREATE VIEW totalbilled AS
SELECT rides.client_id as client_id, rides.month as month, 
coalesce(sum(tempbilled.amount), '0') as total
FROM rides LEFT OUTER JOIN tempbilled 
on rides.request_id = tempbilled.request_id AND
	rides.client_id = tempbilled.client_id
GROUP BY rides.client_id, rides.month;

CREATE VIEW average AS
SELECT totalbilled.month as month, avg(totalbilled.total) as average
FROM totalbilled
WHERE total > 0
GROUP BY totalbilled.month;

CREATE VIEW final AS
SELECT DISTINCT rides.client_id as client_id, rides.month as month, 
totalbilled.total as total, average.average as average
FROM rides, totalbilled, average
WHERE rides.client_id = totalbilled.client_id AND
	totalbilled.month = rides.month AND
	rides.month = average.month;

SELECT * FROM (SELECT DISTINCT final.client_id as client_id, 
final.month as month, final.total as total, 'at or above' as comparison
FROM final 
WHERE final.total >= final.average
UNION
SELECT DISTINCT final.client_id as client_id, final.month as month, 
final.total as total, 'below' as comparison
FROM final 
WHERE final.total < final.average) AS result 
ORDER BY result.month ASC, result.total ASC, result.client_id ASC;
