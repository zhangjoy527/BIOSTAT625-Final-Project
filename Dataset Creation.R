## Clean dataset, reupload cleaned version

library(dplyr)
diabetes = read.csv("diabetes_data_raw.csv")

attach(diabetes)

# categorize age into 4 groups
# 18 < age < 35: 1, 2, 3
# 35 < age < 50: 4, 5, 6
# 50 < age < 65: 7, 8, 9
# age > 65: 10, 11, 12, 13

diabetes$age_cat <- cut(diabetes$Age,
                             breaks=c(1, 4, 7, 10, 13),
                             include.lowest=TRUE,
                             right=FALSE,
                             labels = c(0, 1, 2, 3))
#levels(diabetes$age_cat) <- c("Under 35", "35-49", "50-65", "Over 65")

# categorize income into 3 groups
# income < 25000 ---> low: 1, 2, 3, 4
# 25000 < income < 75000 ---> medium: 5, 6, 7
# income > 75000 ---> high: 8

diabetes$income_cat <- cut(diabetes$Income,
                                breaks = c(1, 5, 7, 8),
                                include.lowest = TRUE,
                                right = FALSE,
                                labels = c(0, 1, 2))
#levels(diabetes$income_cat) <- c("Low Income", "Medium Income", "High Income")

# categorize education into 2 groups
# never attended college: 1, 2, 3, 4
# attended college: 5, 6

diabetes$edu_cat <- cut(diabetes$Education,
                             breaks=c(1, 5, 6),
                             include.lowest=TRUE,
                             right=FALSE,
                             labels = c(0, 1))
#levels(diabetes$edu_cat) <- c("No College", "College")

# categorize physical health into 2 groups
# physical illness or injury days in past 30 days < 5
# physical illness or injury days in past 30 days >= 5

diabetes$PhysHlth_cat <- cut(diabetes$PhysHlth,
                                  breaks=c(0, 5, 30),
                                  include.lowest=TRUE,
                                  right=FALSE,
                                  labels = c(0, 1))
#levels(diabetes$PhysHlth_cat) <- c("Low Physical Health", "High Physical Health")

# categorize mental health into 2 groups
# mental illness days in past 30 days < 5
# mental illness days in past 30 days >= 5

diabetes$MentHlth_cat <- cut(diabetes$MentHlth,
                                  breaks=c(0, 5, 30),
                                  include.lowest=TRUE,
                                  right=FALSE,
                                  labels = c(0, 1))
#levels(diabetes$MentHlth_cat) <- c("Low Mental Health", "High Mental Health")

detach(diabetes)

write.csv(diabetes, "diabetes_data.csv")




