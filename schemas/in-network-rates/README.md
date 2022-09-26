### In-Network File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | No |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | No |
| **plan_id** | Plan ID | String | The 10-digit Health Insurance Oversight System (HIOS) identifier, or, if the 10-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for each plan or coverage offered by a plan or issuer. | No |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | No |
| **in_network** | In-Network Negotiated Rates | Array | An array of [in-network object types](#in-network-object) | Yes |
| **provider_references** | Provider References | Array | An array of [provider reference object types.](#provider-reference-object) | No |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (i.e. YYYY-MM-DD) | Yes |
| **version** | Version | String | The version of the schema for the produced information | Yes |

##### Additional Notes Concerning `plan_name`, `plan_id_type`, `plan_id`, `plan_market_type`
These attributes are not required for files that will be reporting multiple plans per file but ARE REQUIRED for single plans that are being reported that do not wish to create a table-of-content file. For payers/issuers that will be reporting multiple plans per file, these attributes will be required in a table-of-contents file.

#### In-Network Object

This type defines an in-network object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiation_arrangement** | Negotiation Arrangement | String | An indication as to whether a reimbursement arrangement other than a standard fee-for-service model applies. Allowed values: "ffs", "bundle", or "capitation" | Yes |
| **name** | Name | String | This is name of the item/service that is offered | Yes |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2. If there is no version available for the `billing_code_type`, use the current plan's year `YYYY` that is being disclosed.  | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. If a custom code is used for `billing_code_type`, please refer to [custom billing code values](#additional-notes-concerning-billing_code) |  Yes |
| **description** | Description | String | Brief description of the item/service | Yes |
| **negotiated_rates** | Negotiated Rates | Array | This is an array of [negotiated rate details object types](#negotiated-rate-details-object) | Yes |
| **bundled_codes** | Bundled Codes | Array | This is an array of [bundle code objects](#bundle-code-object). This array contains all the different codes in a bundle if `bundle` is selected for `negotiation_arrangement` | No |
| **covered_services** | Covered Service | Array | This is an array of [covered services objects](#covered-services-object). This array contains all the different codes in a capitation arrangement if `capitation` is selected for `negotiation_arrangement` | No |

#### Bundle Code Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2. If there is no version available for the `billing_code_type`, use the current plan's year `YYYY` that is being disclosed. | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. If a custom code is used for `billing_code_type`, please refer to [custom billing code values](#additional-notes-concerning-billing_code)| Yes |
| **description** | Description | String | Brief description of the item/service | Yes |

#### Covered Services Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | Common billing code types. Please see a list of the [currently allowed codes](#additional-notes-concerning-billing_code_type) at the bottom of this document. | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare's current (as of 5/24/21) MS-DRG version is 37.2. If there is no version available for the `billing_code_type`, use the current plan's year `YYYY` that is being disclosed. | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. If a custom code is used for `billing_code_type`, please refer to [custom billing code values](#additional-notes-concerning-billing_code)| Yes |
| **description** | Description | String | Brief description of the item/service | Yes |

#### Negotiated Rate Details Object

This type defines a negotiated rate object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_prices** | Negotiated Prices |	Array | An array of [negotiated price objects](#negotiated-price-object) defines information about the type of negotiated rate as well as the dollar amount of the negotiated rate | Yes |
| **provider_groups** | Provider Groups | Array | The [providers object](#providers-object) defines information about the provider and their associated TIN related to the negotiated price. | No |
| **provider_references** | Provider References | Array | An array of `provider_group_id`s defined in the [provider reference Object.](#provider-reference-object) | No |

##### Additional Notes Concerning `provider_groups`, `provider_references`
Either a `provider_groups` or `provider_references` attribute will be required in the Negotiated Rate Object to map the provider network to the item/service that is being documented. The schema requirements can be found [here](https://github.com/CMSgov/price-transparency-guide/blob/master/schemas/in-network-rates/in-network-rates.json#L197-L200).

#### Providers Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **npi** | NPI | Array | An array of National Provider Identifiers (NPIs). The NPI array attribute can contain a mix of Type 1 and Type 2 NPIs, both of which must be provided, if available. In contractual arrangements with Type 2 NPIs where Type 1 NPIs are unknown or otherwise unavailable, only the Type 2 NPIs must be reported. | Yes |
| **tin** | Tax Identification Number | Object | The [tax identifier object](#tas-identifier-object) contains tax information on the place of business | Yes |

#### Tax Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **type** | Type | String | Allowed values: "ein" and "npi". | Yes |
| **value** | Value | String | Either the unique identification number issued by the Internal Revenue Service (IRS) for type "ein" or the provider's npi for type "npi". | Yes |

##### Additional Notes

For most businesses reporting cases, a tax identification number (tin) is used to represent a business. There are situations where a provider's social security number is still used as a tin. In order to keep private personally identifiable information out of these files, substitute the provider's npi number for the social security number. When a npi number is used, it is assumed that the provider would otherwise be reporting by their social security number.

In contractual arrangements that are only made at the TIN level, where NPIs are unknown or otherwise unavailable, the value "0" should be reported for the NPI field. In contractual arrangements where both the NPI and TIN are available, both are required to be disclosed.
#### Provider Reference Object

This type defines a provider reference object. This object is used in the `provider_references` array found on the root object of the in-network schema. The Provider Group Id is a unique interger ID that is defined by the user to be referenced in the [Negotiated Rate Details Object](#negotiated-rate-details-object) in the `provider_references` array. An example of using provider references can be found in the definition of [provider reference objects](https://github.com/CMSgov/price-transparency-guide/blob/c3ba257f41f4b289b574557e2fcf0833c36ef79f/examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json#L10-L28) and then the usages of the `provider_group_id`s in the [negotiated rate object](https://github.com/CMSgov/price-transparency-guide/blob/c3ba257f41f4b289b574557e2fcf0833c36ef79f/examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json#L86).

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_group_id** | Provider Group Id |	Number | The unique, primary key for the associated `provider_group` object | Yes |
| **provider_groups** | Provider Groups | Array  | The [providers object](#providers-object) defines information about the provider and their associated TIN related to the negotiated price. | No |
| **location** | Location | String  | A fully qualified domain name on where the provider group data can be downloaded. The file must validate against the requirements found in the [provider reference](https://github.com/CMSgov/price-transparency-guide/tree/master/examples/provider-reference). Examples can be found [here](https://github.com/CMSgov/price-transparency-guide/blob/574caa73dd0a1f49c7b4696f585dc6f8b087d67a/examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json#L25-L28) that would link to a valid provider reference file such as one found [here](https://github.com/CMSgov/price-transparency-guide/blob/master/examples/provider-reference/provider-reference.json). | No |

##### Additional Notes Concerning `provider_group`, `location`
Either a `provider_group` or `location` attribute will be required in the Provider Reference Object.

#### Negotiated Price Object

The negotiated price object contains negotiated pricing information that the type of negotiation for the covered item or service.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_type** | Negotiated Type |	String | There are a few ways in which negotiated rates can happen. Allowed values: "negotiated", "derived", "fee schedule", "percentage", and "per diem". See [additional notes](#additional-notes-1). | Yes |
| **negotiated_rate** | Negotiated Rate | Number | The dollar or percentage amount based on the `negotiation_type` | Yes |
| **expiration_date** | Expiration Date | String | The date in which the agreement for the `negotiated_price` based on the `negotiated_type` ends. Date must be in an ISO 8601 format (i.e. YYYY-MM-DD). See additional notes. | Yes |
| **service_code** | Place of Service Code | An array of two-digit strings | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided. When attribute of `billing_class` has the value of "professional", `service_code` is required.  | No |
| **billing_class** | Billing Class | String | Allowed values: "professional", "institutional" | Yes |
| **billing_code_modifier** | Billing Code Modifier | Array | An array of strings. There are certain billing code types that allow for modifiers (e.g. The CPT coding type allows for modifiers). If a negotiated rate for a billing code type is dependent on a modifier for the reported item or service, then an additional negotiated price object should be included to represent the difference. | No |
| **additional_information** | Additional Information | String | The additional information text field can be used to provide context for negotiated arrangements that do not fit the existing schema format. Please open a Github discussion to ask a question about your situation if you plan to use this attribute. | No |

##### Additional Notes
For `negotiated_type` there are five allowable values: "negotiated", "derived", "fee schedule", "percentage", and "per diem". The value are defined as:
* `negotiated`: If applicable, the negotiated rate, reflected as a dollar amount, for each covered item or service under the plan or coverage that the plan or issuer has contractually agreed to pay an in-network provider, except for prescription drugs that are subject to a fee-for-service reimbursement arrangement, which must be reported in the prescription drug machine-readable file. If the negotiated rate is subject to change based upon participant, beneficiary, or enrollee-specific characteristics, these dollar amounts should be reflected as the base negotiated rate applicable to the item or service prior to adjustments for participant, beneficiary, or enrollee-specific characteristics.
* `derived`: If applicable, the price that a plan or issuer assigns to an item or service for the purpose of internal accounting, reconciliation with providers or submitting data in accordance with the requirements of 45 CFR 153.710(c).
* `fee schedule`: If applicable, the rate for a covered item or service from a particular in-network provider, or providers that a group health plan or health insurance issuer uses to determine a participant’s, beneficiary’s, or enrollee’s cost-sharing liability for the item or service, when that rate is different from the negotiated rate.
* `percentage`: If applicable, the negotiated percentage value for a covered item or service from a particular in-network provider for a percentage of billed charges arrangement. Note: percentage values entered into the `negotiated_rate` attribute are to be a whole number percentage of the negotiated arrangement (i.e. 40.5% should be entered as 40.5 and not .405).
* `per diem`: If applicable, the per diem daily rate, reflected as a dollar amount, for each covered item or service under the plan or coverage that the plan or issuer has contractually agreed to pay an in-network provider.

For `expiration_date`, there may be a situation when a contract arrangement is "[evergreen](https://www.investopedia.com/terms/e/evergreen.asp)". For evergreen contracts that automatically renew on a date provided in the contract, the expiration date you include should be the day immediately before the day of the automatic renewal.

In situation where there is not expiration date ([see discussion here](https://github.com/CMSgov/price-transparency-guide/discussions/42)), the value `9999-12-31` would be entered.

For `service_code`, if a negotiated rate for either "professional" or "institutional" `billing_class` is the same for all `service_code`s, the custom value of `CSTM-00` can be used to avoid listing all possible service codes.


##### Additional Notes Concerning `billing_code_type`
Negotiated rates for items and services can come from a variety of billing code standards. The list of possible allowed values is in the following table with the name of the standard and the values representing that standard that would be expected if being reported on. For standards that are used for negotiated rate that are not in the following table, please open a [discussion](https://github.com/CMSgov/price-transparency-guide/discussions) to potentially add a new standard to the table.

There are custom `billing_code_type`s defined for the Transparency in Coverage rule. These coding types are prefixed with `CTSM-`. These coding types are meant to help with generic reporting. The complete list can be found the in following table.

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
| Custom Code Type: All | CSTM-ALL | This is a custom coding type defined for the Transparency in Coverage rule. This value represents all possible coding types under the contractual arrangement |


##### Additional Notes Concerning `billing_code`
The following are custom defined billing codes that can be applied to any `billing_code_type`s:

| Reporting Value | Additional Information |
| --------------- | ---------------------- |
| CSTM-00 | Represents all possible `billing_code` values for the defined `billing_code_type`. Typically this can be used when a negotiated arrangement applies to all codes under a `billing_code_type` |

The following would applied the `negotiated_price` object(s) to all CPT codes:
```json
{
 "negotiation_arrangement": "ffs",
 "name": "CPT codes",
 "billing_code_type": "CPT",
 "billing_code_type_version": "2020",
 "billing_code": "CSTM-00",
 "description": "All CPT codes",
 "negotiated_rates": [{
   "provider_groups": [{
     "npi": [6666666666],
     "tin":{
       "type": "npi",
       "value": "6666666666"
     }
   }],
   "negotiated_prices": [{
     "negotiated_type": "negotiated",
     "negotiated_rate": 12.45,
     "expiration_date": "2022-01-01",
     "service_code": ["18", "19", "11"],
     "billing_class": "institutional"
   }]
 }
```

The following would applied the `negotiated_price` object(s) to each `billing_code_type` defined at [here](#additional-notes-concerning-billing_code_type). NOTE: the `billing_code_type_version` would apply to the current plan's year.

```json
{
 "negotiation_arrangement": "ffs",
 "name": "All coding types",
 "billing_code_type": "CSTM-ALL",
 "billing_code_type_version": "2022",
 "billing_code": "CSTM-00",
 "description": "All codes possible",
 "negotiated_rates": [{
   "provider_groups": [{
     "npi": [6666666666],
     "tin":{
       "type": "npi",
       "value": "6666666666"
     }
   }],
   "negotiated_prices": [{
     "negotiated_type": "negotiated",
     "negotiated_rate": 12.45,
     "expiration_date": "2022-01-01",
     "service_code": ["18", "19", "11"],
     "billing_class": "institutional"
   }]
 }
```

