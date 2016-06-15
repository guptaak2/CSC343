SET search_path TO uber, public;
DROP VIEW IF EXISTS temp, temp2, r1, r2, r3, r4, r5,
nulls1, nulls2, nulls3, nulls4, nulls5,
nullswith1, nullswith2, nullswith3, nullswith4, nullswith5.
final1, final2, final3, final4, final5 cascade;

CREATE VIEW temp AS
SELECT * FROM Driverrating
GROUP BY rating, driverrating.request_id;

CREATE VIEW temp2 AS
SELECT Dispatch.driver_id, temp.rating
FROM temp, dispatch
WHERE dispatch.request_id = temp.request_id
ORDER BY dispatch.driver_id;

CREATE VIEW r1 AS
SELECT temp2.driver_id, count(temp2.rating) as r1
FROM temp2
WHERE temp2.rating = '1'
GROUP BY temp2.driver_id;

CREATE VIEW r2 AS
SELECT temp2.driver_id, count(temp2.rating) as r2
FROM temp2
WHERE temp2.rating = '2'
GROUP BY temp2.driver_id;

CREATE VIEW r3 AS
SELECT temp2.driver_id, count(temp2.rating) as r3
FROM temp2
WHERE temp2.rating = '3'
GROUP BY temp2.driver_id;

CREATE VIEW r4 AS
SELECT temp2.driver_id, count(temp2.rating) as r4
FROM temp2
WHERE temp2.rating = '4'
GROUP BY temp2.driver_id;

CREATE VIEW r5 AS
SELECT temp2.driver_id, count(temp2.rating) as r5
FROM temp2
WHERE temp2.rating = '5'
GROUP BY temp2.driver_id;

CREATE VIEW nulls1 AS
SELECT temp2.driver_id
FROM temp2
GROUP BY temp2.driver_id EXCEPT
SELECT temp2.driver_id FROM temp2 where temp2.rating = '1'
GROUP BY temp2.driver_id;

CREATE VIEW nulls2 AS
SELECT temp2.driver_id
FROM temp2
GROUP BY temp2.driver_id EXCEPT
SELECT temp2.driver_id FROM temp2 where temp2.rating = '2'
GROUP BY temp2.driver_id;

CREATE VIEW nulls3 AS
SELECT temp2.driver_id
FROM temp2
GROUP BY temp2.driver_id EXCEPT
SELECT temp2.driver_id FROM temp2 where temp2.rating = '3'
GROUP BY temp2.driver_id;

CREATE VIEW nulls4 AS
SELECT temp2.driver_id
FROM temp2
GROUP BY temp2.driver_id EXCEPT
SELECT temp2.driver_id FROM temp2 where temp2.rating = '4'
GROUP BY temp2.driver_id;

CREATE VIEW nulls5 AS
SELECT temp2.driver_id
FROM temp2
GROUP BY temp2.driver_id EXCEPT
SELECT temp2.driver_id FROM temp2 where temp2.rating = '5'
GROUP BY temp2.driver_id;

CREATE VIEW nullswith1 AS
SELECT nulls1.driver_id, null::bigint as r1 
FROM nulls1;

CREATE VIEW nullswith2 AS
SELECT nulls2.driver_id, null::bigint as r2
FROM nulls2;

CREATE VIEW nullswith3 AS
SELECT nulls3.driver_id, null::bigint as r3
FROM nulls3;

CREATE VIEW nullswith4 AS
SELECT nulls4.driver_id, null::bigint as r4
FROM nulls4;

CREATE VIEW nullswith5 AS
SELECT nulls5.driver_id, null::bigint as r5
FROM nulls5;

CREATE VIEW final1 AS SELECT * FROM nullswith1 UNION SELECT * FROM r1;
CREATE VIEW final2 AS SELECT * FROM nullswith2 UNION SELECT * FROM r2;
CREATE VIEW final3 AS SELECT * FROM nullswith3 UNION SELECT * FROM r3;
CREATE VIEW final4 AS SELECT * FROM nullswith4 UNION SELECT * FROM r4;
CREATE VIEW final5 AS SELECT * FROM nullswith5 UNION SELECT * FROM r5;

SELECT DISTINCT final1.driver_id as driver_id, final5.r5 as r5, final4.r4 
as r4, final3.r3 as r3, final2.r2 as r2, final1.r1 as r1
FROM final1, final2, final3, final4, final5
WHERE final5.driver_id = final4.driver_id AND
	 final4.driver_id = final3.driver_id AND 
	 final3.driver_id = final2.driver_id AND 
	 final2.driver_id = final1.driver_id 
GROUP by final5.driver_id, final4.driver_id, final3.driver_id, 
final2.driver_id, final1.driver_id, final5.r5, final4.r4, final3.r3, 
final2.r2, final1.r1  
ORDER by r5 DESC, r4 DESC, r3 DESC, r2 DESC, r1 DESC, driver_id ASC;
GROUP by r5 DESC, r4 DESC, r3 DESC, r2 DESC, r1 DESC;
