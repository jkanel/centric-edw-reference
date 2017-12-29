﻿CREATE TABLE [vex].[country_xref] (

  -- KEY COLUMNS
  country_xref_version_key INT NOT NULL
, country_xref_key INT NOT NULL

  -- GRAIN COLUMNS
, country_xref_uid VARCHAR(200) NOT NULL

  -- VERSION ATTRIBUTES
, version_index INT NOT NULL
, version_current_ind BIT NOT NULL
, version_latest_ind BIT NOT NULL

  -- END OF RANGE COLUMNS
, end_version_dtmx DATETIME2 NULL
, end_version_batch_key INT NULL
, end_source_rev_dtmx DATETIME2 NULL

, CONSTRAINT vex_country_xref_pk PRIMARY KEY (country_xref_version_key)
)
;
GO

CREATE UNIQUE INDEX vex_country_xref_u1 ON vex.country_xref (country_xref_version_key) WHERE version_latest_ind = 1;
GO

