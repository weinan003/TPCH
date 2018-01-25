DROP TABLE IF EXISTS nation;
DROP EXTERNAL WEB TABLE IF EXISTS e_nation;

CREATE TABLE nation (
    N_NATIONKEY  INTEGER NOT NULL,
    N_NAME       CHAR(25) NOT NULL,
    N_REGIONKEY  INTEGER NOT NULL,
    N_COMMENT    VARCHAR(152) )
WITH (appendonly = true, orientation = PARQUET, pagesize = 1048576, rowgroupsize = 8388608)
DISTRIBUTED RANDOMLY;

CREATE EXTERNAL WEB TABLE e_nation (
    N_NATIONKEY  INTEGER,
    N_NAME       CHAR(25),
    N_REGIONKEY  INTEGER,
    N_COMMENT    VARCHAR(152) )
EXECUTE E'bash -c \"$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T n -s 1\"' 
ON 1 FORMAT 'TEXT' (DELIMITER'|');

INSERT INTO nation SELECT * FROM e_nation;
select '***', 'tpch_parquet_1gpn_nocomp_nopart_wwang_nation', sess_id from pg_stat_activity where current_query like '%tpch_parquet_1gpn_nocomp_nopart_wwang_nation%';