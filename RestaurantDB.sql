-- TABLE CREATION
CREATE TABLE RESTURAUNT (
    resturauntID	INT	NOT NULL	AUTO_INCREMENT,
    PRIMARY KEY (resturauntID)
);

CREATE TABLE INVENTORY (
	itemName	VARCHAR(15)		NOT NULL,
	itemPrice		FLOAT			NOT NULL,
	PRIMARY KEY (itemName)
);

CREATE TABLE EMPLOYEE (
	employeeID	INT	NOT NULL	AUTO_INCREMENT,
	Fname		VARCHAR(15)		NOT NULL,
	Lname		VARCHAR(15)		NOT NULL,
	Position	VARCHAR(15)		NOT NULL,
	resturauntID	INT			NOT NULL,
	PRIMARY KEY (employeeID),
	FOREIGN KEY (resturauntID) REFERENCES RESTURAUNT(resturauntID) ON DELETE CASCADE
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
	FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID) ON DELETE CASCADE,
	PRIMARY KEY (customerID)
);

CREATE TABLE DAILY_STATS (
	orderDate	DATE	NOT NULL,
	resturauntID	INT		NOT NULL,
	dailyIncome			FLOAT	DEFAULT	0.0,
	dailyOrderAmt	INT		DEFAULT 0,
	PRIMARY KEY (orderDate),
	FOREIGN KEY (resturauntID) REFERENCES RESTURAUNT(resturauntID) ON DELETE CASCADE
);

CREATE TABLE ORDER_DATA (
	orderID 	INT	NOT NULL	AUTO_INCREMENT,
	customerID	INT	NOT NULL,
	totalCost	FLOAT	NOT NULL,
	orderDate	DATE	NOT NULL,
	PRIMARY KEY (orderID),
	FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID) ON DELETE CASCADE,
	FOREIGN KEY (orderDate)  REFERENCES DAILY_STATS(orderDate) ON DELETE CASCADE
);

CREATE TABLE ORDER_ITEM (
	orderID		INT	NOT NULL,
	itemName	VARCHAR(15)	NOT NULL,
	FOREIGN KEY (orderID) REFERENCES ORDER_DATA(orderID) ON DELETE CASCADE,
	FOREIGN KEY (itemName) REFERENCES INVENTORY(itemName) ON DELETE CASCADE
);

-- PROCEDURES
-- UPDATES ORDER_DATA.totalCost attribute given specific orderID
DELIMITER // 
CREATE DEFINER=root@localhost PROCEDURE calculateOrderTotal (IN orderID INT, IN orderDate DATE)
BEGIN
UPDATE ORDER_DATA 
SET ORDER_DATA.totalCost = (SELECT	SUM(i.itemPrice)
				FROM	inventory i,order_item s
				WHERE	i.itemName = s.itemName and s.orderID = orderID
				)
WHERE ORDER_DATA.orderID = orderID and ORDER_DATA.orderDate = orderDate;
END//
DELIMITER ;

-- UPDATES REWARDS_MEMBER.rewardsPoints based on their current rewards points + order total * 10
DELIMITER //  
CREATE DEFINER=root@localhost PROCEDURE addRewardsPoints(IN customerID INT)
BEGIN
UPDATE REWARDS_MEMBER m, ORDER_DATA d
SET m.rewardsPoints = m.rewardsPoints + (d.totalCost * 10)
WHERE m.customerID = customerID and d.customerID = customerID;
END//
DELIMITER ;

-- UPDATES DAILY_STATS.dailyIncome attribute given specifc orderDate
DELIMITER // 
CREATE DEFINER=root@localhost PROCEDURE calculateDailyIncome(IN orderDate DATE)
BEGIN
UPDATE DAILY_STATS s
SET s.dailyIncome = (SELECT	SUM(d.totalCost)
				FROM	order_data d 
				WHERE d.orderDate = orderDate
				)
WHERE s.orderDate = orderDate;
END//
DELIMITER ;

-- UPDATES DAILY_STATS.dailyOrderAmt attribute given a specific orderDate
DELIMITER // 
CREATE DEFINER=root@localhost PROCEDURE calculateDailyOrderAmt(IN orderDate DATE)
BEGIN
UPDATE DAILY_STATS s
SET s.dailyOrderAmt = (SELECT COUNT(*)
			FROM ORDER_DATA d
			WHERE d.orderDate = orderDate
			)
WHERE s.orderDate = orderDate;
END//
DELIMITER ;

-- Returns INVENTORY.itemPrice
DELIMITER //
CREATE DEFINER=root@localhost PROCEDURE getItemitemPrice(IN inputName VARCHAR(15))
BEGIN
SELECT itemPrice
FROM INVENTORY
WHERE itemName = inputName;
END//
DELIMITER ;

-- Returns REWARDS_MEMBER rewards points
DELIMITER //
CREATE DEFINER=root@localhost PROCEDURE getRewardsPoints(IN inputID INT)
BEGIN
SELECT rewardsPoints 
FROM REWARDS_MEMBER
WHERE customerID = inputID;
END //
DELIMITER ;

-- Returns the order history given a specific customerID
DELIMITER // 
CREATE DEFINER=root@localhost PROCEDURE getOrderHistory(IN inputID INT)
BEGIN
SELECT d.customerID, d.orderID, d.totalCost, d.orderDate
FROM order_data d
INNER JOIN customer c
ON d.customerID = c.customerID
WHERE c.customerID = inputID;
END //
DELIMITER ;

-- INSERTION
INSERT INTO RESTURAUNT VALUES ();
INSERT INTO DAILY_STATS (orderDate, resturauntID) VALUES ('2021-05-07',1);
INSERT INTO DAILY_STATS (orderDate, resturauntID) VALUES ('2021-05-08',1);
INSERT INTO EMPLOYEE (Fname, Lname, Position, resturauntID) VALUES ('Joel','Embiid','Cashier', 1);
INSERT INTO EMPLOYEE (Fname, Lname, Position, resturauntID) VALUES ('Bob','Ross','Manager', 1);
INSERT INTO EMPLOYEE (Fname, Lname, Position, resturauntID) VALUES ('Jayson','Tatum','Manager', 1);
INSERT INTO EMPLOYEE (Fname, Lname, Position, resturauntID) VALUES ('Steph','Curry','Chef', 1);
INSERT INTO INVENTORY VALUES ('Pizza', 8.5), 
								('Fries', 3), 
								('Sandwich', 6), 
								('Salad', 4.4), 
								('Chicken', 8),
								('Potato', 2);
							
INSERT INTO CUSTOMER VALUES ();
INSERT INTO REWARDS_MEMBER (customerID, Fname, Lname, Address) VALUES (1, 'Carson', 'Rottinghaus','1800 Address Lane');
INSERT INTO CUSTOMER VALUES ();
INSERT INTO REWARDS_MEMBER (customerID, Fname, Lname, Address) VALUES (2, 'John', 'Doe','1600 Address Street');
INSERT INTO CUSTOMER VALUES ();

-- EXAMPLE USAGE
-- Order Ticket 1
INSERT INTO ORDER_DATA (customerID, totalCost, orderDate) VALUES(1,0,'2021-05-07');
INSERT INTO ORDER_ITEM VALUES(1,'Pizza'), (1,'Fries'), (1,'Sandwich');
CALL calculateOrderTotal(1,'2021-05-07');
CALL addRewardsPoints(1);

-- Order Ticket 2
INSERT INTO ORDER_DATA (customerID, totalCost, orderDate) VALUES(2,0,'2021-05-07');
INSERT INTO ORDER_ITEM VALUES(2,'Chicken'), (2,'Fries'), (2,'Sandwich'), (2,'Chicken');
CALL calculateOrderTotal(2, '2021-05-07');
CALL addRewardsPoints(2);

-- Order Ticket 3
INSERT INTO ORDER_DATA (customerID, totalCost, orderDate) VALUES(2,0,'2021-05-08');
INSERT INTO ORDER_ITEM VALUES(3,'Chicken'), (3,'Fries'), (3,'Sandwich'), (3,'Salad');
CALL calculateOrderTotal(3, '2021-05-08');
CALL addRewardsPoints(2);

-- DAILY_STATS UPDATE QUERIES
CALL calculateDailyIncome('2021-05-07');
CALL calculateDailyOrderAmt('2021-05-07');
CALL calculateDailyIncome('2021-05-08');
CALL calculateDailyOrderAmt('2021-05-08');

-- MODIFICATION
UPDATE REWARDS_MEMBER 
SET Fname = 'Jason', Lname = 'Smith'
WHERE customerID = 1;

UPDATE EMPLOYEE
SET Position = 'Manager'
WHERE employeeID = 1;

UPDATE INVENTORY
SET itemPrice = 4
WHERE itemName = 'Potato';

-- DELETION
DELETE FROM EMPLOYEE
WHERE Fname = 'Steph' and Lname = 'Curry';

DELETE FROM DAILY_STATS
WHERE orderDate = '2021-05-08';

DELETE FROM ORDER_ITEM
WHERE orderID = 1;
CALL calculateOrderTotal(1,'2021-05-07');

DELETE FROM ORDER_DATA
WHERE orderID = 1;

DELETE FROM REWARDS_MEMBER
WHERE customerID = 1;

DELETE FROM CUSTOMER
WHERE customerID = 1;


