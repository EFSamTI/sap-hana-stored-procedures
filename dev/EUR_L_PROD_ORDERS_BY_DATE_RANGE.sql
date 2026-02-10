CREATE OR REPLACE PROCEDURE "BH1_EUROFISH_NEW_CAPA15"."EUR_L_PROD_ORDERS_BY_DATE_RANGE" (
	IN start_date DATE,
	IN end_date DATE,
	IN warehouse NVARCHAR(8),
	IN contract_number NVARCHAR(30),
	IN customer NVARCHAR(80),
	IN quotation INT,
	IN lvl NVARCHAR(10),
	IN product NVARCHAR(80),
	IN doc_number INT,
	IN status NVARCHAR(1)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
SELECT o."DocEntry",
       o."DocNum" AS "DocumentNumber",
       o."ItemCode" AS "ItemNo",
       o."ProdName" AS "ProductDescription",
       o."Warehouse",
       o."U_SYP_NIVEL",
       o."U_SYP_ORDEN_N1",
       o."U_SYP_ORDEN_N2",
       o."U_SYP_ORDEN_N3",
       TO_NVARCHAR(o."StartDate", 'YYYY-MM-DD') AS "StartDate",
       TO_DATE(o."DueDate") AS "DueDate",
       TO_DATE(o."PostDate") AS "PostingDate",
       o."PlannedQty" AS "PlannedQuantity",
       o."OriginType" AS "ProductionOrderOrigin",
       o."OriginAbs" AS "ProductionOrderOriginEntry",
       o."OriginNum" AS "ProductionOrderOriginNumber",
       o."Status" AS "ProductionOrderStatus",
       (
           SELECT "DocNum",
                  "CardCode",
                  "CardName",
                  "U_SYP_NUM_CONTRATO"
           FROM OQUT q
           WHERE o5."RefDocEntr" = q."DocEntry"
    FOR JSON
    ) AS "Quotation",
    (
SELECT "LineNum" AS "LineNumber",
    "ItemCode" AS "ItemNo",
    "ItemName",
    "BaseQty" AS "BaseQuantity",
    "PlannedQty" AS "PlannedQuantity",
    "IssuedQty" AS "IssuedQuantity",
    "wareHouse" AS "Warehouse",
    "ItemType"
FROM WOR1 w
WHERE w."DocEntry" = o."DocEntry"
ORDER BY "LineNum"
    FOR JSON
    ) AS "DocumentLines"
FROM OWOR o JOIN WOR5 o5 ON o5."DocEntry" = o."DocEntry"
    JOIN OQUT q ON q."DocEntry" = o5."RefDocEntr"
WHERE (
    o5."RefObjType" = '23'
  AND
    TO_DATE(o."DueDate") BETWEEN :start_date AND :end_date
    )
  AND o."Warehouse" = COALESCE(:warehouse, o."Warehouse")
  AND o."U_SYP_NIVEL" = COALESCE(:lvl, o."U_SYP_NIVEL")
  AND o."ProdName" LIKE_REGEXPR COALESCE(:product, o."ProdName") FLAG 'i'
  AND o."DocNum" = COALESCE(:doc_number, o."DocNum")
  AND o."Status" = COALESCE(:status, o."Status")
  AND (
    q."CardCode" LIKE_REGEXPR COALESCE(:customer, q."CardCode") FLAG 'i'
   OR
    q."CardName" LIKE_REGEXPR COALESCE(:customer, q."CardName") FLAG 'i'
    )
  AND q."DocNum" = COALESCE(:quotation, q."DocNum")
  AND q."U_SYP_NUM_CONTRATO" LIKE_REGEXPR COALESCE(:contract_number, q."U_SYP_NUM_CONTRATO") FLAG 'i'
ORDER BY o."DueDate" DESC FOR JSON;
END;