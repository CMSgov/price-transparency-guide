### Out-Of-Network Allowed Amount File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **reporting_plans** | Allowed Amount Plans | Array  | An array of [reporting plan object types](#reporting-plans-object) | Yes |
| **out_of_network** | Out Of Network | Array | An array of [out-of-network object types](#out-of-network-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |
| **version** | Version | String | The version of the schema for the produced information | No |

#### Reporting Plans Object

Information about the plan that is being reported on for the allowed amounts. Multiple `Reporting Plan Objects` can be included in this array for all of the plans that have identical out-of-network objects in the `out_of_network` array.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for    each plan or coverage offered by a plan or issuer. | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |

#### Out-Of-Network Object

The out-of-network object contains information related to the service that was provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Name | String | The name of each item or service for which the costs are payable, in whole or in part, under the terms of the plan or coverage. | Yes |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code** | Billing Code | String | The `billing_code_type` code for the item/service | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2 | Yes |
| **description** | Description | String | Brief description of the item or service. In the case of items and services that are associated with common billing codes (such as the HCPCS codes), the codes’ associated short text description may be provided. In the case of NDCs for prescription drugs, the plain language description must be the proprietary and nonproprietary names assigned to the NDC by the FDA | Yes |
| **allowed_amounts** | Rates |	Array | An array of [allowed amounts objects](#allowed-amounts-object) | Yes |

#### Allowed Amounts Object

The allowed amounts object documents the entity or business and service code in where the service was provided out-of-network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **tin** | Tax Identification Number | Object | The [tax identifier object](#tas-identifier-object) contains tax information on the place of business | Yes |
| **service_code** | Place of Service Code | An array of two-digit strings | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided. When attribute of `billing_class` has the value of "professional", `service_code` is required.  | No |
| **billing_class** | Billing Class | String | Allowed values: "professional", "institutional" | Yes |
| **payments** | Payments |	Array | An array of [out-of-network payments objects](#out-of-network-payment-object) | Yes |

#### Tax Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **type** | Type | String | Allowed values: "ein" and "npi". | Yes |
| **value** | Value | String | Either the unique identification number issued by the Internal Revenue Service (IRS) for type "ein" or the provider's npi for type "npi". | Yes |

##### Additional Notes

For most businesses reporting cases, a tax identification number (tin) is used to represent a business. There are situations where a provider's social security number is still used as a tin. In order to keep private personally identifiable information out of these files, substitute the provider's npi number for the social security number. When a npi number is used, it is assumed that the provider would otherwise be reporting by their social security number.

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


##### Additional Notes Concerning `billing_code_type`
Negotiated rates for items and services can come from a variety of billing code standards. The list of possible allowed values is in the following table with the name of the standard and the values representing that standard that would be expected if being reported on. For standards that are used for negotiated rate that are not in the following table, please open a [discussion](https://github.com/CMSgov/price-transparency-guide/discussions) to potentially add a new standard to the table.

| Standard Name | Reporting Value | Additional Information |
| ------------- | --------------- | ---------------------- |
| Current Procedural Terminology | CPT | [American Medical Association](https://www.ama-assn.org/practice-management/cpt/cpt-overview-and-code-approval) |
| National Drug Code | NDC | [FDA NDC Background](https://www.fda.gov/drugs/development-approval-process-drugs/national-drug-code-database-background-information) |
| Healthcare Common Procedural Coding System | HCPCS | [CMS HCPCS](https://www.cms.gov/Medicare/Coding/MedHCPCSGenInfo) |
| Revenue Code | RC | [What is a revenue code](https://www.e2emedicalbilling.com/blog/what-is-revenue-code/) |
| International Classification of Diseases | ICD | [ICD background](https://en.wikipedia.org/wiki/International_Classification_of_Diseases) |
| Medicare Severity Diagnosis Related Groups | MS-DRG | [CMS DRGs](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software) |
| Refined Diagnosis Related Groups | R-DRG | |
| Severity Diagnosis Related Groups | S-DRG | |
| All Patient, Severity-Adjusted Diagnosis Related Groups | APS-DRG | |
| All Patient Diagnosis Related Groups | AP-DRG | |
| All Patient Refined Diagnosis Related Groups | APR-DRG | [AHRQ documentation](https://www.hcup-us.ahrq.gov/db/nation/nis/APR-DRGsV20MethodologyOverviewandBibliography.pdf) |
| Ambulatory Payment Classifications | APC | [APC background information](https://www.acep.org/administration/reimbursement/reimbursement-faqs/apc-ambulatory-payment-classifications-faq/#question0) |
| Local Processing  | LOCAL | |
| Enhanced Ambulatory Patient Grouping | EAPG |[EAPG](https://www.3m.com/3M/en_US/health-information-systems-us/drive-value-based-care/patient-classification-methodologies/enhanced-apgs/) |
| Health Insurance Prospective Payment System | HIPPS | [HIPPS](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/ProspMedicareFeeSvcPmtGen/HIPPSCodes)| 
| Current Dental Terminology | CDT | [CDT](https://www.ada.org/en/publications/cdt)  | 
