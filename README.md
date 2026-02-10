## Regla general obligatoria
+ Usar el prefijo `EUR_L_` en los nombres de procedimientos almacenados.
+ Los procedimientos son únicamente de consulta, prohibido usar instrucciones `INSERT`, `UPDATE`, `DELETE` en los mismos.

## Datos para conectar a base y crear procedimientos

| IP           | PORT  | USER     | PASSWORD         |
|--------------|-------|----------|------------------|
| 192.168.32.2 | 30015 | B1EU_DEV | 6OR2gaqV5hQSj5i4 |

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

> uuid del ambiente de desarrollo
>
| uuid                                  | database                |
|---------------------------------------|-------------------------|
| 100a86d0-2a8b-4da5-b3d8-afde5abf4711	 | BH1_EUROFISH_NEW_CAPA15 |

## production environment

### URL: `https://frontend.eurofish.com.ec/core-prod/message/generic`

> uuid del ambiente de producción
> 
| uuid                                  | database                 |
|---------------------------------------|--------------------------|
| 578c19ea-5930-417d-8fcc-661536f0775c	 | BH1_EUROFISH_DESA        |
| e18bb8b3-b45a-4310-8bc2-1691b63d2d3e	 | BH1_EUROFISH_NEW_CAPA10  |
| bffe3624-d8b1-4459-b677-715fa787313a	 | BH1_EUROFISH_NEW_CAPA11  |
| 9894df67-4dad-43aa-a994-b61c006e0b95	 | BH1_EUROFISH_NEW_CAPA12  |
| d18b0626-8b52-4614-a05d-2833431c3c0d	 | BH1_EUROFISH_NEW_CAPA13  |
| 33cfb956-4a39-4c7b-8f2d-b12a56cada16	 | BH1_EUROFISH_NEW_CAPA14  |
| 37b25d3e-4432-47ad-92bd-53e68253b66e	 | BH1_EUROFISH_NEW_CAPA15  |
| 476adf45-fee8-4b0d-b855-8dd2d65c61b8	 | BH1_EUROFISH_PRINTEGIII  |
| 19bfdf10-252a-4cc9-b42b-b74f0362644a	 | BH1_EUROFISH_PRINTERNAII |
| 100a86d0-2a8b-4da5-b3d8-afde5abf4711	 | BH1_EUROFISH_PROD        |

### body
```json
{
  "source": "5e0bf5e2-a73b-45b0-8b11-2f828c79e4df",
  "destination": "322fa2d7-0a05-4b57-aaa9-695d956c1253",
  "operation": "R",
  "verb": "POST",
  "path": "/{{sap-uuid}}/call-procedure",
  "body": {
    "procedure": "{{SP_NAME}}",
    "params": {
    }
  }
}
```
+ procedure: Nombre del procedimiento.
+ params: Objeto JSON con pares clave: valor con los nombres y valores de los parámetros que recibe el procedimiento.

### cURL
```shell
curl --location '{{URL}}' \
--header 'X-Keycloak-Realm;' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{token}}' \
--data '{
  "source": "5e0bf5e2-a73b-45b0-8b11-2f828c79e4df",
  "destination": "322fa2d7-0a05-4b57-aaa9-695d956c1253",
  "operation": "R",
  "verb": "POST",
  "path": "/{{sap-uuid}}/call-procedure",
  "body": {
    "procedure": "{{SP_NAME}}",
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