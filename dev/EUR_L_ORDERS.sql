CREATE OR REPLACE PROCEDURE "BH1_EUROFISH_NEW_CAPA15"."EUR_L_ORDERS"(
	start_date DATE,
	end_date DATE,
	customer NVARCHAR(80)
)
LANGUAGE SQLSCRIPT AS
BEGIN
SELECT "DocNum", "CardCode", "CardName", "JrnlMemo" AS "JournalMemo"
FROM ORDR o
WHERE TO_DATE(o."DocDueDate") BETWEEN :start_date AND :end_date
  AND (
    o."CardCode" LIKE_REGEXPR COALESCE(:customer, o."CardCode") FLAG 'i'
			OR
			o."CardName" LIKE_REGEXPR COALESCE(:customer, o."CardName") FLAG 'i'
    )
ORDER BY o."DocNum"
    FOR JSON;
END;