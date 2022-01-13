### Provider Reference File

The schema has a single root object vs an array to accommodate formats that may not allow for multiple root nodes, such as XML.

| Field | Name | Type | Definition | Required |
| ----- | ---- | ---- | ---------- | -------- |
| **provider_groups** | Provider Groups | Array | The [providers object](#providers-object) defines information about the provider and their associated TIN related to the negotiated price. | Yes |

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
