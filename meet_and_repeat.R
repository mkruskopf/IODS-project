
# Milla Kruskopf | Exercise 6 Data wrangling

#Step 1.
BPRS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="\t", header=TRUE)

names(BPRS)
str(BPRS)
summary(BPRS)

names(RATS)
str(RATS)
summary(RATS)

#The wide form datasets, with dependency between the same individual's datapoints from different weeks.


#Step 2. Convert the categorical variables of both data sets to factors.
library(dplyr)
library(tidyr)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Step 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS.
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))
glimpse(BPRSL)

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,4))) 
glimpse(RATSL)


#Step 4. Better look at the data
library(ggplot2)


# BPRS

ggplot(BPRSL, aes(x = week, y = bprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  theme(legend.position = "none") + 
  scale_y_continuous(limits = c(min(BPRSL$bprs), max(BPRSL$bprs)))

# Standardise the variable bprs
BPRSL <- BPRSL %>%
  group_by(week) %>%
  mutate(stdbprs = (bprs - mean(bprs))/sd(bprs)) %>%
  ungroup()

# Glimpse the data
glimpse(BPRSL)

# Plot again with the standardised bprs
ggplot(BPRSL, aes(x = week, y = stdbprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  scale_y_continuous(name = BPRSL$stdbprs)

# Number of weeks, baseline (week 0) included
n <- BPRSL$week %>% unique() %>% length()

# Summary data with mean and standard error of bprs by treatment and week 
BPRSS <- BPRSL %>%
  group_by(treatment, week) %>%
  summarise( mean = mean(bprs), se = sd(bprs)/sqrt(n) ) %>%
  ungroup()

# Glimpse the data
glimpse(BPRSS)

# Plot the mean profiles
ggplot(BPRSS, aes(x = week, y = mean, linetype = treatment, shape = treatment)) +
  geom_line() +
  scale_linetype_manual(values = c(1,2)) +
  geom_point(size=3) +
  scale_shape_manual(values = c(1,2)) +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se, linetype="1"), width=0.3) +
  theme(legend.position = c(0.8,0.8)) +
  scale_y_continuous(name = "mean(bprs) +/- se(bprs)")

# Create a summary data by treatment and subject with mean as the summary variable (ignoring baseline week 0).
BPRSL8S <- BPRSL %>%
  filter(week > 0) %>%
  group_by(treatment, subject) %>%
  summarise( mean=mean(bprs) ) %>%
  ungroup()

# Filtering the outlier
BPRSL8S1 <- filter(BPRSL8S, BPRSL8S$mean<=60)

# Draw a boxplot of the mean versus treatment
ggplot(BPRSL8S1, aes(x = treatment, y = mean)) +
  geom_boxplot() +
  stat_summary(fun.y = "mean", geom = "point", shape=23, size=4, fill = "white") +
  scale_y_continuous(name = "mean(bprs), weeks 1-8")


# RATS

# Check the dimensions of the data
dim(RATSL)

# Plot the RATSL data
ggplot(RATSL, aes(x = Time, y = Weight, group = ID)) +
  geom_line(aes(linetype = Group)) + 
  scale_x_continuous(name = "Time (days)", breaks = seq(0, 60, 10)) + 
  scale_y_continuous(name = "Weight (grams)") + 
  theme(legend.position = "top")


#The datasets BPRS and RATS are in the wide form, where the different measurements of the same individual are 
#interdependent.In the long form of the datasets BPRSL and RATSL we ignore the interdependency, and analyze 
#all observations independent of one another, ignoring, that, i.e., the 11 weights come from the same rat. 
#This way the data can easily be analyzed using, i.e., multiple linear regression.

setwd("C:/Users/mkruskop/Documents/IODS/IODS-project/data")
write.csv(BPRS, file = "BPRS", row.names = FALSE)
test <- read.csv("BPRS")
str(test)
head(test)

write.csv(BPRSL, file = "BPRSL", row.names = FALSE)
test <- read.csv("BPRSL")
str(test)
head(test)

write.csv(BPRSL8S, file = "BPRSL8S", row.names = FALSE)
test <- read.csv("BPRSL8S")
str(test)
head(test)

write.csv(BPRSL8S1, file = "BPRSL8S1", row.names = FALSE)
test <- read.csv("BPRSL8S1")
str(test)
head(test)

write.csv(RATS, file = "RATS", row.names = FALSE)
test <- read.csv("RATS")
str(test)
head(test)

write.csv(RATSL, file = "RATSL", row.names = FALSE)
test <- read.csv("RATSL")
str(test)
head(test)
