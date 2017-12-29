﻿CREATE TABLE [vex].[legal_entity] (

  legal_entity_version_key INT NOT NULL
, legal_entity_key INT NOT NULL

  -- GRAIN COLUMNS
, legal_entity_uid VARCHAR(200) NOT NULL

  -- VERSION ATTRIBUTES
, version_index INT NOT NULL
, version_current_ind BIT NOT NULL
, version_latest_ind BIT NOT NULL

  -- END OF RANGE COLUMNS
, end_version_dtmx DATETIME2 NULL
, end_version_batch_key INT NULL
, end_source_rev_dtmx DATETIME2 NULL

, CONSTRAINT vex_legal_entity_pk PRIMARY KEY (legal_entity_version_key)
)
;
GO

CREATE UNIQUE INDEX vex_legal_entity_u1 ON vex.legal_entity (legal_entity_version_key) WHERE version_latest_ind = 1;
GO
