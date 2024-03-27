#creating vectors
x<-c("a","c","b")
x<-c(1,2,3,5:9)
x<-c(T,F) #logical
x<-c(1+0i, +4i) #complex

x<-vector("numeric", length=10 ) #the defual value for num. vector is zero
#[1] 0 0 0 0 0 0 0 0 0 0

#when different objects are mixed in a vector, coercion occurs so that every element 
#in the vector is of the same class
x<-c(TRUE, 2) #numeric

#Explicit coercion: obejcts can be explcitly coerced from one class to another
x<-0:6
as.character(x)

#list: a special type of vector that can contain elements of different classes
x<-list(2,"i", TRUE, 2+0i)
x[[1]] #[1] 2
x[[3]] #[1] TRUE

#Matrices: vectors with dimension attributes (i.e. (nrow,ncol))
m<-matrix(nrow=4,ncol=4)
dim(m)
attributes(m)
m<-matrix(1:16,nrow=4, ncol=4) #assign values by col.
m[,2] #return the values in 2nd col
m[1,] #return the values in 1st row
#create matrices directly from vectors by adding dimensional attributes
x<-1:3
y<-6:8
cbind(x,y)
rbind(x,y)

#Factors: represent categorical data; can be ordered or un-ordered
x<-factor(c("yes","no","no","yes"))
table(x)
unclass(x)
attr(x,"levels") #levels in R are determined alphabetically
x<-factor(c("yes","no","no","yes"),levels = c("yes","no")) #use the levels=  argument to specify the 1st/2nd levels.

#Missing values
is.na() #is used to test objects if they are NA
is.nan() # is used to test objects if they are NAN
#NA values have a class also, so there are integer NA, character NA, etc
#A NAN value is also NA but the converse is not true
x<-c(1,2,NA,10, 3)
is.na(x)
is.nan(x)
x<-c(1,2, NaN, NA, 4)
is.na(x)
is.nan(x) # true only if the object value== NaN

#Data Frames
  #is a special type of list where element of the list has to have the same length.
  #a column can be thought as an element, and number of rows can be thought as the length of an object
  #Each element can be different classes (e.g. col1=num, col2=charac)
  #are usuallt created by calling read.table() or read.csv()
  #can be converted to a matrix by calling data.matrix()
x<-data.frame(foo=1:4, bar=c(T,F,F,T))
nrow(x)
ncol(x)

#Names Attributes
  #R objects/matrices can have names
x<-1:3
names(x)<-c("foo", "bar", "norf")
m<-matrix(1:4,nrow=2,ncol=2)
dimnames(m)<-list(c("a","b"),c("c","d")) #1st element is a vector of row names; 2nd element is a vector of column names

#Reading Tabular Data
  #for reading tabular data: read.table(), read.csv()
  #for reading lines of a text file: readlines()
  #for reading R code files (inverse of dump): source()
  #for reading R code files (inverse of dput): dget()
  #for reading in saved work spaces: load()
  #for reading single R objects in binary form: unserialize()
data<-read.table("foo.txt") 
  #automatically skip lines that begin with a #
  #read.cvs() is identical to read.table except that the default separator is a comma

#Reading large tables
initial<-read.table("datatable.txt",nrows=100)
classes<-sapply(initial,class) #the class function tells you the class of each col. 
tabAll<-read.table("datatable.txt",
                   colClasses=classes)#use the colClasses argument can make the function run much faster . 
                                      #If all of the columns are "numeric", you can set colClasses="numeric"

#Textual Data Formats
  #generally store all types of data as text.
y<-data.frame(a=1, b="a")
dput(y) #deparsing the R object
dput(y, file="y.R") #output the result to a file to the working directory
new.y<-dget("y.R") #reading it back using dget()
new.y
y

x<-"foo"
y<-data.frame(a=1, b="a")
dump(c("x","y"), file="data.R") #deparsing multiple objects
rm(x,y)
source("data.R")
y
x

#Interface to the Outside World
  #file: opens a connection to a file
  #gzfile: opens a connection to a file compressed with gzip
  #bzfile: opens a connection to a file compressed with bzip2
  #url: opens a connection to a webdge
str(file)
  #open="" is a code indicating :'r' read only
  #                              'w' writing (and initializing a new file)
  #                              'a'appending
  #                             'rb','wb','ab' reading, writing, or appending in binary mode(Windows)
con<-file("foo.txt","r")
dtaa<-read.csv(con)
close(con)
#is the same as
data<-read.csv("foo.txt")
#the function can be useful if you want to read parts of the file
con<-gzfile("wonder.gz")
x<-readLines(con, 10) #read the first 10 lines
                       #takes a character vector and writes each element one line at a time to a text file
#read.lines() can also be useful for reading in lines of webpages
con<-url("http://www.jhsph.edu","r")
x<-readLines(con)
head(x)

#Subsetting
  # [ ] always return an object of the same class as the original; can select >1 element
  # [[ ]] is used to extract elements of a list or a data frame; it can only be used to extract a single element
  #       and the class of the returned object will not necessarily be a list or data frame.    
x<-c("a","b","c","c","d","a")
x[1]
x[1:4]
x[x>"a"]
u<-x>"a"
u
#Subsetting lists
x<-list(foo=1:4, bar=0.6,baz="hello")
x[1]
x[c(1,3)]
x[["bar"]]
name<-"foo"
x[[name]] ##[[ ]] can be used with computed indices; $ can only be used with literal names
x<-list(a=list(10, 12, 14), b=list(3.14, 2.81))
x[[c(1,3)]] #extract the 3rd element of the first list in x
x[[c(2,1)]]#extract tje 1st element of the 2nd list in x
#Subsetting Matrices
x<-matrix(1:6,2,3)
x[1,2]
x[1,]
x[1,2, drop=FALSE] #return a matrix not just the number/lists
                  #'drop' drop the dimension
#Partial Matching
x<-list(aardvark:1:5)
x$a
x[["a"]]
x[["a",exact = FALSE]] #partial matching with names is allowed with $, [[ ]]

#Removing Missing Values
x<-c(1,2,NA,4,NA,5)
bad<-is.na(x) #store NAs to bad vector
x[!bad]
y<-c("a","b",NA,"d",NA,"f")
good<-complete.cases(x,y) #return a logical vector indicating which positions that are both non-missing.
x[good]
y[good]
airquality[1:6, ] #a data frame
good<-complete.cases(airquality)
airquality[good, ][1:6, ]

#vectorized operations
x<-matrix(1:4,2,2); y<-matrix(rep(10,4),2,2) #repeat 10 for 4 times
x*y #element-wise multiplication
x %*% y # matrix multiplication

#Quiz1
#Q12.
q1[c(1,2),]
#Q13.
nrow(q1)
#Q14.
tail(q1) #this function is an wasy way to extract the last few elements of an R objects
#Q15.
q1[47,"Ozone"]
#Q16.
bad<-is.na(q1$Ozone)
summary(bad)
#Q17.
mean(q1$Ozone,na.rm=T)
#Q18.
#generate a logical vector in R to match the question's requirements
q1.oz32<-q1$Ozone>31
q1.temp91<-q1$Temp>90
#Then use the logical vector to subset the data frame
q1.2col<-q1[q1.oz32,][q1.temp91,]
mean(q1.2col$Solar.R,na.rm=T)
#Q19
q1.June<-q1$Month==6
q1.June<-q1[q1.June,]
mean(q1.June$Temp,na.rm=T)
#Q20
q1.May<-q1$Month==5
q1.May<-q1[q1.May,]
max(q1.May$Ozone,na.rm = T)

##################################################################
#Practical Exercises with Swirl Package
install.packages("swirl")%>%library(swirl)
packageVersion("swirl") #check the package version
install_from_swirl("R Programming")
swirl()#to start swirl
#Lesson 2. Workspace and files
ls() #list all the object in your local workspace 
list.files() #list all the files in your woeking directory
dir() #do the same thing as list.files()
args(list.files) #to determine the arguments to list.files()
old.dir<-getwd() #assign the value of the current working directory to a varabible called "old.dir".
dir.create("testdir") #creat a directory in the current working directory
setwd("testdir")
file.create("mytest.R") #create a file in the new working directory
file.exists("mytest.R") #check to see if the new file exists in the wokring directory
file.info("mytest.R") #access information about the file
file.info("mytest.R")$mode #grab specific items
file.rename("mytest.R","mytest2.R") #change the name of the file
file.remove("mytest2.R") #delete unwanted files
file.copy("mytest2.R","mytest3.R") #copy files
file.path("mytest3.R") #get the relative path to the file 
file.path("folder1","folder2") #make platform-independent pathname
dir.create(file.path('testdir2', 'testdir3'), recursive = TRUE)#to create nested directories, 'recursive' must be set to TRUE
                        #create a directory in the current working directory called"testdir2"
                        #create a subdirectory for 'testdir3' called 'testdir3'
setwd(old.dir) #go back to your original directory

#Lesson3. sequence of numbers
?':' # to look up the documentation for an operator; must enclosed with ''
seq(1:20)
seq(0,10, by=0.5) # a vector of numbers ranging from 0 to 10, incremented by 0.5
my_seq<-seq(5,10,length=30)
length(my_seq)
seq(1:length(my_seq)) # to creat a vector of numbers from 1 to the length of my_seq
seq(along.with=my_seq) #another option
seq_along(my_seq)
rep(0,times=40)
rep(c(0,1,2),times=10) #repeat (0,1,2) over and over again
rep(c(0,1,2),each=10) #want 10 ones, 10, twos, and 10zeros

#Lesson4. Vectors
num_vect<-c(0.5, 55, -10, 6)
tf<-num_vect<1 # a vector of 4 logical values; b/c the statement used to define tf is a condition
my_char<-c("My", "name","is")
paste(my_char, collapse = " ") #to join the elements together into one continuous character string
my_name<-c(my_char, "Annabelle")
paste(my_name, collapse=" ") # collapse the element of a single character
paste("Hello", "world!", sep = " ")
paste(1:3,c("x","Y","z"), sep="")#collapse  the elements of multiple character vectors
paste(LETTERS,1:4,sep="-")#for vectors of different length, R will do vector recycling

#Lesson5. Missing values
x<-c(44,NA,5,NA)
x*3
y<-rnorm(1000)# a vector containing 1000 draws from a standard normal distribution
z<-rep(NA,1000)
my_data<-sample(c(y,z), 100)# select 100 elelments at random from these 2000 values (combining y and z)
my_na<-is.na(my_data)# whether each elemetn of the vector is NA
my_data == NA # yields the same results as is.na()
# R represents TRUE as the number 1 and FALSE as the number 0
sum(my_na) # to count the total number of TRUEs


#Lesson6. Subsetting vectors
x[1:10] # vie the first 10 elements of x
x[is.na(x)] # is.na returns a logical statement; subseting x based on is.na(x) gives a vector of all NAs
y<-x[!is.na(x)] # isolating the non-missing values of x and put them into y 
x[!is.na(x) & x>0] #requesting values that are both non-missing AND greater than 0
x[c(3,5,7)] # subset the 3rd, 5th, and 7th elements of x
x[c(-2, -10)] # gives us all elements of x EXCEPT for the 2nd and10 elements.
x[-c(2, 10)] # do the same thing 
vect<-c(foo=11, bar=2,norf=NA)
vect
names(vect) # get the names the vector
vect2<-c(11,2,NA) #an unnames vector
names(vect2)<-c("foo","bar", "norf") # add the names attribute to vect2
identical(vect,vect2) # check if the two vectors are the same

#Lesson7. Matrices and data frames
my_vector<-1:20
dim(my_vector)
length(my_vector)
dim(my_vector) <- c(4, 5) #give my_vector a 'dim' attribute
attributes(my_vector)
my_matrix <- my_vector
my_matrix2<-matrix(1:20,nrow=4,ncol=5)
identical(my_matrix,my_matrix2)
# add a column to the matrix
patients<-c("Bill","Gina","Kelly","Sean") #start by creating a vector of names
cbind(patients,my_matrix) # to combine columns with a matrix
my_data <- data.frame(patients, my_matrix)
class(my_data)
cnames<-c("patient","age","weight","bp","rating","test")
colnames(my_data)<-cnames# set the colnames attribute for the data frame


#Week2
#Control structures
  #else, if: testing a statement
  #for: execute a loop for a fixed number of times
  #while: execute a loop while a condition is true
  #repeat: execute an infinite loop 
  #break: break the execution of a loop
  #next: skip an interation of an loop
  #return: exit a function

#if-else
# if(<condition>) {
#           do something
# } else {
#           do something else
# }

#if(<condition1>) {
#         do something
# } else if (<condition2>) {
#         do something different
# } else {
#         do something different 
# }
if(x>3){
  y<-10
}else {
  y<-0
}

y<-if(x>3) {
  10
}else{
  0
}

#for loops: commonly used for iterating over the elements of an object
for(i in 1:10) {
  print(i)
}
#the 4 loops below have the same behavior
x<-c("a","b","c")
#1
for(i in 1:4) {
  print(x(i))
}
#2
for(i in seq_along(x)) {
  print(x(i))
} #seq_along() takes the vector as an input and creates an integer sequence that equals to the length of that vector.
#3
for (letter in x) { 
  print(letter)
} # the letter indec variable(i.e. letter) will be index and take values from the vector iteself.
#4
for(i in 1:4) print(x(i)) # if only has a single expression in the body, you can omit the urly braces

#Nested for loops
x<-matrix(1:6,2,3)

for(i in seq_len(nrow(x))){
  for(j in seq_len(ncol(x))){
    print(x(i,j))
  }
}


#While loop
  #begin by testing a condition. If it is true, they excute the loop body
count<-0
while(count<10){
  print(count)
  count<-count+1
}

z<-5
while(z >=3 && z<=10){
  print(z)
  coin<-rbinom(1,1,0.5)
  
  if(coin==1){## random walk
    z<-z+1
  } else {
      z<-z-1
  }
}


#Repeat, Next, Break
  #repeat: an infinite loop; there's NO guarantee it will stop, so better to set a hard limit (e.g. using a for loop) on the number of iterations.
  #break: the only way to exit a repeat loop
x0<-1
tol<-le-8
repeat {
  x1<-computeEstimate()
  if(abs(x1-x0)<tol){
    break
  }else {
    x0<-x1
  }
}

  #Next: is used to skip an iteration of a loop
for(i in 1:100){
  if(i<=20){
    ## skip the first 20 iterations
    next
  }
  ## Do something here
}

# R Function
add2<-function(x,y){
  x+y
}

above10 <- function(x){
  use<-x>10
  x[use]
}

above<-function(x,n){
  use<-x>n
  x[use]
}

columnmean<-function(y,removeNA=TRUE){
  nc<-ncol(y)
  means<-numeric(nc)
  for(i in 1:nc){
    means[i]<-mean(y[,i],na.rm=removeNA )
  }
}

  #Function Arguments
#functions have named arguments which potentially have default values
#function arguments can be missing or might have default values
#function arguments are matched positionally or by name
args(lm) # get the argument list of the function

f<-function(a,b=1,c=2,d=NULL){
  #a and d have not default values. 
  #In addition to not specifying a default value, you can also set an arguemnt value to NULL
  print(a)
  print(b)
  print(c)
  print(d)
}

  #the ... argument: indicate a variable number of arguments that are usually passed to other functions
  #... is often used when extending another function and you don't want to copy the entire argument list of the original function
myplot<-function(x,y,type="1",...){
  plot(x,y,type=type,...)
}
  #... argument is necessary when the number of arguments passed to the fuunction cannot be known in advance
args(paste)
  #arguments that appear afte ... on the argument list must be named explicitly and cannot be partially matched
mypaste<-function(...,sep=" ",collapse = NULL){}

  #constructing functions: the function os constructing another function
make.power<-function(n){
  pow<-function(x){
    x^n
  }
  pow
}
cube<-make.power(3)
square<-make.power(2)
#to know what is in the function's envrionment
ls(environment(cube))
ls(environment(square))
get("n",environment(square))

y<-10
f<-function(x){
  y<-2
  y^2+g(x)
}

g<-function(x){
  x*y
}
f(3) #g(x=3)=10*3->f(x=3)=2^2 +g(x=2)=4+30=34
#Lexical vs Dynamic Scoping
  #with lexical scoping, the value of y in g(x) is looked up in the environment in which the function was defined (i.e. the global environment)
  #with dynamic scoping, the value of y is looked up in the environment from which the function was called
  #     (sometimes referred to as the calling environment). In R, the calling environment is known as the parent frame.
  #.    so the value of y would be 2.


#Optimization
  #Optimization routines in R like to optim, nlm, and optimize require you to paste a function whose argument is a vector of parameter (e.g.log-likelihood)
make.NegLogLik<-function(data,fixed=c(FALSE,FALSE)){
  params<-fixed
  function(p){ 
    #the parameter function that I want to maximize over
    params[!fixed]<-p
    mu<-params[1]
    sigma<-params[2]
    a<- -0.5*length(data)*log(2*pi*sigma^2)
    b<- -0.5*sum(data-mu)^2 / (sigma^2)
    -(a+b)
  }
}
 set.seed(1);normals<-rnorm(100,1,2)
 nLL<-make.NegLogLik(normals)
 ls(environment(nLL))
 
 #Estimating Parameters
 optim(c(mu=0,sigma=1),nLL)$par
 #fixing sigma=2
 nLL<-make.NegLogLik(normals, c(FALSE,2))
 optimize(nLL,c(-1,3))$minimum
 #fixing mu=1
 nLL<-make.NegLogLik(normals, c(1,FALSE))
 optimize(nLL,c(le-6,10))#minimum
 #ploting the likelihood
 nLL<-make.NegLogLik(normals, c(1,FALSE))
 x<-seq(1.7, 1.9, len=100)
 y<-sapply(x,nLL)
 plot(x,exp(-(y-min(y))),type="l")
 
 #Coding standards for R
 #1. Always the text files/text editor
 #2. Indent your code
 #3. Limit the width of your code(80 columns)
 #4. Limit the length of your code
 
 #Dates and Times in R
    #Dates can be coerced from a character string using the as.Date() 
 x<-as.Date("1970-01-01")
x
unclass(x) #return 0 b/c dates are stroed internally as the number of days since 19701.1
unclass(as.Date("1970-01-02"))

    #Times are represented using the POSIXct or the POSIXlt class
    #POSIXlt: a list undermeath
x<-Sys.time() #uses the current time as known by the system
x
p<-as.POSIXlt(x)
names(unclass(p))
    #To convert string to date type
datestring<-c("January10,2012 10:40","December 9, 2011 9:10")
x<-strptime(datestring,"%B %d, %Y %H:%M") #%B =month, %D=day, %Y=4-digit year

    #Operations on Dates and Times
x<-as.Date("2012-01-01")
y<-strptime("9 Jan 2011 11:34:21","%d %b %Y %H:%M:%S")
x<-as.POSIXlt(x)
x-y

x<-as.POSIXct("2012-10-125 01:00:00")
y<-as.POSIXct("2012-10-125 06:00:00",tz="GMT")
y-x # the time difference is NOT 5 hrs but 1hr b/c of the change in time zone.

#Swirl Lesson: Logic
    # The '|' version of OR evaluates OR across an entire vector, while the '||" version of 
    # OR only evaluates the fost member of a vector
isTRUE(6>4)
identical('twins','twins') # will return TRUE if the two R objects passed to it as arguments are identical
xor(5==6,!FALSE) # stands for exclusive OR. It takes 2 arguments. If one argument evaluates to TRUE and one argument evaluates to FALSE, 
#                 then this function will return TRUE, otherwise it will return FALSE.
xor(6==6, !FLASE)
    # so xor(TRUE, TRUE) would have evaluated to FALSE
    # For xor() to evaluate to TRUE, one argument must be TRUE and one must be FALSE.

ints<-sample(10)
which(c(TRUE, FALSE, TRUE)) # which() takes a logical vector as an argument and return the indices of the vetor that are TRUE.
which(ints <= 2)

any(ints<0)
    # any() function will return TRUE if one or more of the elements in the logical vector is TRUE. 

all(ints>0)
    # all() function will return TRUE if every element in the logical vector is TRUE.


#Swirl Lesson: Function
# you assign functions in the following
# way:
#
# function_name <- function(arg1, arg2){
#	# Manipulate arguments in some way
#	# Return a value
# }

my_mean <- function(my_vector) {
  sum(my_vector)/length(my_vector)
  # Remember: the last expression evaluated will be returned! 
}

increment <- function(number, by = 1){
     number + by
}

remainder <- function(num, divisor=2) {
  # Write your code here!
  num %% divisor
  # Remember: the last expression evaluated will be returned! 
}
remainder(11,5) #evaluates to 1
remainder(divisor =11, num=5) #evaluates to 5
# R can partially match arguments
remainder(4, div=2)

evaluate <- function(func, dat){
  # Write your code here!
  func(dat)
  # Remember: the last expression evaluated will be returned! 
}
evaluate(sd, c(1.4, 3.6, 7.9, 8.8))
evaluate(function(x){x+1}, 6) # the first argument is an anoymous function
evaluate(function(x){x[1]},c(8,4,0))
evaluate(function(x){x[length(x)]},c(8,4,0)) # to find the last element of the vector

# the '...' arguments allow an indefinite number of arguments to be passed into a function.
paste("Programming","is","fun!")
simon_says <- function(...){
    paste("Simon says:", ...)
}

telegram <- function(...){
  paste("START", ..., "STOP", sep=" ")
}
#Telegrams used to be peppered with the words START and STOP in order to demarcate the beginning and end of sentences.

# To "unpack" arguments from an ellipses 
mad_libs <- function(...){
  # First we must capture the ellipsis inside of a list
  # and then assign the list to a variable.
  argus<-list(...)
  # Extract named arguments from
  # the args list by using the name of the argument and double brackets.
  place<-args[["place"]]
  adjective<-args[["adjective"]]
  noun<-args[["noun"]]
  # Don't modify any code below this comment.
  # Notice the variables you'll need to create in order for the code below to
  # be functional!
  paste("News from", place, "today where", adjective, "students took to the streets in protest of the new", noun, "being installed on campus.")
}
mad_libs(Place="Atlanta", place="American", noun="policy")

## User-defined binary operators have the following syntax: %[whatever]% where [whatever] represents any valid variable name.
"%mult_add_one%" <- function(left, right){ # Notice the quotation marks!
   left * right + 1
}

4 %mult_add_one% 5

"%p%" <- function(x="Good",y="job!"){ 
  paste(x, y, sep=" ")
}
"I" %p% "love" %p% "R!"

#Swirl Lesson: Dates and Times
    # Dates are represented by the 'Date' class. Internally, dates are stored as the number of days since 1970-01-01
    # Times are represented by the 'POSIXct' and 'POSIXlt' classes. Internally, times are stroed as either the number of seconds since 1970-01-01 (for 'POSIXct)
    #       or a list of seconds, minutes, hours, etc. (for 'POSIXlt')
d1 <- Sys.Date()
class(d1)
unclass(d1) # to see what d1 looks like internally
#if we need to reference a date prior to 1970-01-01?
d2<-as.Date("1969-01-01")
unclass(d2)

t1<-Sys.time()
# By default, Sys.time() returns an object of class POSIXct
t2<-as.POSIXlt(Sys.time()) # coerce the results to POSIXlt
str(unclass(t2))


weekdays(Sys.Date()) #function will return the day of week from any date or time object
months(t1) 
quarters(t2) # returns quarter of the year
t3<-"October 17, 1986 08:24"
t4<-strptime(t3, "%B %d, %Y %H:%M") # To convert our date/time object to a format that R understands
t4
class(t4)

# Operations on dates and times
Sys.time() - t1
difftime(Sys.time(), t1, units = 'days' )


