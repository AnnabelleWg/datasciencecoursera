#Week2 Quiz
# Part1

# setwd("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata")

  # Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors.
pollutantmean<-function(directory, pollutant, id=1:332){
  ## 'directory is a character vector of length 1 indicating
  ## the location of the CSV files.
  directory<-as.character(directory)
  setwd(directory)
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculating the 
  ## mean; wither 'sulfate' or 'nitrate'

  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  #library(readr)
  #install.packages("data.table")
  library(data.table)
  
  #format number with fixed width and then append .csv
  filenames<-paste0(formatC(id, width=3, flag="0"),".csv")
  
  #Reading in all files and making a large data.table
  list<-lapply(filenames, data.table::fread) # fread is for regular delimited files; 
                                             # i.e., where every row has the same number of columns. 
  
  dt<-rbindlist(list) # make one data.table from a list of many; same as rbind() but faster
  
# if(c(pollutant) %in% names(dt)) {
#   return(dt[,lapply(.SD, mean, na.rm=TRUE), .SDcols=pollutant][[1]])
# }

#  for (filenames in seq_along(list)){
#    return(mean(dt[,pollutant], na.rm=TRUE))
# }
  if(pollutant=="sulfate"){
    mean(dt[,sulfate], na.rm=TRUE)
  }else{
    mean(dt[,nitrate], na.rm=TRUE)
  }
 
  }


# Part 2
complete<-function(directory, id=1:332){
      ## 'directory' is a character vecotr of length 1 indicting 
      ## the location of the csv files
  directory<-as.character(directory)
  setwd(directory)
  
      ## 'id' is an  integer vector indicating the moitor ID numbers
      ## to be used
  
      ## the function reads a directory full of files 
  library(data.table)
  filenames<-paste0(formatC(id, width=3, flag="0"),".csv")
  list<-lapply(filenames, data.table::fread)
  dt<-rbindlist(list) # make one data.table from a list of many
  
      ## reports the number of completely observed cases in each data file.
  dt[complete.cases(dt),.(nobs=.N), by=ID] # 'nobs'  stands for number of non-missing observations
}

    ## test the function
    #getwd()
    #complete("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 30:25)
    #complete("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata",c(2,4,8,10,12) )


# Part 3
corr<-function(directory, threshold = 0){
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completly observed observations (on all variables)
  ## required to compute the correlation betwwen nitrate and sulfate;
  ## the default is 0
  library(data.table)
  setwd(as.character(directory))
  
  list<- lapply(file.path(directory,list.files(path=directory, pattern="*.csv")), data.table::fread )
  #make one table from a list of many
  dt<-rbindlist(list)
  #only keep completely observed observations
  dt<-dt[complete.cases(dt),]
  
  ## Return a numeric vector of correlation
  # Apply the threshold
  dt<-dt[, .(nobs =.N, corr = cor(x= sulfate, y=nitrate)), by=ID][nobs>threshold]
  return(dt[,corr])
}
corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", threshold=0)
cr<-corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", threshold=150)
head(cr)
summary(cr)
length(cr)

#Quiz
#1.
pollutantmean("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", "sulfate", 1:10)
#2
pollutantmean("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", "nitrate", 70:72)

pollutantmean("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", "sulfate", 34)

pollutantmean("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", "nitrate")

cc <- complete("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", c(6, 10, 20, 34, 100, 200, 310))
print(cc$nobs)

cc <- complete("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 54)
print(cc$nobs)

RNGversion("3.5.1")  
set.seed(42)
cc <- complete("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

cr <- corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata")                
cr <- sort(cr)   
RNGversion("3.5.1")
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

cr <- corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 129)                
cr <- sort(cr)                
n <- length(cr)    
RNGversion("3.5.1")
set.seed(197)                
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)

cr <- corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 2000)                
n <- length(cr)                
cr <- corr("/Users/aw/Downloads/Coursera/datasciencecoursera/specdata", 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))
