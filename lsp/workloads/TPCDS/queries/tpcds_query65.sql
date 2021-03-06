--@author guz4
--@description TPC-DS tpcds_query65
--@created 2013-03-06 18:02:02
--@created 2013-03-06 18:02:02
--@tags tpcds orca

-- start query 1 in stream 0 using template query65.tpl
select  s_store_name, i_item_desc, sc.revenue
 from store_TABLESUFFIX, item_TABLESUFFIX,
     (select ss_store_sk, avg(revenue) as ave
 	from
 	    (select  ss_store_sk, ss_item_sk, 
 		     sum(ss_sales_price) as revenue
 		from store_sales_TABLESUFFIX, date_dim_TABLESUFFIX
 		where ss_sold_date_sk = d_date_sk and d_year = 2000
 		group by ss_store_sk, ss_item_sk) sa
 	group by ss_store_sk) sb,
     (select  ss_store_sk, ss_item_sk, sum(ss_sales_price) as revenue
 	from store_sales_TABLESUFFIX, date_dim_TABLESUFFIX
 	where ss_sold_date_sk = d_date_sk and d_year = 2000
 	group by ss_store_sk, ss_item_sk) sc
 where sb.ss_store_sk = sc.ss_store_sk and 
       sc.revenue <= 0.1 * sb.ave and
       s_store_sk = sc.ss_store_sk and
       i_item_sk = sc.ss_item_sk
 order by s_store_name, i_item_desc, sc.revenue
limit 100;

-- end query 1 in stream 0 using template query65.tpl
