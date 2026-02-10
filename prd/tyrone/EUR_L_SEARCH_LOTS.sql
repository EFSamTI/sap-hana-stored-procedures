CREATE OR REPLACE PROCEDURE  "EUR_L_SEARCH_LOTS" (
      code NVARCHAR(50),
      unloadCode NVARCHAR(12),
      prodDay INT,
      groupCode  NVARCHAR(12) DEFAULT NULL,
      lot NVARCHAR(20) DEFAULT NULL
)
LANGUAGE SQLSCRIPT
AS
BEGIN

SELECT TOP 100
L.*, IA."GroupCode", IA."GroupName"
FROM "BH1_EUROFISH_PROD"."LotBase" L
         JOIN "GetItemsAttributes" IA ON IA."ItemCode" = L."ItemCode"
WHERE L."Quantity" > 0 and L."ItemCode"=:code
  AND (:groupCode IS NULL OR IA."GroupCode" = :groupCode)
  AND L."Unload" = :unloadCode
  AND L."ProdDate" = :prodDay
  AND (:lot IS NULL OR L."BatchNum" LIKE_REGEXPR :lot FLAG 'i');
END;