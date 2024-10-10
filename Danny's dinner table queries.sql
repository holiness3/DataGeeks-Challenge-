 Create schema, tables and insert respective values.

CREATE SCHEMA dannys_diner;

USE dannys_diner;

CREATE TABLE menu (
  product_id INT NOT NULL,
  product_name VARCHAR(5),
  price INT,
  PRIMARY KEY (product_id)
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
CREATE TABLE members (
  customer_id VARCHAR(1) NOT NULL,
  join_date DATE,
  PRIMARY KEY (customer_id)
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

CREATE TABLE sales (
  customer_id VARCHAR(1) NOT NULL,
  order_date DATE,
  product_id INTEGER NOT NULL
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');


--What is the total amount each customer spent at the restaurant?

select sales.customer_id, sum (menu.price ) as Total_Amount
from sales left join menu
on sales.product_id=menu.product_id
group by sales.customer_id;

--How many days has each customer visited the restaurant?

select sales.customer_id,
count (distinct sales.order_date) as no_of_days
from sales
group by sales.customer_id;

--What was the first item from the menu purchased by each customer?

select sales.customer_id, menu.product_name, sales.order_date
from sales left join menu on
sales.product_id = menu.product_id
where sales.order_date = '2021-01-01'
group by customer_id, product_name, order_date;

--What is the most purchased item on the menu 
--and how many times was it purchased by all customers?

select menu.product_name, 
count (sales.product_id) as no_of_times_purchased
from menu join sales on menu.product_id = sales.product_id
group by 1
order by 2 desc limit 1;

--Which item was the most popular for each customer?

select sales.customer_id, menu.product_name, 
count (sales.product_id) as no_of_times_purchased
from menu right join sales on menu.product_id = sales.product_id
group by 1,2
order by 3 desc;


--Which item was purchased first by the customer after they became a member?

select members.join_date, members.customer_id, sales.order_date, 
menu.product_name
from menu  join sales on menu.product_id = sales.product_id
join members on sales.customer_id = members.customer_id
where sales.order_date >= members.join_date
order by 3 asc;

--Which item was purchased just before the customer became a member?

select  members.join_date, sales.order_date,members.customer_id, 
menu.product_name
from menu  join sales on menu.product_id = sales.product_id
join members on sales.customer_id = members.customer_id
where sales.order_date < members.join_date
order by 2 desc;


--What is the total items and amount spent for each member before they became a member?

select members.customer_id, count(sales.product_id)as total_items,
sum(menu.price) as total_amount
from menu  join sales on menu.product_id = sales.product_id
join members on sales.customer_id = members.customer_id
where sales.order_date < members.join_date
group by 1

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
--how many points would each customer have?

select sales.customer_id,
sum(case
   when menu.product_name = 'sushi' then 20 * menu.price
   else 10 * menu.price
end) as total_points
	from sales join menu
on sales.product_id = menu.product_id
group by sales.customer_id;


--In the first week after a customer joins the program (including their join date) 
--they earn 2x points on all items, not just sushi - 
--how many points do customer A and B have at the end of January?

select sales.customer_id, sum (menu.price * 20) as total_points
from sales left join menu on
sales.product_id = menu.product_id
join members on sales.customer_id = members.customer_id
where sales.order_date >= members.join_date and sales.order_date <= '2021-01-31'
group by 1;






