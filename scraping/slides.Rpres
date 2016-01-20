Scraping the web
========================================================
author: Pablo Barberá
date: January 22, 2016
incremental: true

Scraping the web: what? why?
========================================================

An increasing amount of data is available on the web:

- Election results, budget allocations, legislative speeches...
- Social media data, newspaper articles, press releases...
- Geographic information, weather forecasts...

These data are often provided in an __unstructured format__.

Web scraping is the process of extracting this information automatically and transforming it into a structured dataset.

Scraping the web: two approaches
========================================================

Two different scenarios:

1. Screen scraping: extract data from source code of website, with html parser and/or regular expressions
  - `rvest` package
2. Web APIs (application programming interfaces): a set of structure http requests that return JSON or XML data
  - [`httr`](https://cran.r-project.org/web/packages/rvest/index.html) to construct API requests
  - packages specific to each API:  [`weatherData`](https://cran.r-project.org/web/packages/weatherData/index.html), [`WDI`](https://cran.r-project.org/web/packages/WDI/index.html), [`Rfacebook`](https://cran.r-project.org/web/packages/Rfacebook/index.html)... Check CRAN Task View on [Web Technologies and Services](https://cran.r-project.org/web/views/WebTechnologies.html) for more examples

The rules of the game
========================================================

1. Respect the hosting site's wishes:
  - First, check if an API exists or if data are available for download
  - Some websites _disallow_ scrapers on their `robots.txt` files
2. Limit your bandwidth use:
  - Wait one or two seconds after each hit
  - Scrape only what you need, and just once (e.g. store the html file in disk, and then parse it)
3. When using APIs, read documentation
  - Is there a batch download option?
  - Are there any rate limits?
  - Can you share the data?

The art of web scraping
========================================================

Workflow:

1. Learn about structure of website
2. Build prototype code
3. Generalize: functions, loops, debugging
4. Data cleaning

Three main scenarios
========================================================
incremental: false

1. Data in table format

![picture1](img/wikitable1.png)
![wikitable1](img/wikitable2.png)

Three main scenarios
========================================================
incremental: false

2\. Data in unstructured format  

![picture1](img/bribe.png)

[www.ipaidabribe.com/reports/paid](www.ipaidabribe.com/reports/paid)


Three main scenarios
========================================================
incremental: false

3\. Data hidden behind web forms

![picture1](img/venezuela.png)

[Candidates on 2015 Venezuelan parliamentary election](http://eligetucandidato.org/filtro/)


Three main scenarios
========================================================

1. Data in table format
  - Automatic extraction with `rvest`
2. Data in unstructured format
  - Element identification with `selectorGadget`
  - Aumatic extraction with `rvest`
3. Data hidden behind web forms
  - Automation of web browser behavior with `selenium`

Web data in table format
========================================================
incremental: false

![picture1](img/census.png)

[Population by Age Groups and Sex, U.S. Census](http://www.census.gov/population/international/data/idb/region.php?N=%20Results%20&T=10&A=separate&RT=0&Y=2016&R=-1&C=US)

APIs
========================================================

API = Application Programming Interface; a set of structured https requests that return data in JSON or XML format.

Types of APIs:  
1. RESTful APIs: queries for static information at current moment (e.g. user profiles, posts, etc.)  
2. Streaming APIs: changes in users' data in real time (e.g. new tweets, new FB posts...)  

Most APIs are rate-limited:
- Restrictions on number of API calls by user/IP address and period of time.

Connecting with an API
========================================================

Constructing a REST API call:
- Baseline URL: `https://graph.facebook.com/`
- Parameters: `?ids=barackobama,johnmccain`
- Authentication token: `&access_token=XXXXX`

Response is often in JSON Format.

Authentication
- Most common is an open standard called OAuth  
- Connections without sharing username or password, only temporary tokens that can be refreshed  
- `httr` package in R implements most cases ([examples](https://github.com/hadley/httr/tree/master/demo))

Social media APIs
========================================================

R packages:
- Twitter: `streamR` for streaming, `twitteR` or `smappR` for REST
- Facebook: `Rfacebook`

Many others on [CRAN Web Technologies Task View](https://cran.r-project.org/web/views/WebTechnologies.html)



