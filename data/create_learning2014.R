
# Milla Kruskopf | 6.11.2018 | RStudio Exercise 2, Data Wrangling

# 2)
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

str(learning2014)

dim(learning2014)

# The dataset contains 183 observations of altogether 60 variables, presumably related to learning.


# 3)

# We will first install the package dplyr and access the library.
install.packages("dplyr")
library(dplyr)

# Then we will create sum composite variables for deep-, surface- and strategic 
# learning questions.
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(learning2014, one_of(deep_questions))
deep <- rowMeans(deep_columns)

surface_columns <- select(learning2014, one_of(surface_questions))
surf <- rowMeans(surface_columns)

strategic_columns <- select(learning2014, one_of(strategic_questions))
stra <- rowMeans(strategic_columns)

# We will pick and name the desired vectors from the dataset
gender <- learning2014$gender
age <- learning2014$Age
attitude <- learning2014$Attitude
points <- learning2014$Points


# Then we will combine the analysis dataset out of our desired components.
learning2014analysis <- data.frame(gender, age, attitude, deep, stra, surf, points)

# We will further exclude observations where the exam points variable is 0.
learning2014analysis <- filter(learning2014analysis, points > 0)

# Now we will revisit the structure and dimensions of our learning2014analysis
# dataset consisting of 7 rows and 166 observations.
str(learning2014analysis)

dim(learning2014analysis)

# 4) Tallennetaan tulos data-kansioon ja testataan tiedoston rakenne.
setwd("insert directory")
write.csv(learning2014analysis, file = "learning2014", row.names = FALSE)
test <- read.csv("learning2014")
str(test)
head(test)

# Näyttäisi oikealta.