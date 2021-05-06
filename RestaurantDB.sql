-- GROUP9 CARSON ROTTINGHAUS, RYAN BELL, YILONG YUAN
-- 1. TABLE CREATION
CREATE TABLE RESTURAUNT (
       resturauntID			VARCHAR(15)		NOT NULL,
       PRIMARY KEY (resturauntID)
);

CREATE TABLE INVENTORY (
       itemID 	        	INT				NOT NULL,
	   stock				INT				NOT NULL,
       PRIMARY KEY (itemID)
);

CREATE TABLE SUPPLIER (
       companyName 	        VARCHAR(15)		NOT NULL,
	   Address				VARCHAR(30)		NOT NULL,
	   Price				FLOAT			NOT NULL,
       PRIMARY KEY (companyName)
);

CREATE TABLE EMPLOYEE (
       employeeID 	    	INT				NOT NULL,
	   Fname				VARCHAR(15)		NOT NULL,
	   Lname				VARCHAR(15)		NOT NULL,
	   Position				VARCHAR(15)		NOT NULL,
       PRIMARY KEY (employeeID)
);

CREATE TABLE CUSTOMER (
       customerID 	     INT		NOT NULL,
       PRIMARY KEY (customerID)
);
CREATE TABLE REWADRS_MEMBER (
       customerID 	        INT		NOT NULL,
	   Fname				VARCHAR(15)		NOT NULL,
	   Lname				VARCHAR(15)		NOT NULL,
	   Address				VARCHAR(30)		NOT NULL,
	   FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID),
       PRIMARY KEY (customerID)
);

CREATE TABLE ORDER_DATA (
       orderID 	        INT		NOT NULL,
	   customerID		INT		NOT NULL,
	   totalCost		FLOAT	NOT NULL,
	   orderDate		DATE	NOT NULL,
       PRIMARY KEY (orderID),
	   FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
);

CREATE TABLE ORDER_ITEM (
	   orderID			INT		NOT NULL,
	   itemID			INT		NOT NULL,
	   Price			FLOAT	NOT NULL,
	   PRIMARY KEY (orderID),
	   FOREIGN KEY (orderID) REFERENCES ORDER_DATA(orderID),
	   FOREIGN KEY (itemID) REFERENCES INVENTORY(itemID)
);

CREATE TABLE DAILY_STATS (
       dailyStatsID		INT		NOT	NULL,
	   dailyProfit		FLOAT	NOT NULL,
	   dailyCustomerAmt	INT		NOT	NULL,
	   PRIMARY KEY (dailyStatsID)
);