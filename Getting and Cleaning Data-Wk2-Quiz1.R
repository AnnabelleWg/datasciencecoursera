#Q1.Register an application with the Github API here https://github.com/settings/applications. 
#Access the API to get information on your instructors repositories 
#(hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
#Use this data to find the time that the datasharing repo was created. What time was it created? 
#  This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
#You may also need to run the code in the base R package and not R studio.

# (i) 2012-06-21T17:28:38Z
# (ii) 2014-03-05T16:11:46Z
# (iii) 2013-11-07T13:25:07Z
# (iv) 2014-02-06T16:13:11Z

library(httr)
    # 1. Find OAuth settings for github
oauth_endpoints("github")

    # 2. To make your own application, register at
    #  https://github.com/settings/developers.Use any URL for the homepage URL
    #    (http://github.com is fine) and  http://localhost:1410 as the callback url.
    # Replace your key and secret below
 myapp <- oauth_app("github", "6e89262ac3a27a69cbd3", "5fd08e68ed1024779e03f232c2771f5ea79a58d3")
 #myapp <- oauth_app("github", "ClientID", "ClientSecret")
 
    # 3. GEt OAuth credentials
 github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
    # 4. Use API
 req <- GET("https://api.github.com/rate_limit", config(token = github_token))
 stop_for_status(req)
 content(req)
 
BROWSE("https://api.github.com/users/jtleek/repos", authenticate("Access Token","x-oauth-basic","basic"))


# Q2. The sqldf package allows for execution of SQL commands on R data frames. 
#.    We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL. 
#     Download the American Community Survey data and load it into an R object called acs

install.packages("sqldf")
library(sqldf)
acs <- read.csv("getdata_data_ss06pid.csv", header=T, sep=",")
sqldf("select pwgtp1 from acs where AGEP < 50")


# Q3. Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

# Q4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)

meowConnect <- url("http://biostat.jhsph.edu/~jleek/contact.html")
helloMeow <- readLines(meowConnect)
close(meowConnect)
c(nchar(helloMeow[10]),nchar(helloMeow[20]),nchar(helloMeow[30]),nchar(helloMeow[100]))
# [1] 45 31  7 25

# Q5.Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

# Original source of the data: 
#  http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# (Hint this is a fixed width file format)

MeowMeow<-read.csv("getdata_wksst8110.for", header=TRUE)
meowFile<-"getdata_wksst8110.for"
meowCatch<-read.fwf(file=meowFile,widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4),skip=4)
sum(meowCatch[,4])


