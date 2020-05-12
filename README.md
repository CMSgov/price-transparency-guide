# price-transparency-guide
The technical implementation guide for the TriDepartmental price transparency rule.

Overview
========

This repository set of schemas describing a data format (encoded as JSON, XML, and CSV) for the TriDepartement Price Transparency NPRM.
All machine-readable files must conform to a non-proprietary, open standards format that is platform independent and made available to the public without restrictions that would impede the re-use of that information.

Background
==========

Beginning in 2019, CMS worked to define a schema for sharing data in a machine-readable format that would allow for greater price transparency of both items and services that healthcare providers, health insurance issuers, and self-insured group health plans  provide to consumers before they receive care. These files are intended to be used by technical folks that could then build services, APIs, mobile applications, or anything else the market can think of to empower consumers to make informed decisions when it comes to managing their own care.

Developer Documentation
=======================

Transport mechanism - HTTPS
--------------------------

All machine-readable files must be made available via HTTPS.

Content type - Non-Proprietary, Open Format
-------------------

There are plenty of great formats to work with that will meet the needs for the TriDepartmental Price Transparency NPRM:
* [JSON](https://www.json.org/)
* [XML](http://www.xml.org/)
* [CSV](https://en.wikipedia.org/wiki/Comma-separated_values)

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

Health Plan - plan\_\<plan name>.json (e.g. `plan_medicare.json`)
-------------------------

### Description

`plan_<plan name>.json` contains a specific pricing information for both in-network and out-of-network prices for a plan for items and services that are being offered at the place of care.


### Schema

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The name of the plan of which these prices are set for the given items and services| Yes |
| **plan_id_type** | Plan Id Type | String | Allowed values: "EIN" and "HIOS" | No |
| **plan_id** | Plan ID | String | If available, this will be either the plan's [EIN](https://en.wikipedia.org/wiki/Employer_Identification_Number) or the 14-character, HIOS-generated Plan ID number. (Plan IDs must be unique, even across different markets.) | No |
| **market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |
| **in_network** | In-Network | Array | An array of in-network object types | Yes |
| **out_of_network** | Out-Of-Network | Array | An array of out-of-network object types | Yes |
| **last_updated_on** | Last Updated On | String | The date in which the file was last updated. Date must be in an ISO 8601 format (e.g. YYYY-MM-DD) | Yes |


#### In-Network Object

This type defines an in-network object that has a price and is offered by the care setting

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **type** | Type | String | This attribute defines the category of charge. Allowed valued are: "item" and "service" | Yes |
| **name** | Name | String | This is name of the item/service that is offered | Yes |
| **expiration_date** | Expiration Date | String | The expiration date of each provider-specific negotiated rate that applies to each item or service (including rates for both individual and bundled items and services). | Yes |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "NDC", and "DRG" | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **billing_code** | Billing Code | String | The code for the item/service | Yes |
| **description** | Description | String | Brief description of the item/service | No |
| **negotiated_rates** | Negotiated Rates | Array | This is an array of negotiated rate objects | Yes |

#### Negotiated Rate Object

This type defines a negotiated rate object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_rate** | Negotiated Rate |	Number | Negotiated rates with respect to each covered item or service under a plan or coverage. Where a plan or issuer reimburses providers for an item or service based on a formula or reference based-pricing (such as a percentage of a Medicare reimbursement rate), the plan or issuer must provide the calculated dollar amount of the negotiated rate for each provider. Negotiated rates must be clearly associated with the provider’s National Provider Identifier, which is accessible by providers, plans and issuers. | Yes |
| **providers** | Providers | Array | An array of NPI numbers | Yes |

#### Out-of-Network Object

This type defines an out-of-network object that has a price for out-of-network customers that is offered by the care setting

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **type** | Type | String | Identifier of an item or service. Allowed values are: "item" and "service" | Yes |
| **name** | Name | String | This is the name of either the item or service | Yes |
| **billing_code_type** | Billing Code Type | String | Allowed values: "CPT", "HCPCS", "NDC", and "DRG" | Yes |
| **billing_code** | Billing Code | String | The code for the item/service | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | There might be versions associated with the `billing_code_type`. For example, Medicare is currently using ICD's version 10 | Yes |
| **description** | Description | String | Brief description of the item/service | No |
| **payments** | Rates |	Array | An array of out-of-network payments objects | Yes |

#### Out-Of-Network Payment Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **allowed_amount** | Allowed Amount | Number | The actual amount paid to the provider for the service performed after all deductions and calculations are performed. This does not include the amount paid fee for service on a capitated service. | Yes |
| **npi** | National Provider Index | Array | An array of 9-digit provider identification numbers (NPI) | Yes |

### Examples
* [In-Network Sample](https://github.com/CMSgov/price-transparency-guide/blob/master/in-network-sample.json)
* [Out-of-Network Sample](https://github.com/CMSgov/price-transparency-guide/blob/master/out-of-network-sample.json)
