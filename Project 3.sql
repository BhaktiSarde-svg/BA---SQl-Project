CREATE DATABASE Customer
USE Customer

CREATE TABLE product (
    product_id   INT          NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price        INT          NOT NULL
);
 
CREATE TABLE user_name (
    userid INT          NOT NULL PRIMARY KEY,
    names  VARCHAR(100) NOT NULL
);
 
CREATE TABLE users (
    userid      INT  NOT NULL PRIMARY KEY,
    signup_date DATE NOT NULL,
    CONSTRAINT fk_users_username FOREIGN KEY (userid) REFERENCES user_name(userid)
);
 
CREATE TABLE goldusers_signup (
    userid           INT  NOT NULL PRIMARY KEY,
    gold_signup_date DATE NOT NULL,
    CONSTRAINT fk_gold_users FOREIGN KEY (userid) REFERENCES users(userid)
);
 
CREATE TABLE sales (
    userid       INT  NOT NULL,
    created_date DATE NOT NULL,
    product_id   INT  NOT NULL,
    CONSTRAINT fk_sales_users   FOREIGN KEY (userid)     REFERENCES users(userid),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);




INSERT INTO product (product_id, product_name, price) VALUES
(1 ,'Dal Makhani'   ,160),
(2 ,'Shahi Paneer'  ,170),
(3 ,'Butter Chicken',340),
(4 ,'Aloo Gobi'     ,150),
(5 ,'Chole Bhature' ,100),
(6 ,'Fish Curry'    ,380),
(7 ,'Chicken Tikka' ,300),
(8 ,'Mutton Biryani',450),
(9 ,'Veg Pulao'     ,200),
(10,'Mango Lassi'   ,80 ),
(11,'Gulab Jamun'   ,100);
 

INSERT INTO user_name (userid, names) VALUES
(1 ,'Anshul'),
(2 ,'Rohan') ,
(3 ,'Shreya'),
(4 ,'Priya') ,
(5 ,'Aryan') ,
(6 ,'Sara')  ,
(7 ,'Sahil') ,
(8 ,'Tanvi') ,
(9 ,'Ritika'),
(10,'Gaurav');
 

INSERT INTO users (userid, signup_date) VALUES
(1 ,'2014-09-02'),
(2 ,'2015-01-15'),
(3 ,'2014-04-11'),
(4 ,'2015-11-17'),
(10,'2016-01-02'),
(9 ,'2016-01-02'),
(7 ,'2013-04-02'),
(8 ,'2013-12-15'),
(5 ,'2015-09-08'),
(6 ,'2014-07-13');
 

INSERT INTO goldusers_signup (userid, gold_signup_date) VALUES
(1,'2017-09-22'),
(3,'2017-04-21');
 

INSERT INTO sales (userid, created_date, product_id) VALUES
(1 ,'2017-04-19',2 ),
(3 ,'2019-12-18',1 ),
(2 ,'2020-07-20',3 ),
(1 ,'2019-10-23',2 ),
(1 ,'2018-03-19',3 ),
(3 ,'2016-12-20',2 ),
(1 ,'2016-11-09',1 ),
(1 ,'2016-05-20',3 ),
(2 ,'2017-09-24',1 ),
(1 ,'2017-03-11',2 ),
(1 ,'2016-03-11',1 ),
(3 ,'2016-11-10',1 ),
(3 ,'2017-12-07',2 ),
(3 ,'2016-12-15',2 ),
(2 ,'2017-11-08',2 ),
(2 ,'2018-09-10',3 ),
(4 ,'2019-05-01',1 ),
(5 ,'2018-11-23',3 ),
(6 ,'2017-06-30',9 ),
(7 ,'2018-08-12',8 ),
(8 ,'2019-03-19',7 ),
(9 ,'2017-12-04',6 ),
(10,'2018-09-22',2 ),
(4 ,'2020-08-17',1 ),
(5 ,'2017-05-12',10),
(6 ,'2014-01-27',11),
(7 ,'2014-04-02',7 ),
(8 ,'2020-12-15',8 ),
(9 ,'2017-09-08',8 );



/*1*/
SELECT  p.product_name, SUM(p.price) AS total_revenue,COUNT(*)     AS units_sold
FROM    sales s
JOIN    product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

/*2*/
SELECT TOP 3 p.product_name, SUM(p.price) AS total_revenue,COUNT(*)     AS units_sold
FROM    sales s
JOIN    product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

/*3*/
SELECT COUNT(DISTINCT userid) AS gold_members
FROM   goldusers_signup;

/*4*/
SELECT  s.userid, un.names,SUM(p.price) AS revenue
FROM    sales s
JOIN    product   p  ON s.product_id = p.product_id
JOIN    user_name un ON s.userid     = un.userid
WHERE   s.userid IN (SELECT userid FROM goldusers_signup)
GROUP BY s.userid, un.names
ORDER BY revenue DESC;

/*5*/
SELECT SUM(p.price) AS total_gold_revenue
FROM   sales s
JOIN   product p ON s.product_id = p.product_id
WHERE  s.userid IN (SELECT userid FROM goldusers_signup);

/*6*/
SELECT  g.userid,
        un.names,
        g.gold_signup_date,
        DATEDIFF(DAY,  g.gold_signup_date, GETDATE()) AS days_as_gold,
        DATEDIFF(YEAR, g.gold_signup_date, GETDATE()) AS approx_years
FROM    goldusers_signup g
JOIN    user_name un ON g.userid = un.userid
ORDER BY g.gold_signup_date;

/*7*/
SELECT TOP 1
        p.product_name,
        COUNT(*) AS times_ordered
FROM    sales s
JOIN    product p ON s.product_id = p.product_id
WHERE   s.userid IN (SELECT userid FROM goldusers_signup)
GROUP BY p.product_name
ORDER BY times_ordered DESC;

/*8*/
SELECT  YEAR(s.created_date) AS sales_year,
        SUM(p.price)         AS yearly_revenue
FROM    sales s
JOIN    product p ON s.product_id = p.product_id
GROUP BY YEAR(s.created_date)
ORDER BY sales_year;

/*9*/
WITH yearly AS (
    SELECT  YEAR(s.created_date) AS sales_year,
            SUM(p.price)         AS revenue
    FROM    sales s
    JOIN    product p ON s.product_id = p.product_id
    GROUP BY YEAR(s.created_date)
)
SELECT  sales_year,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_year) AS prev_year_revenue,
        CAST( (revenue - LAG(revenue) OVER (ORDER BY sales_year)) * 100.0
              / NULLIF(LAG(revenue) OVER (ORDER BY sales_year),0)
              AS DECIMAL(10,2) ) AS pct_change
FROM    yearly
ORDER BY sales_year;

/*10*/
SELECT  (SELECT COUNT(DISTINCT userid) FROM goldusers_signup) AS gold_users,
        (SELECT COUNT(DISTINCT userid) FROM users)            AS total_users,
        CAST( (SELECT COUNT(DISTINCT userid) FROM goldusers_signup) * 100.0
              / (SELECT COUNT(DISTINCT userid) FROM users)
              AS DECIMAL(5,2) ) AS gold_pct;

/*11*/

SELECT  s.userid,
        un.names,
        COUNT(*) AS total_orders
FROM    sales s
JOIN    user_name un ON s.userid = un.userid
WHERE   s.userid IN (SELECT userid FROM goldusers_signup)
GROUP BY s.userid, un.names
ORDER BY total_orders DESC;
 
-- average number of orders per gold member
SELECT AVG(order_cnt * 1.0) AS avg_orders_per_gold_member
FROM (
    SELECT userid, COUNT(*) AS order_cnt
    FROM   sales
    WHERE  userid IN (SELECT userid FROM goldusers_signup)
    GROUP BY userid
) t;


/*12*/
SELECT  s.userid,
        un.names,
        SUM(p.price) AS total_amount_spent
FROM    sales s
JOIN    product   p  ON s.product_id = p.product_id
JOIN    user_name un ON s.userid     = un.userid
GROUP BY s.userid, un.names
ORDER BY total_amount_spent DESC;
 

 /**13*/
 SELECT  s.userid,
        un.names,
        COUNT(DISTINCT s.created_date) AS visit_count
FROM    sales s
JOIN    user_name un ON s.userid = un.userid
GROUP BY s.userid, un.names
ORDER BY visit_count DESC;

/*14*/
WITH ranked AS (
    SELECT  s.userid,
            s.created_date,
            p.product_name,
            ROW_NUMBER() OVER (PARTITION BY s.userid
                               ORDER BY s.created_date) AS rn
    FROM    sales s
    JOIN    product p ON s.product_id = p.product_id
)
SELECT r.userid, un.names, r.created_date, r.product_name AS first_product
FROM   ranked r
JOIN   user_name un ON r.userid = un.userid
WHERE  r.rn = 1
ORDER BY r.userid;

/*15*/
SELECT TOP 1
        p.product_name,
        COUNT(*) AS times_purchased
FROM    sales s
JOIN    product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY times_purchased DESC;

/*16*/
WITH cust_prod AS (
    SELECT  s.userid,
            p.product_name,
            COUNT(*) AS order_cnt,
            RANK() OVER (PARTITION BY s.userid
                         ORDER BY COUNT(*) DESC) AS rnk
    FROM    sales s
    JOIN    product p ON s.product_id = p.product_id
    GROUP BY s.userid, p.product_name
)
SELECT cp.userid, un.names, cp.product_name AS favourite_item, cp.order_cnt
FROM   cust_prod cp
JOIN   user_name un ON cp.userid = un.userid
WHERE  cp.rnk = 1
ORDER BY cp.userid;

/*17*/
WITH after_gold AS (
    SELECT  s.userid,
            s.created_date,
            p.product_name,
            ROW_NUMBER() OVER (PARTITION BY s.userid
                               ORDER BY s.created_date) AS rn
    FROM    sales s
    JOIN    goldusers_signup g ON s.userid = g.userid
    JOIN    product p          ON s.product_id = p.product_id
    WHERE   s.created_date >= g.gold_signup_date
)
SELECT userid, created_date, product_name AS first_item_after_membership
FROM   after_gold
WHERE  rn = 1
ORDER BY userid;


/*18*/
WITH before_gold AS (
    SELECT  s.userid,
            s.created_date,
            p.product_name,
            ROW_NUMBER() OVER (PARTITION BY s.userid
                               ORDER BY s.created_date DESC) AS rn
    FROM    sales s
    JOIN    goldusers_signup g ON s.userid = g.userid
    JOIN    product p          ON s.product_id = p.product_id
    WHERE   s.created_date < g.gold_signup_date
)
SELECT userid, created_date, product_name AS last_item_before_membership
FROM   before_gold
WHERE  rn = 1
ORDER BY userid;

/*19*/
SELECT  s.userid,
        un.names,
        COUNT(*)     AS orders_before_gold,
        SUM(p.price) AS amount_before_gold
FROM    sales s
JOIN    goldusers_signup g ON s.userid = g.userid
JOIN    product   p        ON s.product_id = p.product_id
JOIN    user_name un       ON s.userid = un.userid
WHERE   s.created_date < g.gold_signup_date
GROUP BY s.userid, un.names
ORDER BY s.userid;


/*20*/
SELECT  s.userid,
        un.names,
        s.created_date,
        p.product_name,
        CASE
            WHEN g.gold_signup_date IS NULL
              OR s.created_date < g.gold_signup_date
            THEN 'na'
            ELSE CAST( RANK() OVER (PARTITION BY s.userid
                                    ORDER BY s.created_date) AS VARCHAR(10) )
        END AS transaction_rank
FROM    sales s
JOIN    product   p  ON s.product_id = p.product_id
JOIN    user_name un ON s.userid     = un.userid
LEFT JOIN goldusers_signup g ON s.userid = g.userid
ORDER BY s.userid, s.created_date;
