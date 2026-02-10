CREATE OR REPLACE PROCEDURE "BH1_EUROFISH_NEW_CAPA15"."EUR_L_BIN_LOCATIONS"(
	warehouse NVARCHAR(8),
	code NVARCHAR(120),
	enabled NVARCHAR(1)
)
LANGUAGE SQLSCRIPT AS
BEGIN
SELECT b."AbsEntry", b."BinCode", b."WhsCode", w."BinActivat"
FROM OWHS w
         JOIN OBIN b ON b."WhsCode" = w."WhsCode"
WHERE w."WhsCode" = COALESCE(:warehouse, w."WhsCode")
  AND b."BinCode" LIKE_REGEXPR COALESCE(:code, b."BinCode") FLAG 'i'
		AND w."BinActivat" = :enabled
ORDER BY b."BinCode" FOR JSON;
END;