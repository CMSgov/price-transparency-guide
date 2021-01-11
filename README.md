# Transparency in Coverage
The technical implementation guide for the machine readable files as required by the [Transparency in Coverage](https://www.federalregister.gov/documents/2019/11/27/2019-25011/transparency-in-coverag) final rules (85 FR 72158).

Overview
========

This repository contains a set of schemas describing a data format (example implementations are encoded as JSON and XML) for the Transparency in Coverage final rule.
All machine-readable files must conform to a non-proprietary, open standards format that is platform independent and made available to the public without restrictions that would impede the re-use of that information.

Background
==========

The Departments of the Treasury, Labor, and Health and Human Services (the Departments) have issued the Transparency in Coverage final rules (85 FR 72158) on November 12, 2020. The final rules require non-grandfathered group health plans and health insurance issuers in the individual and group markets (plans and issuers) to disclose certain pricing information. Under the final rules a plan or issuer must disclose in-network negotiated rates, billed and out-of-network allowed, and in-network drug prices (including both “negotiated rates” and “historical net prices”) through three machine-readable files posted on an internet website.  

Plans and issuers are required to make these files public for plan or policy years beginning on or after January 1, 2022.

Developer Documentation
=======================

Transport mechanism - HTTPS
--------------------------

All machine-readable files must be made available via HTTPS.

Content type - Non-Proprietary, Open Format
-------------------

There are plenty of great formats to work with that will meet the needs for Transparency in Coverage:
* [JSON](https://www.json.org/)
* [XML](http://www.xml.org/)
* [YAML](https://yaml.org/)

Examples of proprietary formats that do *not* meet this definition would be:
* [PDF](https://en.wikipedia.org/wiki/PDF)
* [XLS/XLSX](https://en.wikipedia.org/wiki/Microsoft_Excel#File_formats) 

Public Discoverability
----------------------

These machine-readable files post made available to the public without restrictions that would impede the re-use of that information.

The location of the these URLs *must* be provided over HTTPS to ensure the integrity of the data.

Special Data Types
------------------

Dates should be strings in [ISO 8601 format](https://en.wikipedia.org/wiki/ISO_8601) (e.g. YYYY-MM-DD).

Different Flat Files
--------------------

There three required flat files associated with Transparency in Coverage:
* In-Network Negotiated Rates
* Out-Of-Network Allowed Amounts
* In-Network Prescription Drugs

**In-Network Negotiated Rates File**
Under the finalized rules, a plan or issuer must disclose in-network provider negotiated rates for all items and services through a machine-readable file.

**Out-Of-Network Allowed Amounts File**
Under the finalized rules, a plan or issuer must disclose certain data elements to the public, including the billed and allowed amounts for out-of-network providers, through a machine-readable file.

**In-Network Prescription Drugs File**
Under the finalized rules, a plan or issuer must disclose in-network prescription drug's historical net price and negotiated rate through a machine-readable file.

The associated names for those files are:
* `in-network-rates`
* `allowed-amounts`
* `prescription-drugs`

File Naming Convention  
-------------------------
The following is the required naming standard for each file: `<YYYY-MM-DD>_<payer or issuer name>_<plan name>_<file type name>.json`

For example, the following would be the required naming for CMS:
* `2020-01-05_cms_medicare_negotiated-rates.json`
* `2020-01-05_cms_medicare_allowed-amounts.json`
* `2020-01-05_cms_medicare_prescription-drugs.json`

Schemas
=======

### In-Network File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company. | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | No |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN)for each plan or coverage offered by a plan or issuer. | No |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |
| **in_network** | In-Network | Array | An array of [in-network object types](#in-network-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |

#### In-Network Object

This type defines an in-network object.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **payment_type** | Payment Type | String | An indication as to whether a reimbursement arrangement other than a standard fee-for-service model applies. Allowed values: "bundle" or "capitation"| No |
| **name** | Name | String | This is name of the item/service that is offered | Yes |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "ICD", and "DRG" | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **billing_code** | Billing Code | String | The code used by a plan or issuer or its in-network providers to identify health care items or services for purposes of billing, adjudicating, and paying claims for a covered item or service. | Yes |
| **description** | Description | String | Brief description of the item/service | No |
| **negotiated_rates** | Negotiated Rates | Array | This is an array of [negotiated rate details object types](#negotiated-rate-details-object) | Yes |

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

### Out-Of-Network Allowed Amount File

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company (for example, “Maximum Health Plan: Alpha Insurance Group”). | Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" or "HIOS" | No |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number [(EIN)](https://en.wikipedia.org/wiki/Employer_Identification_Number), for each coverage option offered by a plan or issuer. | Yes |
| **market_type** | Market Type | String | Allowed values: "group" or "individual" | Yes |
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

### Rx file schema

This schema describes the Rx attributes that are necessary for the drug flat file.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company (for example, “Maximum Health Plan: Alpha Insurance Group”). | Yes |
| **plan_id_type** | Plan ID Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN), for each coverage option offered by a plan or issuer | Yes |
| **market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |
| **drugs** | Drugs |	Array | An array of [drug information objects](#drug-object) | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |

#### Drug Object

This type defines a drug object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **drug_name** | Drug Name |	String | The proprietary and nonproprietary name assigned to the National Drug Code (NDC) by the Food and Drug Administration (FDA). | Yes |
| **drug_type** | Drug Type |	String | Allowed values: "branded", "generic", or "biosimilar" | Yes |
| **ndc** | National Drug Code | String | A unique 10-digit or 11-digit, 3-segment number assigned by the FDA, which provides a universal product identifier for drugs in the United States.  Data reporting will be on the **first 8 digits** of the full 10-digit or 11-digit NDCs. The last 2 digits of the full 10-digit or 11-digit NDC specify quantity and do not have an impact on the negotiated rate or historic net price. | Yes |
| **prices** | Prices | Array | An array of [drug price objects](#drug-price-object) | Yes |

#### Drug Price Object

This type defines a drug price object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **historical_net_price** | Historical Net Price |	Number | The retrospective average amount paid, reflected as a dollar amount, by a plan or issuer to an in-network provider for a prescription drug. See additional notes. | Yes |
| **historical_net_reporting_period** | Historical Net Price Reporting Period |	String | The date in which the reporting period for the `historical_net_price` ended. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |
| **negotiated_rate** | Negotiated Rate |	Number | The amount, reflected as a dollar amount, that a plan or issuer has contractually agreed to pay an in-network provider. See additional notes. | Yes |
| **administrative_fee** | Administrative Fee | Number | The fee, reflected as a dollar amount, charged by the Pharmacy Benefit Manager to the plan or issuer for administrating each prescription. This fee must be reflected separately only for the negotiated rate data element. | Yes |
| **dispensing_fee** | Dispensing Fee | Number | The fee, reflected as a dollar amount, for dispensing a prescription applied at the point of sale. This fee must be reflected separately only for the negotiated rate data element. | Yes |
| **transaction_fee** | Transaction Fee |	Number | Any fees, reflected as a dollar amount, assessed when processing a prescription that is not associated with the administrative or dispensing fee. This fee must be reflected separately only for the negotiated rate data element. | Yes |
| **tin** | Tax Identification Number | String | The unique identification number issued either by the Social Security Administration or by the Internal Revenue Service (IRS). | Yes |
| **service_code** | Place of Service Code | String | The [CMS-maintained two-digit code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) that is placed on a professional claim to indicate the setting in which a service was provided | Yes |
| **providers** | Providers |	Array | A list of different [providers objects](#provider-object) that have specific negotiated rates for the specific `ndc` | Yes |

##### Additional Notes
The `historical_net_price` is the average dollar price for the 90-day period beginning 180 days before the file publication date, including any in-network pharmacy or other prescription drug dispenser, for a prescription drug, inclusive of any _reasonably allocated rebates, discounts, chargebacks, fees, and any additional price concessions received by the plan or issuer_ with respect to the prescription drug or prescription drug service.  The historic net price must be reported at the billing unit level as defined by the NCPDP. The standard contains three units: Each “EA,” Milliliter “ML,” or Gram “GM.”

Further notes for _reasonable allocation of rebates, discounts, chargebacks, fees, and any additional price concessions_.
* If the total amount of the price concession is known to the plan or issuer on the file publication date, then rebates, discounts, chargebacks, fees, and other price concessions must be reasonably allocated by total known dollar amount.
* If the total amount of the price concession is not known to the plan or issuer on the file publication date, then rebates, discounts, chargebacks, fees, and other price concessions should be reasonably allocated using a good faith, reasonable estimate of the average price concessions based on the rebates, discounts, chargebacks, fees, and other price concessions received over a time period prior to the current reporting period and of equal duration to the current reporting period.

The `negotiated_rate` is the rate agreed to pay an in-network provider, including an in-network pharmacy or other prescription drug dispenser, whether directly or indirectly, including through a third-party administrator or pharmacy benefit manager, for prescription drugs. The negotiated rate must be reported at the billing unit level as defined by NCPDP. The standard contains three units “EA,” “ML,” or “GM.” Fees that are assessed at the point of sale must be reflected separately as a dollar amount (see Dispensing Fee, Administrative Fee, and Transaction Fee data elements). 

Fees that are assessed at the point of sale must be reflected separately as a dollar amount (see `dispensing_fee`, `administrative_fee`, and `transaction_fee` data elements).

#### Provider Object

Different types of providers and pharmacies that have the specific negotiated rate and historical net price for the defined NDC.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **pharmacy_id_type** | Provider ID Type |	String | Allowed values: “NCPDP ID,” “NCPDP Chain Code,” or “NPI”. Note: NPIs must be of type 2 to be included in `pharmacy_ids` | Yes |
| **pharmacy_ids** | Pharmacy IDs | Array | The National Council for Prescription Drug Programs (NCPDP) ID5 - The unique 7-digit number assigned by the NCPDP to every licensed pharmacy and non-Pharmacy Dispensing Site (NPDS) in the United States and its territories. This number represents a unique pharmacy entity or line of business and is used to identify licensed pharmacies and NPDSs to insurance companies, health care providers, and other entities. The NCPDP Chain Code6 - The ID number provided by the NCPDP that represents a group of pharmacies under the same ownership.  If the plan or issuer includes the NCPDP Chain Code, it must also include the NCPDP IDs for each pharmacy that is represented in the group of pharmacies that are identified by the NCPDP Chain Code. | Yes |
| **npi** | National Provider Identifier | Array | An array of provider identification numbers (NPI) | Yes |

### Examples
* [In-Network Sample](https://github.com/CMSgov/price-transparency-guide/blob/master/examples/in-network-sample.json)
* [Out-of-Network Sample](https://github.com/CMSgov/price-transparency-guide/blob/master/examples/out-of-network-sample.json)
* [Prescription Drug Sample](https://github.com/CMSgov/price-transparency-guide/blob/master/examples/out-of-network-sample.json)
