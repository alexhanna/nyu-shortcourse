library(rvest)
library(stringr)

vignette("selectorgadget")
# add selectorGadget to browser

url <- 'http://ipaidabribe.com/reports/paid'
bribes <- read_html(url)

# first we extract the amounts
# use selectorGadget to identify it
amounts <- html_nodes(bribes, ".paid-amount span")
amounts

# and we extract the text
(amounts <- html_text(amounts))

# use regular expressions to extract what we want
(amounts <- gsub("Paid INR ", "", amounts))

# and clean empty text
(amounts <- str_trim(amounts))

# finally, delete commas and convert to numeric
(amounts <- gsub(",", "", amounts))
(amounts <- as.numeric(amounts))

# let's do another one: transaction during which bribe occurred
transaction <- html_nodes(bribes, ".transaction a")
(transaction <- html_text(transaction))

# and one more
dept <- html_nodes(bribes, ".name a")
(dept <- html_text(dept))

# best way to do this is to put it inside a function
scrape_bribe <- function(url){
	bribes <- read_html(url)
	# amounts
	amounts <- html_text(html_nodes(bribes, ".paid-amount span"))
	amounts <- str_trim(gsub("Paid INR |,", "", amounts))
	# other variables
	transaction <- html_text(html_nodes(bribes, ".transaction a"))
	dept <- html_text(html_nodes(bribes, ".name a"))
	# putting together into a data frame
	df <- data.frame(
		amounts = amounts,
		transaction = transaction,
		dept = dept,
			stringsAsFactors=F)
	return(df)
}

bribes <- list()
bribes[[1]] <- scrape_bribe(url)

# and we look at the structure of the URLs
base_url <- "http://ipaidabribe.com/reports/paid?page="

# we'll loop over the first five pages
pages <- seq(0, 50, by=10)

for (i in 2:length(pages)){
	# informative message about progress of loop
	message(i, '/', length(pages))
	# prepare URL
	url <- paste(base_url, pages[i], sep="")
	# scrape website
	bribes[[i]] <- scrape_bribe(url)
	# wait a couple of seconds between URL calls
	Sys.sleep(2)
}

# we convert the list of data frames into a single data frame
bribes <- do.call(rbind, bribes)

head(bribes)
str(bribes)

# quick descriptive statistics
tab <- table(bribes$transaction)
tab <- sort(tab, decreasing=TRUE)	
head(tab)

summary(bribes$amounts)

# oops, we forgot to convert to numeric
bribes$amounts <- as.numeric(bribes$amounts)
summary(bribes$amounts)

(agg <- aggregate(bribes$amount, by=list(dept=bribes$dept), FUN=mean))
agg[order(agg$x),]

