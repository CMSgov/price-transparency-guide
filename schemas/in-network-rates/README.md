### In-network Rate File
**An In-network Rate File is required for each provider network through which a group health plan or health insurance issuer provides coverage. Each file reports the negotiated rates for covered items and services with the providers in that network, along with contract terms that apply across rates, such as outlier, stop-loss, and capitation arrangements. The plans that use each network are listed in the [Table of Contents](../table-of-contents/README.md), which links each plan to its networks by `network_id` and each network to its In-network Rate Files.**

#### Reading the Required column
Each of the following tables has various requirements for individual attribute disclosures. The following are the definitions for each attribute's expected requirement in the machine-readable files.

| Value | Meaning |
| ----- | ------- |
| Yes | Must always be present. |
| No | May be omitted. Where omission has a specific meaning, the Definition says so. |
| Conditional | Required only under the condition stated in the Definition: when another field is present or has a particular value, or from a date set by the final rule. |
| One of | Include one field from a pair, but not both. The object's additional notes name the pair and say when to use each. |

#### In-network Rate File Root Level Object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **schema_version** | Schema Version | String | The version of the schema the file conforms to, for example `3.0.0`. | Yes |
| **reporting_entity** | Reporting Entity | Object | The entity that published the file. See the [reporting entity object](#reporting-entity-object). | Yes |
| **network** | Network | Object | The provider network whose rates this file reports. Its `network_id` matches the network's entry in the Table of Contents. See the [network identity object](#network-identity-object). | Yes |
| **reporting_period** | Reporting Period | Object | The quarter this file covers. See the [date range object](#date-range-object). | Yes |
| **last_updated_on** | Last Updated On | String | The date the file was last updated, in ISO 8601 format (YYYY-MM-DD). This is the "date in the file" that the attestation refers to. | Yes |
| **attestation** | Attestation | Object | The attestation of accuracy and completeness, and the official responsible for it. See the [attestation object](#attestation-object). | Yes |
| **related_files** | Related Files | Object | The locations of this network's Utilization File and Taxonomy File. Each location is required once that file is first posted; see the Table of Contents' [applicability dates](../table-of-contents/README.md#applicability-dates). See the [related files object](#related-files-object). | Conditional |
| **provider_groups** | Provider Groups | Array | The providers whose rates this file reports, grouped and declared once, then referenced by ID. An array of [provider group objects](#provider-group-object). | Yes |
| **service_code_sets** | Service Code Sets | Array | Sets of places of service declared once and referenced by ID from negotiated prices. Omit when no price references a set. An array of [service code set objects](#service-code-set-object). | No |
| **payment_provisions** | Payment Provisions | Array | Outlier, stop-loss, and similar contract terms that change how payment is computed once a threshold is crossed, declared once for the file. Omit when the contracts carry none. An array of [payment provision objects](#payment-provision-object). | No |
| **capitation_arrangements** | Capitation Arrangements | Array | Capitation contracts with providers in this network. Omit when there are none. An array of [capitation arrangement objects](#capitation-arrangement-object). | No |
| **in_network** | In-network | Array | Each covered item or service with negotiated rates. An array of [in-network item objects](#in-network-item-object). | Yes |

#### Reporting Entity Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Entity Name | String | The legal name of the entity that published the file, either as the plan or issuer, or as the party providing the information under a written agreement with the plan or issuer. This is not a contractor that builds or hosts the file on that entity's behalf. | Yes |
| **type** | Entity Type | String | The kind of entity that published the file. See [allowed entity type values](#allowed-entity-type-values). | Yes |

#### Network Identity Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **network_id** | Network ID | String | The provider network identifier. It matches the `network_id` of this network's entry in the Table of Contents and ties together the In-network Rate, Utilization, and Taxonomy Files for one network. See the Table of Contents' [additional notes concerning `network_id`](../table-of-contents/README.md#additional-notes-concerning-network_id). | Yes |
| **network_name** | Network Name | Array | A unique list of one or more common provider network names most familiar to members and the public. The same names listed for this network in the Table of Contents. | Yes |

#### Date Range Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **start** | Start Date | String | The first day of the period, in ISO 8601 format (YYYY-MM-DD). | Yes |
| **end** | End Date | String | The last day of the period, included in the period, in ISO 8601 format (YYYY-MM-DD). | Yes |

#### Attestation Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **statements** | Statements | Array | A unique list of one or more attestation statements, each word for word, one for each regulation the plans and coverage in this file are subject to. See [allowed attestation statement values](#allowed-attestation-statement-values). | Yes |
| **attester** | Attester | Object | The official responsible for the attestation. See the [attester object](#attester-object). | Yes |

#### Attester Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Name | String | The name of the chief executive officer, president, or senior official designated to oversee the encoding of true, accurate, and complete data. When another party attests on the plan's or issuer's behalf under a written agreement, this is that party's chief executive officer, president, or designated senior official. | Yes |
| **title** | Title | String | The official's title. | Yes |
| **organization** | Organization | String | The legal name of the organization the official belongs to. Populate it when that organization is not the reporting entity. | No |

**Example**

```json
"attestation": {
  "statements": [
    "To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 26 CFR 54.9815-2715A3, and the information encoded is true, accurate, and complete as of the date in the file.",
    "To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 29 CFR 2590.715-2715A3, and the information encoded is true, accurate, and complete as of the date in the file.",
    "To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 45 CFR 147.212, and the information encoded is true, accurate, and complete as of the date in the file."
  ],
  "attester": {
    "name": "Jane Doe",
    "title": "Chief Executive Officer",
    "organization": "ACME Health Plan, Inc."
  }
}
```

#### Related Files Object
The locations of this network's other files, so someone holding only this file can reach them. At least one location must be present when the object is included.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **utilization_file** | Utilization File | Object | The location of this network's Utilization File, as a [file location object](#file-location-object). Required once the Utilization File is first posted. | Conditional |
| **taxonomy_file** | Taxonomy File | Object | The location of the Taxonomy File used to prepare this file, as a [file location object](#file-location-object). Required once the Taxonomy File is first posted. | Conditional |

#### File Location Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **description** | Description | String | A short description of the file, such as the network and the period it covers. | Yes |
| **location** | Location | String | The full URL where the file can be downloaded. It must begin with `https://`, and the file must be downloadable without an account, password, or other credentials. | Yes |

#### Provider Group Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_group_id** | Provider Group ID | Integer | An identifier for the group, 0 or greater. It must be unique within this file. Negotiated rates and capitation arrangements refer to the group by this ID. | Yes |
| **providers** | Providers | Array | The providers in the group, grouped by tax identification number. An array of one or more [provider objects](#provider-object). | Yes |

#### Provider Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **tin** | Tax Identifier | Object | The tax identifier the providers bill under. See the [tax identifier object](#tax-identifier-object). | Yes |
| **npi** | National Provider Identifiers | Array | A unique list of one or more NPIs, as 10-digit strings, for the providers under this tax identifier that the group's rates apply to. Use `["0"]` when the contract is at the TIN level and NPIs are not available. See [additional notes concerning `npi`](#additional-notes-concerning-npi). | Yes |

##### Additional Notes Concerning `npi`
`["0"]` means the rates apply to every provider billing under the tax identifier and the individual NPIs are not available. It must be the only value in the list; it cannot be mixed with real NPIs. Do not use it when the contract names individual providers. List their NPIs instead.

When `tin` carries an `npi` instead of an `ein`, list that same NPI here.

#### Tax Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **ein** | Employer Identification Number | String | The Employer Identification Number issued by the IRS, either as `12-3456789` or `123456789`. See [additional notes concerning `ein` and `npi`](#additional-notes-concerning-ein-and-npi). | One of |
| **npi** | National Provider Identifier | String | The provider's 10-digit NPI, used in place of a Social Security number. See [additional notes concerning `ein` and `npi`](#additional-notes-concerning-ein-and-npi). | One of |
| **business_name** | Business Name | String | The legal business name associated with the EIN: the name of the organization (NPI Type 2 entity), not of individual practitioners. Required when `ein` is present. | Conditional |

##### Additional Notes Concerning `ein` and `npi`
Include either `ein` or `npi`, not both. Most providers are identified by the EIN of the business they bill through. Some individual providers still bill under their Social Security number. To keep personally identifiable information out of the files, report that provider's NPI in `npi` instead. An `npi` here means the provider would otherwise be identified by a Social Security number.

#### In-network Item Object
Each in-network item is one billing code with the rates negotiated for it.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiation_arrangement** | Negotiation Arrangement | String | Whether the rates pay for the item on its own or as a bundle. See [allowed negotiation arrangement values](#allowed-negotiation-arrangement-values). | Yes |
| **billing_code_type** | Billing Code Type | String | The billing code standard the code belongs to. See [allowed billing code type values](#allowed-billing-code-type-values). | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | The version of the billing code type the rates apply to, for example the MS-DRG version. See [additional notes concerning `billing_code_type_version`](#additional-notes-concerning-billing_code_type_version). | Yes |
| **billing_code** | Billing Code | String | The billing code for the item or service. For a bundle, the code the bundle is billed under. | Yes |
| **description** | Description | String | A plain-language description of the billing code. | Yes |
| **severity_of_illness** | Severity of Illness | String | The severity of illness level the rates depend on, for DRG codes whose rates vary by severity. Omit when the rates do not depend on severity. | No |
| **negotiated_rates** | Negotiated Rates | Array | The rates negotiated for this item and the provider groups they apply to. A unique list of one or more [negotiated rate details objects](#negotiated-rate-details-object). | Yes |
| **bundled_codes** | Bundled Codes | Array | The codes for the items and services included in the bundle. A unique list of one or more [bundled code objects](#bundled-code-object). Required when `negotiation_arrangement` is `bundle`. See [additional notes concerning bundles](#additional-notes-concerning-bundles). | Conditional |

##### Additional Notes Concerning `billing_code_type_version`
Report the version of the code set the negotiated rates apply to. When a code set has no versions, use the year the reporting period falls in, as `YYYY`.

##### Additional Notes Concerning Bundles
A bundle is a single negotiated rate for a group of items and services billed under one code. Report it as one item with `negotiation_arrangement` set to `bundle`, `billing_code` set to the code the bundle is billed under, and every included code listed in `bundled_codes`.

A capitation arrangement is reported in `capitation_arrangements`, not as an item. Derived amounts for the services it covers are reported as items; see [additional notes concerning capitated items and services](#additional-notes-concerning-capitated-items-and-services).

##### Additional Notes Concerning Prescription Drugs
A prescription drug appears in this file only as part of a bundle, listed in the bundle's `bundled_codes` by its national drug code: `billing_code_type` is `NDC`, and `billing_code` is the NDC.

#### Bundled Code Object
Each bundled code is one specific item or service included in a bundle.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | The billing code standard the code belongs to. See [allowed billing code type values](#allowed-billing-code-type-values). | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | The version of the billing code type. See [additional notes concerning `billing_code_type_version`](#additional-notes-concerning-billing_code_type_version). | Yes |
| **billing_code** | Billing Code | String | The billing code for the included item or service. | Yes |
| **description** | Description | String | A plain-language description of the billing code. | No |

#### Negotiated Rate Details Object
Each negotiated rate details object pairs a set of prices with the provider groups they apply to.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_group_ids** | Provider Group IDs | Array | The provider groups these prices apply to, as a unique list of one or more `provider_group_id` values. Each must match a [provider group](#provider-group-object) declared in this file. | Yes |
| **negotiated_prices** | Negotiated Prices | Array | The prices negotiated with these provider groups for the item or service. A unique list of one or more [negotiated price objects](#negotiated-price-object). | Yes |

#### Negotiated Price Object
Each negotiated price is one rate for the item or service, with the claim type, setting, places of service, and modifiers it applies to.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_type** | Negotiated Type | String | How the rate is expressed. See [allowed negotiated type values](#allowed-negotiated-type-values). | Yes |
| **negotiated_rate** | Negotiated Rate | Number | The rate, as a dollar amount, or as a percentage when `negotiated_type` is `percentage`. See [additional notes concerning `negotiated_rate`](#additional-notes-concerning-negotiated_rate). | Yes |
| **billing_class** | Billing Class | String | The type of claim the rate applies to. See [allowed billing class values](#allowed-billing-class-values). | Yes |
| **setting** | Setting | String | Whether the rate applies to inpatient or outpatient services. See [allowed setting values](#allowed-setting-values). | Yes |
| **service_code** | Place of Service Codes | Array | A unique list of one or more [CMS place of service codes](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) the rate applies to. Required when `billing_class` is `professional` or `both` and `service_code_set_id` is not present. See [additional notes concerning `service_code` and `service_code_set_id`](#additional-notes-concerning-service_code-and-service_code_set_id). | Conditional |
| **service_code_set_id** | Service Code Set ID | Integer | The `service_code_set_id` of a [service code set](#service-code-set-object) declared in this file, used instead of listing the places of service here. Required when `billing_class` is `professional` or `both` and `service_code` is not present. See [additional notes concerning `service_code` and `service_code_set_id`](#additional-notes-concerning-service_code-and-service_code_set_id). | Conditional |
| **billing_code_modifiers** | Billing Code Modifiers | Array | A unique list of one or more modifiers the rate depends on, as strings. A rate that differs by modifier is reported as a separate negotiated price. If the rate does not depend on a modifier, don't include `billing_code_modifiers`. An empty array (`[]`) or an empty string (`[""]`) is invalid. | No |
| **expiration_date** | Expiration Date | String | The date the rate expires, in ISO 8601 format (YYYY-MM-DD). See [additional notes concerning `expiration_date`](#additional-notes-concerning-expiration_date). | Yes |
| **payment_provision_ids** | Payment Provision IDs | Array | A unique list of one or more `provision_id` values for the [payment provisions](#payment-provision-object) that govern this rate. List only provisions whose `applies_to` is `referenced_rates`; a provision whose `applies_to` is `all_rates` governs every rate without being listed. | No |
| **additional_information** | Additional Information | String | Terms of the rate that the other fields cannot express. | No |

##### Additional Notes Concerning `negotiated_rate`
For a `percentage` rate, enter the percentage as a whole number: 40.5% is `40.5`, not `0.405`.

##### Additional Notes Concerning `service_code` and `service_code_set_id`
Place of service codes are reported on professional claims but not on institutional claims. A negotiated rate whose `billing_class` is `professional` or `both` therefore states its places of service in one of two ways: list them in `service_code`, or reference a set declared once in `service_code_sets`. Do not include both.

| `billing_class` | `service_code` or `service_code_set_id` |
| --------------- | --------------------------------------- |
| `professional` | Exactly one |
| `both` | Exactly one |
| `institutional` | At most one |

When a professional rate does not depend on place of service, declare a set listing every place of service code and reference it.

##### Additional Notes Concerning `expiration_date`
For an evergreen contract that renews automatically on a date stated in the contract, use the day before the renewal date. When the contract has no set expiration date, use `9999-12-31`.

##### Additional Notes Concerning Rate Types
Report every rate that applies to the item or service, each as its own negotiated price:
- **Negotiated rate.** The amount the contract pays the provider.
- **Underlying fee schedule rate.** When the plan calculates members' cost-sharing from a different amount, report that amount as an additional negotiated price with `negotiated_type` set to `fee schedule`, alongside the negotiated rate or derived amount.
- **Derived amount.** When the plan does not pay the provider by negotiated rates, as under capitation, report derived amounts if the plan already calculates them in the normal course of business. A plan does not need to create them for this file.
- **Percentage.** Use `percentage` only when the contract pays a percentage of billed charges and no dollar amount can be assigned before the bill is generated.

#### Service Code Set Object
Each service code set is a list of places of service declared once for the file, so a rate that applies at many places can reference the set instead of listing them.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **service_code_set_id** | Service Code Set ID | Integer | An identifier for the set, 0 or greater. It must be unique within this file. Negotiated prices refer to the set by this ID. | Yes |
| **service_code** | Place of Service Codes | Array | A unique list of one or more [CMS place of service codes](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) in the set. | Yes |

##### Additional Notes Concerning Rates That Apply at Every Place of Service
Earlier versions of this schema used the value `CSTM-00` in `service_code` for a rate that applies at every place of service. This version does not accept `CSTM-00`. To report the same thing, declare a set listing every place of service code once, and reference it from each such rate by `service_code_set_id`. The result has the same meaning as `CSTM-00` and costs one integer per rate, and every code in it can be checked.

```json
"service_code_sets": [
  {
    "service_code_set_id": 0,
    "service_code": ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
                     "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                     "21", "22", "23", "24", "25", "26", "27", "31", "32", "33",
                     "34", "41", "42", "49", "50", "51", "52", "53", "54", "55",
                     "56", "57", "58", "60", "61", "62", "65", "66", "71", "72",
                     "81", "99"]
  }
]
```

```json
{
  "negotiated_type": "negotiated",
  "negotiated_rate": 85.00,
  "billing_class": "professional",
  "setting": "both",
  "service_code_set_id": 0,
  "expiration_date": "9999-12-31"
}
```

#### Payment Provision Object
Each payment provision is a contract term, such as an outlier or stop-loss clause, that changes how payment is computed once a threshold is crossed. It is declared once for the file and governs either every rate or only the rates that reference it.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provision_id** | Provision ID | Integer | An identifier for the provision, 0 or greater. It must be unique within this file. Negotiated rates refer to the provision by this ID. | Yes |
| **provision_type** | Provision Type | String | The kind of provision. See [allowed provision type values](#allowed-provision-type-values). | Yes |
| **applies_to** | Applies To | String | Which negotiated rates the provision governs: `all_rates` or `referenced_rates`. See [additional notes concerning `applies_to`](#additional-notes-concerning-applies_to). | Yes |
| **trigger** | Trigger | Object | The condition that activates the provision. See the [provision trigger object](#provision-trigger-object). | Yes |
| **method** | Method | Object | How payment is computed once the trigger is met. See the [provision method object](#provision-method-object). | Yes |
| **cost_to_charge_ratios** | Cost-to-Charge Ratios | Array | The cost-to-charge ratio of each facility the provision governs. A unique list of one or more [cost-to-charge ratio objects](#cost-to-charge-ratio-object). Required when the trigger's `measure` or the method's `basis` is `estimated_cost`. | Conditional |
| **contract_text** | Contract Text | String | The provision as written in the contract. The structured fields make the provision computable; the text makes it checkable against the contract. | No |

##### Additional Notes Concerning `applies_to`
A provision whose `applies_to` is `all_rates` governs every negotiated rate in the file, and no negotiated rate in the file lists it. A provision whose `applies_to` is `referenced_rates` governs only the negotiated rates that list its `provision_id` in `payment_provision_ids`. Use `referenced_rates` when a provision applies only to some provider groups or some items or services.

#### Provision Trigger Object
The provision applies once `measure` exceeds `threshold`.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **measure** | Measure | String | The quantity compared against the threshold. See [allowed threshold measure values](#allowed-threshold-measure-values). | Yes |
| **threshold** | Threshold | Number | The value `measure` must exceed, 0 or greater: a dollar amount, or a number of days when `measure` is `length_of_stay_days`. | Yes |

#### Provision Method Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **negotiated_type** | Negotiated Type | String | How `rate` is expressed. See [allowed negotiated type values](#allowed-negotiated-type-values). | Yes |
| **rate** | Rate | Number | The rate applied once the trigger is met, 0 or greater, as a dollar amount, or as a percentage when `negotiated_type` is `percentage` (80% is `80`). | Yes |
| **basis** | Basis | String | The dollar quantity `rate` is applied to. Required when `negotiated_type` is `percentage`. See [allowed payment basis values](#allowed-payment-basis-values). | Conditional |
| **application** | Application | String | Whether `rate` applies to the full `basis` amount or only to the amount above the threshold. Required when `negotiated_type` is `percentage`. See [allowed application values](#allowed-application-values). | Conditional |
| **relation_to_rate** | Relation to Rate | String | How the computed amount relates to the negotiated rate the provision governs. See [allowed relation to rate values](#allowed-relation-to-rate-values). | Yes |

#### Cost-to-Charge Ratio Object
Each cost-to-charge ratio applies to one facility, identified by its NPI, or to every facility under one tax identifier.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **npi** | National Provider Identifier | String | The facility's organizational (Type 2) NPI, as a 10-digit string. See [additional notes concerning `npi` and `tin`](#additional-notes-concerning-npi-and-tin). | One of |
| **tin** | Tax Identifier | Object | The tax identifier of the facilities the ratio applies to. See the [tax identifier object](#tax-identifier-object) and [additional notes concerning `npi` and `tin`](#additional-notes-concerning-npi-and-tin). | One of |
| **ratio** | Ratio | Number | The ratio that converts the facility's billed charges to estimated cost, greater than 0. Estimated cost is billed charges multiplied by this ratio. | Yes |

##### Additional Notes Concerning `npi` and `tin`
Include either `npi` or `tin`, not both. Use `npi` when the ratio belongs to one facility. Use `tin` only when one ratio applies to every facility billing under that tax identifier, such as a contract at the TIN level that states a single ratio.

Cover each tax identifier one way: either one entry by `tin`, or entries by `npi` for the facilities under it, but not both. List each NPI or tax identifier once. Every NPI or tax identifier listed must belong to a provider group whose rates the provision governs.

#### Capitation Arrangement Object
Each capitation arrangement is a fixed monthly payment for each member attributed to a provider group, made in place of per-claim payment for the items and services the arrangement covers.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **capitation_id** | Capitation ID | Integer | An identifier for the arrangement, 0 or greater. It must be unique within this file. | Yes |
| **description** | Description | String | A plain-language description of the arrangement. | Yes |
| **provider_group_ids** | Provider Group IDs | Array | The provider groups paid under this arrangement, as a unique list of one or more `provider_group_id` values. Each must match a [provider group](#provider-group-object) declared in this file. | Yes |
| **rate** | Rate | Number | The dollar amount paid each month for each attributed member (per member per month, or PMPM), 0 or greater. See [additional notes concerning capitation `rate`](#additional-notes-concerning-capitation-rate). | Yes |
| **covered_services** | Covered Services | Array | The items and services the arrangement covers. A unique list of one or more [billing code scope objects](#billing-code-scope-object). | Yes |
| **expiration_date** | Expiration Date | String | The date the arrangement expires, in ISO 8601 format (YYYY-MM-DD). See [additional notes concerning `expiration_date`](#additional-notes-concerning-expiration_date). | Yes |
| **additional_information** | Additional Information | String | Terms the other fields cannot express. | No |

##### Additional Notes Concerning Capitation `rate`
Report the amount as a monthly figure. When the contract states it for another period, such as per member per year, report the monthly equivalent: $480 per member per year is `40`.

##### Additional Notes Concerning Capitated Items and Services
A capitation arrangement replaces per-claim payment, so the items and services it covers usually have no negotiated rate. When the plan already calculates derived amounts for them in the normal course of business, report each as an [in-network item](#in-network-item-object) with a negotiated price whose `negotiated_type` is `derived`, for the same provider groups, in addition to the arrangement. A plan does not need to create derived amounts for this file.

#### Billing Code Scope Object
Each billing code scope is one specific code, or an inclusive range of codes, within one billing code type.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | The billing code standard the codes belong to. See [allowed billing code type values](#allowed-billing-code-type-values). | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | The version of the billing code type. See [additional notes concerning `billing_code_type_version`](#additional-notes-concerning-billing_code_type_version). | Yes |
| **billing_code** | Billing Code | String | One specific code. See [additional notes concerning `billing_code`, `range_start`, and `range_end`](#additional-notes-concerning-billing_code-range_start-and-range_end). | One of |
| **range_start** | Range Start | String | The first code in the range, included in the range. Required with `range_end`. See [additional notes concerning `billing_code`, `range_start`, and `range_end`](#additional-notes-concerning-billing_code-range_start-and-range_end). | One of |
| **range_end** | Range End | String | The last code in the range, included in the range. Required with `range_start`. | Conditional |

##### Additional Notes Concerning `billing_code`, `range_start`, and `range_end`
Include either `billing_code` for one code, or `range_start` and `range_end` together for a range, but not both.

A range covers every code of the billing code type that:
- has the same format as `range_start` and `range_end`: the same length, with letters and digits in the same positions; and
- sorts from `range_start` through `range_end`, including both ends, comparing one character at a time.

`range_start` and `range_end` must have the same format, and `range_start` must not sort after `range_end`. Codes in a different format need their own range. For example, `00100`–`99499` covers only five-digit numeric CPT codes, so CPT Category III codes such as `0042T` are reported as a separate range, such as `0042T`–`0999T`.

### In-network Rate File Allowed Values
Fields that take a fixed set of values link here. Each table lists the values and what each one means.

#### Allowed Entity Type Values
Used by `reporting_entity.type`.

| Value | Meaning |
| ----- | ------- |
| `group_health_plan` | A group health plan publishing its own files. |
| `health_insurance_issuer` | A health insurance issuer. |
| `third_party_administrator` | A third-party administrator publishing under a written agreement with a plan or issuer. |
| `claims_clearinghouse` | A health care claims clearinghouse publishing under a written agreement with a plan or issuer. |
| `other_third_party` | Any other party publishing under a written agreement with a plan or issuer. |

#### Allowed Attestation Statement Values
Used by `attestation.statements`. Each entry must match one of these exactly, character for character; any other wording fails validation. "The date in the file" is `last_updated_on`.

| Regulation | Value |
| ---------- | ----- |
| 26 CFR 54.9815-2715A3 (Treasury) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 26 CFR 54.9815-2715A3, and the information encoded is true, accurate, and complete as of the date in the file. |
| 29 CFR 2590.715-2715A3 (Labor) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 29 CFR 2590.715-2715A3, and the information encoded is true, accurate, and complete as of the date in the file. |
| 45 CFR 147.212 (HHS) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 45 CFR 147.212, and the information encoded is true, accurate, and complete as of the date in the file. |

#### Allowed Negotiation Arrangement Values
Used by `in_network.negotiation_arrangement`.

| Value | Meaning |
| ----- | ------- |
| `ffs` | Fee for service: the rate pays for the item or service on its own. |
| `bundle` | The rate pays for a group of items and services billed under one code. The included codes are listed in `bundled_codes`. See [additional notes concerning bundles](#additional-notes-concerning-bundles). |

#### Allowed Billing Code Type Values
Used by `billing_code_type` on in-network items, bundled codes, and billing code scopes. For a billing code standard not in this table, please open a [discussion](https://github.com/CMSgov/price-transparency-guide/discussions) to propose adding it.

| Standard Name | Value | Additional Information |
| ------------- | ----- | ---------------------- |
| Current Procedural Terminology | `CPT` | [American Medical Association](https://www.ama-assn.org/practice-management/cpt/cpt-overview-and-code-approval) |
| Healthcare Common Procedure Coding System | `HCPCS` | [CMS HCPCS](https://www.cms.gov/Medicare/Coding/MedHCPCSGenInfo) |
| Medicare Severity Diagnosis Related Groups | `MS-DRG` | [CMS DRGs](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/AcuteInpatientPPS/MS-DRG-Classifications-and-Software) |
| Refined Diagnosis Related Groups | `R-DRG` | |
| Severity Diagnosis Related Groups | `S-DRG` | |
| All Patient, Severity-Adjusted Diagnosis Related Groups | `APS-DRG` | |
| All Patient Diagnosis Related Groups | `AP-DRG` | |
| All Patient Refined Diagnosis Related Groups | `APR-DRG` | [AHRQ documentation](https://www.hcup-us.ahrq.gov/db/nation/nis/APR-DRGsV20MethodologyOverviewandBibliography.pdf) |
| Ambulatory Payment Classifications | `APC` | |
| National Drug Code | `NDC` | [FDA NDC Background](https://www.fda.gov/drugs/development-approval-process-drugs/national-drug-code-database-background-information) |
| Health Insurance Prospective Payment System | `HIPPS` | [HIPPS](https://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/ProspMedicareFeeSvcPmtGen/HIPPSCodes) |
| Local Code Processing | `LOCAL` | A code defined by the plan or issuer rather than by a published code set. |
| Enhanced Ambulatory Patient Grouping | `EAPG` | |
| Current Dental Terminology | `CDT` | [CDT](https://www.ada.org/en/publications/cdt) |
| Revenue Code | `RC` | |

#### Allowed Negotiated Type Values
Used by `negotiated_price.negotiated_type` and `method.negotiated_type`.

| Value | Meaning |
| ----- | ------- |
| `negotiated` | The dollar amount the plan or issuer has contractually agreed to pay an in-network provider for the item or service. When the amount changes with member-specific characteristics, report the base amount before those adjustments. |
| `derived` | The dollar amount the plan or issuer assigns to the item or service for internal accounting, reconciliation with providers, or submitting data under 45 CFR 153.710(c). |
| `fee schedule` | The underlying fee schedule rate: the dollar amount the plan or issuer uses as the basis for calculating a member's cost-sharing for the item or service from a particular in-network provider or providers, when that amount differs from the negotiated rate or derived amount. |
| `percentage` | A percentage of billed charges, entered as a whole number: 40.5% is `40.5`. |
| `per diem` | A daily dollar amount for the item or service. |

#### Allowed Billing Class Values
Used by `billing_class`.

| Value | Meaning |
| ----- | ------- |
| `professional` | A professional claim (CMS-1500 or 837P): an item or service billed by a provider. |
| `institutional` | An institutional claim (UB-04 or 837I): an item or service billed by a facility. |
| `both` | The same rate applies to professional and institutional claims. |

#### Allowed Setting Values
Used by `setting`.

| Value | Meaning |
| ----- | ------- |
| `inpatient` | Furnished during an inpatient stay. |
| `outpatient` | Furnished on an outpatient basis. |
| `both` | The same rate applies inpatient and outpatient. |

#### Allowed Provision Type Values
Used by `payment_provision.provision_type`.

| Value | Meaning |
| ----- | ------- |
| `outlier` | Pays more for an unusually costly case, typically an amount on top of the rate once the case's cost or charges exceed a threshold. |
| `stop_loss` | Changes how a case is paid once its charges exceed a threshold, typically replacing the rate with a percentage of billed charges. |
| `other` | A threshold provision that is neither an outlier nor a stop-loss provision. |

#### Allowed Threshold Measure Values
Used by `trigger.measure`.

| Value | Meaning |
| ----- | ------- |
| `billed_charges` | The provider's total billed charges for the case. |
| `estimated_cost` | Billed charges multiplied by the facility's cost-to-charge ratio, from `cost_to_charge_ratios`. |
| `allowed_amount` | The amount allowed for the case under the contract. |
| `negotiated_rate` | The negotiated rate the provision governs. |
| `length_of_stay_days` | The number of days in an inpatient stay. |

#### Allowed Payment Basis Values
Used by `method.basis`.

| Value | Meaning |
| ----- | ------- |
| `billed_charges` | The provider's total billed charges for the case. |
| `estimated_cost` | Billed charges multiplied by the facility's cost-to-charge ratio, from `cost_to_charge_ratios`. |
| `allowed_amount` | The amount allowed for the case under the contract. |
| `negotiated_rate` | The negotiated rate the provision governs. |
| `fee_schedule` | An amount from a fee schedule. |

#### Allowed Application Values
Used by `method.application`.

| Value | Meaning |
| ----- | ------- |
| `full_amount` | `rate` is applied to the whole `basis` amount. |
| `amount_above_threshold` | `rate` is applied only to the part of the `basis` amount above the trigger's threshold. |

#### Allowed Relation to Rate Values
Used by `method.relation_to_rate`.

| Value | Meaning |
| ----- | ------- |
| `in_addition_to_rate` | The computed amount is paid on top of the negotiated rate. |
| `in_place_of_rate` | The computed amount replaces the negotiated rate. |
| `greater_of_rate` | Whichever is higher, the negotiated rate or the computed amount, is paid. |
| `lesser_of_rate` | Whichever is lower, the negotiated rate or the computed amount, is paid. |

