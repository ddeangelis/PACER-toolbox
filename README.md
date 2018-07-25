<p align="center">
<a href="https://tycherisk.co"><img src="tyche_logo.png" alt="Tyche"></a><br/>
<b>Utility for extracting data from PACER summaries</b><br/>
</p>

[PACER](https://www.pacer.gov/) (Public Access to Court Electronic Records) is an electronic public access service that allows users to obtain case and docket information online from federal appellate, district, and bankruptcy courts, and the PACER Case Locator.

PACER is a paid service, and collecting summary information is far less expensive than gathering full case documents. Command line tools (wget, curl, etc.) can be used to harvest html search results from PACER with minimal fees incurred, then these html pages are fed into this utility to extract summary information for each docket: 

- Case ID
- Plaintiff name
- Defendant
- Court
- NOS (Nature of Suit) Code
- Date Filed
- Date Closed

