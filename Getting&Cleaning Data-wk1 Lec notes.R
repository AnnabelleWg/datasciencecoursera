# Tidy data
    # 4 things you should have: 1. the raw data 2. a tidy data set 3.a code book describing each variable and its valuables in the tidy data set
    #                           4. an explicit recipe you used to go from raw to the porcessed data

# Get/Set your working directory
 getwd()
 setwd("../") # move up 1 wd
      # an important difference in Windows: use backslashes. setwd("C:\\Users\\Andrew\\Downloads")
 
# Checking for and creating directories 
    # file.exists("directoryName") : to check to see if the directory exists
    # dir.create("directoryName") : will creat a directory if it doesn't exist
 
 if(!file.exists("data")){
   dir.creat("data")
 }
 
 
 # Getting data from the internet
    # useful for downloading tab-delimited, csv, and other files
 fileURL<-"https://healthdata.gov/ASPR/COVID-19-Treatments/xkzp-zhs7/data_preview"
 download.file(fileURL,destfile = "./covidtrt.csv", method="curl")
 list.files("./covidtrt.csv")

dateDownloaded<- date() 
dateDownloaded
    
    # If the url starts with http you can use download.file()
    # If the url starts with gttps on Windows you may be ok.
    # If the url starts with https on Mac you may need to set method="curl
    # If the file is big, this might take a while
    # be sure to record when you download


# Reading Local Files
    # Loading flat files-read.table()
        # flexible and robust but requires more parameters (e.g.file, header, sep, row names, nrows)
        # related: read.csv(), read.csv2()
covidData<-read.table(file="COVID-19_Treatments_20240408.csv", sep=",",header = TRUE)
head(covidData)

COVID_19xlsxCOVID_19_Treatments_20240408 <- read_csv("COVID-19_Treatments_20240408.csv")
    # quote: can tell R whether there are any quoted values; quote="" means no quotes
    # na.string: set the character that represents a missing value
    # nrows: how many rows to read of the file(e.g. nrows=10 reads 10 lines)
    # skip: number of lines to skip before starting to read
    
    #In my experience, the biggest touble with reading flat files are quotation marks or " placed in 
    # data value, setting quote="" often resolve these.


# Reading excel files
install.packages("xlsx")
library("xlsx")
covidData<-read.xlsx("COVID-19_Treatments_20240408.csv",sheetIndex=1, header=TRUE)
    # Reading specific rows and columns
colIndex<-2:3
rowIndex<-1:4
    # Further notes
# write.xlsx() will write out an Excel file with similar arguments
# In general, it is advised to store your data in either a database or in comma separated files(.csv) or tab separated files(.tab/txt) as they are easier to distribute.

covidDataSubset<-read.xlsx("COVID-19_Treatments_20240408.csv",sheetIndex=1, header=TRUE,
                     rowINdex=rowIndex,colIndex=colIndex)

# Reading XML
    # tags correspond to general labels
    # - start tags <section>
    # - End tags </section>
    # Empty tags <line-break />
    
    # Elements are specific examples of tags
    # - <Greeting> Hello, world </Greeting>
    
    # Attributes are components of the label
    # - <img src="jeff.jpg" alt="instructor"/>
    # - <step number="3"> Connect A to B. </step>
  

    # reading the file into R
install.packages("XML")
library(XML)
fileURL<-"http://www.w3schools.com/xml/simple.xml"
doc<-xmlTreeParse(fileURL,useInternal=TRUE)
rootNode<-xmlRoot(doc)
xmlName(rootNode)

names(tootNode) # to know the names of the elements within the rootNode

# Directly access part of the XML document
rootNode[[1]] # the 1st element
rootNode[[1]][[1]]

# Programmatically extract parts of the file
xmlSApply(rootNode,xmlValue)
    #Get the items on the menu and prices
xpathSApply(rootNote,"//name",xmValue)
xpathSApply(rootNode,"//price",xmValue)

fileURL<-"http://espn.gp.com/nfl/team/_/name/bal/baltimore-ravens"
doc<-htmlTreeParse(fileURL,useInternal=TRUE)
scores<-xpathSApply(doc,"//li[@class='score']",xmvalue)
teams<-xpathSApply(doc,"//li[@class='team-name']",xmValue)
# will check if it's class is score. If it is, it'll return the XML value



# Reading JSON
    # Javascript Object Notation
    # Lightwieght data storage
    # Common format for data from application programming interfaces (APIs)
    # Similar structure to XML, but different syntax/format

install.packages("jsonlite")
library(jsonlite)
jsonData<-fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
jsonData$owner$login
    
    # Wiritng data frames to JSON
myjson<-toJSON(iris,pretty = TRUE)
cat(myjson)
    # Convert back to JSON
iris2<-fromJSON(myjson)
head(iris2)
    # Further resources
# http://www.json.org
# (A good tutorial on jsonlite) http:/www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/


# The data.table package
    # data table: -inherit all functions that accept data.drame work on dtaa.table
    #             -much faster at subsetting, group, and updating

install.packages("data.table")
library(data.table)
DF=data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF)

  # see all the data tales in memory
tables()

DT=data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)

    # subsetting rows ( slightly different from data.frame)
DT[2,]
DT[DT$y=="a"]
DT[c(2,3)] # will take the 2nd and 3rd rows in that table

    # subsetting columns
DT[,c(2,3)]

    # calculating values for variables with expressions
DT[, list(mean(x),sum(z))]
DT[,table(y)]

    # Adding new columns
DT[,w:=z^2]

    #Be careful
DT2<-DT
DT[, y:=2]
head(DT, n=3)
head(DT2, n=3)

    # Multiple operations
DT[,m:={tmp<-(x+2); log2(tmp+5)}]
# each statement is followed by ':

    # plyr like operations
DT[, b:=mean(x+w), by=a]

    # special variables
set.seed(123);
DT<-data.table(x=sample(letters[1:3],1E5,TRUE))
DT[, .N, by=x] # .N is an integer, length 1, containing the number r.

    # Keys
DT<-data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
setkey(DT, x)
DT['a']
    # (can use keys to facilatite) Joining table
DT1<-data.table(x=c('a','a','b','dt1'),y=1:4)
DT2<-data.table(x=c('a','b','dt2'),z=5:7)
setkey(DT1, x); setkey(DT2,x)
merge(DT1,DT2)

    # Fast reading
big_df<-data.frame(x=rnorm(1E6),y=rnorm(1E6))
file<-tempfile()
write.table(big_df,file=file, row.names = FALSE, col.names=TRUE, sep="\t",quote=FALSE)
system.time(fread(file))
system.time(read.table(file, header = TRUE,sep="\t"))

    # Summaru and further reading
# Here is a list of differences b/w data.table and data.frame: http://stackoverflow.com/questions/13618488/what-you-can-do-with-data-frame-that-you-cant-in-data-table
# Notes based on Rapheal Gottardo's note: ttp://github.com/raphg/Biostat-578/blob/master/Advanced_data_manipulation.Rpres


# Swirl Exercise-Lesson getting and cleaning Data
library(swirl)
install_from_swirl("Getting and Cleaning Data")
swirl()

    # Manipulation Data with dplyr
mydf<-read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf)
head(mydf)

library(dplyr)
packageVersion("dplyr")
    # load data into what the package author called a "data frame tbl". 
cran<-tbl_df(mydf)
rm("mydf")
?tbl_df #"The main advantage to using a tbl_df over a regular data frame is the printing."
cran

    # keep or drop columns
select(cran, ip_id, package, country) # columns are returned to us in the order we specified

5:20
select(cran, r_arch:country)
select(cran, country:r_arch) # select in a reversed order
cran
    # specifying columns you don't want
select(cran, -time)
-5:20
-(5:20)
select(cran, -(X:size))


    # Selecting subset of rows
filter(cran, package=="swirl") # in this, case, package is an entire vector
filter(cran, r_version=="3.1.1", country=="US") #specify many conditions
?Comparison

filter(cran, r_version<="3.0.2", country=="IN")
filter(cran, country=="US"| country=="IN")
filter(cran, size>100500 , r_os=="linux-gnu")

    # missing values
is.na(c(3,5,NA,10))
!is.na(c(3,5,NA,10))
filter(cran, !is.na(r_version))

    # order the rows of a dataset according to the valuse of a particular variable
cran2<-select(cran, size:ip_id)
arrange(cran2, ip_id) # in ascending order (from small to large)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id) # will first arrange by package names (ascending alphabetically), then by ip_id
                              # if there are multiple rows with the same value for package, they will be sorted by ip_id (ascending, numerically)
arrange(cran2, country,desc(r_version),ip_id)

    # creat a new variable based on the value of one or more variables
cran3<-select(cran, ip_id,package,size)
cran3
mutate(cran3, size_mb=size/2^20)
mutate(cran3, size_mb=size/2^20, size_gb=size_mb/2^10)
mutate(cran3, correct_size=size+1000)

    # collapses the dataset to a single row
summarize(cran, avg_bytes=mean(size))


# Grouping and chaining with dplyr
    # break up the dataset into groups of rows based on the values of one or more variables
library(dplyr)
cran<-tbl_df(mydf)
rm("mydf")
cran
?group_by
by_package<-group_by(cran, package)
by_package
summarize(by_package, mean(size)) # instead of one summary statistics, we now have the mean size for each package in our dataset

pack_sum <- summarize(by_package,
                      count = n() ,
                      unique = n_distinct(ip_id) ,
                      countries = n_distinct(country),
                      avg_bytes = mean(size) )
pack_sum

quantile(pack_sum$count, prob=0.99)

top_counts<-filter(pack_sum,count>679)
top_counts
View(top_counts)

top_counts_sorted<-arrange(top_counts,desc(count))
View(top_counts_sorted)

quantile(pack_sum$unique, prob=0.99)
top_unique<-filter(pack_sum, unique>465)
View(top_unique)
top_unique_sorted<-arrange(top_unique, desc(unique))
View(top_unique_sorted)

    # Chaining
by_package <- group_by(cran, package)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)

submit()

result2 <-
  arrange(
    filter(
      summarize(
        group_by(cran,
                 package
        ),
        count = n(),
        unique = n_distinct(ip_id),
        countries = n_distinct(country),
        avg_bytes = mean(size)
      ),
      countries > 60
    ),
    desc(countries),
    avg_bytes
  )

result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)
 
View(result3)

      # when you're using the chaining operator, you don't
      # need to specify the name of the data tbl in your call to
      # select().
cran %>%
  select(ip_id, country, package, size) %>%
  print


# Tidying Data with tidyr
library(tidyr)
students
?gather # gather columns into key-values paris
getdata_data_ss06hid
