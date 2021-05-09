-- GROUP9 CARSON ROTTINGHAUS, RYAN BELL, YILONG YUAN
-- TABLE CREATION
CREATE TABLE RESTURAUNT (
       resturauntID	INT	NOT NULL	AUTO_INCREMENT,
       PRIMARY KEY (resturauntID)
);

CREATE TABLE INVENTORY (
	itemName	VARCHAR(15)		NOT NULL,
	price		FLOAT	NOT NULL,
	PRIMARY KEY (itemName)
);

CREATE TABLE EMPLOYEE (
	employeeID	INT	NOT NULL	AUTO_INCREMENT,
	Fname		VARCHAR(15)		NOT NULL,
	Lname		VARCHAR(15)		NOT NULL,
	Position	VARCHAR(15)		NOT NULL,
	PRIMARY KEY (employeeID)
);

CREATE TABLE CUSTOMER (
       customerID	INT	NOT NULL	AUTO_INCREMENT,
       PRIMARY KEY (customerID)
);

CREATE TABLE REWARDS_MEMBER (
	customerID 	INT	NOT NULL,
	Fname		VARCHAR(15)		NOT NULL,
	Lname		VARCHAR(15)		NOT NULL,
	Address		VARCHAR(30)		NOT NULL,
	rewardsPoints	INT	DEFAULT 0,
	FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID),
	PRIMARY KEY (customerID)
);

CREATE TABLE DAILY_STATS (
	orderDate		DATE	NOT NULL,
	dailyIncome			FLOAT	DEFAULT	0.0,
	dailyCustomerAmt	INT		DEFAULT 0,
	PRIMARY KEY (orderDate)
);

CREATE TABLE ORDER_DATA (
	orderID 	INT		NOT NULL	AUTO_INCREMENT,
	customerID	INT		NOT NULL,
	totalCost	FLOAT	NOT NULL,
	orderDate	DATE	NOT NULL,
	PRIMARY KEY (orderID),
	FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID),
	FOREIGN KEY (orderDate)  REFERENCES DAILY_STATS(orderDate)
);

CREATE TABLE ORDER_ITEM (
	orderID		INT		NOT NULL,
	itemName	VARCHAR(15)		NOT NULL,
	FOREIGN KEY (orderID) REFERENCES ORDER_DATA(orderID),
	FOREIGN KEY (itemName) REFERENCES INVENTORY(itemName),
	CONSTRAINT orderItem PRIMARY KEY (orderID, itemName)
);

-- INSERTION
INSERT INTO RESTURAUNT VALUES ();
INSERT INTO DAILY_STATS (orderDate) VALUES ('2021-05-07');
INSERT INTO INVENTORY VALUES ('Pizza', 8.5), 
							('Fries', 3), 
							('Sandwich', 6), 
							('Salad', 4.4), 
							('Chicken', 8);

INSERT INTO CUSTOMER VALUES ();
INSERT INTO REWARDS_MEMBER (customerID, Fname, Lname, Address) VALUES (1, 'Carson', 'Rottinghaus','1800 Address Lane');
INSERT INTO CUSTOMER VALUES ();
INSERT INTO REWARDS_MEMBER (customerID, Fname, Lname, Address) VALUES (2, 'John', 'Doe','1600 Address Street');

-- Order Ticket 1
INSERT INTO ORDER_DATA (customerID, totalCost, orderDate) VALUES(1,0,'2021-05-07');
INSERT INTO ORDER_ITEM VALUES(1,'Pizza'), (1,'Fries'), (1,'Sandwich');

UPDATE ORDER_DATA -- QUERY UPDATES ORDER_DATA.totalCost attribute given specific orderID
SET ORDER_DATA.totalCost = (SELECT	SUM(i.price)
							FROM	inventory i, order_item s
							WHERE	i.itemName = s.itemName and s.orderID = 1
							)
WHERE ORDER_DATA.OrderID = 1;

UPDATE REWARDS_MEMBER m, ORDER_DATA d -- QUERY UPDATES REWARDS_MEMBER.rewardsPoints based on their order total * 10 
SET m.rewardsPoints = d.totalCost * 10
WHERE m.customerID = 1 and d.customerID = 1;

-- Order Ticket 2
INSERT INTO ORDER_DATA (customerID, totalCost, orderDate) VALUES(1,0,'2021-05-07');
INSERT INTO ORDER_ITEM VALUES(2,'Chicken'), (2,'Fries'), (2,'Sandwich');

UPDATE ORDER_DATA -- QUERY UPDATES ORDER_DATA.totalCost attribute given specific orderID
SET ORDER_DATA.totalCost = (SELECT	SUM(i.price)
							FROM	inventory i, order_item s
							WHERE	i.itemName = s.itemName and s.orderID = 2
							)
WHERE ORDER_DATA.OrderID = 2;

UPDATE REWARDS_MEMBER m, ORDER_DATA d -- QUERY UPDATES REWARDS_MEMBER.rewardsPoints based on their order total * 10 
SET m.rewardsPoints = d.totalCost * 10
WHERE m.customerID = 2 and d.customerID = 2;

UPDATE DAILY_STATS -- QUERY UPDATES DAILY_STATS.dailyIncome attribute given specifc orderDate
SET DAILY_STATS.dailyIncome = (SELECT	SUM(d.totalCost)
							FROM	order_data d 
							WHERE d.orderDate = '2021-05-07'
							);

-- MODIFICATION
UPDATE REWARDS_MEMBER 
SET Fname = 'Jason', Lname = 'Smith'
WHERE customerID = 1;
