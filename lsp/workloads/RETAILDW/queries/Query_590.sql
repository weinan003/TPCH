-- Average number of items bought by all customers in 2010 by month
SELECT ROUND(AVG(item_count),2) AS average_item_count
FROM  (SELECT customer_id
       ,      to_char(order_datetime, 'YYYY/MM') as order_month
       ,      sum(item_quantity) AS item_count
       FROM   retail_demo.order_lineitems
       WHERE  order_datetime BETWEEN timestamp '2010-01-01' AND date '2010-12-31'
       GROUP BY customer_id
       ,      to_char(order_datetime, 'YYYY/MM')
       ORDER BY to_char(order_datetime, 'YYYY/MM')
      )lineitems
;
