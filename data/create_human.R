
# Milla Kruskopf | 23.11.2018 | RStudio Exercise 4, Data Wrangling

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
