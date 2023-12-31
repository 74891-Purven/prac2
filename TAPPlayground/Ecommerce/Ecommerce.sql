--  USE Ecommerce ;

CREATE TABLE
    users(
        user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(25) UNIQUE NOT NULL,
        contact_number VARCHAR(20) NOT NULL UNIQUE,
        password VARCHAR(15) NOT NULL
    );

CREATE TABLE
    customers(
        cust_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(25),
        last_name VARCHAR(25),
        email VARCHAR(25) UNIQUE NOT NULL,
        contact_number VARCHAR(20) UNIQUE NOT NULL,
        password VARCHAR(15) NOT NULL
    );

SELECT * FROM users;

/*
 possible vales  for addressmode:
 1:only residential
 2:only delivery address
 3:residentail and delivery
 */

CREATE TRIGGER insert_user AFTER INSERT ON customers 
FOR EACH ROW BEGIN 
	INSERT INTO
	    users(
	        email,
	        contact_number,
	        password
	    )
	VALUES (
	        NEW.email,
	        NEW.contact_number,
	        NEW.password
	    );
END; 

CREATE TABLE
    addresses(
        address_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        cust_id INT NOT NULL,
        CONSTRAINT fk_customer_id_2 FOREIGN KEY(cust_id) REFERENCES customers(cust_id) ON UPDATE CASCADE ON DELETE CASCADE,
        address_mode ENUM('permanent', 'billing') NOT NULL,
        house_number VARCHAR(20),
        landmark VARCHAR(25) NOT NULL,
        city VARCHAR(25) NOT NULL,
        state VARCHAR(25) NOT NULL,
        country VARCHAR(25) NOT NULL,
        pincode VARCHAR(25) NOT NULL
    );

CREATE TABLE
    products (
        product_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(20) NOT NULL,
        description VARCHAR(50),
        stock_available INT NOT NULL,
        unit_price DOUBLE NOT NULL,
        image VARCHAR(40)
    );

CREATE TABLE
    orders(
        order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        delivery_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        cust_id INT NOT NULL,
        CONSTRAINT fk_customer_id FOREIGN KEY (cust_id) REFERENCES customers(cust_id) ON UPDATE CASCADE ON DELETE CASCADE,
        status ENUM('processing', 'deliverd') NOT NULL
    );

CREATE TABLE
    orderdetails(
        orderdetails_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        order_id INT NOT NULL,
        CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
        product_id INT NOT NULL,
        CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
        quantity INT NOT NULL
    );

SELECT
    sum(quantity) as totalquantity
from orderdetails
where product_id = 1;

CREATE PROCEDURE getrevenue(IN productid INT, OUT totalrevenue 
DOUBLE) BEGIN 
	DECLARE totalquantity INT;
	DECLARE unitprice DOUBLE;
	SELECT
	    sum(quantity) INTO totalquantity
	from orderdetails
	where product_id = productid;
	SELECT
	    unit_price INTO unitprice
	FROM products
	WHERE product_id = productid;
	SET totalrevenue = totalquantity * unitprice;
	SELECT totalrevenue;
END; 

CALL getrevenue(2,@totalrevenue);

SELECT @totalrevenue;

DESCRIBE addresses;

SELECT
    orderdetails_id,
    quantity,
    order_date
from orders o1
    LEFT JOIN orderdetails o2 ON o1.order_id = o2.order_id;

/*
 select month(order_date),sum(unit_price*quantity) 
 from orders,products,orderdetails 
 where products.product_id=orderdetails.product_id 
 and order_date > now() - INTERVAL 12 month 
 group by month(order_date);*/

INSERT INTO
    customers(
        first_name,
        last_name,
        email,
        contact_number,
        password
    )
VALUES (
        'sahil',
        'mankar',
        'sahil@123',
        '9960916323',
        'sahil@123'
    );

INSERT INTO
    customers(
        first_name,
        last_name,
        email,
        contact_number,
        password
    )
VALUES (
        'abhay',
        'navle',
        'abhay@123',
        '9075966080',
        'password'
    );

INSERT INTO
    products(
        title,
        description,
        stock_available,
        unit_price,
        image
    )
VALUES
(
        'ParleG',
        'tasty biscuits',
        20000,
        10,
        './images/Parleg.jpg'
    );

INSERT INTO
    products(
        title,
        description,
        stock_available,
        unit_price,
        image
    )
VALUES
(
        'GoodDay',
        'tasty cookies',
        50000,
        15,
        './images/goodday.jpg'
    );

INSERT INTO
    products(
        title,
        description,
        stock_available,
        unit_price,
        image
    )
VALUES
(
        'MariGold',
        'tasty biscuits',
        40000,
        16,
        './images/marigold.jpg'
    );

INSERT INTO
    products(
        title,
        description,
        stock_available,
        unit_price,
        image
    )
VALUES
(
        '20-20',
        'tasty biscuits',
        70000,
        10,
        './images/2020.jpg'
    );

INSERT INTO
    products(
        title,
        description,
        stock_available,
        unit_price,
        image
    )
VALUES
(
        'Crack-Jack',
        'tasty biscuits',
        30000,
        10,
        './images/crackjack.jpg'
    );

SELECT * FROM customers;

INSERT INTO
    addresses(
        cust_id,
        address_mode,
        house_number,
        landmark,
        city,
        state,
        country,
        pincode
    )
VALUES
(
        1,
        'permanent',
        'houseNo.12',
        'Pune-Nashik Highway',
        'Manchar',
        'Maharashtra',
        'India',
        '123321'
    );

INSERT INTO
    addresses(
        cust_id,
        address_mode,
        house_number,
        landmark,
        city,
        state,
        country,
        pincode
    )
VALUES
(
        1,
        'billing',
        'houseNo.12',
        'Pune-Nashik Highway',
        'Manchar',
        'Maharashtra',
        'India',
        '123321'
    );

INSERT INTO
    addresses(
        cust_id,
        address_mode,
        house_number,
        landmark,
        city,
        state,
        country,
        pincode
    )
VALUES
(
        2,
        'permanent',
        'houseNo.32',
        'Peth-Kurwandi Road',
        'Manchar',
        'Maharashtra',
        'India',
        '123321'
    );

INSERT INTO
    addresses(
        cust_id,
        address_mode,
        house_number,
        landmark,
        city,
        state,
        country,
        pincode
    )
VALUES
(
        2,
        'permanent',
        'houseNo.234',
        'Pune-Nashik Highway',
        'Rajgurunagar',
        'Maharashtra',
        'India',
        '121321'
    );

INSERT INTO
    orders(order_date, cust_id)
VALUES ('2020-08-25  06:35:25', 1);

INSERT INTO
    orders(order_date, cust_id)
VALUES ('2021-06-04  08:35:25', 1);

INSERT INTO
    orders(order_date, cust_id)
VALUES ('2010-01-16  09:35:25', 2);

INSERT INTO
    orders(order_date, cust_id)
VALUES ('2021-05-15  11:35:25', 2);

INSERT INTO
    orderdetails(order_id, product_id, quantity)
VALUES
(1, 1, 70);

INSERT INTO
    orderdetails(order_id, product_id, quantity)
VALUES
(1, 2, 700);

INSERT INTO
    orderdetails(order_id, product_id, quantity)
VALUES
(2, 3, 78);

INSERT INTO
    orderdetails(order_id, product_id, quantity)
VALUES
(3, 4, 78);

INSERT INTO
    orderdetails(order_id, product_id, quantity)
VALUES(3, 1, 78);

SELECT
	orderdetails.product_id,
    products.title,
	products.description,
	products.unit_price,
    products.image,
    orderdetails.order_id,
	orderdetails.quantity,
	(products.unit_price*orderdetails.quantity) as  totalprice
from products
INNER JOIN orderdetails ON
    products.product_id =  orderdetails.product_id 
    WHERE orderdetails.order_id=1;

    SELECT
    products.title,
	products.description,
	products.unit_price,
    products.image,
    orderdetails.order_id,
	orderdetails.quantity
	-- (products.unit_price*orderdetails.quantity) as  totalprice
from products, orders
INNER JOIN customers ON customers.cust_id=orders.cust_id
INNER JoIN orderdetails ON  orderdetails.order_id=orders.order_id
where customers.cust_id=1 ;
    
    SELECT * FROM orderdetails;
SELECT SUM (products.unit_price*orderdetails.quantity) as totalamount  from products
INNER JOIN orderdetails ON
    products.product_id =  orderdetails.product_id 
    WHERE orderdetails.order_id=1 ;  

SELECT * FROM orders WHERE cust_id=1;

--  SELECT DISTINCT orderdetails.order_id from orderdetails,orders WHERE orderdetails.order_id=orders.order_id AND  orders.cust_id=1   ;


SELECT
    orderdetails.product_id,products.title,
    SUM(orderdetails.quantity) * products.unit_price 
FROM orderdetails, products
WHERE
    orderdetails.product_id = products.product_id
GROUP BY product_id;



SELECT products.product_id,products.title , products.unit_price, orderdetails.quantity,customers.cust_id,orders.order_id,orders.order_date 
FROM products,customers, orders INNER JOIN orderdetails on orderdetails.order_id=orders.order_id 
WHERE  products.product_id=orderdetails.product_id AND customers.cust_id=orders.cust_id 
AND customers.cust_id=1 order by orders.order_id;

SELECT * FROM orders;

insert into orders(cust_id) VALUES(1);

insert into orderdetails(order_id,product_id,quantity) VALUES (7,2,2000);
insert into orderdetails(order_id,product_id,quantity) VALUES (8,3,3000);
insert into orderdetails(order_id,product_id,quantity) VALUES (9,5,5000);


