# Reading from MySQL
    # free and widely used open source database software
    # Data are structured in Databases/Tables within databases/Fields within tables

# Install RMySQL
    # On a Mac,
install.packages("RMySQL")
    # on Windows,
    #    official instructions=http://biostate.mc.vanderbilt.edu/wiki/Main/RMySQL

    # Example-UCSC database (http://genome.ucsc.edu/goldenPatn/help/mysql.html)
library(RMySQL)
    # Connecting and listing databases
ucscDb<-dbConnect(MySQL(), user="genome",
                  host="genome-mysql.cse.ucsc.edu") # it's an MySQL command, so you need to disconnect it later.
result<-dbGetQuery(ucscDb,"show database;")
dbDisconnect(ucscDb)

result # show the list of all db in the MySQL server located in the particular host address above
        # within a database, there can be multiple tables. Each table corresponding to what you might of as data table

    # Connecting to hg19 and listing tables
hg19<-dbConnect(MySQL(), user="genome", db="hg19",
                host= "genome-mysql.cse.ucsc.edu")
    # look at all tables in the hg19 database
allTables<-dbListTables(hg19) 
length(allTables)
allTables[1:5] # each different data type gets its own table

    # look at fields in a particular table (The fields correspond to something like the column names of a df )
dbListFields(hg19, "affyU133Plus2")
    # count the number of elements in a particular table (e.g.affyU133Plus2) in a database (e.g.hg19).
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

    # Select a Specific Subset
query<-dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3") # select all obs from table affyU133Plus2 ...
    # B/c dbSendQuery() didn't send the data to your computer, you need to fetch the result using fetch()
affMis<-fetch(query)
quantile(affMis$misMatches)

    # If you only want to suck out a very small amount of data
affyMisSmall<-fetch(query, n=10)
dbClearResult(query) # need to clear the query you sent out earlier to the MySQL server. 
                     # You fetch the data back, but it didn't stop that query from still being out at the MySQL server.
dim(affyMisSmall)

    # Don't forget to close the connection
dbDisconnect(hg19)


#Reading from MySQL
    # data structure: In a mySQL server, there could be multiple databases each of which could have multiple tables having multiple fields.
    # Each table corresponds to different kind of dataset.
    # Fields correpond to column names

  # look at all tables in the hg19 database
allTables<-dbListTables(hg19) 
length(allTables)
allTables[1:5] # each different data type gets its own table

  # look at fields in a particular table (The fields correspond to something like the column names of a df )
dbListFields(hg19, "affyU133Plus2")
  # count the number of elements in a particular table (e.g.affyU133Plus2) in a database (e.g.hg19).
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

    # To get a particular table from the MySQl server
affData<-dbReadTable(hg19, "affyU133Plus2")
head(affData)


# Reading from HDF5
    # used for storing large data sets
    # sipports storing a range of data types
    # Heirarchical data format

    # Groups containing 0 or more data sets and metadata
      # - have a group header with group name and list of attributes
      # - have a group symbol table with a list of objects in group

    # Datasets multidimensional array of data elements with metadata
      # - have a header with name, datatype, dataspace and storahe layout
      # - have a data array with data


    # R HDF5 package
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
    # use the following codes for R version 4.3 or higher
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("rhdf5")


library(rhdf5)
created=h5createFile("example.h5")
created

#dat1<-as.Date("2017-08-23")
#dat2<-as.Date("2020-11-28")
#difftime(dat1, dat2, units = "days")


    # Create groups
created=h5createGroup("example.h5","foo")
created=h5createGroup("example.h5","baa")
created=h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")


    # write to groups
A=matrix(1:10, nr=5,nc=2)
h5write(A, "example.h5","foo/A")# to write that matrix to a particuler group

B=array(seq(0.1,2.0,by=0.1),dim=c(5,2))
attr(B,"scale")<-"liter"
h5write(B,"example.h5","foo/foobaa/B")
h5ls("example.h5")

    # Write a dataset directly (to a top level group)
df= data.frame(1L:5L,seq(0,1,length.out=5),c("ab","cde","fghi","a","s"),stringsAsFactors=FALSE)#create a df
h5write(df,"example.h5","df") # write the df to the top level group
h5ls("example.h5")


    # Reading data
readA=h5read("example.h5","foo/A")
readB=h5read("example.h5","foo/foobaa/B")
readf=h5read("example.h5","df") # if read the top-level group, just put the group name

readA


    # writing and reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3, 1)) # indices indicate the specific 
                                                             # part of the dataset you want to wrtie/read into.

h5read("example.h5","foo/A")


# Reading data from the web: 
con=url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode=readLines(con)
close(con)
htmlCode #hard to read

library(XML)
url<-"http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html<-htmlTreeParse(url, useInternalNodes = T)
xpathSapply(html, "//title",xmValue)

    # get from the httr package
library(httr)
html2=GET(url)
content2=content(html2, as="text") #extract the content from that url page
parsedHtml=htmlParse(content2, asText = TRUE) # to parse out解析出 the text
xpathSApply(parsedHtml,"//title",xmlValue) # to extract the title

    # Accessing websites with passwords
pg2=GET("http://httpbin.org/basic-auth/user/passwd",authenticate("user","passwd"))
pg2
names(pg2)
    # using handles: so you don't have to keep authenticating over and over again as you access that website
google=handle("http://google.com")
pg1=GET(handle=google,path="/")
pg2=GET(handle=google, path="search")


# Reading from APIs
    # APIs: are programming interfaces. Most internet companies like Facebook will have an application programming 
    #       interface or an API, where you can download data.
    # use HHTR package to be able to get data from these web site


    # Firstly, you have to creat an account with api or with the development team out of 
    #         each particular organization. (not a user account)

    # Accessing Twitter from R
myapp=oauth_app("twitter",
                key="yourConsumerKeyHere",secret="yourConsumerSecretHere") # start the authorization process with your application.
                                                  # get yourConsumerKey and yourConsumerSecret from the website
sig=sign_oauth1.0(myapp,
                  token="yourTokenHere",
                  token_secret = "yourTokenSecretHere")
homeTL=get("https://api.twitter.com/1.1/statuses/home_timeline.json",sig) # use the url specific to the specific api


    # Converting the json object 
json1=content(homeTL)
json2=jsonlite::fromJSON(toJSON(json1)) # convert the jason data to data frame
json2[1,1:4]

    # How did I know what url to use?
    #       Go to the documentation for Twitter API. For this example, we need 'resource URL'



# Loading data from ohter sources
    # Loads data from Minitab, S, SAS, SPSS, Stata, Synstat
    # basic functions read.foo
    #. - read.arff(Weka)
    #. - read.dta(Stata)
    #. - read.mtp(Minitab)
    #. - read.octave(Octave)
    #. - read.spss(SPSS)
    #. - read.xport(SAS)
