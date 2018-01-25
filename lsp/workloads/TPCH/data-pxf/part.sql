-- ----------------------------------------------------------------------

DROP TABLE IF EXISTS part_TABLESUFFIX;
DROP EXTERNAL WEB TABLE IF EXISTS e_part_TABLESUFFIX;

CREATE TABLE part_TABLESUFFIX (
    P_PARTKEY     INTEGER NOT NULL,
    P_NAME        VARCHAR(55) NOT NULL,
    P_MFGR        CHAR(25) NOT NULL,
    P_BRAND       CHAR(10) NOT NULL,
    P_TYPE        VARCHAR(25) NOT NULL,
    P_SIZE        INTEGER NOT NULL,
    P_CONTAINER   CHAR(10) NOT NULL,
    P_RETAILPRICE DECIMAL(15,2) NOT NULL,
    P_COMMENT     VARCHAR(23) NOT NULL )
WITH (SQLSUFFIX)
DISTRIBUTED BY(P_PARTKEY);

CREATE EXTERNAL WEB TABLE e_part_TABLESUFFIX (
    P_PARTKEY     INTEGER,
    P_NAME        VARCHAR(55),
    P_MFGR        CHAR(25),
    P_BRAND       CHAR(10),
    P_TYPE        VARCHAR(25),
    P_SIZE        INTEGER,
    P_CONTAINER   CHAR(10),
    P_RETAILPRICE DECIMAL(15,2),
    P_COMMENT     VARCHAR(23) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T P -s SCALEFACTOR -N NUMSEGMENTS -n $((GP_SEGMENT_ID + 1))"'
ON NUMSEGMENTS FORMAT 'TEXT' (DELIMITER'|');

INSERT INTO part_TABLESUFFIX SELECT * FROM e_part_TABLESUFFIX;

-- ----------------------------------------------------------------------

DROP EXTERNAL TABLE IF EXISTS part_w_hdfstextsimple;
DROP EXTERNAL TABLE IF EXISTS part_r_PXF_TABLE_SUFFIX;

CREATE WRITABLE EXTERNAL TABLE part_w_hdfstextsimple (
    P_PARTKEY     INTEGER,
    P_NAME        VARCHAR(55),
    P_MFGR        CHAR(25),
    P_BRAND       CHAR(10),
    P_TYPE        VARCHAR(25),
    P_SIZE        INTEGER,
    P_CONTAINER   CHAR(10),
    P_RETAILPRICE DECIMAL(15,2),
    P_COMMENT     VARCHAR(23) )
    LOCATION ('pxf://PXF_NAMENODE:51200PXF_WRITABLE_PATH/part_hdfstextsimple?PROFILE=HdfsTextSimple')
    FORMAT 'TEXT' (delimiter=E',');

INSERT INTO part_w_hdfstextsimple SELECT * FROM part_TABLESUFFIX;

CREATE READABLE EXTERNAL TABLE part_r_PXF_TABLE_SUFFIX (
    P_PARTKEY     INTEGER,
    P_NAME        VARCHAR(55),
    P_MFGR        CHAR(25),
    P_BRAND       CHAR(10),
    P_TYPE        VARCHAR(25),
    P_SIZE        INTEGER,
    P_CONTAINER   CHAR(10),
    P_RETAILPRICE DECIMAL(15,2),
    P_COMMENT     VARCHAR(23) )
    LOCATION ('pxf://PXF_NAMENODE:51200/PXF_OBJECT_PATHpart_EXTERNAL_DATA_FORMAT?PROFILE=PXF_PROFILE')
    FORMAT 'PXF_FORMAT_TYPE' (PXF_FORMAT_OPTIONS);

-- ----------------------------------------------------------------------

