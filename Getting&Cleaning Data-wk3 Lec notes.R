# Subsetting

set.seed(13435)
x<-data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
x<-x[sample(1:5),];x$var2[c(1,3)]=NA

    # subset specific column
x[,1]
x[,"var1"]
    # subset rows and columns 
x[1:2, "var2"]
    # use logical statement
x[(x$var1<=3 & x$var3>11),]
x[(x$var1<=3 | x&var3>15),]

    # Dealing with missing values
x[which(x$var2>8),] # it returns the indexes where var2 >2 but doesn't return the NAs


# Sorting
sort(x$var1)
sort(x$var1, decreasng=TRUE)
sort(x$var2,na.last=TRUE)

# ordering
x[order(x$var1),]
x[oreder(x$var1,x$var3),] # if there are multiple values of var1 that are the same, 
                         #    it will sort the values of var3 in increasing order within these values.

    #Ordering with dplyr
library(dplyr)
arrange(x, var1)
arrange(x, desc(var1))


# Adding rows and columns
x$var4<-rnorm(5)
y<-cbind(x,rnorm(5)) # add a new vector rnorm(5) to the right-hand side of the df x
z<-rbind(x, rnorm(4))
z
    # notes and further resources
# http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf


# Summarizing Data
    # Getting the data from web
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessTYpes=Download"
download.file(fileUrl,destfile = "./data/restaurants.csv", method="curl")
restData<-read.csv("./data/restaurants.csv")


    # look at a bit of the data
head(restData,n=3)
tail(restData, n=3)

    # make summary
summary(restData)

    # more in depth information
str(restData) # gives a bit more information on the data frame

    # Quantiles of quantitative variable
quantile(restData$councilDistrict, na.rm=TRUE)
quantile(restData$councilDistrict, probs(0.5, 0.75, 0.9)) # can also look at different quantiles of the distribution

    # Make table
table(restData$zipCode, useNA="ifany") # use the useNA to make sure you don't miss any missing values
    # Make a 2-d table
table(restData$councilDistrict, restData$zipCode)


    # Check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode>0) # to check if all values satisfy with the condition

    # Row and column sums
colSums(is.na(restData)) # get the number of missing values for each column
all(colSums(is.na(restData))==0)

    # Values with specific characteristics
table(restData$zipCode %in% c("21212")) # are there any values of variable zipcode that fall into the vector c("21212")

table(restData$zipCode %in% c("21212","21213")) # find any values that either 21212 or 21213

restData[restData$zipCOde %in% c("21212","21213"), ] # to subset the df based on a logical variable (within [ ])


    # cross tabs
data("UCBAdmissions")
DF=as.data.frame(UCBAdmissions)
summary(DF)

xt<-xtabs(Freq~ Gender +Admit, data=DF) # The left of ~ (e.g. Freq) is the value shown in the table
                                        # the table tells you the frequency male/female was admitted/rejected
xt


    # flat tables
warpbreaks$replicate<-rep(1:9, len=54)
xt= xtabs(breaks~., data=warpbreaks)
xt # a very long table. hard to see
ftable(xt) # summarize data in a more compact form, so it's easier to see


    # Size of a data set
fakeData=rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")


# Creating New Variables
    # getting the data from the web
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-("https://data.baltmorecity.gov")
download.file(fileUrl, destfile="./data/restaurant/csv", method="curl")
restData<-read.csv("./data/restautants.csv")

    #creating sequences
      # sometimes you need an index for your data set
s1<-seq(1,10, by=2);s1

s2<-seq(1,10, length=3);s2

x<-c(1,3,8,25,100); seq(along=x)

    # subsetting variables
restData$nearMe=restData$neighborhood%in%c("Roland Park","Homeland") # find restaurants only in the two neighborhood
                # then appending the nearMe variable onto the data set. 
table(restData$nearMe)

    # creating binary variables
restData$zipWrong=ifelse(restData$zipCode<0, TRUE, FALSE) # argu1:condition, argu2: value returned whent the conditon is TRUE, argu3: value retured when the condition is FALSE
table(restData$zipWrong, restData$zipCode<0)
  
      # break up the variable according to some values
restData$zipGroups=cut(restData$zipCode, breaks=quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode) # the zipGroup is a factor variable
  
      # easier cutting (* cutting creats factor variables)
install.packages("Hmisc")
library(Hmisc)
restData$zipGroups=cut2(restData$zipCode, g=4) # break up into 4 groups
table(restData$zipGroups)

    # Creating factor variables
restData$zcf<-factor(restDat$zipCode)
restData$zcf[1:10]
class(restData$zcf)
    # Levels of factor variables
yesno<-sample(c("yes","no"),size=10,replace=TRUE)
yesnofac=factor(yesno, levels=c("yes","no")) # By default, R will treat the lowest value alphabetically as the first value.
relevel(yesnofac,ref="yes") # you can change the level setting
as.numeric(yesnofac)


    # Using the mutate function
library(Hmisc); library(dplyr)
restData2=mutate(restData, zipGroups=cut2(zipCode, g=4))
table(restData2$zipGroups)


    # common transforms (quantitative data)
# abs(x) absolute value
# sqrt(x)
# ceiling(x) ceiling(3.475) is 4
# floor(x) floor(3.475) is 3
# round(x,digits=n) round(3.475, digits=2) is 3.48
# signif(x, digits = n) signif(3.475, digits=2) is 3.5
# cos(x), sin(x)
# log2(x), log10(x)
# exp(x) exponentiating x

# additonal reading materials
# http://statmethods.net/management/functions/html


# reshaping Data
install.packages("reshape2")
library(reshape2)
head(mtcars)

    # melting data frames
mtcars$carname<-rownames(mtcars)
carMelt<-melt(mtcars, id=c("caranmes","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt, n=3)

    # casting data frames
cylData<-dcast(carMelt, cyl~variable) # take the data set and summarize it
cylData<-dcate(carMelt, cyl~variable,mean) # take a mean of each values


    # averaging values
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)
    # another way-Split+Combine
      # firstly, split the dataset
spIns=split(InsectSprays$count, InsectSprays$spray)
spIns # a list

      # secondly, use apply() to calculate the sum for each element of the list
sprCount=lapply(spIns, sum)
sprCount

      # thirdly, combine the list
unlist(sprCount)

sapply(spIns, sum)


    #Another way-dplyr package
install.packages("plyr")
library(plyr)
ddply(InsectSprays,.(spray), summarize, sum=sum(count)) # have to use.(), so you don't need quotation marks around spray
      # Can also creat3 new variables
spraySums<-ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN=sum)) # summarize the spray variable; want to summarize the counts and sum them up
spraySums # every time I see an A in the spray variable, I got the sum for all of the A values
          # so spraySums has the same dimension as the InsectSprays data set


    # More info.
      # acast - for csting as multi-dimensional arrays
      # arrage - for faster reordering without using order() commands
      # mutate - adding new variables

# Managing Data Frames with dplyr
    # arrange - reorder rows
    # filter - extract a subset of rows based on logical conditions
    # select - return a subset of the columns of a data frame
    # mutate - add new variables or transform existing variables
    # rename -  rename variables
    # summarise - generate summary statistics of different variable in the data frame

library(dplyr)
chicago<-readRDS("chicago.rds")
sim(chicago)
str(chicago)
names(chicago)
head(select(chicago, city:dptp))
head(select(chicago,-(city:dptp))) # look at columns except for certain columns
    # alternatives
i<-match("city",names(chicago)) # find the indices of the columns
j<-match("dptp", names(chicago))
head(chicago, -(i:j))



chic.f<-filter(chicago, pm25tmean2>30)
head(chic.f,10)
chic.f<-filter(chicago,pm25tmean2>30 & tmpd>80)
head(chic.f, 10)



chicago<-arraneg(chicago, date) # reorder rows based on date variable
head(chicago)
tail(chicago)
chicago<-arrange(chicago, desc(date)) # in a decending order



chicago<-rename(chicago, pm25=pm25tmean2, dewpoint=dptp) # new name=old name



chicago<-mutate(chicago, pm25detrend=pm25-mean(pm25, na.rm=TRUE))
head(select(chicago, pm25, pm25detrend))


chicago<-mutate(chicago, tempcat=factor(1*(tmpd>80),labels=c("cold","hot")))
hotcold<-group_by(chicago, tempcat)
head(hotcold)

summarise(hotcold, pm25=mean(pm25), o3=max(o3tmean2),no2=median(no2mean2))

chicago<-mutate(chicago, year=as.POSIXlt(date)$year+1900)
years<-group_by(chicago, year)
summarize(years, pm25=mean(pm25,na.rm=TRUE), o3=max(o3tmean2), no2=median(no2mean2))
    # using the %>%
chicago%>%mutate(month=as.POSIXlt(date)$mon+1)%>% group_by(month)%>% summarize( pm25=mean(pm25,na.rm=TRUE), o3=max(o3tmean2), no2=median(no2mean2))


# Merging Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1<-"https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2<-"https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1, destfile = "./data/reviews.csv", method="curl")
download.file(fileUrl2, destfile = "./data/solutions.csv", method="curl")
 
reviews=read.csv("./data/reviews.csv");solutions<-read.csv("./data/solutions.csv")

head(reviews,2)
head(solutions, 2)

    # Important parameters: x,y,by.x, by.y
mergedData=merge(reviews, solutions, by.x="solution_id", by.y="id", all=TRUE)
        # x df is reviews, and we gona merge on the soluion_id
        # y_df is the solutions, and we gonna merge on the id
        # all=TRUE: If one value is included in one df but not the other. It should include it in the row bu with an NA value for the missing values that didn't appear in the other df.
head(mergedData)

    # Default- merge all common column names
intersect(names(solutions),names(reviews))
mergedData2=merge(reviews, solutions, all=TRUE)


    # Using join in the plyr package
        # faster, but less full featured-defaults to left join, see help file for more.
library(plyr)
df1=data.frame(id=sample(1:10),x=rnorm(10))
df2=data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)
    # If you have multiple data frames
df3=data.frame(id=sample(1:10), z=rnorm(10))
dflist=list(df1,df2,df3)
join_all(dflist)

# swirl lesson 1-Manipulating data with dplyr 
?read.csv
mydf<-read.csv(path2csv, stringsAsFactors=FALSE)
dim(mydf)
head(mydf)
library(dplyr)
packageVersion("dplyr")
  # Load data
cran<-tbl_df(mydf)
    # remove original df to avoid confusion
rm("mydf")
tbl_df
cran
select(cran, ip_id, package,country) 
5:20
select(cran, r_arch:country)
select(cran, country:r_arch)
cran
select(cran, -time) #to omit time column
-5:20
-(5:20)
select(cran ,-(X:size))
filter(cran, package=="swirl")
filter(cran, r_version=="3.1.1", country=="US")
?Comparison
filter(cran, r_version<="3.0.2", country=="IN")
filter(cran, country=="US"| country=="IN")
filter(cran, size>100500, r_os=="linux-gnu")

is.na(c(3,5,NA,10))
!is.na(c(3,5,NA,10))
filter(cran, !is.na(r_version))
 
cran2<-select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version),ip_id)

cran3<-select(cran, ip_id, package, size)
cran3
mutate(cran3, size_mb=size/2^20)
mutate(cran3, size_mb=size/2^20, size_gb=size_mb/2^10)
mutate(cran3, correct_size=size+1000)
summarize(cran, avg_bytes = mean(size))


# swirl lesson 2-Grouping and chaining data with dplyr
    # after group_by(), commands will be performed on group basis
by_package<-group_by(cran, package)
summarize(by_package, mean(size))

# 1. count = n()
# 2. unique = n_distinct(ip_id). - gives the total# of unique downloads for each package
# 3. countries = n_distinct(country) - give the # of countries in which each package was downloaded
# 4. avg_bytes = mean(size)

pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
quantile(pack_sum$count, probs=0.99)

top_counts<-filter(pack_sum, count>679)
top_counts

View(top_counts)

top_counts_sorted<-arrange(top_counts, desc(count))
View(top_counts_sorted)

quantile(pack_sum$unique, probs = 0.99)
top_unique<-filter(pack_sum, unique>465)
View(top_unique)
top_unique_sorted<-arrange(top_unique, desc(unique))
View(top_unique_sorted)

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





# Swirl Lesson 3: Tidying Data with tidyr
res <- gather(students2, sex_class, count, -grade)

    # seperating one column into multiple columns
separate(data=res,col=sex_class, into = c("sex","class"))
students3

students3 %>%
  gather( class,grade ,class1 :class5 , na.rm= TRUE) %>%
  print

?spread
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
            print

library(readr)
parse_number("class5")
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class = parse_number(class)) %>%
  print

passed<-passed%>%mutate(status="passed")
failed<-failed%>%mutate(status="failed")
bind_rows(passed,failed)

sat %>%
  select(-contains("total")) %>%
  gather(key=part_sex,value=count , -score_range) %>%
  separate(part_sex, into=c("part","sex")) %>%
  print

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total=sum(count),
         prop=count/total
  ) %>% print