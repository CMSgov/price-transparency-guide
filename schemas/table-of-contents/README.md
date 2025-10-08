### Table of Contents File
**The Table of Contents File is an optional file that can be leveraged to significantly decrease file sizes of the required machine-readable files. The Transparency in Coverage final rules do not require plans and issuers to publish a Table of Contents file.**

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **reporting_structure** | Reporting Structure | Array | An array of [reporting structure object types](#reporting-structure-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (i.e. YYYY-MM-DD) | Yes |
| **version** | Version | String | The version of the schema for the produced information | Yes |

#### Reporting Structure Object
The Reporting Structure object maps assoicated plans to their in-network and allowed amount files.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_plans** | In-Network Plans | Array  | An array of [reporting plan object types](#reporting-plans-object) | Yes |
| **in_network_files** | In Network File List | Array | An array of [file location objects](#file-location-object) contains the location of the in-network file for the associated [reporting plan object.](#reporting-plans-object) | No |
| **allowed_amount_file** | Allowed Amount File List | Object | The [file location object](#file-location-object) contains the location of the allowed amounts file for the associated [reporting plan object.](#reporting-plans-object) | No |

#### Additional Notes Concerning `in_network_files` and `allowed_amount_file`
At [least one](https://github.com/CMSgov/price-transparency-guide/blob/master/schemas/table-of-contents/table-of-contents.json#L37-L40) of these attributes need to be present in the `reporting_structure` object. The location of the files defined in `in_network_files` and `allowed_amount_file` are required to be valid [in-network](https://github.com/CMSgov/price-transparency-guide/tree/master/schemas/in-network-rates) and [allowed amounts](https://github.com/CMSgov/price-transparency-guide/tree/master/schemas/allowed-amounts) files.

#### Reporting Plans Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The plan's name. | Yes |
| **issuer_name** | Issuer Name | String | The name of the plan's issuer. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "ein" and "hios" | Yes |
| **plan_id** | Plan ID | String | If the `plan_id_type`'s value is "HIOS", the 10-digit Health Insurance Oversight System (HIOS) identifier, or, if the 10-digit HIOS identifier is not available, the 5-digit HIOS identifier. If the `plan_id_type`'s value is "EIN", the Employer Identification Number (EIN) of the plan sponsor. | Yes |
| **plan_sponsor_name** | Plan Sponsor Name | String | 	If the `plan_id_type` is "ein", the common business name of the plan sponsor is required. | No |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |

#### File Location Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **description** | Description | String | Description of the file included | Yes | 
| **location** | Description | String | A full HTTPS URL indicating where the data file can be downloaded | Yes | 

In the following example:
* `Plan A`, `Plan B`, and `Plan C` have identical negotiated rates for all items/services for the **in-network** file. (in-network-file-1.json)
* `Plan C` is unique with its negotiated rates. (BH-health-shared-0002.json)
* `Plan A` and `Plan C` both didn't meet the 20 claim threshold for any services for the **allowed amounts** file. (allowed-amounts-file-empty.json)
* `Plan B` met the 20 claim threshold for multiple services for the **allowed amounts** file. (allowed-amounts-file-1.json)
* `Plan A`, `Plan B`, and `Plan C` all have different HIOS numbers, they are different products.

```json
{
  "reporting_entity_name":"...",
  "reporting_entity_type":"...",
  "reporting_structure":[
    {
      "reporting_plans":[{
          "plan_name":"Plan A",
          "plan_id_type":"hios",
          "plan_id":"0000000000",
          "issuer_name": "ACME Payer 1",
          "plan_market_type":"individual"
        },{
          "plan_name":"Plan B",
          "plan_id_type":"hios",
          "plan_id":"11111111111",
          "issuer_name": "ACME Payer 2",
          "plan_market_type":"individual"
        }],
      "in_network_files":[{
        "description":"in-network file",
        "location":"https://www.some_site.com/files/in-network-file-1.json"
      }]
    },{
      "reporting_plans":[{
          "plan_name":"Plan C",
          "plan_id_type":"hios",
          "plan_id":"222222222",
          "issuer_name": "ACME Payer 3",
          "plan_market_type":"individual"
        }],
      "in_network_files":[{
        "description":"in-network file primary",
        "location":"https://www.some_site.com/files/in-network-file-1.json"
      },
      {
        "description":"behavioral health shared file",
        "location":"https://www.some_site.com/files/BH-health-shared-0002.json"
      }],
      "allowed_amount_file":{
        "description":"allowed amount file",
        "location":"https://www.some_site.com/files/allowed-amounts-file-empty.json"
      }
    },{
      "reporting_plans":[
        {
          "plan_name":"Plan A",
          "plan_id_type":"hios",
          "plan_id":"0000000000",
          "issuer_name": "ACME Payer 1",
          "plan_market_type":"individual"
        }],
      "allowed_amount_file":{
        "description":"allowed amount file",
        "location":"https://www.some_site.com/files/allowed-amounts-file-empty.json"
      }
    },{
      "reporting_plans":[
        {
          "plan_name":"Plan B",
          "plan_id_type":"hios",
          "plan_id":"11111111111",
          "issuer_name": "ACME Payer 2",
          "plan_market_type":"individual"
        }],
      "allowed_amount_file":{
        "description":"allowed amount file",
        "location":"https://www.some_site.com/files/allowed-amounts-file-1.json"
      }
    }]
}
```
