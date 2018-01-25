DROP TABLE IF EXISTS customer;
DROP EXTERNAL WEB TABLE IF EXISTS e_customer;

CREATE TABLE customer (
    C_CUSTKEY     INTEGER NOT NULL,
    C_NAME        VARCHAR(25) NOT NULL,
    C_ADDRESS     VARCHAR(40) NOT NULL,
    C_NATIONKEY   INTEGER NOT NULL,
    C_PHONE       CHAR(15) NOT NULL,
    C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
    C_MKTSEGMENT  CHAR(10) NOT NULL,
    C_COMMENT     VARCHAR(117) NOT NULL )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_customer (
    C_CUSTKEY     INTEGER,
    C_NAME        VARCHAR(25),
    C_ADDRESS     VARCHAR(40),
    C_NATIONKEY   INTEGER,
    C_PHONE       CHAR(15),
    C_ACCTBAL     DECIMAL(15,2),
    C_MKTSEGMENT  CHAR(10),
    C_COMMENT     VARCHAR(117) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T c -s 1 -N 6 -n $((GP_SEGMENT_ID + 1))"'
ON 6 FORMAT 'TEXT' (DELIMITER '|');

INSERT INTO customer SELECT * FROM e_customer;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_customer', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_customer%';