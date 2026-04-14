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
);

CREATE TABLE Order_Statuses_sat (
	order_statuses_hash_key UUID, 
	status VARCHAR(255) NOT NULL, 
	load_date TIMESTAMP DEFAULT now(),  
	record_source TEXT NOT NULL, 
	PRIMARY KEY (order_statuses_hash_key, load_date),
	CONSTRAINT fk_order_statuses FOREIGN KEY (order_statuses_hash_key) REFERENCES Order_Statuses_hub(order_statuses_hash_key)
);
