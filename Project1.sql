use magist;

#1.1 In relation to the products:
#Categories: 'audio','consoles_games', 'eletronicos', 'telefonia', 'eletroportateis','informatica_acessorios', 'pcs', 'pc_gamer'
select 
SUM(order_item_id)
from products
left join order_items
on products.product_id=order_items.product_id
where product_category_name
in ('audio','eletronicos','telefonia','informatica_acessorios', 'pcs');

#1.2 products of these tech categories have been sold (20747items)
select
sum(order_item_id)
from order_items;

#overall number of products sold 134936
#20747/134936=0,153754(like 15%)

#1.3 avg price 
select 
AVG(o.price)
from products p
left join order_items o
on p.product_id=o.product_id
where product_category_name
in ('audio','relogios_presentes','consoles_games', 'eletronicos','telefonia', 'eletroportateis','informatica_acessorios', 'pcs', 'pc_gamer');
#avg price in categories(+freight value)
select 
AVG(o.price+o.freight_value)
from products p
left join order_items o
on p.product_id=o.product_id
where product_category_name
in ('audio','eletronicos','telefonia','informatica_acessorios', 'pcs');

SELECT
ROUND(SUM(price+freight_value))
FROM order_items;

#2 In relation to the sellers:
#2.1How many months of data are included in the magist database?
SELECT MONTH(order_purchase_timestamp) AS M_, YEAR(order_purchase_timestamp) AS Y_
FROM orders
ORDER BY M_;

#2.2 how many sellers and
SELECT 
COUNT(DISTINCT seller_id)
from sellers;

Select 
COUNT(DISTINCT s.seller_id)
from order_items o
left join products p
on o.product_id=p.product_id
left join sellers s
on o.seller_id=s.seller_id
where product_category_name
in ('audio','relogios_presentes','consoles_games', 'eletronicos','telefonia', 'eletroportateis','informatica_acessorios', 'pcs', 'pc_gamer');

#616/3095=0.1990.. LIKE 20% ARE TECH SELLERS

select
order_status
from orders
group by order_status;

#2.2
select product_category_name,COUNT(DISTINCT seller_id),SUM(price)
from order_items
left join orders ON order_items.order_id = orders.order_id
left join products ON order_items.product_id = products.product_id
group by product_category_name
order by COUNT(DISTINCT seller_id) desc;

SELECT 
product_category_name_english,
ROUND(SUM(price) / COUNT(orders.order_id)) AS avg_rev_ord,
ROUND(SUM(price)) AS rev_total,
ROUND((SUM(price))/22) AS avg_mon
FROM order_items
Left join orders ON order_items.order_id=orders.order_id
left join products on order_items.product_id=products.product_id
left join product_category_name_translation on product_category_name_translation.product_category_name=products.product_category_name
where product_category_name_english
in ('audio','consoles_games','electronics','small_appliances','computer_accessories','pc_gamer','computers','watches_gifts')
group by product_category_name_english;

#просто так, чтобы не использовать испанские
select product_category_name,product_category_name_english
from product_category_name_translation
where product_category_name
in ('audio','relogios_presentes','consoles_games', 'eletronicos','telefonia', 'eletroportateis','informatica_acessorios', 'pcs', 'pc_gamer');


#3 In relation to the delivery time:
#3.1 AVG BETWEEN...
SELECT 
avg(DATEDIFF(order_delivered_customer_date,order_purchase_timestamp))
FROM orders
where order_status
in ('delivered');

#3.2 delivered on time and delivered with a delay

select
COUNT(DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)) AS on_time
from orders
where DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)>=0
and order_status
in ('delivered');

select
COUNT(DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)) AS delay
from orders
where DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)<0
and order_status
in ('delivered');

select
COUNT(DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)) AS delay,
product_category_name
from orders
left join order_items ON orders.order_id=order_items.order_id
left join products ON order_items.product_id=products.product_id
where DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)<0
AND order_status
IN ('delivered') 
AND product_category_name IN ('audio','relogios_presentes','consoles_games', 'eletronicos','telefonia', 'eletroportateis','informatica_acessorios', 'pcs', 'pc_gamer')
group by product_category_name
order by delay desc;

select
COUNT(DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)) AS delay,
product_category_name
from orders
left join order_items ON orders.order_id=order_items.order_id
left join products ON order_items.product_id=products.product_id
where DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)<0
AND order_status
IN ('delivered') 
group by product_category_name
order by delay desc;


Select 
COUNT(distinct s.seller_id)
from order_items o
left join products p
on o.product_id=p.product_id
left join sellers s
on o.seller_id=s.seller_id;