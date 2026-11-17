### Prescription Drug File
**A Prescription Drug File is required for each provider network through which a group health plan or health insurance issuer covers prescription drugs paid on a fee-for-service basis: a pharmacy network for drugs covered under the pharmacy benefit, or a medical provider network for drugs covered under the medical benefit. Each file reports the negotiated rates and historical net prices for those drugs with the pharmacies and other providers in that network. The plans that use each network are listed in the [Table of Contents](../table-of-contents/README.md), which links each plan to its networks by `network_id` and each network to its Prescription Drug Files.**

#### Reading the Required column
Each of the following tables has various requirements for individual attribute disclosures. The following are the definitions for each attribute's expected requirement in the machine-readable files.

| Value | Meaning |
| ----- | ------- |
| Yes | Must always be present. |
| No | May be omitted. Where omission has a specific meaning, the Definition says so. |
| Conditional | Required only under the condition stated in the Definition: when another field is present or has a particular value, or from a date set by the final rule. |
| One of | Include one field from a pair, but not both. The object's additional notes name the pair and say when to use each. |

#### Prescription Drug File Root Level Object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **schema_version** | Schema Version | String | The version of the schema the file conforms to, for example `3.0.0`. | Yes |
| **reporting_entity** | Reporting Entity | Object | The entity that published the file. See the [reporting entity object](#reporting-entity-object). | Yes |
| **network** | Network | Object | The provider network whose prescription drug prices this file reports. Its `network_id` matches the network's entry in the Table of Contents. See the [network identity object](#network-identity-object) and [additional notes concerning `network`](#additional-notes-concerning-network). | Yes |
| **benefit** | Benefit | String | The benefit under which every drug in this file is covered, `medical` or `pharmacy`. A network that covers drugs under both benefits has a separate file for each. See [allowed benefit values](#allowed-benefit-values). | Yes |
| **reporting_period** | Reporting Period | Object | The calendar month this file covers. See the [date range object](#date-range-object). | Yes |
| **historical_net_price_period** | Historical Net Price Period | Object | The 90-day period, beginning 180 days before the file is published, over which the historical net prices in this file are calculated. See the [date range object](#date-range-object). | Yes |
| **last_updated_on** | Last Updated On | String | The date the file was last updated, in ISO 8601 format (YYYY-MM-DD). This is the "date in the file" that the attestation refers to. | Yes |
| **attestation** | Attestation | Object | The attestation of accuracy and completeness, and the official responsible for it. See the [attestation object](#attestation-object). | Yes |
| **provider_references** | Provider References | Array | The pharmacies and other providers whose prices this file reports, grouped and declared once, then referenced by ID. An array of [provider reference objects](#provider-reference-object). | Yes |
| **drugs** | Drugs | Array | Each covered prescription drug with its prices. An array of [drug objects](#drug-object). | Yes |

##### Additional Notes Concerning `network`
A network is defined by its providers and rates. A variation in either is a separate network with its own file, as described in the Table of Contents' [additional notes concerning `network_id`](../table-of-contents/README.md#additional-notes-concerning-network_id). A carve-out, such as a local pharmacy a plan uses for a few drugs in place of its main specialty network, is a separate network that the plan lists alongside its main network in its `network_references` in the Table of Contents.

Each Prescription Drug File covers one benefit. A network whose drugs are covered under both the medical and the pharmacy benefit has two files, one for each. A drug covered under both benefits appears in each file with its own prices.


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

#### Provider Reference Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_group_id** | Provider Group ID | Integer | An identifier for the group, 0 or greater. It must be unique within this file. Drug prices refer to the group by this ID. | Yes |
| **channel** | Channel | String | The pharmacy channel ("pharmacy service type" in NCPDP's terms) under which these pharmacies are paid the prices that reference this group, such as retail, mail order, or specialty. Required in a file whose `benefit` is `pharmacy`. In a `medical` file, include it for pharmacies and omit it for physicians, facilities, and other providers. See [allowed channel values](#allowed-channel-values) and [additional notes concerning `channel`](#additional-notes-concerning-channel). | Conditional |
| **contracting_organization** | Contracting Organization | Object | The chain or pharmacy services administrative organization (PSAO) that signed the network contract for the pharmacies in this group. Omit when the pharmacies contracted directly. See the [contracting organization object](#contracting-organization-object) and [additional notes concerning `contracting_organization`](#additional-notes-concerning-contracting_organization). | No |
| **provider_groups** | Provider Groups | Array | The providers in this group, as an array of [provider group objects](#provider-group-object), each a tax identifier and the NPIs under it. | Yes |

##### Additional Notes Concerning `channel`
Most pharmacy locations operate in one channel, so all of a group's pharmacies share one value. When a pharmacy is paid different prices depending on the channel, for example as a retail pharmacy and as a long-term care pharmacy, list its NPI in one group for each channel and have each price refer to the matching group. The channel is separate from days' supply: a 30-day and a 90-day retail fill are both `community_retail`.

##### Additional Notes Concerning `contracting_organization`
Include it whenever a chain or PSAO signed the contract for the group's pharmacies, even when it is a chain whose pharmacies bill under its own EIN, so that readers can find every chain and PSAO contract the same way. A PSAO contracts for independent pharmacies with many different EINs, so without this object its name and EIN would appear nowhere in the file.

#### Provider Group Object
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

#### Contracting Organization Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **ncpdp_relationship_id** | NCPDP Relationship ID | String | The organization's NCPDP relationship ID (formerly the chain code). | Yes |
| **ein** | Employer Identification Number | String | The organization's Employer Identification Number, either as `12-3456789` or `123456789`. | Yes |
| **business_name** | Business Name | String | The organization's legal business name. | Yes |

#### Drug Object
Each drug object is one NDC and the prices for it in this network.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | The billing code standard the code belongs to. See [allowed billing code type values](#allowed-billing-code-type-values). | Yes |
| **billing_code** | Billing Code | String | The drug's National Drug Code, without hyphens. See [additional notes concerning `billing_code`](#additional-notes-concerning-billing_code). | Yes |
| **proprietary_name** | Proprietary Name | String | The proprietary name the Food and Drug Administration lists for this NDC. See [additional notes concerning `proprietary_name` and `nonproprietary_name`](#additional-notes-concerning-proprietary_name-and-nonproprietary_name). | Yes |
| **nonproprietary_name** | Nonproprietary Name | String | The nonproprietary name the Food and Drug Administration lists for this NDC. See [additional notes concerning `proprietary_name` and `nonproprietary_name`](#additional-notes-concerning-proprietary_name-and-nonproprietary_name). | Yes |
| **drug_type** | Drug Type | String | Whether the drug is branded or generic. See [allowed drug type values](#allowed-drug-type-values). | Yes |
| **billing_unit** | Billing Unit | String | The unit every price for this drug is stated in, as assigned by the NCPDP Billing Unit Standard. See [allowed billing unit values](#allowed-billing-unit-values). | Yes |
| **prices** | Prices | Array | The prices for this drug in this network. An array of [drug price objects](#drug-price-object). | Yes |

##### Additional Notes Concerning `billing_code`
Report each NDC without hyphens. List each NDC once in the file.

##### Additional Notes Concerning `proprietary_name` and `nonproprietary_name`
Use the names the FDA lists for the NDC in its National Drug Code Directory. For many generic drugs the two names are the same; report both.

#### Drug Price Object
Each drug price object is one set of prices for the drug, paid to the pharmacies and other providers in the provider groups it references. All amounts are dollars per billing unit (the drug's `billing_unit`).

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_references** | Provider References | Array | The provider groups these prices apply to, as a unique list of one or more `provider_group_id` values. Each must match a [provider reference](#provider-reference-object) declared in this file. | Yes |
| **service_code** | Place of Service Codes | Array | A unique list of the CMS place of service codes these prices apply at, for example `["01"]` for a pharmacy. Use the codes for the settings the contract applies the rate to, even where claims from that setting carry no place of service code, such as a hospital outpatient department's institutional claims (`22` or `19`). | Yes |
| **days_supply** | Days' Supply | Object | The range of days' supply the price applies to, such as 1 to 34 days or 84 to 90 days. Omit when the price does not depend on days' supply. See the [days' supply object](#days-supply-object). | No |
| **negotiated_rate** | Negotiated Rate | Number | The dollar amount per billing unit the plan or issuer has contractually agreed to pay, directly or through a pharmacy benefit manager. See [additional notes concerning `negotiated_rate`](#additional-notes-concerning-negotiated_rate). | Yes |
| **expiration_date** | Expiration Date | String | The date the rate expires, in ISO 8601 format (YYYY-MM-DD). See [additional notes concerning `expiration_date`](#additional-notes-concerning-expiration_date). | Yes |
| **historical_net_price** | Historical Net Price | Number | The average dollar amount per billing unit the plan or issuer paid over the `historical_net_price_period`, net of reasonably allocated rebates, discounts, chargebacks, fees, and other price concessions. Omit when it would be calculated using fewer than 20 different claims for payment. See [additional notes concerning `historical_net_price`](#additional-notes-concerning-historical_net_price). | Conditional |

##### Additional Notes Concerning `negotiated_rate`
Report a dollar amount even when the contract sets the rate by formula, such as a percentage off average wholesale price. Apply the formula to the underlying price on a single date and report the result.

##### Additional Notes Concerning `expiration_date`
For an evergreen contract that renews automatically on a date stated in the contract, use the day before the renewal date. When the contract has no set expiration date, use `9999-12-31`.

##### Additional Notes Concerning `historical_net_price`
The historical net price is calculated over all claims for this drug at the pharmacies and other providers in the referenced provider groups during the `historical_net_price_period`. When the total of a rebate or other price concession is known by the publication date, allocate it by its dollar value. When it is not yet known, use a good faith, reasonable estimate based on concessions received over an earlier period of the same length. Omit `historical_net_price` for a drug when it would be calculated using fewer than 20 different claims for payment. Nothing in this file requires disclosing information that would violate an applicable health information privacy law. To report historical net prices pharmacy by pharmacy, reference a provider group containing only that pharmacy.

#### Days' Supply Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **minimum** | Minimum | Integer | The fewest days' supply the price applies to, at least 1. | Yes |
| **maximum** | Maximum | Integer | The most days' supply the price applies to, no less than `minimum`. | Yes |

### Prescription Drug File Allowed Values
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

#### Allowed Benefit Values
Used by `benefit`.

| Value | Meaning |
| ----- | ------- |
| `medical` | The drug is covered under the plan's medical benefit, for example a drug given in a physician's office or a hospital outpatient department. |
| `pharmacy` | The drug is covered under the plan's pharmacy benefit, for example a prescription filled at a retail, mail order, or specialty pharmacy. |

#### Allowed Attestation Statement Values
Used by `attestation.statements`. Each entry must match one of these exactly, character for character; any other wording fails validation. "The date in the file" is `last_updated_on`.

| Regulation | Value |
| ---------- | ----- |
| 26 CFR 54.9815-2715A3 (Treasury) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 26 CFR 54.9815-2715A3, and the information encoded is true, accurate, and complete as of the date in the file. |
| 29 CFR 2590.715-2715A3 (Labor) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 29 CFR 2590.715-2715A3, and the information encoded is true, accurate, and complete as of the date in the file. |
| 45 CFR 147.212 (HHS) | To the best of its knowledge and belief, this plan or issuer has included all applicable information in accordance with the requirements of 45 CFR 147.212, and the information encoded is true, accurate, and complete as of the date in the file. |

#### Allowed Billing Code Type Values
Used by `drugs.billing_code_type`.

| Standard Name | Value | Additional Information |
| ------------- | ----- | ---------------------- |
| National Drug Code | `NDC` | [FDA NDC Background](https://www.fda.gov/drugs/development-approval-process-drugs/national-drug-code-database-background-information) |

#### Allowed Drug Type Values
Used by `drugs.drug_type`.

| Value | Meaning |
| ----- | ------- |
| `branded` | A drug marketed under a brand name. |
| `generic` | A generic drug. |

#### Allowed Billing Unit Values
Used by `drugs.billing_unit`. These are the units of the NCPDP Billing Unit Standard.

| Value | Meaning |
| ----- | ------- |
| `EA` | Each. |
| `ML` | Milliliter. |
| `GM` | Gram. |

#### Allowed Channel Values
Used by `provider_references.channel`. The values follow the National Council for Prescription Drug Programs (NCPDP) Pharmacy Service Type code set used on pharmacy claims.

| Value | Meaning |
| ----- | ------- |
| `community_retail` | Community or retail pharmacy services. |
| `compounding` | Compounding pharmacy services. |
| `home_infusion` | Home infusion therapy provider services. |
| `institutional` | Institutional pharmacy services. |
| `long_term_care` | Long-term care pharmacy services. |
| `mail_order` | Mail order pharmacy services. |
| `managed_care_organization` | Managed care organization pharmacy services. |
| `specialty` | Specialty care pharmacy services. |
| `other` | Any other type of pharmacy service. |

