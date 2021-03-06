-- ----------------------------------------------------------------------

DROP TABLE IF EXISTS orders_TABLESUFFIX;
DROP EXTERNAL WEB TABLE IF EXISTS e_orders_TABLESUFFIX;

CREATE TABLE orders_TABLESUFFIX (
    O_ORDERKEY       INT8 NOT NULL,
    O_CUSTKEY        INTEGER NOT NULL,
    O_ORDERSTATUS    CHAR(1) NOT NULL,
    O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
    O_ORDERDATE      DATE NOT NULL,
    O_ORDERPRIORITY  CHAR(15) NOT NULL,
    O_CLERK          CHAR(15) NOT NULL,
    O_SHIPPRIORITY   INTEGER NOT NULL,
    O_COMMENT        VARCHAR(79) NOT NULL )
WITH (SQLSUFFIX)
DISTRIBUTED BY(O_ORDERKEY) PARTITIONS;

CREATE EXTERNAL WEB TABLE e_orders_TABLESUFFIX (
    O_ORDERKEY       INT8,
    O_CUSTKEY        INTEGER,
    O_ORDERSTATUS    CHAR(1),
    O_TOTALPRICE     DECIMAL(15,2),
    O_ORDERDATE      DATE,
    O_ORDERPRIORITY  CHAR(15),
    O_CLERK          CHAR(15),
    O_SHIPPRIORITY   INTEGER,
    O_COMMENT        VARCHAR(79) ) 
EXECUTE E'bash -c "$GPHOME/bin/dbgen -b $GPHOME/bin/dists.dss -T O -s SCALEFACTOR -N NUMSEGMENTS -n $((GP_SEGMENT_ID + 1))"'
ON NUMSEGMENTS FORMAT 'TEXT' (DELIMITER '|')
LOG ERRORS INTO errortable_orders_TABLESUFFIX SEGMENT REJECT LIMIT 100 PERCENT;

INSERT INTO orders_TABLESUFFIX SELECT * FROM e_orders_TABLESUFFIX;

-- ----------------------------------------------------------------------

DROP EXTERNAL TABLE IF EXISTS orders_w_hdfstextsimple;
DROP EXTERNAL TABLE IF EXISTS orders_r_PXF_TABLE_SUFFIX;

CREATE WRITABLE EXTERNAL TABLE orders_w_hdfstextsimple (
    O_ORDERKEY       INT8,
    O_CUSTKEY        INTEGER,
    O_ORDERSTATUS    CHAR(1),
    O_TOTALPRICE     DECIMAL(15,2),
    O_ORDERDATE      DATE,
    O_ORDERPRIORITY  CHAR(15),
    O_CLERK          CHAR(15),
    O_SHIPPRIORITY   INTEGER,
    O_COMMENT        VARCHAR(79) )
    LOCATION ('pxf://PXF_NAMENODE:51200PXF_WRITABLE_PATH/orders_hdfstextsimple?PROFILE=HdfsTextSimple')
    FORMAT 'TEXT' (delimiter=E',');

INSERT INTO orders_w_hdfstextsimple SELECT * FROM orders_TABLESUFFIX;

CREATE READABLE EXTERNAL TABLE orders_r_PXF_TABLE_SUFFIX (
    O_ORDERKEY       INT8,
    O_CUSTKEY        INTEGER,
    O_ORDERSTATUS    CHAR(1),
    O_TOTALPRICE     DECIMAL(15,2),
    O_ORDERDATE      DATE,
    O_ORDERPRIORITY  CHAR(15),
    O_CLERK          CHAR(15),
    O_SHIPPRIORITY   INTEGER,
    O_COMMENT        VARCHAR(79) )
    LOCATION ('pxf://PXF_NAMENODE:51200/PXF_OBJECT_PATHorders_EXTERNAL_DATA_FORMAT?PROFILE=PXF_PROFILE')
    FORMAT 'PXF_FORMAT_TYPE' (PXF_FORMAT_OPTIONS);

-- ----------------------------------------------------------------------

