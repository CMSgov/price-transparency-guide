### Rx file schema

This schema describes the Rx attributes that are necessary for the drug flat file.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **reporting_entity_name** | Entity Name | String | The legal name of the entity publishing the machine-readable file. | Yes |
| **reporting_entity_type** | Entity Type | String | The type of entity that is publishing the machine-readable file (a group health plan, health insurance issuer, or a third party with which the plan or issuer has contracted to provide the required information, such as a third-party administrator, a health care claims clearinghouse, or a health insurance issuer that has contracted with a group health plan sponsor). | Yes |
| **plan_name** | Plan Name | String | The plan name and name of plan sponsor and/or insurance company (for example, “Maximum Health Plan: Alpha Insurance Group”). | Yes |
| **plan_id_type** | Plan ID Type | String | Allowed values: "EIN" and "HIOS" | Yes |
| **plan_id** | Plan ID | String | The 14-digit Health Insurance Oversight System (HIOS) identifier, or, if the 14-digit HIOS identifier is not available, the 5-digit HIOS identifier, or if no HIOS identifier is available, the Employer Identification Number (EIN), for each coverage option offered by a plan or issuer | Yes |
| **plan_market_type** | Market Type | String | Allowed values: "group" and "individual" | Yes |
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
| **npi** | National Provider Identifier | Array | An array of *type 1* individual national provider identification numbers (NPI) | No |
| **pharmacies** | Providers |	Array | A list of different [providers objects](#provider-object) that have specific negotiated rates for the specific `ndc` | No |

##### Additional Notes
The `historical_net_price` is the average dollar price for the 90-day period beginning 180 days before the file publication date, including any in-network pharmacy or other prescription drug dispenser, for a prescription drug, inclusive of any _reasonably allocated rebates, discounts, chargebacks, fees, and any additional price concessions received by the plan or issuer_ with respect to the prescription drug or prescription drug service.  The historic net price must be reported at the billing unit level as defined by the NCPDP. The standard contains three units: Each “EA,” Milliliter “ML,” or Gram “GM.”

Further notes for _reasonable allocation of rebates, discounts, chargebacks, fees, and any additional price concessions_.
* If the total amount of the price concession is known to the plan or issuer on the file publication date, then rebates, discounts, chargebacks, fees, and other price concessions must be reasonably allocated by total known dollar amount.
* If the total amount of the price concession is not known to the plan or issuer on the file publication date, then rebates, discounts, chargebacks, fees, and other price concessions should be reasonably allocated using a good faith, reasonable estimate of the average price concessions based on the rebates, discounts, chargebacks, fees, and other price concessions received over a time period prior to the current reporting period and of equal duration to the current reporting period.

The `negotiated_rate` is the rate agreed to pay an in-network provider, including an in-network pharmacy or other prescription drug dispenser, whether directly or indirectly, including through a third-party administrator or pharmacy benefit manager, for prescription drugs. The negotiated rate must be reported at the billing unit level as defined by NCPDP. The standard contains three units “EA,” “ML,” or “GM.” Fees that are assessed at the point of sale must be reflected separately as a dollar amount (see Dispensing Fee, Administrative Fee, and Transaction Fee data elements). 

Fees that are assessed at the point of sale must be reflected separately as a dollar amount (see `dispensing_fee`, `administrative_fee`, and `transaction_fee` data elements).

#### Pharmacies Object

Different types of pharmacies that have the specific negotiated rate and historical net price for the defined `pharmacy_id_type`.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **pharmacy_id_type** | Provider ID Type |	String | Allowed values: “NCPDP ID,” “NCPDP Chain Code,” or “NPI”. Note: NPIs must be of *type 2* to be included in `pharmacy_ids` | Yes |
| **pharmacy_ids** | Pharmacy IDs | Array | The pharmacy idenifier based on the `phaarmacy_id_type`. See Additional Notes | Yes |

##### Additional Notes

The `pharmacy_ids` element is dependent on the `pharmacy_id_type`. The following `pharmacy_id_type` values are allowed:
* `NCPDP ID` - [The National Council for Prescription Drug Programs (NCPDP) ID](https://www.resdac.org/cms-data/variables/ncpdp-pharmacy-identifier-pharmacy-characteristics) - The unique 7-digit number assigned by the NCPDP to every licensed pharmacy and non-Pharmacy Dispensing Site (NPDS) in the United States and its territories. This number represents a unique pharmacy entity or line of business and is used to identify licensed pharmacies and NPDSs to insurance companies, health care providers, and other entities.
* `NCPDP Chain Code` - [The NCPDP Chain Code](https://accessonline.ncpdp.org/Resources/Help/NCPDP%20Part%202%20Training%20Guide%20v1.04.pdf) - The ID number provided by the NCPDP that represents a group of pharmacies under the same ownership. If the plan or issuer includes the NCPDP Chain Code, it must also include the NCPDP IDs for each pharmacy that is represented in the group of pharmacies that are identified by the NCPDP Chain Code.
* `NPI` - [The NPI Type 2](https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/downloads/NPI-What-You-Need-To-Know.pdf) - The unique 10-digit identification number issued to a provider by CMS for an organization of health care providers, such as a medical group or pharmacy.


