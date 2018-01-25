DROP VIEW IF EXISTS revenue;

CREATE VIEW revenue (supplier_no, total_revenue) AS
    SELECT l_suppkey, sum(l_extendedprice * (1 - l_discount))
    FROM lineitem
    WHERE l_shipdate >= date '1997-04-01' AND l_shipdate < date '1997-04-01' + interval '90 days'
    GROUP BY l_suppkey;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_revenue', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_revenue%';