DROP TABLE IF EXISTS partsupp;
DROP EXTERNAL WEB TABLE IF EXISTS e_partsupp;

CREATE TABLE partsupp (
    PS_PARTKEY     INTEGER NOT NULL,
    PS_SUPPKEY     INTEGER NOT NULL,
    PS_AVAILQTY    INTEGER NOT NULL,
    PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
    PS_COMMENT     VARCHAR(199) NOT NULL )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_partsupp (
    PS_PARTKEY     INTEGER,
    PS_SUPPKEY     INTEGER,
    PS_AVAILQTY    INTEGER,
    PS_SUPPLYCOST  DECIMAL(15,2),
    PS_COMMENT     VARCHAR(199) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T S -s 1 -N 6 -n $((GP_SEGMENT_ID + 1))"'
ON 6 FORMAT 'TEXT' (DELIMITER '|');

INSERT INTO partsupp SELECT * FROM e_partsupp;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_partsupp', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_partsupp%';