# Part 1
getwd()
setwd("/Users/aw/Downloads/Coursera/datasciencecoursera/ProgrammingAssignment3Dat")
outcome<-read.csv("outcome-of-care-measures.csv", colClasses="character")
head(outcome)
str(outcome)
outcome[,11]<-as.numeric(outcome[,11])
hist(outcome[,11])

# Function: Handling ties
    # If there is a tie for the best hospital for a given outcome, then the hospital names
    # should be sorted in alphabetical order and the first hospital in that set should be chosen
best<-function(state, outcome) {
      ## read the outcome data
  
# Option 1 : read data from origin
  #if(!dir.exists("./data")) dir.create("./data")
  #if(!file.exists("data/outcome-of-care-measures.csv")){
  #  url <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
  #  temp <- tempfile()
  #   download.file(url, temp)
  #  unzip(temp, exdir = "./data")
  #  unlink(temp)
  #}

# Option 2: read data from local   
  data <- read.csv("outcome-of-care-measures.csv", 
                   colClasses = "character")
 
  outcome.list<-c("heart attack","heart failure", "pneumonia")
  
    ## check that state and outcome are valid
  if(!state %in% data$State | !outcome%in%outcome.list) stop("Invalid state or outcome")
     
   ## Return hospital name in that state with lowest 30-day death rate
      ## select the outcome column
  index<-which(outcome.list %in% outcome)
  outcome.index<-c(11,17,23)[index]
      ## arrange and return data
  data<-data[data$State==state,]
      ## likequiet = TRUE argument. It is possible to suppress all messages with suppressMessages()
  suppressWarnings(data[,outcome.index]<-
                     as.numeric(data[,outcome.index]))
      ## to re-order the data based on the Motality rate
  data<-data[order(data[,outcome.index],data[,2]), ]
      ## return the answer
  data[1,2]
}
    # test the function
best("TX", "heart attack")
best("MD","heart attack")


# Ranking hospitals by outcome in a state
    # the function takes 3 arguments(state, outcome, ranking)
    # it returns a character vector with the hospital name that has the ranking specified
rankhospital<-function(state, outcome,num="best" ){
    ## read the csv file 
data <- read.csv("outcome-of-care-measures.csv", 
                 colClasses = "character")
    ## filter data for the specified state
data<-data[data$State==state,]


    ## check that state and outcome are valid
outcome.list<-c("heart attack", "heart failure", "pneumonia")
if(!state%in%data$State | !outcome%in%outcome.list)stop("invalid state or outcome")


    ## column number for each outcome: heart attack=col 11, heart failure =col 17
    ## index the outcome
index<-which(outcome.list %in% outcome) #to check if a value is present in a vector or a list of values. 
    ## convert the outcome index to the corresponding column number
outcome.index<-c(11,17,23)[index]
    ## change the data class of the specified outcome column 
data[,outcome.index]<-suppressWarnings(as.numeric(data[,outcome.index]))
    ## order the hospitals in the specified state for the specified outcome
data<-data[order(data[,outcome.index],data[,2]), ]
    ## omit the NAs !!!
data<-data[!is.na(data[,outcome.index]),]

    ##converting "best" and "worse" to numbers
if(num=="best") num<-1
if(num=="worst") num<-nrow(data)

    ## return the hospital name
data[num,2]
}

    # test the function
rankhospital("TX","heart failure", 4)
rankhospital("MD", "heart attack", "worst")




# Ranking hospitals in all states

rankall<-function(outcome, num="best") {
  
      ## read the outcome data file
  data<-read.csv("outcome-of-care-measures.csv", 
                 colClasses = "character" )
    
    ## check that state and outcome are valid
  outcome.list<-c("heart attack", "heart failure", "pneumonia")
  if(!outcome%in%outcome.list) stop("Invalid state name")
  
    ## index the outcome
  index<-which(outcome.list%in%outcome)
    ## convert the outcome index to the column number
  outcome.index<-c(11,17,23)[index]
  
  
    ## change the class of the column 
data[,outcome.index]<-suppressWarnings(as.numeric(data[,outcome.index]))
data<-data[!is.na(data[,outcome.index]), ]
    


    ## for each state, give a hospital of a given rank
data<-order(data[,outcome.index])

states<-sort(unique(data$State)) 
hospitals<-NULL

for(i in states) {
  rank<-num
  state.data<-data[data$State ==i, ]
  
  ## order the outcome and hospital columns
  state.data<-state.data[order(state.data[,outcome.index],state.data[,2]),]
  
  ## convert best/worst to numbers
  if(rank=="best") rank<-1
  if(rank=="worst") rank<-nrow(data)
  
  hospital<-state.data[rank, 2]
  hospitals<-c(hospitals, hospital)
  
}
#data.sort<-tapply(data, data$State, function(data) order(data[,outcome.index], data[,2])) 

output<-cbind(hospitals, states)
}


 # test the function 
head(rankall("heart attack",20),10)
rankall("heart attack",20)


pr(t/war) = 0.7
pr(t)=0.2


# Quiz 3
  #Q1
best("SC", "heart attack")
  #Q2
best("NY", "pneumonia")

best("AK", "pneumonia")

rankhospital("NC", "heart attack", "worst")

rankhospital("WA", "heart attack", 7)

rankhospital("TX", "pneumonia", 10)

rankhospital("NY", "heart attack", 7)

##rank hospitals in all states

rankall <- function(outcome, num = "best"){
  #if(!dir.exists("./data")) dir.create("./data")
  #if(!file.exists("data/outcome-of-care-measures.csv")){
  #  url <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
  #  temp <- tempfile()
  #  download.file(url, temp)
  #  unzip(temp, exdir = "./data")
  #  unlink(temp)
  #}
  data <- read.csv("outcome-of-care-measures.csv", 
                   colClasses = "character")
  ##check the validity of outcome
  outcome.list <- c("heart attack", "heart failure", "pneumonia")
  if(!outcome %in% outcome.list) stop("invalid outcome")
  ##select the outcome column
  index <- which(outcome.list %in% outcome)
  outcome.index <- c(11, 17, 23)[index]
  data[, outcome.index] <- suppressWarnings(
    as.numeric(data[ , outcome.index]))
  data <- data[!is.na(data[, outcome.index]), ]
  ##for each state give the hospital of a given rank
  states <- sort(unique(data$State))
  hospitals <- NULL
  for(i in states){
    rank <- num
    ##arrange and return data
    state.data <- data[data$State == i, ]
    ##converting best and worst to numbers
    state.data <- state.data[order(state.data[, outcome.index], 
                                   state.data[, 2]), ]
    if(rank == "best") rank <- 1
    if(rank == "worst") rank <- nrow(state.data)
    hospital <- state.data[rank, 2]
    hospitals <- c(hospitals, hospital)
  }
  
  
  ##return and print the result data frame
  (output <- cbind(hospitals, states))
}

r <- rankall("heart attack", 4)
as.character(subset(r, states == "HI")$hospitals)

  #Q9
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)


  #Q10,
r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)
