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






