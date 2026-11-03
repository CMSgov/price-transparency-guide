### Allowed Amount File
**An Allowed Amount File is required for each health insurance market in which the plan or issuer offers coverage: individual, small group, large group, and self-insured. Each file reports the allowed amounts and billed charges for covered items and services furnished by out-of-network providers, aggregated across every plan or policy in that market. The plans included in each file are listed in the [Table of Contents](../table-of-contents/README.md), which links each plan to the Allowed Amount File for its market segment.**

#### Reading the Required column
Each of the following tables has various requirements for individual attribute disclosures. The following are the definitions for each attribute's expected requirement in the machine-readable files.

| Value | Meaning |
| ----- | ------- |
| Yes | Must always be present. |
| No | May be omitted. Where omission has a specific meaning, the Definition says so. |
| Conditional | Required only under the condition stated in the Definition: when another field is present, or from a date set by the final rule. |
| One of | Include one field from a pair, but not both. The object's additional notes name the pair and say when to use each. |

#### Allowed Amount File Root Level Object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **schema_version** | Schema Version | String | The version of the schema the file conforms to, for example `3.0.0`. | Yes |
| **reporting_entity** | Reporting Entity | Object | The entity that published the file. See the [reporting entity object](#reporting-entity-object). | Yes |
| **market_segment** | Market Segment | String | The health insurance market this file covers. It matches the key this file is listed under in the Table of Contents' `allowed_amount_files`, and the `market_segment` of each plan the file covers. See [allowed market segment values](#allowed-market-segment-values). | Yes |
| **reporting_period** | Reporting Period | Object | The six months of service dates the allowed amounts cover, beginning nine months before the file is published. See the [date range object](#date-range-object). | Yes |
| **lookback_period** | Lookback Period | Object | The nine months before the file is published, starting on the first day of the reporting period. See the [date range object](#date-range-object). | Yes |
| **last_updated_on** | Last Updated On | String | The date the file was last updated, in ISO 8601 format (YYYY-MM-DD). This is the "date in the file" that the attestation refers to. | Yes |
| **attestation** | Attestation | Object | The attestation of accuracy and completeness, and the official responsible for it. See the [attestation object](#attestation-object). | Yes |
| **out_of_network** | Out of Network | Array | Each covered item or service with out-of-network allowed amounts to report. An array of [out-of-network item objects](#out-of-network-item-object). May be empty; see additional notes. | Yes |

##### Additional Notes Concerning `out_of_network`
The file is required for each market even when no item or service reaches the 11-claim threshold. In that case, `out_of_network` is an empty array.

#### Reporting Entity Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Entity Name | String | The legal name of the entity that published the file, either as the plan or issuer, or as the party providing the information under a written agreement with the plan or issuer. This is not a contractor that builds or hosts the file on that entity's behalf. | Yes |
| **type** | Entity Type | String | The kind of entity that published the file. See [allowed entity type values](#allowed-entity-type-values). | Yes |

#### Date Range Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **start** | Start Date | String | The first day of the period, in ISO 8601 format (YYYY-MM-DD). | Yes |
| **end** | End Date | String | The last day of the period, included in the period, in ISO 8601 format (YYYY-MM-DD). | Yes |

#### Attestation Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **statements** | Statements | Array | The attestation statement, word for word, once for each regulation the plans and coverage in this file are subject to. At least one statement; none may repeat. See [allowed attestation statement values](#allowed-attestation-statement-values). | Yes |
| **attester** | Attester | Object | The official responsible for the attestation. See the [attester object](#attester-object). | Yes |

#### Attester Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Name | String | The name of the senior official designated to oversee the encoding of true, accurate, and complete data. When another party attests on the plan's or issuer's behalf under a written agreement, this is that party's official. | Yes |
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


#### Out-of-Network Item Object
Each out-of-network item is one billing code with allowed amounts to report.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **billing_code_type** | Billing Code Type | String | The billing code standard the code belongs to. See [allowed billing code type values](#allowed-billing-code-type-values). | Yes |
| **billing_code_type_version** | Billing Code Type Version | String | The version of the billing code type the claim was submitted under, for example the MS-DRG version. See [additional notes concerning `billing_code_type_version`](#additional-notes-concerning-billing_code_type_version). | Yes |
| **billing_code** | Billing Code | String | The billing code for the item or service. | Yes |
| **description** | Description | String | A plain-language description of the billing code. | Yes |
| **allowed_amounts** | Allowed Amounts | Array | The allowed amounts for this item, grouped by provider, claim type, place of service, and modifiers. An array of [allowed amount objects](#allowed-amount-object); at least one, and none may repeat. | Yes |

##### Additional Notes Concerning Which Items Are Included
An item is included only when the plans in the file's market have 11 or more different claims for payment of it during the reporting period. The count is for the item across the whole market, not for each provider. When another party combines several self-insured plans in one file, including plans from different plan sponsors, the 11 claims are counted across all of them.

##### Additional Notes Concerning `billing_code_type_version`
Report the version of the code set that each claim was submitted under. When the reporting period spans an update to a code set, such as the annual CPT and HCPCS update on January 1, use the version on each claim rather than a single version for the whole file.

#### Allowed Amount Object
Each allowed amount object is one tax identification number, claim type, place of service, and set of modifiers, with the unique amounts paid under it. A tax identification number can cover many providers; each payment lists the NPIs of the providers who were paid that amount.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **tin** | Tax Identification Number | Object | The provider's tax identifier. See the [tax identifier object](#tax-identifier-object). | Yes |
| **billing_class** | Billing Class | String | Whether the claims were professional or institutional. See [allowed billing class values](#allowed-billing-class-values) and [additional notes concerning `billing_class`, `service_code`, and `setting`](#additional-notes-concerning-billing_class-service_code-and-setting). | Yes |
| **service_code** | Place of Service Code | String | The [CMS place of service code](https://www.cms.gov/Medicare/Coding/place-of-service-codes/Place_of_Service_Code_Set) on the claims. Required when `billing_class` is `professional`. See [additional notes concerning `billing_class`, `service_code`, and `setting`](#additional-notes-concerning-billing_class-service_code-and-setting). | Conditional |
| **setting** | Setting | String | Whether the item or service was furnished inpatient or outpatient. Required when `billing_class` is `institutional`. See [allowed setting values](#allowed-setting-values) and [additional notes concerning `billing_class`, `service_code`, and `setting`](#additional-notes-concerning-billing_class-service_code-and-setting). | Conditional |
| **billing_code_modifiers** | Billing Code Modifiers | Array | The modifiers on the claims, as strings. Claims with different modifiers are reported in separate allowed amount objects. If the claims carried no modifier, don't include `billing_code_modifiers`. An empty array (`[]`) or an empty string (`[""]`) is invalid. | No |
| **payments** | Payments | Array | Each unique allowed amount paid under this object, with its billed charge and the providers who were paid it. An array of [payment objects](#payment-object); at least one, and none may repeat. | Yes |

##### Additional Notes Concerning `billing_class`, `service_code`, and `setting`
A professional claim carries a place of service code, which also says whether the service was inpatient or outpatient. An institutional claim carries no place of service code, so `setting` takes its place.

| `billing_class` | `service_code` | `setting` |
| --------------- | -------------- | --------- |
| `professional` | Required | Optional |
| `institutional` | Not required | Required |

Each allowed amount object has one place of service. A provider paid for the same item at two places of service is reported in two allowed amount objects.

#### Tax Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **ein** | Employer Identification Number | String | The Employer Identification Number issued by the IRS, either as `12-3456789` or `123456789`. See [additional notes concerning `ein` and `npi`](#additional-notes-concerning-ein-and-npi). | One of |
| **npi** | National Provider Identifier | String | The provider's 10-digit NPI, used in place of a Social Security number. See [additional notes concerning `ein` and `npi`](#additional-notes-concerning-ein-and-npi). | One of |
| **business_name** | Business Name | String | The legal business name associated with the EIN: the name of the organization (NPI Type 2 entity), not of individual practitioners. Required when `ein` is present. | Conditional |

##### Additional Notes Concerning `ein` and `npi`
Include either `ein` or `npi`, not both. Most providers are identified by the EIN of the business they bill through. Some individual providers still bill under their Social Security number. To keep personally identifiable information out of the files, report that provider's NPI in `npi` instead. An `npi` here means the provider would otherwise be identified by a Social Security number.

#### Payment Object
Each payment object is one unique allowed amount and billed charge, with the providers who were paid it.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **allowed_amount** | Allowed Amount | Number | The dollar amount the plan or issuer paid the out-of-network provider for the item or service, plus the participant's, beneficiary's, or enrollee's share of the cost. See [additional notes concerning `allowed_amount` and `billed_charge`](#additional-notes-concerning-allowed_amount-and-billed_charge). | Yes |
| **billed_charge** | Billed Charge | Number | The total dollar amount the out-of-network provider charged for the item or service. See [additional notes concerning `allowed_amount` and `billed_charge`](#additional-notes-concerning-allowed_amount-and-billed_charge). | Yes |
| **npi** | National Provider Identifiers | Array | The NPIs of providers who submitted their billed charges and the allowed amounts reimbursed, as 10-digit strings. At least one; none may repeat. | Yes |

##### Additional Notes Concerning `allowed_amount` and `billed_charge`
Report each unique combination of allowed amount and billed charge once, with every NPI under the tax identification number that was paid it. Don't split one combination across payment objects with different NPI lists. The same allowed amount can appear in more than one payment object when it was paid against different billed charges.

### Allowed Amount File Allowed Values
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

#### Allowed Market Segment Values
Used by `market_segment`. These are the health insurance markets the final rule defines for the Allowed Amount File, and the same values the Table of Contents uses.

| Value | Meaning |
| ----- | ------- |
| `individual` | The individual market. |
| `small_group` | The small group market. |
| `large_group` | The large group market. |
| `self_insured` | Self-insured group health plans. Plans from several plan sponsors may be combined in one file. |

#### Allowed Billing Code Type Values
Used by `billing_code_type`. For a billing code standard not in this table, please open a [discussion](https://github.com/CMSgov/price-transparency-guide/discussions) to propose adding it.

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
| Enhanced Ambulatory Patient Grouping | `EAPG` | |
| Current Dental Terminology | `CDT` | [CDT](https://www.ada.org/en/publications/cdt) |
| Revenue Code | `RC` | |

#### Allowed Billing Class Values
Used by `billing_class`.

| Value | Meaning |
| ----- | ------- |
| `professional` | A professional claim (CMS-1500 or 837P): an item or service billed by a provider. |
| `institutional` | An institutional claim (UB-04 or 837I): an item or service billed by a facility. |

#### Allowed Setting Values
Used by `setting`.

| Value | Meaning |
| ----- | ------- |
| `inpatient` | Furnished during an inpatient stay. |
| `outpatient` | Furnished on an outpatient basis. |

