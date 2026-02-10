CREATE
OR REPLACE PROCEDURE "BH1_EUROFISH_PROD"."EUR_L_GET_PO_BY_DOC_NUM" (
    doc_num INT
)
LANGUAGE SQLSCRIPT
AS
BEGIN
SELECT o."DocEntry" as "doc_entry" o."DocNum" as "doc_num", o."PlannedQty" as "planned_qty"
     , (SELECT "ItemCode"   as "item_code",
               "ItemName"   as "item_name",
               "LineNum"    as "line_number",
               "ItemType"   as "item_type",
               "BaseQty"    as "base_qty",
               "PlannedQty" as "planned_qty",
               "wareHouse"  as "warehouse"
        FROM WOR1 w
        WHERE w."DocEntry" = o."DocEntry"
        ORDER BY w."LineNum"
    FOR JSON
    ) as "lines",
     (SELECT
    q."DocNum" as "quotation_doc_num",
    q."DocEntry" as "quotation_doc_entry",
    q."CardCode" as "customer_code",
    q."CardName" as "customer_name",
    q."U_SYP_NUM_CONTRATO" as "contract_number"
FROM WOR5 o5
    JOIN OQUT q ON q."DocEntry" = o5."RefDocEntr"
WHERE o5."DocEntry" = o."DocEntry"
  AND o5."RefObjType" = '23'
    FOR JSON
    ) as "quotation"
FROM OWOR o
WHERE o."DocNum" = :doc_num;
END;