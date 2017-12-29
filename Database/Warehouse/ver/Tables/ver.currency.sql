﻿CREATE TABLE [ver].[currency] (

  -- VERSION KEY (named for the table, not grain)
  currency_version_key int IDENTITY(1000,1) NOT NULL

  -- GRAIN COLUMNS
, currency_uid VARCHAR(200) NOT NULL

  -- FOREIGN KEY COLUMNS

  -- ATTRIBUTE COLUMNS
, currency_desc varchar(200) NOT NULL
, currency_code varchar(20) NOT NULL
, currency_symbol nvarchar(20) NULL

  -- SOURCE COLUMNS (Passive)
, source_uid VARCHAR(200) NOT NULL
, source_rev_dtm DATETIME NOT NULL
, source_rev_actor VARCHAR(200) NULL
, source_delete_ind BIT NOT NULL

  -- VERSION COLUMNS (Passive)
, version_dtm DATETIME2
, version_batch_key INT

, CONSTRAINT ver_currency_pk PRIMARY KEY NONCLUSTERED (currency_version_key)

);
GO

-- NOTE: clustered inded on the Grain Columns is important for
--   later joins in the Warehouse queries
CREATE CLUSTERED INDEX ver_currency_cx ON ver.currency (currency_uid);
GO

