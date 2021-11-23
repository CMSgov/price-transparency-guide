### Table of Contents File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **reporting_structure** | Reporting Structure | Array | An array of [reporting structure object types](#reporting-structure) | Yes |

#### Reporting Structure Object
The Reporting Structure object maps assoicated plans to their in-network and allowed amount files.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_plans** | In-Network Plans | Array  | An array of [reporting plan object types](#reporting-plans-object) | Yes |
| **in_network_file** | In Network File List | Object | The [file location object](#file-location-object) contains the location of the in-network file for the associated [reporting plan object.](#reporting-plans-object) | Yes |
| **allowed_amount_file** | Allowed Amount File List | Object | The [file location object](#file-location-object) contains the location of the allowed amounts file for the associated [reporting plan object.](#reporting-plans-object) | Yes |

#### Reporting Plans Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for each plan or coverage offered by a plan or issuer. | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |

#### File Location Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **description** | Description | String | Description of the file included | Yes | 
| **location** | Description | String | A full fully qualified domain name on where the in-network data can be downloaded | Yes | 
