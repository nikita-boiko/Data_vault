CREATE TABLE Customers_hub (
	customer_hash_key UUID PRIMARY KEY, 
	customer_id TEXT UNIQUE NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL
);

CREATE TABLE Products_hub (
	product_hash_key UUID PRIMARY KEY, 
	product_id TEXT UNIQUE NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL
);

CREATE TABLE Orders_hub (
	order_hash_key UUID PRIMARY KEY, 
	order_id TEXT UNIQUE NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL
);

CREATE TABLE Order_Statuses_hub (
	order_statuses_hash_key UUID PRIMARY KEY, 
	status_id TEXT UNIQUE NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL
);


CREATE TABLE Orders_Products_link (
	link_hash_key UUID PRIMARY KEY,
	order_hash_key UUID NOT NULL, 
	product_hash_key UUID NOT NULL,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	CONSTRAINT fk_order FOREIGN KEY (order_hash_key) REFERENCES Orders_hub(order_hash_key), 
	CONSTRAINT fk_product FOREIGN KEY (product_hash_key) REFERENCES Products_hub(product_hash_key)
);

CREATE TABLE Orders_Customers_link (
	link_hash_key UUID PRIMARY KEY,
	order_hash_key UUID NOT NULL, 
	customer_hash_key UUID NOT NULL,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	CONSTRAINT fk_order FOREIGN KEY (order_hash_key) REFERENCES Orders_hub(order_hash_key), 
	CONSTRAINT fk_customer FOREIGN KEY (customer_hash_key) REFERENCES Customers_hub(customer_hash_key)
);

CREATE TABLE Orders_Statuses_link (
	link_hash_key UUID PRIMARY KEY,
	order_hash_key UUID NOT NULL, 
	order_statuses_hash_key UUID NOT NULL,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	CONSTRAINT fk_order FOREIGN KEY (order_hash_key) REFERENCES Orders_hub(order_hash_key), 
	CONSTRAINT fk_order_statuses FOREIGN KEY (order_statuses_hash_key) REFERENCES Order_Statuses_hub(order_statuses_hash_key)
);

CREATE TABLE Customers_sat (
	customer_hash_key UUID, 
	hash_diff TEXT NOT NULL,
	name VARCHAR(255) NOT NULL, 
	email VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL, 
	start_date TIMESTAMP DEFAULT now(),
	end_date TIMESTAMP,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL,
	PRIMARY KEY (customer_hash_key, load_date), 
	CONSTRAINT fk_customer FOREIGN KEY (customer_hash_key) REFERENCES Customers_hub(customer_hash_key)
);

CREATE TABLE Products_sat (
	product_hash_key UUID, 
	hash_diff TEXT NOT NULL,
	product_name VARCHAR(255) NOT NULL, 
	category VARCHAR(255) NOT NULL,
	start_date TIMESTAMP DEFAULT now(),
	end_date TIMESTAMP,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL,
	PRIMARY KEY (product_hash_key, load_date), 
	CONSTRAINT fk_product FOREIGN KEY (product_hash_key) REFERENCES Products_hub(product_hash_key)
);

CREATE TABLE Orders_sat (
	order_hash_key UUID, 
	hash_diff TEXT NOT NULL,
	amount NUMERIC(10, 2) NOT NULL, 
	quantity INT NOT NULL, 
	start_date TIMESTAMP DEFAULT now(),
	end_date TIMESTAMP,
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	PRIMARY KEY (order_hash_key, load_date), 
	CONSTRAINT fk_order FOREIGN KEY (order_hash_key) REFERENCES Orders_hub(order_hash_key)
) PARTITION BY RANGE (load_date);

CREATE TABLE Order_Statuses_sat (
	order_statuses_hash_key UUID, 
	status VARCHAR(255) NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	PRIMARY KEY (order_statuses_hash_key, load_date),
	CONSTRAINT fk_order_statuses FOREIGN KEY (order_statuses_hash_key) REFERENCES Order_Statuses_hub(order_statuses_hash_key)
);

CREATE TABLE orders_2024 PARTITION OF Orders_sat
	FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2025 PARTITION OF Orders_sat
	FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE INDEX idx_order_hash_key ON Orders_sat (order_hash_key);

CREATE INDEX idx_load_date ON Orders_sat (load_date);

INSERT INTO Orders_hub 
VALUES
('8f653b1f-f216-4617-84a4-779111b4b143'::uuid, 
'CUST-427681', 
'2024-04-14 00:00:00', 
'default'),
('6f5aef8a-b686-4b03-b908-7547fc6cedae'::uuid, 
'CUST-684971', 
'2025-04-14 00:00:00',  
'default');

INSERT INTO Orders_sat
VALUES
('8f653b1f-f216-4617-84a4-779111b4b143'::uuid, 
'4f0a92d8b1c4e7a5b6d3f0e8a1c2b5d4e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 
15.00, 
10,
'2024-04-14 00:00:00', 
NULL,  
'2024-04-14 00:00:00', 
'default'),
('6f5aef8a-b686-4b03-b908-7547fc6cedae'::uuid, 
'd5e8f1a2c3b4a5d6e7f809a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9012b', 
25.50, 
12,
'2025-04-14 00:00:00', 
NULL, 
'2025-04-14 00:00:00', 
'default');

EXPLAIN ANALYZE 
SELECT * FROM Orders_sat 
WHERE load_date >= '2024-01-01' 
AND load_date < '2025-01-01'

EXPLAIN ANALYZE 
SELECT * FROM Orders_sat 
WHERE order_hash_key = '6f5aef8a-b686-4b03-b908-7547fc6cedae'

SELECT * FROM orders_2024

SELECT * FROM orders_2025
