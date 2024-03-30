# The str() function
    # a diagnostic function; an alternative to 'summary'
str(ls)
x<-rnorm(100,2,4)
str(x)
summary(x)

library(datasets)
head(airquality)
str(airquality)

s<-split(airquality,airquality$Month)
str(s)

# Simulations -Generating Random Numbers  
    # Functions for probability distribution in R
    # rnorm: generate random normal variables with a given mean and standard deviation
    # dnorm: evaluate the Normal probability density( with a given mean/SD) at a point (or vector of points)
    # pnorm: evaluate the cumulative distribution function for a Normal distribution
    # rpois: generate random Poisson variates with a given rate

    # Probability distribution functions usually have 4 functions associated with them.
    # the functions are prefixed with a : d(for density); r (for random number generation); 
    # p (for cumulative distribution); q (for quantile function)
library(stats)
rnorm(n, mean=0, sd=1)
dnorm(x, mean=0, sd=1, log =FALSE)
pnrom(q, mean=0, sd=1, lower.tail=TRUE, log.p=FAlSE) #if lower.tail (the part goes to the left) ==FALSE, it will evalute the upper tail of the distribution
qnorm(p, mean=0, sd=1, lower.tail=TRUE, log.p=FASLE) # n is the number of random variables you want to generate

    # if 'phi' is the cul. distribution function for a standard Normal distribution,
    # then pnorm(q)=phi(q) and qnorm(p)=inverse of phi
rnorm(10, 20, 2)

    # set.seed ensures reproducibility
set.seed(1)
rnorm(5)

rnorm(5)

set.seed(1)
rnorm(5)

rpois(10, 1)
ppois(2,2) # cumulative distribution function for the Poisson distribution
          # the probability that a poisson random variable is less than or equal to 2 if the rate is 2

#. Simulating a linear model
set.seed(20)
x<-rnorm(100)
e<-rnorm(100,0,2)
y<-0.5 + 2*x +e
summary(y)
plot(x,y)

set.seed(10)
x<-rbinom(100,1,0.5) # 100 binomial random variables
e<-rnorm(100, 0,2)
y<-0.5+2*x+e
summary(y)
plot(x,y)

# Poisson Mode
set.seed(1)
x<-rnorm(100)
log.mu<-0.5+0.3*x
y<-rpois(100, exp(log.mu))
summary(y)
plot(x,y)


# simulating random sampling
    # sample() draws randomly from a specified set of (scalar) objects allowing you to sample from arbitrary distributions
set.seed(1)
sample(1:10,4)
sample(1:10,4)
sample(letters, 5)
sample(1:10) #Permutation
sample(1:10)
sample(1:10, replace =TRUE)
set.seed(1)

# R profiler
    # profiling: a systematic way to examine how much time is spend in different parts of a program
    # useful when trying to optimize your code

# takes an arbitrary R expression as input and returns the amount of time taken to evaluate the expression
    # Elapsed time: "wall clock"time
    # user time: time charged to the CPU(s) for this expression

#Elapsed time>user time (could b/c the CPU spends more time waiting around)
system.time(readLines("http://jhsph.edu"))

# Elaspsed time< user time
hilbert<-function(n){
  i<-1:n
  1/outer(i-1,i,"+")
}

x<-hilbert(1000)
system.time(svd(x))

# The R profiler
  # Rprof(): keeps track of the function call stack at regularly sampled intervals and tabulates how much time is spend in each function
  # if your codes runs very quickly, the profiler is not useful
    # Default sampling interval is 0.02 seconds

  # summaryRprof(): tabulate the R profiler output and calculate how much time is spend in which function
  # 2 methods for normalizing the data
  #        1."by.total" divides the time spend in each function by the total run time
  #        2."by.self" does the same but first subtract out time spent in functions above in the call stack.


# Swirl Lesson 13: Looking at Data
    #to list the variables in your workspace
ls()
    # to see the dimension of a data frame
dim(plants)
    # to see the number of rows
nrow(plants)
    # to see the number of columns
ncol(plants)
    # to see how much space the dataset is occupying
object.size(plants)
    # return a character vector of column
names(plants)
    # to preview the top of the dataset
head(plants) # by default, it show the first 6 lines
head(plants,10)
    # to preview th end of the dataset
tail(plants, 15)
    # to see how each variable is distributed and how much of the dataset is missing
summary(plants)
    # to see the distribution of a categorical variable with table
table(plants$Active_Growth_Period)

    # structure of a dataset, a function, etc
str(plants)


# Swirl lesson13: Simulation
    # to generate random numbers
?sample
sample(1:6, 4, replace=TRUE) # to randomly select 4 numbers between 1 and 5, with replacement
sample(1:20, 10) # to sample without replacement, simply leave off replace argument.

LETTERS # a predefined variable in R
sample(LETTERS) # whent the sample size is undefined, R takes a sample equal in size to the vector from which you are sampling

flips<-sample(c(0,1),100, replace=TRUE, prob=c(0.3,0.7)) # to set a specific probability to the values
flips
sum(flips)


    # ro simulate  binomial random ramdom variable
?rbinom # rbinom(n, size, prob) 
rbinom(1, size=100, prob=0.7)# to generate 1 random variable that represent the number of heads in 100 flips of your fair coin.
flips2<-rbinom(100, size=1, prob=0.7)
flips2
sum(flips2)

?rnorm # rnorm(x, mean=0, sd=1)
rnorm(10)
rnorm(10, mean = 100, sd=25)

    # if you want to similuate 100 *groups* of random numbers, each containing 5 values generated from a Poisson distribution with mean 10
    # Firstly, start with one group fo 5 numbers
rpois(5, lambda=10)
    # Then us replicate() to perform this operation 100 times
my_pois<-replicate(100, rpois(5, 10))
my_pois
cm<-colMeans(my_pois)
    # to look at the distribution of column means
hist(cm)
    # other standatd probabbility distributions built in R including exponential (rexp()), chi-squared (rchisq()), gamma(rgamma())



# Swirl lession15: Base graphics
data(cars)  
    # before ploting, it is always good to get a sense of data. (can use dim(), names(), head(), tail(), summary())
plot(cars)
plot(x = cars$speed, y = cars$dist)
plot(dist~ speedm cars) # alternative
    # to recreat the label of x-axis to "speed"
plot(x=cars$speed,y=cars$dist, xlab="Speed")

plot(x=cars$speed,y=cars$dist, ylab="Stopping Distance")

plot(x=cars$speed,y=cars$dist, xlab="Speed", ylab="Stopping Distance")
    # add a main title
plot(cars,  main="My Plot")
    # add a subtitle
plot(cars, sub="My Plot Subtitle")
    # set plot points color to red
plot(cars, col=2)
    # limit the x-axis to 10 through 15
plot(cars, xlim=c(10,15))
    # change the symbols in the plot 
?points
plot(cars, pch=2) # change the points to triangle

# to load the data
data(mtcars)
boxplot(formula=mpg~cyl, data=mtcars)

hist(mtcars$mpg)
