CREATE OR REPLACE PROCEDURE "BH1_EUROFISH_NEW_CAPA15"."EUR_L_BUSINESS_PARTNERS"(
	card_type NVARCHAR(1),
	term NVARCHAR(80)
)
LANGUAGE SQLSCRIPT AS
BEGIN
SELECT o."CardCode",
       o."CardName",
       o."CardFName" AS "CardForeignName",
       o."CardType",
       o."Address",
       o."City",
       o."ZipCode",
       o."Cellular",
       o."Phone1",
       o."Phone2",
       o."MailAddres" AS "MailAddress",
       o."AgentCode",
       o."AliasName",
       o."CmpPrivate" AS "BusinessType",
       o."CntctPrsn" AS "ContactPerson"
FROM OCRD o
WHERE o."CardType" = :card_type
  AND (o."CardName" LIKE_REGEXPR COALESCE(:term, '\w+') FLAG 'i'
		OR o."AgentCode" LIKE_REGEXPR COALESCE(:term, '\w+') FLAG 'i'
		OR o."CardCode" LIKE_REGEXPR COALESCE(:term, '\w+') FLAG 'i'
		OR o."AliasName" LIKE_REGEXPR COALESCE(:term, '\w+') FLAG 'i'
		OR o."CardFName" LIKE_REGEXPR COALESCE(:term, '\w+') FLAG 'i')
ORDER BY o."CardName"
    FOR JSON;
END;