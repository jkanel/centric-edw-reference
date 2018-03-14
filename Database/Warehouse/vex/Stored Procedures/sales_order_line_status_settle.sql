﻿/* ################################################################################

OBJECT: vex.[sales_order_line_status_settle]

DESCRIPTION: Truncates corresponding VEX table and reloads it using settle logic.

PARAMETERS: None.

OUTPUT PARAMETERS: None.

RETURN VALUE: None.

RETURN DATASET: None.

HISTORY:

Date        Name            Version  Description
---------------------------------------------------------------------------------
2017-12-27  Jeff Kanel      1.0      Created by Centric Consulting, LLC

################################################################################ */

CREATE PROCEDURE vex.[sales_order_line_status_settle] AS
BEGIN

SET NOCOUNT ON;

TRUNCATE TABLE vex.[sales_order_line_status];

INSERT INTO vex.[sales_order_line_status] (
  sales_order_line_status_version_key
, next_sales_order_line_status_version_key
, sales_order_line_status_key
, version_index
, version_current_ind
, version_latest_ind
, end_version_dtmx
, end_version_batch_key
, end_source_rev_dtmx
)
SELECT

  v.sales_order_line_status_version_key

, LEAD(v.sales_order_line_status_version_key, 1) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) AS next_sales_order_line_status_version_key

, MIN(v.sales_order_line_status_version_key) OVER (
    PARTITION BY v.sales_order_line_status_uid) AS sales_order_line_status_key

, ROW_NUMBER() OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) AS version_index

  -- XOR "^" inverts the deleted indicator
, LAST_VALUE(v.source_delete_ind) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) ^ 1 AS version_current_ind

, CASE
  WHEN LAST_VALUE(v.sales_order_line_status_version_key) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) = v.sales_order_line_status_version_key THEN 1
  ELSE 0 END AS version_latest_ind

, LEAD(v.version_dtm, 1) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) AS end_version_dtmx

  -- Back the LEAD batch key off by 1
, LEAD(v.version_batch_key, 1) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) - 1 AS end_version_batch_key

, LEAD(v.source_rev_dtm, 1) OVER (
    PARTITION BY v.sales_order_line_status_uid
    ORDER BY v.sales_order_line_status_version_key ASC) AS end_source_rev_dtmx

FROM
ver.sales_order_line_status v

END;