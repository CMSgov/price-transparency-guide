### In-Network File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **reporting_plans** | In-Network Plans | Array  | An array of [reporting plan object types](#reporting-plans-object) | Yes |
| **in_network** | In-Network Negotiated Rates | Array | An array of [in-network object types](#in-network-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |
| **version** | Version | String | The version of the schema for the produced information | No |

#### Reporting Plans Object

Information about the plan that is being reported on for the in-network negotiated rates for all items and services. Multiple `Reporting Plan Objects` can be included in this array for all of the plans that have identical negotiated rates in the `in_network` array.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for each plan or coverage offered by a plan or issuer. | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |

#### In-Network Object

This type defines an in-network object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiation_arrangement** | Negotiation Arrangement | String | An indication as to whether a reimbursement arrangement other than a standard fee-for-service model applies. Allowed values: "ffs", "bundle" or "capitation" | Yes |
| **name** | Name | String | This is name of the item/service that is offered | Yes |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | No |
| **negotiated_rates** | Negotiated Rates | Array | This is an array of [negotiated rate details object types](#negotiated-rate-details-object) | Yes |
| **bundled_codes** | Bundled Codes | Array | This is an array of [bundle code objects](#bundle-code-object). This array contains all the different codes in a bundle if `bundle` is selected for `negotiation_arrangement` | No |
| **covered_services** | Covered Service | Array | This is an array of [covered services objects](#covered-services-object). This array contains all the different codes in a capitation arrangement if `capitation` is selected for `negotiation_arrangement` | No |

#### Bundle Code Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | Yes |

#### Covered Services Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | Yes |

#### Negotiated Rate Details Object

This type defines a negotiated rate object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_prices** | Negotiated Prices |	Array | An array of [negotiated price objects](#negotiated-price-object) defines information about the type of negotiated rate as well as the dollar amount of the negotiated rate | Yes |
| **provider_groups** | Provider Groups | Array  | The [providers object](#providers-object) defines information about the provider and their associated TIN related to the negotiated price. | Yes |

#### Providers Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **npi** | NPI | Array | An array of individual (type 1) provider identification numbers (NPI). | Yes |
| **tin** | Tax Identification Number | Object | The [tax identifier object](#tas-identifier-object) contains tax information on the place of business | Yes |

#### Tax Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **type** | Type | String | Allowed values: "ein" and "npi". | Yes |
| **value** | Value | String | Either the unique identification number issued by the Internal Revenue Service (IRS) for type "ein" or the provider's npi for type "npi". | Yes |

##### Additional Notes

For most businesses reporting cases, a tax identification number (tin) is used to represent a business. There are situations where a provider's social security number is still used as a tin. In order to keep private personally identifiable information out of these files, substitute the provider's npi number for the social security number. When a npi number is used, it is assumed that the provider would otherwise be reporting by their social security number.

#### Negotiated Price Object

The negotiated price object contains negotiated pricing information that the type of negotiation for the covered item or service.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_type** | Negotiated Type |	String | There are a few ways in which negotiated rates can happen. Allowed values: "negotiated", "derived", and "fee schedule". See additional notes. | Yes |
| **negotiated_rate** | Negotiated Rate | Number | The dollar amount based on the `negotiation_type` | Yes |
| **expiration_date** | Expiration Date | String | The date in which the agreement for the `negotiated_price` based on the `negotiated_type` ends. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD). See additional notes. | Yes |
| **service_code** | Place of Service Code | An array of two-digit strings | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided. When attribute of `billing_class` has the value of "professional", `service_code` is required.  | No |
| **billing_class** | Billing Class | String | Allowed values: "professional", "institutional" | Yes |

##### Additional Notes
For `negotiated_type` there are three allowable values: "negotiated", "derived", and "fee schedule". The value are defined as:
* `negotiated`: If applicable, the negotiated rate, reflected as a dollar amount, for each covered item or service under the plan or coverage that the plan or issuer has contractually agreed to pay an in-network provider, except for prescription drugs that are subject to a fee-for-service reimbursement arrangement, which must be reported in the prescription drug machine-readable file. If the negotiated rate is subject to change based upon participant, beneficiary, or enrollee-specific characteristics, these dollar amounts should be reflected as the base negotiated rate applicable to the item or service prior to adjustments for participant, beneficiary, or enrollee-specific characteristics.
* `derived`: If applicable, the price that a plan or issuer assigns to an item or service for the purpose of internal accounting, reconciliation with providers or submitting data in accordance with the requirements of 45 CFR 153.710(c).
* `fee schedule`: If applicable, the rate for a covered item or service from a particular in-network provider, or providers that a group health plan or health insurance issuer uses to determine a participant’s, beneficiary’s, or enrollee’s cost-sharing liability for the item or service, when that rate is different from the negotiated rate.

For `expiration_date`, there may be a situation when a contract arrangement is "[evergreen](https://www.investopedia.com/terms/e/evergreen.asp)". For evergreen contracts that automatically renew on a date provided in the contract, the expiration date you include should be the day immediately before the day of the automatic renewal.

In situation where there is not expiration date ([see discussion here](https://github.com/CMSgov/price-transparency-guide/discussions/42)), the value `9999-12-31` would be entered.


##### Additional Notes Concerning `billing_code_type`
Negotiated rates for items and services can come from a variety of billing code standards. The list of possible allowed values is in the following table with the name of the standard and the values representing that standard that would be expected if being reported on. For standards that are used for negotiated rate that are not in the following table, please open a [discussion](https://github.com/CMSgov/price-transparency-guide/discussions) to potentially add a new standard to the table.

| Standard Name | Reporting Value | Additional Information |
| ------------- | --------------- | ---------------------- |
| Current Procedural Terminology | CPT | [American Medical Association](https://www.ama-assn.org/practice-management/cpt/cpt-overview-and-code-approval) |
| National Drug Code | NDC | [FDA NDC Background](https://www.fda.gov/drugs/development-approval-process-drugs/national-drug-code-database-background-information) |
| Healthcare Common Procedural Coding System | HCPCS | [CMS HCPCS](https://www.cms.gov/Medicare/Coding/MedHCPCSGenInfo) |
| Revenue Code | RC | [What is a revenue code](https://www.e2emedicalbilling.com/blog/what-is-revenue-code/) |
| International Classification of Diseases |	ICD	| [ICD background](https://en.wikipedia.org/wiki/International_Classification_of_Diseases) |
| Medicare Severity Diagnosis Related Groups | MS-DRG | [CMS DRGs](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software) |
| Refined Diagnosis Related Groups | R-DRG | |
| Severity Diagnosis Related Groups | S-DRG | |
| All Patient, Severity-Adjusted Diagnosis Related Groups | APS-DRG | |
| All Patient Diagnosis Related Groups | AP-DRG | |
| All Patient Refined Diagnosis Related Groups | APR-DRG | [AHRQ documentation](https://www.hcup-us.ahrq.gov/db/nation/nis/APR-DRGsV20MethodologyOverviewandBibliography.pdf) |
| Ambulatory Payment Classifications | APC | [APC background information](https://www.acep.org/administration/reimbursement/reimbursement-faqs/apc-ambulatory-payment-classifications-faq/#question0) |
| Local Code Processing |LOCAL | |
| Enhanced Ambulatory Patient Grouping | EAPG | [EAPG](https://www.3m.com/3M/en_US/health-information-systems-us/drive-value-based-care/patient-classification-methodologies/enhanced-apgs/) |
| Health Insurance Prospective Payment System | HIPPS | [HIPPS](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/ProspMedicareFeeSvcPmtGen/HIPPSCodes) |
| Current Dental Terminology | CDT | [CDT](https://www.ada.org/en/publications/cdt) |
