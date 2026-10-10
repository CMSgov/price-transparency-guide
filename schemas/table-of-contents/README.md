### Table of Contents File
**The Table of Contents File is required. It is the file that defines the plan information: it lists each provider network and the files that describe it, each plan or policy and the networks it uses, and the Allowed Amount File for each health insurance market. A file user finds the files that apply to a plan through the Table of Contents.**

#### Reading the Required column
Each of the following tables has various requirements for individual attribute disclosures. The following are the definitions for each attribute's expected requirement in the machine-readable files.

| Value | Meaning |
| ----- | ------- |
| Yes | Must always be present. |
| No | May be omitted. Where omission has a specific meaning, the Definition says so. |
| Conditional | Required only under the condition stated in the Definition: when another field is present, or from a date set by the final rule. |
| One of | Include one field from a pair, but not both. The object's additional notes name the pair and say when to use each. |

#### Table of Contents Root Level Object

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **schema_version** | Schema Version | String | The version of the schema the file conforms to, for example `3.0.0`. | Yes |
| **reporting_entity** | Reporting Entity | Object | The entity that published the file. See the [reporting entity object](#reporting-entity-object). | Yes |
| **reporting_period** | Reporting Period | Object | The quarterly period the indexed files cover. See the [date range object](#date-range-object). | Yes |
| **last_updated_on** | Last Updated On | String | The date the file was last updated, in ISO 8601 format (YYYY-MM-DD). This is the "date in the file" that the attestation refers to. | Yes |
| **attestation** | Attestation | Object | The attestation of accuracy and completeness, and the official responsible for it. See the [attestation object](#attestation-object). | Yes |
| **networks** | Networks | Array | Each provider network, once, with the files that describe it. An array of [network objects](#network-object); at least one. | Yes |
| **plans** | Plans | Array | Each plan or policy, once, with the networks it uses. An array of [plan entry objects](#plan-entry-object); at least one. | Yes |
| **allowed_amount_files** | Allowed Amount Files | Object | The Allowed Amount File for each health insurance market, keyed by market segment. See the [allowed amount files object](#allowed-amount-files-object). | Yes |

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

#### Network Object
One provider network and the files that describe it. Each network appears once in `networks`.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **network** | Network | Object | The network's identifier and common names. See the [network identity object](#network-identity-object). | Yes |
| **negotiated_by** | Negotiated By | Object | Who negotiated the rates in this network. See the [negotiated by object](#negotiated-by-object). | Yes |
| **in_network_files** | In-Network Files | Array | The location of this network's In-network Rate File, as an array of [file location objects](#file-location-object) with at least one entry. More than one location means the network's rates are split across several files. Each is an In-network Rate File carrying this network's `network_id`. | Yes |
| **utilization_file** | Utilization File | Object | The location of this network's Utilization File, as a [file location object](#file-location-object). Required once the Utilization File is first posted. See [applicability dates](#applicability-dates). | Conditional |
| **taxonomy_mapping_file** | Taxonomy File | Object | The location of the Taxonomy File used to prepare this network's In-network Rate File, as a [file location object](#file-location-object). Required once the Taxonomy File is first posted. See [applicability dates](#applicability-dates). | Conditional |

#### Network Identity Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **network_id** | Network ID | String | The provider network identifier. It ties together the In-network Rate, Utilization, and Taxonomy Files for one network, and plans reference the network by it. See [additional notes concerning `network_id`](#additional-notes-concerning-network_id). | Yes |
| **network_name** | Network Name | Array | The common provider network names most familiar to members and the public, as an array of strings. At least one; none may repeat. | Yes |

##### Additional Notes Concerning `network_id`
Use the identifier you already use to track the network internally. If none exists, assign one that is:
- **unique** among the networks you report;
- **stable**, unchanged across reporting periods for as long as the network's providers and rates belong to the same network;
- **never reused**, so a retired identifier never names a different network; and
- **independent of the network name**, so renaming a network does not change it.

A variation in a network's providers or rates is a separate network and needs its own identifier. For a network negotiated by another entity (a rented network, carve-out vendor, or host plan), use the identifier that entity assigns, where it provides one.

Each `network_id` should appear only once in `networks`.

#### Negotiated By Object
Who negotiated the rates in a network, and how the reporting entity's members come to be paid at them. Every network states this, including networks the reporting entity negotiated itself.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **name** | Negotiating Entity Name | String | The legal name of the entity that negotiated this network's rates with the providers. Which entity that is depends on the arrangement; see [allowed arrangement values](#allowed-arrangement-values). | Yes |
| **arrangement** | Arrangement | String | How the rates came to apply to the reporting entity's members. See [allowed arrangement values](#allowed-arrangement-values) and [additional notes concerning `arrangement` and `arrangement_description`](#additional-notes-concerning-arrangement-and-arrangement_description). | One of |
| **arrangement_description** | Arrangement Description | String | A plain-language description of an arrangement that none of the allowed arrangement values describes: who negotiated the rates, and on what terms the reporting entity's members are paid at them. See [additional notes concerning `arrangement` and `arrangement_description`](#additional-notes-concerning-arrangement-and-arrangement_description). | One of |

##### Additional Notes Concerning `arrangement` and `arrangement_description`
Include either `arrangement` or `arrangement_description`, but not both.
- Use `arrangement` when one of the [allowed arrangement values](#allowed-arrangement-values) describes how the rates apply.
- Use `arrangement_description` only when none of them does.

A `negotiated_by` with both fields, or with neither, fails validation.

#### Plan Entry Object
One plan or policy and the networks it uses. Each plan appears once in `plans`.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan** | Plan | Object | The plan's identity. See the [plan object](#plan-object). | Yes |
| **network_references** | Network References | Array | The networks this plan uses, as an array of [network reference objects](#network-reference-object) with at least one entry. See [additional notes concerning `network_references`](#additional-notes-concerning-network_references). | No |

##### Additional Notes Concerning `network_references`
Leave `network_references` out entirely for a plan that contracts with no provider network, such as a traditional indemnity plan. That plan has no In-network Rate File; its only disclosure is the Allowed Amount File for its `market_segment`. An empty array is not a substitute and fails validation.

A plan's `product_type` doesn't decide this: an indemnity plan that uses a rented network does list it.

#### Plan Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **plan_name** | Plan Name | String | The plan's or policy's name. | Yes |
| **issuer_name** | Issuer Name | String | The name of the plan's issuer. | Yes |
| **plan_identifier** | Plan Identifier | Object | The plan's HIOS ID, or its sponsor's EIN. See the [plan identifier object](#plan-identifier-object). | Yes |
| **plan_market_type** | Market Type | String | See [allowed market type values](#allowed-market-type-values). | Yes |
| **market_segment** | Market Segment | String | The health insurance market the plan belongs to. This identifies the Allowed Amount File that covers it. See [allowed market segment values](#allowed-market-segment-values). | Yes |
| **product_type** | Product Type | String | The plan's or policy's product type. See [allowed product type values](#allowed-product-type-values) and [additional notes concerning `product_type` and `product_type_description`](#additional-notes-concerning-product_type-and-product_type_description). | One of |
| **product_type_description** | Product Type Description | String | A plain-language description of the product type, when none of the allowed product type values describes it. See [additional notes concerning `product_type` and `product_type_description`](#additional-notes-concerning-product_type-and-product_type_description). | One of |

##### Additional Notes Concerning `product_type` and `product_type_description`
Include either `product_type` or `product_type_description`, but not both.
- Use `product_type` when one of the [allowed product type values](#allowed-product-type-values) describes the plan.
- Use `product_type_description` only when none of them does.

Product type describes the plan's or policy's benefit design, not its network.

#### Plan Identifier Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **hios** | HIOS ID | String | The plan's Health Insurance Oversight System identifier: either the 5-digit HIOS issuer ID, or the 14-character HIOS plan ID (5-digit issuer ID, 2-letter state, 3-digit product number, 4-digit component). See [additional notes concerning `hios` and `ein`](#additional-notes-concerning-hios-and-ein). | One of |
| **ein** | EIN | String | The plan sponsor's Employer Identification Number, in the format `NN-NNNNNNN`. See [additional notes concerning `hios` and `ein`](#additional-notes-concerning-hios-and-ein). | One of |
| **plan_sponsor_name** | Plan Sponsor Name | String | The common business name of the plan sponsor. Required when `ein` is present; optional with `hios`. | Conditional |

##### Additional Notes Concerning `hios` and `ein`
Include either `hios` or `ein`, but not both.
- Use `hios` when the plan has a HIOS ID.
- Use `ein` only when it doesn't.

With `ein`, also include `plan_sponsor_name`, because an EIN identifies the sponsor, not the plan.

#### Network Reference Object
One network a plan uses, with its place in the order the plan's networks are consulted.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **network_id** | Network ID | String | The `network_id` of a network listed in this file's `networks`. | Yes |
| **precedence** | Precedence | Integer | The order in which this plan's networks are consulted to find the rate that applies. `1` is consulted first. Required even when the plan uses only one network. See [additional notes concerning `precedence` and `tier`](#additional-notes-concerning-precedence-and-tier). | Yes |
| **tier** | Tier | Integer | The cost-sharing tier this network has for this plan, for tiered products only. `1` is the most preferred tier. See [additional notes concerning `precedence` and `tier`](#additional-notes-concerning-precedence-and-tier). | No |
| **tier_label** | Tier Label | String | The plan's name for the tier, as it appears in member materials. Required when `tier` is present. | Conditional |

##### Additional Notes Concerning `precedence` and `tier`
**Precedence decides which rate applies.** For a given provider and billing code, the rate comes from the network with the lowest `precedence` whose In-network Rate File prices that provider for that code. Each of a plan's network references has a different `precedence`.

**Tier is about cost sharing, not rates.** `tier` is the cost-sharing level a member pays when using the network, and it exists only on tiered products. Leave it out on a plan that isn't tiered; such a plan has no tier, not tier `1`. On a tiered plan, tiers and precedence usually run in the same order, but they answer different questions.

**Example**

```json
"plans": [
  {
    "plan": { "plan_name": "ACME Gold PPO 1000", "...": "..." },
    "network_references": [
      { "network_id": "NET-BH-CARVEOUT", "precedence": 1 },
      { "network_id": "NET-CHOICE-PPO",  "precedence": 2 }
    ]
  },
  {
    "plan": { "plan_name": "ACME Premier Tiered POS 500", "...": "..." },
    "network_references": [
      { "network_id": "NET-SELECT-HMO", "precedence": 1, "tier": 1, "tier_label": "Select Preferred" },
      { "network_id": "NET-CHOICE-PPO", "precedence": 2, "tier": 2, "tier_label": "Choice Standard" }
    ]
  }
]
```

Which rate applies:

| Plan | Claim | Networks that price it | Rate that applies |
| ---- | ----- | ---------------------- | ----------------- |
| ACME Gold PPO 1000 | Psychotherapy (90837) from a provider in the behavioral health carve-out | `NET-BH-CARVEOUT` | `NET-BH-CARVEOUT` (precedence 1) |
| ACME Gold PPO 1000 | Knee replacement (27447) from a Choice PPO surgeon | `NET-CHOICE-PPO` only. The carve-out file doesn't price surgery | `NET-CHOICE-PPO` (precedence 2) |
| ACME Premier Tiered POS 500 | Office visit (99213) from a provider in both networks | `NET-SELECT-HMO` and `NET-CHOICE-PPO` | `NET-SELECT-HMO` (precedence 1); the member pays tier 1 cost sharing |
| ACME Premier Tiered POS 500 | Office visit (99213) from a provider only in Choice PPO | `NET-CHOICE-PPO` | `NET-CHOICE-PPO` (precedence 2); the member pays tier 2 cost sharing |

#### Allowed Amount Files Object
The Allowed Amount File for each health insurance market the reporting entity reports, keyed by market segment. Each key is one of the [allowed market segment values](#allowed-market-segment-values), and each value is a [file location object](#file-location-object) for that market's Allowed Amount File. At least one market must be listed.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **individual** | Individual | Object | The Allowed Amount File for the individual market. Required when any plan in `plans` has this `market_segment`. | Conditional |
| **small_group** | Small Group | Object | The Allowed Amount File for the small group market. Required when any plan in `plans` has this `market_segment`. | Conditional |
| **large_group** | Large Group | Object | The Allowed Amount File for the large group market. Required when any plan in `plans` has this `market_segment`. | Conditional |
| **self_insured** | Self-Insured | Object | The Allowed Amount File for self-insured group health plans. Required when any plan in `plans` has this `market_segment`. | Conditional |

##### Additional Notes Concerning `allowed_amount_files`
Each market appears once, so a market can't point to two files.

List a market's file even when no item or service met the claims threshold. That file is still published, with an empty `out_of_network` array.

**Example**

```json
"allowed_amount_files": {
  "self_insured": {
    "description": "Out-of-network allowed amounts, self-insured segment",
    "location": "https://mrf.acmehealth.example/2027-04/allowed-amounts-self-insured.json"
  },
  "large_group": {
    "description": "Out-of-network allowed amounts, large group segment",
    "location": "https://mrf.acmehealth.example/2027-04/allowed-amounts-large-group.json"
  },
  "individual": {
    "description": "Out-of-network allowed amounts, individual segment. No item or service met the reporting threshold.",
    "location": "https://mrf.acmehealth.example/2027-04/allowed-amounts-individual.json"
  }
}
```

#### File Location Object
| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **description** | Description | String | A short description of the file, such as the network or market and the period it covers. | Yes |
| **location** | Location | String | The full URL where the file can be downloaded. It must begin with `https://`, and the file must be downloadable without an account, password, or other credentials. | Yes |

### Table of Contents Allowed Values
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

#### Allowed Arrangement Values
Used by `negotiated_by.arrangement`. An arrangement not described here is given in `arrangement_description` instead.

| Value | Meaning | `name` is |
| ----- | ------- | --------- |
| `own` | The reporting entity, or an affiliate under common ownership or control with it, negotiated directly with the providers. | The reporting entity, or the affiliate that negotiated the rates |
| `rented` | The reporting entity pays for access to a network another entity assembled and holds the provider contracts for. That entity does not manage the benefit. Includes networks described as leased or wrap networks. | The network vendor |
| `carve_out_vendor` | A vendor administers a defined category of benefits, such as behavioral health, under its own provider contracts, and manages that benefit on the plan's behalf. | The vendor |
| `host_plan` | Another member of an inter-plan program, in whose service area the care is delivered, negotiated the rates. They apply to the reporting entity's members through that program. | The host plan |
| `plan_sponsor_direct` | The plan sponsor contracted directly with the providers, and the reporting entity reports those rates on the sponsor's behalf. | The plan sponsor |

`rented` and `carve_out_vendor` differ in who manages the benefit. A rented network supplies contracted providers; claims, utilization management, and plan rules stay with the reporting entity. A carve-out vendor runs the benefit for its category.

#### Allowed Market Type Values
Used by `plan.plan_market_type`.

| Value | Meaning |
| ----- | ------- |
| `group` | Group health plan coverage. |
| `individual` | Individual market coverage. |

#### Allowed Market Segment Values
Used by `plan.market_segment`, and as the keys of `allowed_amount_files`. These are the health insurance markets the final rule defines for the Allowed Amount File.

| Value | Meaning |
| ----- | ------- |
| `individual` | The individual market. |
| `small_group` | The small group market. |
| `large_group` | The large group market. |
| `self_insured` | Self-insured group health plans. Each plan sponsor's self-insured plans form one market. The party reporting for them under a written agreement may combine several sponsors' plans in a single Allowed Amount File. |

#### Allowed Product Type Values
Used by `plan.product_type`. A product type not listed here is given in `product_type_description` instead.

| Value | Meaning |
| ----- | ------- |
| `hmo` | Health maintenance organization |
| `ppo` | Preferred provider organization |
| `epo` | Exclusive provider organization |
| `pos` | Point of service |
| `hdhp` | High deductible health plan |
| `indemnity` | Indemnity |

### Applicability Dates
The final rule applies in two phases. Fields marked Conditional because they point to a Phase 2 file are left out until that file is first posted.

| Phase | Files | First posted | Fields in this file |
| ----- | ----- | ------------ | ------------------- |
| 1 | Table of Contents, In-network Rate Files, Allowed Amount Files, and their attestations | April 1, 2027, then quarterly | Everything not listed below |
| 2 | Taxonomy File | October 1, 2027, then quarterly | `taxonomy_mapping_file` |
| 2 | Utilization File | July 1, 2028, then annually | `utilization_file` |

### Example
In the following example, ACME Health Plan, Inc. reports four networks and five plans:
* **Four networks.** ACME negotiated two itself (`NET-CHOICE-PPO`, `NET-SELECT-HMO`). A vendor negotiated the behavioral health carve-out (`NET-BH-CARVEOUT`), and the national wrap network is rented (`NET-WRAP-NATIONAL`).
* **ACME Gold PPO 1000** checks the behavioral health carve-out first, then Choice PPO. It isn't tiered.
* **Example Manufacturing Employee Health Plan** is a self-funded employer plan identified by EIN, so it includes `plan_sponsor_name`. Its out-of-network data is in the self-insured Allowed Amount File.
* **ACME Premier Tiered POS 500** is tiered: Select HMO is tier 1 and Choice PPO is tier 2.
* **ACME Classic Indemnity 80/20** has no provider network, so it has no `network_references`. Its only disclosure is the large group Allowed Amount File.
* **ACME Classic Indemnity Plus 80/20** is also an indemnity plan, but it uses the rented wrap network, so it lists it.
* **No utilization or taxonomy file locations.** This file is posted April 1, 2027, before those files exist (see [applicability dates](#applicability-dates)).
* **No individual or small group Allowed Amount File,** because no plan in this file is in those markets.

```json
{
  "schema_version": "3.0.0",
  "reporting_entity": {"name": "ACME Health Plan, Inc.", "type": "health_insurance_issuer"},
  "reporting_period": {"start": "2027-04-01", "end": "2027-06-30"},
  "last_updated_on": "2027-04-01",
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
  },
  "networks": [
    {
      "network": {"network_id": "NET-CHOICE-PPO", "network_name": ["ACME Choice PPO", "ACME Choice Network"]},
      "negotiated_by": {"name": "ACME Health Plan, Inc.", "arrangement": "own"},
      "in_network_files": [
        {
          "description": "In-network rates, ACME Choice PPO, Q2 2027",
          "location": "https://mrf.acmehealth.example/2027-04/net-choice-ppo.json"
        }
      ]
    },
    {
      "network": {"network_id": "NET-SELECT-HMO", "network_name": ["ACME Select HMO"]},
      "negotiated_by": {"name": "ACME Health Plan, Inc.", "arrangement": "own"},
      "in_network_files": [
        {
          "description": "In-network rates, ACME Select HMO, Q2 2027",
          "location": "https://mrf.acmehealth.example/2027-04/net-select-hmo.json"
        }
      ]
    },
    {
      "network": {"network_id": "NET-BH-CARVEOUT", "network_name": ["Example Behavioral Health Network"]},
      "negotiated_by": {"name": "Example Behavioral Partners, LLC", "arrangement": "carve_out_vendor"},
      "in_network_files": [
        {
          "description": "In-network rates, behavioral health carve-out, Q2 2027",
          "location": "https://mrf.acmehealth.example/2027-04/net-bh-carveout.json"
        }
      ]
    },
    {
      "network": {"network_id": "NET-WRAP-NATIONAL", "network_name": ["Example National Wrap Network"]},
      "negotiated_by": {"name": "Example Network Rentals, Inc.", "arrangement": "rented"},
      "in_network_files": [
        {
          "description": "In-network rates, national wrap network, Q2 2027",
          "location": "https://mrf.acmehealth.example/2027-04/net-wrap-national.json"
        }
      ]
    }
  ],
  "plans": [
    {
      "plan": {
        "plan_name": "ACME Gold PPO 1000",
        "issuer_name": "ACME Health Plan, Inc.",
        "plan_identifier": {"hios": "45821WA0080001"},
        "plan_market_type": "group",
        "market_segment": "large_group",
        "product_type": "ppo"
      },
      "network_references": [
        {"network_id": "NET-BH-CARVEOUT", "precedence": 1},
        {"network_id": "NET-CHOICE-PPO", "precedence": 2}
      ]
    },
    {
      "plan": {
        "plan_name": "Example Manufacturing Employee Health Plan",
        "issuer_name": "ACME Health Plan, Inc.",
        "plan_identifier": {"ein": "91-0442452", "plan_sponsor_name": "Example Manufacturing Company"},
        "plan_market_type": "group",
        "market_segment": "self_insured",
        "product_type": "ppo"
      },
      "network_references": [{"network_id": "NET-CHOICE-PPO", "precedence": 1}]
    },
    {
      "plan": {
        "plan_name": "ACME Premier Tiered POS 500",
        "issuer_name": "ACME Health Plan, Inc.",
        "plan_identifier": {"hios": "45821WA0090002"},
        "plan_market_type": "group",
        "market_segment": "large_group",
        "product_type": "pos"
      },
      "network_references": [
        {
          "network_id": "NET-SELECT-HMO",
          "precedence": 1,
          "tier": 1,
          "tier_label": "Select Preferred"
        },
        {
          "network_id": "NET-CHOICE-PPO",
          "precedence": 2,
          "tier": 2,
          "tier_label": "Choice Standard"
        }
      ]
    },
    {
      "plan": {
        "plan_name": "ACME Classic Indemnity 80/20",
        "issuer_name": "ACME Health Plan, Inc.",
        "plan_identifier": {"hios": "45821WA0080002"},
        "plan_market_type": "group",
        "market_segment": "large_group",
        "product_type": "indemnity"
      }
    },
    {
      "plan": {
        "plan_name": "ACME Classic Indemnity Plus 80/20",
        "issuer_name": "ACME Health Plan, Inc.",
        "plan_identifier": {"hios": "45821WA0080003"},
        "plan_market_type": "group",
        "market_segment": "large_group",
        "product_type": "indemnity"
      },
      "network_references": [{"network_id": "NET-WRAP-NATIONAL", "precedence": 1}]
    }
  ],
  "allowed_amount_files": {
    "self_insured": {
      "description": "Allowed amounts, self insured market, 2027-01-01 to 2027-06-30",
      "location": "https://mrf.acmehealth.example/2027-04/allowed-amounts-self-insured.json"
    },
    "large_group": {
      "description": "Allowed amounts, large group market, 2027-01-01 to 2027-06-30",
      "location": "https://mrf.acmehealth.example/2027-04/allowed-amounts-large-group.json"
    }
  }
}
```
