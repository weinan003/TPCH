-- ----------------------------------------------------------------------

DROP TABLE IF EXISTS customer_TABLESUFFIX;
DROP EXTERNAL WEB TABLE IF EXISTS e_customer_TABLESUFFIX;

CREATE TABLE customer_TABLESUFFIX (
    C_CUSTKEY     INTEGER NOT NULL,
    C_NAME        VARCHAR(25) NOT NULL,
    C_ADDRESS     VARCHAR(40) NOT NULL,
    C_NATIONKEY   INTEGER NOT NULL,
    C_PHONE       CHAR(15) NOT NULL,
    C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
    C_MKTSEGMENT  CHAR(10) NOT NULL,
    C_COMMENT     VARCHAR(117) NOT NULL )
WITH (SQLSUFFIX)
DISTRIBUTED BY(C_CUSTKEY);

CREATE EXTERNAL WEB TABLE e_customer_TABLESUFFIX (
    C_CUSTKEY     INTEGER,
    C_NAME        VARCHAR(25),
    C_ADDRESS     VARCHAR(40),
    C_NATIONKEY   INTEGER,
    C_PHONE       CHAR(15),
    C_ACCTBAL     DECIMAL(15,2),
    C_MKTSEGMENT  CHAR(10),
    C_COMMENT     VARCHAR(117) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T c -s SCALEFACTOR -N NUMSEGMENTS -n $((GP_SEGMENT_ID + 1))"'
ON NUMSEGMENTS FORMAT 'TEXT' (DELIMITER '|');

INSERT INTO customer_TABLESUFFIX SELECT * FROM e_customer_TABLESUFFIX;

-- ----------------------------------------------------------------------

DROP EXTERNAL TABLE IF EXISTS customer_w_hdfstextsimple;
DROP EXTERNAL TABLE IF EXISTS customer_r_PXF_TABLE_SUFFIX;

CREATE WRITABLE EXTERNAL TABLE customer_w_hdfstextsimple (
    C_CUSTKEY     INTEGER,
    C_NAME        VARCHAR(25),
    C_ADDRESS     VARCHAR(40),
    C_NATIONKEY   INTEGER,
    C_PHONE       CHAR(15),
    C_ACCTBAL     DECIMAL(15,2),
    C_MKTSEGMENT  CHAR(10),
    C_COMMENT     VARCHAR(117) )
    LOCATION ('pxf://PXF_NAMENODE:51200PXF_WRITABLE_PATH/customer_hdfstextsimple?PROFILE=HdfsTextSimple')
    FORMAT 'TEXT' (delimiter=E',');

INSERT INTO customer_w_hdfstextsimple SELECT * FROM customer_TABLESUFFIX;

CREATE READABLE EXTERNAL TABLE customer_r_PXF_TABLE_SUFFIX (
    C_CUSTKEY     INTEGER,
    C_NAME        VARCHAR(25),
    C_ADDRESS     VARCHAR(40),
    C_NATIONKEY   INTEGER,
    C_PHONE       CHAR(15),
    C_ACCTBAL     DECIMAL(15,2),
    C_MKTSEGMENT  CHAR(10),
    C_COMMENT     VARCHAR(117) )
    LOCATION ('pxf://PXF_NAMENODE:51200/PXF_OBJECT_PATHcustomer_EXTERNAL_DATA_FORMAT?PROFILE=PXF_PROFILE')
    FORMAT 'PXF_FORMAT_TYPE' (PXF_FORMAT_OPTIONS);

-- ----------------------------------------------------------------------

