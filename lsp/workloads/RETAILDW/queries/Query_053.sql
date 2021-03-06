 -- count of orders, customers, total qty, total amt for Photography - 2011-07-22
 select c.category_name 
 ,      count(distinct o.product_id) as prod_cnt 
 ,      count(distinct o.order_id) as order_cnt 
 ,      count(distinct o.customer_id) as cust_cnt 
 ,      sum(item_quantity) as total_qty 
 ,      sum(item_price * item_quantity) as total_amt 
 from   retail_demo.order_lineitems o 
 ,      retail_demo.products_dim p 
 ,      retail_demo.categories_dim c 
 where o.product_id = p.product_id 
 and    p.category_id = c.category_id 
 and    p.category_id = 3
 and    o.order_datetime between timestamp '2011-07-22' and date '2011-07-22' + 1 
 group by c.category_name 
 
;
