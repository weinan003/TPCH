explain analyze 
select
 p_brand,
 p_type,
 p_size,
 count(distinct ps_suppkey) as supplier_cnt
from
 partsupp_TABLESUFFIX,
 part_TABLESUFFIX
where
 p_partkey = ps_partkey
 and p_brand <> 'Brand#45'
 and p_type not like 'ECONOMY BURNISHED%'
 and p_size in (9, 6, 45, 44, 47, 21, 14, 42)
 and ps_suppkey not in (
 select
 s_suppkey
 from
 supplier_TABLESUFFIX
 where
 s_comment like '%Customer%Complaints%'
 )
group by
 p_brand,
 p_type,
 p_size
order by
 supplier_cnt desc,
 p_brand,
 p_type,
 p_size;