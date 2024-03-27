# Week 3: Loop Functions and Debugging

# lapply(): lop over a list and evaluate a function on each element
# sapply(): same as lapply but try to simplify the result
# apply(): Apply a function over the margins of any array
# tapply(): Apply a function over subsets of a vector
# mapply(): Multivariate version of lapply()

# lapply: takes 3 arguments: 1)a list; 2)a function; 3)other arguments
#        If x is not a list, it will be coreced to a list using as.list()
#        always return a list, regardless of the class of the input
x<- list(a=1:5, b=rnorm(10))
lapply(x,mean)

x<-list(a=1:4, b=rnorm(10), c=rnorm(20,1), d=rnorm(100,5))
lapply(x, mean)

x<-1:4
lapply(x,runif) #generate a uniform random variables
  # apply runif() to sequence 1,2,3,4. You get a list.
  # the first element is a single random number random uniform.
  # the second element is a vector of 2 random uniforms

lapply(x, runif, min=0, max=10)
 # to pass some arguments to th runif function which are NOT default values

# lapply can take anonymous function
x<-list(a=martix(1:4,2,2), b=matrix(1:6, 3,2))
lapply(x, function(elt) elt[,1] ) # an anonymous function for extracting the first column of each matrix


# sapply() : will try to simplify the result of lapply if possible
  ## if the results is a list where element is length 1, then a vector is returned
  ## if the result is a list where every element is a vector of the same legth(>1), a matrix is retunred.
  ## if it can't figure things out, a list is returned.
x<-list(a=1:4, b=rnorm(10), c=rnorm(20,1),d=rnorm(100,5))
lapply(x, mean)
sapply(x, mean)

# apply()
  ## most often used to apply a function to the rows or columns of a matrix
  ## can be used with genral arrays, e.g. taking the average of an array of matrices.
  ## function(x, MARGIN, FUN, ...) '...' is for other arguments to be paased to FUN
  ##                               'MARGIN' is an integer vector indicqting which margin should be  'retained'

x<-matrix(rnorm(200),20,10)
apply(x,2, mean)
  # have the mean of each of the column of the matrix
  # '2' means you want to keep the 2nd dimension (i.e. the # of columns) 
  # and collapse the first dimension which is the number of rows
apply(x,1,sum)
  # preserve all the rows; collapse all the columns
  # for each row, I calculate the sum of that row
 
  ##  some shortcuts
rowSums=apply(x,1,sum)
rowMean=aaply(x,1,mean)
colSum=apply(x,2,sum)
colMean = apply(x,2,mean)
x<-matrix(rnorm(200),20,10)
apply(x,1,quaantile, probs=c(0.25,0.75))

a<-array(rnorm(2*2*10),c(2,2,10))
apply(a,c(1,2),mean)
rowMeans(a,dims=2)

# mapply()
  # applies a function in parallel over a set of arguments
  # function(FUN, ..., MoreArgs =NULL, SIMPLIFY = TRUE,
  #          USE.NAMES =TRUE) 'MoreArgs' is a list of other arguments to FUN
  #                           'SIMPLIFY' indicates whether the result should be simplified
mapply(rep,1:4, 4:1 )

noise<-function(n, mean, sd){
  rnorm(n,mean, sd)
}
noise(5,1,2)
noise(1:5,1:5, 2) # the function doesn't work on vectors

 #Get 1 with mean 1, two with mean 1, three with mean 3, four with mean 4
mapply(noise, 1:5,1:5,2) #'2' :to fix sd at 2
  #is equivalent to
list(noise(1,1,2), noise(2,2,2),
     noise(3,3,2), noise(4,4,2),
     noise(5,5,2))

# tapply()
    # is used to apply a function over subsets of a vector
    # function(x, INDEX, FUN =Null, ...,simplify=TRUE) INDEX: a factor or a list of factors(or else they are coerced to factors)

    # example: take group means
x<-c(rnorm(10), runif(10),rnorm(10,1))
f<-gl(3,10) # generate factors by specifying the patterns of their levels
            # the results have levels from 1 to 3 with each value replicated in groups of length 10
            # the factor variable f indicates which group the observation is in
tapply(x,f,mean) # to take the mean of each group of numbers in x

# take group means without simplification
tapply(x,f,mean, simplify=FALSE)

# find group ranges
tapply(x,f,range)


# split()
    # takes a vector or other objects and splits it into groups determined by a factor or list of factors
    # function(x,f,drop =FALSE, ...); (x is a vector or list or data frame
    #                                 f is a factor or coerced to one or a list of factors        
    #.                                drop indicates whether empty factors levels should be dropped 
split(x, f)

    # can be used in conjunction with lapply, tapply
lapply(split(x,f),mean) # split x using f variable

libary(datasets)
head(airquality)

s<-split(airquality,airquality$Month)
lapply(s,function(x) colMeans(x[, c("Ozone","Solar.R","Wind")])) # only take of the means of those 3 columns

# 
sapply(s, function(x) colMeans(x[,c("Ozone","Solar.R","Wind")]))
sapply(s, function(x) colMeans(x[,c("Ozone","Solar.R","Wind")], na.rm=TRUE))

# Splitting on More than one level
x<-rnorm(10)
f1<-gl(2,5)
f2<-gl(5,2)
interaction(f1,f2) # to see the different combination of 10 different levels

str(split(x, list(f1,f2),drop= TRUE))
# drop can drop empty levels created by splitting


# Debugging Tools- Diagnosing the problem
    # traceback(): print out the function call stack after an error occurs
    # debug(): flags a fucntions for debug() mode which allows you to stepn through execution of a fucntion one line at a time
    # browser(): suspends the execution of a function whereever it is called and puts the function in debug mode
    # trace(): allows you to modify the error behavior so that you can browse the function call stack
    # recover(): allows you to modify the error behavior so that you can browse the function call stack.
rm(x)
mean(x)
traceback() # have to call tracback() immediately after error occurs; it will only give you the most recent error

lm(y~x)
traceback()

debug(lm)
browser() # then press n for next, and it runs the first line.
          # to stop the process, enter Q

options(error=recover)
read.csv("nosuchfile")


# Swirl Practice: No.10 Lapply and sapply
    # Each of the *apply functions will SPLIT up some data into smaller pieces, 
    # APPLY a function to each piece, then COMBINE the results. 

head(flags) #to preview a dataset
dim(flags) # to check the dimension of a dataset

    # to find out the class of each column of a dataset
    # could do it one by one, or using the lapply()
cls_list<-lapply(flags, class)
cls_list
    #l in lapply() means 'list
class(cls_list) # the output is a list, which can stor multiple classes of data
                # in this case, each element in the cls_list is a character vector of length one

    # to simplify the list to a chatacter vector
as.character(cls_list)

    # 's' in 'sapply' stands for simplify
cls_vect<-sapply(flags, class)
class(cls_vect) # chatacter ! 
                # In general, if the result is alist where every element is of length one, then sapply() returns a vector
                # If sapply cannot configure things out, then it returns a list
                # If the result is a list where element is a vector of the same length(>1), it returns a matrix

    # Column 11:17 are indicator variables. 1 if the color is present in a country's flag and 0 otherwise
    # if we want to know the total number of countries with, for example, the color organge on their flag, we can add up all of the 1s and 0s in the 'orange' column.
sum(flags$orange)
    # repeat this for each of the colors recorded in the dataset
flag_colors<-lapply(flags[,11:17],sum)
    # method 2
flag_colors<-flags[, 11:17]
head(flag_colors)
lapply(flag_colors, sum)
sapply(flag_colors, sum)

    # to extract columns 19:23
flag_shapes<-flags[,19:23]
    # we are interested in the minimum and maximum number of times each shape o design appears.
lapply(flag_shapes, range)
shape_mat<-sapply(flag_shapes, range)
shape_mat

    # example when sapply() can't figure out how to simplify
unique(c(3,4,5,5,5,6,6))
unique_vals <- lapply(flags, unique)
unique_vals
lapply(unique_vals, length)
sapply(unique_vals, length)
sapply(flags, unique)

    # write a function to return the second item from each element of the unique_vals list 
lapply(unique_vals, function(elem) elem[2]) # the function takes 1 argument, elem, which is just 
                                            # a 'dummy variable that takes on the value of each element of unique_vals list


# Swirl lesson 11: vapply and tapply
    # while sapply() tries to guess the correct format of the result, vapply() allows you to specify it explicitly
    # If the result doesn't match the format you specify, vapply() will throw an error.
    # Additionally, vapply() perform faster than sapply() for large datasets

vapply(flags, unique, numeric(1)) # says that you expect each element of the result to be a numeric vector of length 1 
                                  # since this is NOT the case, you will get an error
vapply(flags, class, character(1)) # say that you expect the class() to return a character vector of length 1

    # Often wish to split the data up into groups based on the value of some variable, then apply a function to 
    #   to the members of each group.
table(flags$landmass)
tapply(flags$animate,flags$landmass, mean)
tapply(flags$population, flags$red, summary)
tapply(flags$population, flags$landmass, summary) # split the data in the population column based on landmass and then apply fuunction to each group

