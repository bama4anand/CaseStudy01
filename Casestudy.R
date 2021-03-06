
#**Introduction**

##The purpose of this project is to analyze the Gross Domestic Product (GDP) among economies with confirmed GDP estimates only. The data includes observations for the year of 2012 (mainly) but can include data for 2011 or 2010 in some cases. The study focuses in understanding the different GDP rankings, quantiles and the correlation that exists with the Income Groups defined in the World Bank EdStats data.

##Original data sources can be found in the links below:
  
 ## http://data.worldbank.org/data-catalog/GDP-ranking-table

##http://data.worldbank.org/data-catalog/ed-stats

##Session Info

sessionInfo()
getwd()
setwd( "C:/Users/GTX8WNS/Desktop/SMU/Expremental Statistics/Casestudy")


list.files()
# Analysis and Tidy of GDP Data

DataGDP <- read.csv("GDP.csv", stringsAsFactors=FALSE, header=FALSE)
head(DataGDP)

##Remove the first 5 lines in the data that is irrilavent to the dataset

DataGDP <- read.csv("GDP.csv", stringsAsFactors=FALSE,skip=5, header=FALSE)
head(DataGDP)


##Select only those columns relevant for our future data analysis:

datasetGDP <- DataGDP[c(1,2,5)]

##Rename variables into  suitable Column names:
  
names(datasetGDP) <- c("CountryCode", "Ranking", "USDinM")
head(datasetGDP)


datasetGDP$Ranking <- gsub("Ranking", "", datasetGDP$Ranking)
##For variable MillionsUSD prepare for datatype conversion:

datasetGDP$USDinM <- gsub(",", "", datasetGDP$USDinM)


##For variable MillionsUSD convert to datatype integer:
  
datasetGDP$USDinM <- as.integer(datasetGDP$USDinM)


##Discard invalid rows (rows with empty CountryCode)

datasetGDP <- datasetGDP[datasetGDP$CountryCode != "", c(1,2,3)]


##Ranking convert to datatype integer:
  
datasetGDP$Ranking <- as.integer(datasetGDP$Ranking)
str(datasetGDP)


## Analysis and Tidy EDU Data


##New DataSet Name

DataEDUSTAT <- read.csv("EDUSTAT.csv",stringsAsFactors=FALSE, header=TRUE)
head(DataEDUSTAT)


##Only select those variables that will be relevant in our future data analysis: CountryCode, CountryName and IncomeGroup.

datasetEDU <- DataEDUSTAT[c(1:3)]
head(datasetEDU)


##variable CountryCode replace the value "CountryCode" for nothing to eliminate invalid value.

datasetEDU$CountryCode <- gsub("CountryCode", "", datasetEDU$CountryCode)

##Replace of an invalid value.

datasetEDU$Income.Group <- gsub("Income.Group", "", datasetEDU$Income.Group)


##Question 1
##Match the data based on Country shortcode. How many of the IDs match?

mergedgdp_edu<-merge(x=datasetEDU,y=datasetGDP,by="CountryCode")
dim(mergedgdp_edu)


##The new merged dataset contains 224 observations and 5 variables

##Question 2
##Sort the data frame in ascending order by GDP rank(so Uniteds is last). What is the 13th country in the resulting data frame?
##First eliminate rows with no GDP and Ranking

mergedgdp_edu <- subset(mergedgdp_edu, !is.na(USDinM))
mergedgdp_edu <- mergedgdp_edu[-which(mergedgdp_edu$Ranking == ""), ]

##Make Rankig as Integer

mergedgdp_edu$Ranking <- as.integer(mergedgdp_edu$Ranking)

##Sort the data frame in ascending order by GDP rank

mergedgdp_edu2<-mergedgdp_edu[order(mergedgdp_edu$Ranking),]

##What is the 13th country in the resulting data frame?

head(mergedgdp_edu2,13)


##The 13th country in the list is: ESP- Kingdom of Spain

##Question 3
##What are the average GDP rankings for “High income:OECD” and “High income:nonOECD groups?

##Choose only the observations with IncomeGroup = "High income: OECD" and calculate its mean

HighIncomeOECD <- mergedgdp_edu2[mergedgdp_edu2$Income.Group == "High income: OECD",c(3,5)]
HighIncomeOECD
summary(HighIncomeOECD$USDinM)


##Choose only the observations with IncomeGroup = "High income: nonOECD" and calculate its mean

HighIncomeNonOECD <- mergedgdp_edu2[mergedgdp_edu2$Income.Group == "High income: nonOECD", c(3,5)]
HighIncomeNonOECD
summary(HighIncomeNonOECD$USDinM)

###The average GDP for the Income Group "High income: nonOECD" is: 1,04,300
###The average GDP for the Income Group "High income: OECD" is: 1,484,000

##Question 4
##Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.
##Use ggplot2 to color your plot by Income Group.

##Install and load the "ggplot2" package as follows:
  
install.packages("ggplot2", dependencies=TRUE, repos='http://cran.rstudio.com/')

library("ggplot2")


##Get data ready for plot (discard unwanted rows such as summaries and rows with empty values):
 
dataplot <- mergedgdp_edu2[1:198,]
dataplot <- dataplot[dataplot$Income.Group != "","NA",c(1,2,3,4,5)]



##Plot using ggplot

ggplot(data=dataplot, aes(x=USDinM,y=CountryCode, color=Income.Group))+geom_point()





##Interpretation of the Plot: United States of America was by far the country with the highest Gross Domestic. 

##Question 5:
##Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
##How many countries are Lower middle income but among the 38 nations with highest
##GDP?

##Cut the GDP ranking into 5 separate quantile groups.

##Create a new dataframe for analysis and review its structure.

dataanalysis <- dataplot
str(dataanalysis)



##Get the mean and standard deviation of the Ranking variable for further calculations of quantiles


summary(dataanalysis$Ranking) 
qtl<-cut(dataanalysis$Ranking, breaks=5)
table(qtl)
qtl



##Make a table versus Income.Group


##table(dataanalysis$Ranking, dataanalysis$Income.Group)



##How many countries are Lower middle income but among the 38 nations with highest GDP?

##Per the counts in the table above: 5 countries are Lower middle income in the 38 highest GDP

##Summary

##An analysis of global economic data was performed in order to evaluate the relationship between GDP (in US$), ranking, and income group. Data were first cleaned and sorted by ranking. Then, averages were calculated for the “high income: OECD” and “high income: nonOECD” groups. Plotting ranking and income by income group revealed that five countries within the top quartile for GDP are listed as “lower middle income” despite their wealth. 

