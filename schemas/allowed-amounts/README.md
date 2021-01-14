### Out-Of-Network Allowed Amount File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company (for example, “Maximum Health Plan: Alpha Insurance Group”). | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" or "HIOS" | No |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number [(EIN)](https://en.wikipedia.org/wiki/Employer_Identification_Number), for each coverage option offered by a plan or issuer. | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" or "individual" | Yes |
| **out_of_network** | Out Of Network | Array | An array of [out-of-network object types](#out-of-network-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |

#### Out-Of-Network Object

The out-of-network object contains information related to the service that was provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Name | String | The name of each item or service for which the costs are payable, in whole or in part, under the terms of the plan or coverage. | Yes |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "NDC", "HCPCS", "ICD", and "DRG" | Yes |
| **billing_code** | Billing Code | String | The `billing_code_type` code for the item/service | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **description** | Description | String | Brief description of the item or service. In the case of items and services that are associated with common billing codes (such as the HCPCS codes), the codes’ associated short text description may be provided. In the case of NDCs for prescription drugs, the plain language description must be the proprietary and nonproprietary names assigned to the NDC by the FDA | Yes |
| **allowed_amounts** | Rates |	Array | An array of [allowed amounts objects](#allowed-amounts-object) | Yes |

#### Allowed Amounts Object

The allowed amounts object documents the entity or business and service code in where the service was provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **tin** | Tax Identification Number | String | The unique identification number issued either by the Social Security Administration or by the Internal Revenue Service (IRS). | Yes |
| **service_code** | Place of Service Code | String | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided | Yes |
| **payments** | Payments |	Array | An array of [out-of-network payments objects](#out-of-network-payment-object) | Yes |

#### Out-Of-Network Payment Object

The payment object documents the allowed amounts the plan has paid for the service that was provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **allowed_amount** | Allowed Amount | Number | The allowed amount must be reported as the actual dollar amount the plan or issuer paid to the out-of-network provider for a particular covered item or service, plus the participant’s, beneficiary’s, or enrollee’s share of the cost. See additional notes. | Yes |
| **providers** | Providers |	Array | An array of [provider objects](#provider-object) | Yes |

##### Additional Notes
The `allowed_amount` is each unique allowed amount, reflected as a dollar amount, that a plan or issuer paid for a covered item or service furnished by an out-of-network provider during the 90-day time period that begins 180 days prior to the publication date of the machine-readable file. To protect patient privacy, a plan or issuer must not provide out-of-network allowed amount data for a particular provider and a particular item or service when compliance would require the plan or issuer to report out-of-network allowed amounts paid to a particular provider in connection with fewer than 20 different claims for payment. Issuers, service providers, or other parties with which the plan or issuer has contracted may aggregate out-of-network allowed amounts for more than one plan or insurance policy or contract. If information is aggregated, the 20 minimum claims threshold applies at the plan or issuer level.

#### Provider Object

The provider object defines the list of NPIs and their billed charges for the service provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billed_charge** | Billed Charge | Number | The total dollar amount charges for an item or service billed to a plan or issuer by an out-of-network provider. | Yes |
| **npi** | National Provider Identifier | Array | An array of provider identification numbers (NPI) | Yes |

