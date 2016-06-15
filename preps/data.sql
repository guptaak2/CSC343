insert into client values
(99, 'Mason', 'Daisy', 'daisy@kitchen.com'),
(100, 'Crawley', 'Violet', 'dowager@dower-house.org'),
(88, 'Branson', 'Tom', 'branson@gmail.com');


insert into driver values
(12345, 'Snow', 'Jon', 'January 1, 1990', 'The Wall', 'BGSW 420', false),
(22222, 'Tyrion', 'Lannister', 'January 1, 1990', 'Kings Landing', 'ABCD 123', false);


insert into available values
(12345, '2016-01-08 04:05', '(1, 2)');


-- Locations are specified as longitude and latitude (in that order), in degrees.
insert into place values
('highclere castle', '(1.361, 51.3267)'),
('dower house', '(-0.4632, 51.3552)'),
('eaton centre', '(79.3803,43.654)'),
('cn tower', '(79.3871,43.6426)'),
('north york civic centre', '(79.4146,43.7673)'),
('pearson international airport', '(79.6306,43.6767)'),
('utsc', '(79.1856,43.7836)');


insert into request values
(1, 99, '2016-01-08 04:10', 'eaton centre', 'pearson international airport'),
-- 2013
(2, 100, '2013-02-01 08:00', 'dower house', 'highclere castle'),
(3, 100, '2013-02-02 08:00', 'dower house', 'highclere castle'),
(4, 100, '2013-02-03 08:00', 'highclere castle', 'dower house'),
-- 2014
(5, 100, '2014-07-01 08:00', 'dower house', 'pearson international airport'),
(6, 100, '2014-07-02 08:00', 'pearson international airport', 'eaton centre'),
(7, 100, '2014-07-03 08:00', 'eaton centre', 'cn tower'),
-- 2015
(8, 100, '2015-07-01 08:00', 'cn tower', 'pearson international airport');


insert into dispatch values
(1, 12345, '(1, 4)', '2016-01-08 04:11'),
(2, 22222, '(5, 5)', '2013-02-01 08:05'),
(3, 22222, '(5, 5)', '2013-02-02 08:05'),
(4, 22222, '(5, 5)', '2013-02-03 08:05'),
(5, 22222, '(5, 5)', '2014-07-01 08:05'),
(6, 22222, '(5, 5)', '2014-07-02 08:05'),
(7, 22222, '(5, 5)', '2014-07-03 08:05'),
(8, 22222, '(5, 5)', '2015-07-01 08:05');


insert into pickup values
(1, '2016-01-08 04:14'),
(2, '2013-02-01 08:06'),
(3, '2013-02-02 08:06'),
(4, '2013-02-03 08:06'),
(5, '2014-07-01 08:06'),
(6, '2014-07-02 08:06'),
(7, '2014-07-03 08:06'),
(8, '2015-07-01 08:06');


insert into dropoff values
(1, '2016-01-08 04:14'),
(2, '2013-02-01 08:16'),
(3, '2013-02-02 08:16'),
(4, '2013-02-03 08:16'),
(5, '2014-07-01 08:16'),
(6, '2014-07-02 08:16'),
(7, '2014-07-03 08:16'),
(8, '2015-07-01 08:16');


insert into rates values
(3.2, .55);


insert into billed values
(1, 8.5),
(2, 255.2),
(3, 105.4),
(4, 175.5),
(5, 5.1),
(6, 5.8),
(7, 6.2),
(8, 5.7);


insert into driverrating values
(1, 5);

insert into clientrating values
(1, 4);

