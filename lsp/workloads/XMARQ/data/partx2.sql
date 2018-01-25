DROP TABLE IF EXISTS partx2_TABLESUFFIX;

CREATE TABLE partx2_TABLESUFFIX (
    P_PARTKEY     INTEGER NOT NULL,
    P_NAME        VARCHAR(55) NOT NULL,
    P_MFGR        CHAR(25) NOT NULL,
    P_BRAND       CHAR(10) NOT NULL,
    P_TYPE        VARCHAR(25) NOT NULL,
    P_SIZE        INTEGER NOT NULL,
    P_CONTAINER   CHAR(10) NOT NULL,
    P_RETAILPRICE DECIMAL(15,2) NOT NULL,
    P_COMMENT     VARCHAR(23) NOT NULL )
WITH (SQLSUFFIX) DISTRIBUTED by (P_SIZE, P_BRAND, P_CONTAINER);
