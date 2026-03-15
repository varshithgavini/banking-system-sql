CREATE DATABASE GV_Bank;
use GV_Bank;

CREATE TABLE customers_info(
cust_id INT PRIMARY KEY AUTO_INCREMENT,
cust_name VARCHAR(50),
city VARCHAR(50),
cust_phone_num VARCHAR(10) UNIQUE
);

CREATE TABLE accounts(
acc_id INT PRIMARY KEY AUTO_INCREMENT,
cust_id INT, FOREIGN KEY(cust_id) REFERENCES customers_info(cust_id),
acc_type VARCHAR(50),
balance DECIMAL(10,2)
);

CREATE TABLE transactions(
trans_id INT PRIMARY KEY AUTO_INCREMENT,
acc_id INT, FOREIGN KEY(acc_id) REFERENCES accounts(acc_id),
trans_type VARCHAR(50),
amount DECIMAL(10,2),
trans_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



INSERT INTO customers_info(cust_name,city,cust_phone_num)
VALUES
('Rahul Sharma','9876543210','Delhi'),
('Priya Verma','9876543211','Mumbai'),
('Amit Kumar','9876543212','Hyderabad'),
('Sneha Reddy','9876543213','Chennai'),
('Ravi Patel','9876543214','Ahmedabad');

INSERT INTO accounts(cust_id, acc_type, balance)
VALUES
(1,'Savings',5000),
(2,'Current',12000),
(3,'Savings',8000),
(4,'Savings',15000),
(5,'Current',10000);

-- cutomers details to join in accounts

SELECT * 
FROM customers_info C
JOIN accounts A 
ON C.cust_id = A.cust_id;

-- Example subquery

SELECT * FROM accounts
WHERE balance >(
     SELECT AVG(balance)
     FROM accounts
);

-- create a view;

CREATE VIEW acc_summary AS 
SELECT C.cust_name, A.cust_id, A.balance
FROM customers_info C 
JOIN accounts A
ON C.cust_id = A.cust_id;

select * from acc_summary
where cust_id = 1;



-- STORED PROCEDURE(DEPOSIT MONEY)

DELIMITER //

CREATE PROCEDURE deposit_money(
IN acc_id INT,
IN amount DECIMAL(10,2)
)

BEGIN

UPDATE accounts
SET balance = balance + amount
WHERE acc_id = acc_id;

INSERT INTO transactions(acc_id,trans_type,amount)
VALUES(acc_id,'Deposit',amount);

END //

DELIMITER ;

 CALL deposit_money(3,5678);
 
 -- Stored procedures(withdrawl money)
 
 DELIMITER &&
 CREATE PROCEDURE withdrawl_money(
 IN acc_id INT,
 IN amount DECIMAL(10,2)
 )
 BEGIN
 
 UPDATE accounts
 SET balance = balance - amount
 WHERE acc_id = acc_id;
 
 INSERT INTO transactions(acc_id,trans_type,amount)
 VALUES(acc_id,'WithDraw',amount);
 
 End &&
 
 DELIMITER ;
 
 
 CALL withdrawl_money(1,1234);
 
 -- Transactions
 
 START TRANSACTION;
 
 UPDATE accounts
 SET balance = balance + 60000
 WHERE cust_id = 1;
 
 UPDATE accounts
 SET balance = balance - 50000
 WHERE acc_id = 1;
 
 COMMIT;
 
 select * from accounts where acc_id = 1;
 
SELECT balance 
from accounts
where acc_id = 1;

SELECT SUM(balance) AS total_bank_balance
FROM accounts;