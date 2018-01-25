DROP TABLE IF EXISTS region;
DROP EXTERNAL WEB TABLE IF EXISTS e_region;

CREATE TABLE region (
    R_REGIONKEY  INTEGER NOT NULL,
    R_NAME       CHAR(25) NOT NULL,
    R_COMMENT    VARCHAR(152) )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_region (
    R_REGIONKEY  INTEGER,
    R_NAME       CHAR(25),
    R_COMMENT    VARCHAR(152) )
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T r -s 1 "' 
ON 1 FORMAT 'TEXT' (DELIMITER '|');

INSERT INTO region SELECT * FROM e_region;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_region', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_region%';