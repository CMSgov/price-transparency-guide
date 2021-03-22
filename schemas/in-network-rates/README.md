### In-Network File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for each plan or coverage offered by a plan or issuer. | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |
| **in_network** | In-Network | Array | An array of [in-network object types](#in-network-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |

#### In-Network Object

This type defines an in-network object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiation_arrangement** | Negotiation Arrangement | String | An indication as to whether a reimbursement arrangement other than a standard fee-for-service model applies. Allowed values: "ffs", "bundle" or "capitation" | Yes |
| **name** | Name | String | This is name of the item/service that is offered | Yes |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "ICD", and "DRG" | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | No |
| **negotiated_rates** | Negotiated Rates | Array | This is an array of [negotiated rate details object types](#negotiated-rate-details-object) | Yes |
| **bundled_codes** | Bundled Codes | Array | This is an array of [bundle code objects](#bundle-code-object). This array contains all the different codes in a bundle if `bundle` is selected for `negotiation_arrangement` | No |
| **covered_services** | Covered Service | Array | This is an array of [covered services objects](#covered-services-object). This array contains all the different codes in a capitation arrangement if `capitation` is selected for `negotiation_arrangement` | No |

#### Bundle Code Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "ICD", and "DRG" | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | No |

#### Covered Services Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "ICD", and "DRG" | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | No |

#### Negotiated Rate Details Object

This type defines a negotiated rate object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_price** | Negotiated Price |	Object | The [negotiated price object](#negotiated-price-object) defines information about the type of negotiated rate as well as the dollar amount of the negotiated rate | Yes |
| **providers** | Providers | Array | An array of provider identification numbers (NPI). This can be a list of type 1 and type 2 NPIs | Yes |
| **tin** | Tax Identification Number | String | The unique identification number issued either by the Social Security Administration or by the Internal Revenue Service (IRS). | Yes |
| **service_code** | Place of Service Code | String | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided | Yes |

#### Negotiated Price Object

The negotiated price object contains negotiated pricing information that the type of negotiation for the covered item or service.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_type** | Negotiated Type |	String | There are a few ways in which negotiated rates can happen. Allowed values: "negotiated", "derived", and "fee schedule". See additional notes. | Yes |
| **negotiated_rate** | Negotiated Rate | Number | The dollar amount based on the `negotiation_type` | Yes |
| **expiration_date** | Expiration Date | String | The date in which the agreement for the `negotiated_price` based on the `negotiated_type` ends. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |

##### Additional Notes
For `negotiated_type` there are three allowable values: "negotiated", "derived", and "fee schedule". The value are defined as:
* `negotiated`: If applicable, the negotiated rate, reflected as a dollar amount, for each covered item or service under the plan or coverage that the plan or issuer has contractually agreed to pay an in-network provider, except for prescription drugs that are subject to a fee-for-service reimbursement arrangement, which must be reported in the prescription drug machine-readable file. If the negotiated rate is subject to change based upon participant, beneficiary, or enrollee-specific characteristics, these dollar amounts should be reflected as the base negotiated rate applicable to the item or service prior to adjustments for participant, beneficiary, or enrollee-specific characteristics.
* `derived`: If applicable, the price that a plan or issuer assigns to an item or service for the purpose of internal accounting, reconciliation with providers or submitting data in accordance with the requirements of 45 CFR 153.710(c).
* `fee schedule`: If applicable, the rate for a covered item or service from a particular in-network provider, or providers that a group health plan or health insurance issuer uses to determine a participant’s, beneficiary’s, or enrollee’s cost-sharing liability for the item or service, when that rate is different from the negotiated rate.

