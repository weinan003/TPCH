DROP TABLE IF EXISTS orders;
DROP EXTERNAL WEB TABLE IF EXISTS e_orders;

CREATE TABLE orders (
    O_ORDERKEY       INT8 NOT NULL,
    O_CUSTKEY        INTEGER NOT NULL,
    O_ORDERSTATUS    CHAR(1) NOT NULL,
    O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
    O_ORDERDATE      DATE NOT NULL,
    O_ORDERPRIORITY  CHAR(15) NOT NULL,
    O_CLERK          CHAR(15) NOT NULL,
    O_SHIPPRIORITY   INTEGER NOT NULL,
    O_COMMENT        VARCHAR(79) NOT NULL )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY ;

CREATE EXTERNAL WEB TABLE e_orders (
    O_ORDERKEY       INT8,
    O_CUSTKEY        INTEGER,
    O_ORDERSTATUS    CHAR(1),
    O_TOTALPRICE     DECIMAL(15,2),
    O_ORDERDATE      DATE,
    O_ORDERPRIORITY  CHAR(15),
    O_CLERK          CHAR(15),
    O_SHIPPRIORITY   INTEGER,
    O_COMMENT        VARCHAR(79) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T O -s 1 -N 6 -n $((GP_SEGMENT_ID + 1))"'
ON 6 FORMAT 'TEXT' (DELIMITER '|')
LOG ERRORS INTO errortable_orders SEGMENT REJECT LIMIT 100 PERCENT;

INSERT INTO orders SELECT * FROM e_orders;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_orders', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_orders%';