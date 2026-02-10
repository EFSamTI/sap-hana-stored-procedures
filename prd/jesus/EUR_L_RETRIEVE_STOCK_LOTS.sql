CREATE OR REPLACE PROCEDURE "EUR_L_RETRIEVE_STOCK_LOTS" (
    lots NCLOB,
    prod_day INT
)
LANGUAGE SQLSCRIPT
AS
BEGIN

WITH ParsedLots AS (
    SELECT "unload", "item", "fadfree"
    FROM JSON_TABLE(:lots, '$[*]' COLUMNS (
            "unload" NVARCHAR(50) PATH '$.unload',
            "item" NVARCHAR(50) PATH '$.item',
            "fadfree" NVARCHAR(10) PATH '$.fadfree'
        ))
)
SELECT L."Unload", L."ItemCode", SUM(L."Quantity") as "Stock", L."FadfreeCode", L."WhsCode"
FROM "BH1_EUROFISH_PROD"."BatchesBaseData" L
         JOIN "GetItemsAttributes" IA ON IA."ItemCode" = L."ItemCode"
         JOIN ParsedLots PL ON L."Unload" = PL."unload" AND L."ItemCode" = PL."item"
WHERE L."ProdDate" = :prod_day AND (PL."fadfree" is null or L."FadfreeCode" = PL."fadfree")
GROUP BY L."Unload", L."ItemCode", L."FadfreeCode", L."WhsCode";

END;