DROP TABLE IF EXISTS part;
DROP EXTERNAL WEB TABLE IF EXISTS e_part;

CREATE TABLE part (
    P_PARTKEY     INTEGER NOT NULL,
    P_NAME        VARCHAR(55) NOT NULL,
    P_MFGR        CHAR(25) NOT NULL,
    P_BRAND       CHAR(10) NOT NULL,
    P_TYPE        VARCHAR(25) NOT NULL,
    P_SIZE        INTEGER NOT NULL,
    P_CONTAINER   CHAR(10) NOT NULL,
    P_RETAILPRICE DECIMAL(15,2) NOT NULL,
    P_COMMENT     VARCHAR(23) NOT NULL )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_part (
    P_PARTKEY     INTEGER,
    P_NAME        VARCHAR(55),
    P_MFGR        CHAR(25),
    P_BRAND       CHAR(10),
    P_TYPE        VARCHAR(25),
    P_SIZE        INTEGER,
    P_CONTAINER   CHAR(10),
    P_RETAILPRICE DECIMAL(15,2),
    P_COMMENT     VARCHAR(23) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T P -s 1 -N 6 -n $((GP_SEGMENT_ID + 1))"'
ON 6 FORMAT 'TEXT' (DELIMITER'|');

INSERT INTO part SELECT * FROM e_part;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_part', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_part%';