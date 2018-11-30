
# Milla Kruskopf | 23.11.2018 | RStudio Exercise 4, Data Wrangling
# SCROLL DOWN FOR EXERCISE 5!

# 2.
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# 3. exploring the datasets
str(hd)
dim(hd)
summary(hd)

# The human development dataset includes 195 observations of 8 variables, such as human development index (HDI), life 
# expectancy at birth and expected years of education.

str(gii)
dim(gii)
summary(gii)

# The gencer inequality dataset includes 195 observations of 10 variables, such as country, percent of representation
# in parliament and labour force participation rates.


# 4. renaming the variables
names(hd) <- c("hdiRank", "country", "hdi", "lifeExpectancy", "expYearsOfEdu", "meanYearsOfEdu", "gniPerCapita", "gniPerCapitaMinusHdi")
names(gii) <- c("giiRank", "country", "gii", "mMortalityRatio", "adolescentBirthRate", "%repInParliament", "withSecondaryEduF", "withSecondaryEduM", "labourParticipRateF", "labourParticipRateM")


# 5. mutating "gender "Gender inequality"
gii <- dplyr::mutate(gii, withSecondaryEduRatio = withSecondaryEduF/withSecondaryEduM, labourParticipRatio = labourParticipRateF/labourParticipRateM)


# 6. joining the datasets by country
human <- dplyr::inner_join(hd, gii, by = "country")

setwd("<insert directory>")
write.csv(human, file = "human", row.names = FALSE)
test <- read.csv("human")
str(test)
head(test)


# Milla Kruskopf | 27.11.2018 | RStudio Exercise 5, Data Wrangling

str(human)
# "human" is a data frame containing 195 observations of 19 variables, related to
# human development and gender equality.

# 1. mutating the gniPerCapita calue as numeric 
library(stringr)
str_replace(human$gniPerCapita, pattern=",", replace ="")%>%as.numeric()

# 2. Excluding the unneeded variables
keep <- c("country", "withSecondaryEduRatio", "labourParticipRatio", "lifeExpectancy", "expYearsOfEdu", "gniPerCapita", "mMortalityRatio", "adolescentBirthRate", "%repInParliament")
human <- select(human, one_of(keep))

# 3. Removing rows with missing values
human <- filter(human, complete.cases(human))

# 4. Removing observations which relate to regions instead of countries
tail(human$country, n=10L)

# We can observe, that the last seven values are regions instead of countries.
# Let's define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]
tail(human, n=10L)


# 5.
# add countries as rownames
rownames(human) <- human$country
human <- select(human, -country)
str(human)

setwd("C:/Users/mkruskop/Documents/IODS/IODS-project/data")
write.csv(human, file = "human", row.names = TRUE)
test <- read.csv("human", row.names = 1)
str(test)
head(test)
