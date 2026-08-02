-- DDL
CREATE TABLE persons (
	id INT NOT NULL , 
	person_name VARCHAR(64) NOT NULL, 
	birth_date DATE, 
	phone VARCHAR(16) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
);

ALTER TABLE persons
ADD email VARCHAR(64) NOT NULL;

ALTER TABLE persons
DROP COLUMN phone;

SELECT * FROM persons;

-- DROP TABLE persons;


-- DML

-- INSERT

INSERT INTO customers (id, first_name, score)
VALUES 
	(6, 'Edward', 700),
	(7, 'Manuel', 500);

SELECT * FROM customers;


-- INSERT SELECTing Values from another Table

INSERT INTO persons (id, person_name, email)
SELECT
	id, first_name, 'Unknown'
FROM customers;

SELECT * FROM persons;


-- UPDATE VALUES
SELECT * FROM customers;

UPDATE customers
SET score = 0
WHERE id = 6;

UPDATE customers
SET score = 0, country = 'UK'
WHERE id = 7;

UPDATE customers
SET country = 'Unknown'
WHERE country IS NULL;

-- DELETE
DELETE FROM customers
WHERE id > 5;

TRUNCATE TABLE persons;