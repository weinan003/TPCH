DROP TABLE IF EXISTS supplier;
DROP EXTERNAL WEB TABLE IF EXISTS e_supplier;

CREATE TABLE supplier (
    S_SUPPKEY     INTEGER NOT NULL,
    S_NAME        CHAR(25) NOT NULL,
    S_ADDRESS     VARCHAR(40) NOT NULL,
    S_NATIONKEY   INTEGER NOT NULL,
    S_PHONE       CHAR(15) NOT NULL,
    S_ACCTBAL     DECIMAL(15,2) NOT NULL,
    S_COMMENT     VARCHAR(101) NOT NULL )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_supplier (
    S_SUPPKEY     INTEGER ,
    S_NAME        CHAR(25) ,
    S_ADDRESS     VARCHAR(40) ,
    S_NATIONKEY   INTEGER ,
    S_PHONE       CHAR(15) ,
    S_ACCTBAL     DECIMAL(15,2) ,
    S_COMMENT     VARCHAR(101) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T s -s 1 -N 6 -n $((GP_SEGMENT_ID + 1))"'
ON 6 FORMAT 'TEXT' (DELIMITER '|');

INSERT INTO supplier SELECT * FROM e_supplier;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_supplier', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_supplier%';