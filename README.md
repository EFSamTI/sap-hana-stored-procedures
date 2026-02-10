## database connection

| IP           | PORT  | USER | PASSWORD |
|--------------|-------|------|----------|
| 192.168.32.2 | 30015 |      |          |

### create procedure syntax
```sql
CREATE [ OR REPLACE ] PROCEDURE <proc_name> 
   [ (<input_output_parameter_clause>) ]
   [ LANGUAGE <lang> ]
   [ SQL SECURITY { DEFINER | INVOKER } ]
   [ DEFAULT SCHEMA <default_schema_name> ]
   [ READS SQL DATA [ WITH RESULT VIEW <view_name> ] ] 
   [ <variable_cache_clause> ]
   [ DETERMINISTIC ] 
   [ WITH ENCRYPTION ]
   [ AUTOCOMMIT DDL { ON | OFF } ]
   AS 
     { BEGIN [ SEQUENTIAL EXECUTION ]
        <statement_body>
END
| HEADER ONLY }
```

### Ref: https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d467407519101484f190f545d54b24.html?locale=es-ES

## dev environment

### URL: `https://dev.eurofish.com.ec:8490/v1/api/message/generic`

## production environment

### URL: `https://frontend.eurofish.com.ec/core-prod/message/generic`

### body
```json
{
  "source": "5e0bf5e2-a73b-45b0-8b11-2f828c79e4df",
  "destination": "322fa2d7-0a05-4b57-aaa9-695d956c1253",
  "operation": "R",
  "verb": "POST",
  "path": "/100a86d0-2a8b-4da5-b3d8-afde5abf4711/call-procedure",
  "body": {
    "procedure": "EUR_L_PROD_ORDERS_BY_DATE_RANGE",
    "params": {
    }
  }
}
```
> procedure: Nombre del procedimiento.
> params: Objeto JSON con pares clave: valor con los nombres y valores de los parámetros que recibe el procedimiento.

### cURL
```shell
curl --location 'https://dev.eurofish.com.ec:8490/v1/api/message/generic' \
--header 'X-Keycloak-Realm;' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{token}}' \
--data '{
  "source": "5e0bf5e2-a73b-45b0-8b11-2f828c79e4df",
  "destination": "322fa2d7-0a05-4b57-aaa9-695d956c1253",
  "operation": "R",
  "verb": "POST",
  "path": "/100a86d0-2a8b-4da5-b3d8-afde5abf4711/call-procedure",
  "body": {
    "procedure": "EUR_L_PROD_ORDERS_BY_DATE_RANGE",
    "params": {
      "start_date": "2026-01-30",
      "end_date": "2026-01-31",
      "warehouse": null,
      "contract_number": null,
      "customer": "gourmet",
      "quotation": 250000063,
      "lvl": null,
      "product": null,
      "doc_number": null,
      "status": null
    }
  }
}'
```