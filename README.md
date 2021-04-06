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

Keeping Up To Date
==================

Github allows for people to track and keep up-to-date with any changes for any repository. If you wish to follow and track the changes that happen on this repo, please leverage the "Watch" feature found at the top of the repository and select "All activity". This will email the user that has "watched" the specific repository.

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

Robots.txt
----------

To allow for search engine discoverability, neither a `robots.txt` file nor `meta` tag on the page where the files are hosted will have rules such that give instructions to web crawlers to not index the page.

This is typically follows the format of `<meta name="robots" content="noindex, nofollow">` or for a `robots.txt` file using the `Disallow` directive.

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
For payer or issuer's names and plan names that have spaces (i.e. "healthplan 100"), those spaces would be replaced with dashes `-`

For example, the following would be the required naming for CMS:
* `2020-01-05_cms_medicare_in-network-rates.json`
* `2020-01-05_cms_medicare_allowed-amounts.json`
* `2020-01-05_cms_medicare_prescription-drugs.json`

An example of a plan named `healthcare 100` with an issuer's name `issuer abc`, the following would be the naming output:
* `2020-01-05_issuer-abc_healthcare-100_in-network-rates.json`
* `2020-01-05_issuer-abc_healthcare-100_allowed-amounts.json`
* `2020-01-05_issuer-abc_healthcare-100_prescription-drugs.json`

Schemas
=======
* [In-Network Rates](https://github.com/CMSgov/price-transparency-guide/tree/master/schemas/in-network-rates)
* [Allowed Amounts](https://github.com/CMSgov/price-transparency-guide/tree/master/schemas/allowed-amounts)
* [Prescription Drugs](https://github.com/CMSgov/price-transparency-guide/tree/master/schemas/prescription-drugs)


Examples
========
* [Implementation Examples](https://github.com/CMSgov/price-transparency-guide/tree/master/examples)

Getting Involved
================

The healthcare ecosystem is complex with what seems like an infinite amount of plan and issuer implementations. There are no doubt going to be questions for these various situations and the requirements found in the Transparency in Coverage rule. Currently, there are two ways in which the community can get involved:
* [Github Issues](https://guides.github.com/features/issues/) - Where people discuss issues related to the project.
* [Github Discussions](https://github.com/CMSgov/price-transparency-guide/discussions) - Use these channels for conversational topics (for example, “How do I…“ or “What do you think about…“ instead of bug reports or feature requests).

Before posting a comment, issue, or question, please search through existing discussions and issues. There is a good chance that the topic in questions is already being discussed.
