#read the data
library(tidyverse)
library(ggplot2)
library(dplyr)
library(stringr)
library(zoo)
library(corrplot)

df <- read.table(file = "Education.csv", sep = ",", header = TRUE)

# keep first 100 rows as it should not be more than that
df <- head(df, 100)

# drop the series code as it is redundant
drop <- c("Series.Code", "Country.Code")
df <- df[, !(names(df) %in% drop)]
#replace value  (this represent null value in this contest) null value
df[df == '..'] <- NA

# count missing value
sum(is.na(df))

#unpivot the year column name into rows
df <- df %>% pivot_longer(cols = starts_with("X20"), 
                    names_to = "Year", values_to = "mean")

#pivot the series 
df <- df %>%  pivot_wider(names_from = Series.Name, 
                            values_from = mean)
# replace the year column with the real value
df$Year <- str_replace(df$Year, "X", "")
df$Year <- str_replace(df$Year, "..YR[0-9]{4}.", "")

# change the data type of the appropriate column to numeric
df[-1:-2] <- lapply(df[-1:-2], as.numeric)
df$Year <- as.Date(paste(df$Year, 1, 1, sep="-"))

#replace na value with the mean of the column
df2 <- select_if(df, is.numeric)
df2 <- na.aggregate(df2)
df[3:12] <- df2
#Calculate descriptive analysis for each series

summary(df)

#plot some graph for the descriptive analysis
#1 education expenditure to overall expenditure

ggplot(df, aes(x = factor(Country.Name), 
               y = Government_EE)) +
  geom_bar(stat = "summary", fun = "mean") + 
  ggtitle("Percentage Education Expenditure to Overall Government Expenditure by Country") + 
  labs(y = "Education Expenditure", x = "Country")

#2 current education expenditure to overall public institution expenditure

ggplot(df, aes(x = factor(Country.Name), 
               y = Education_E_PI)) +
  geom_bar(stat = "summary", fun = "mean") + 
  ggtitle("Percentage Education Expenditure to Public Institution Expenditure by Country") + 
  labs(y = "Education Expenditure", x = "Country")

#3 primary education expenditure

ggplot(df, aes(x = factor(Country.Name), 
               y = Primary_E)) +
  geom_bar(stat = "summary", fun = "mean") + 
  ggtitle("Percentage Primary Education Expenditure to Education Expenditure by Country") + 
  labs(y = "Primary Education Expenditure", x = "Country")

#4 secondary education expenditure

ggplot(df, aes(x = factor(Country.Name), 
               y = Secondary_E)) +
  geom_bar(stat = "summary", fun = "mean") + 
  ggtitle("Percentage Secondary Education Expenditure to Education Expenditure by Country") + 
  labs(y = "Secondary Education Expenditure", x = "Country")

#5 tertiary education expenditure

ggplot(df, aes(x = factor(Country.Name), 
               y = Tertiary_E)) +
  geom_bar(stat = "summary", fun = "mean") + 
  ggtitle("Percentage Tertiary Education Expenditure to Education Expenditure by Country") + 
  labs(y = "Tertiary Education Expenditure", x = "Country")

#6 Education expenditure vs primary education

ggplot(df, aes(Primary_A, Secondary_A, colour = Country.Name)) +
  geom_point() + 
  ggtitle(
    "% Attained at least Primary Enducation vs % Attained at least 
    Secondary Enducation") +
  labs(y="% Attained Secondary Education", 
       x = "% Attained at least Primary Enducation")

#6 correlation analysis
corrplot(cor(df[-1:-2]))

#7 regression analysis
# linear regression
rg <- lm(df$Primary_A ~ df$Secondary_A)
summary(rg)
rg$coefficients
anova(rg)
plot(rg)

# multi linear regression
m_rg  <- lm(df$Primary_A ~df$Secondary_A + df$Bachelor_A)
summary(m_rg)
plot(m_rg)

#8 Time Series analysis
df_gp <- df %>% group_by(Year) %>%
  summarise(primary_a = mean(Primary_A), secondary_a = mean(Secondary_A),
            bachelor_a = mean(Bachelor_A))

#primary school attained
ggplot(df_gp, aes(x = Year, 
               y = primary_a)) + geom_line() + 
  ggtitle("Trend Analysis % of Primary Education Attained ") + 
  labs(y = "Percentage(%)", x = "Year")

#secondary
ggplot(df_gp, aes(x = Year, 
                  y = secondary_a)) + geom_line() + 
  ggtitle("Trend Analysis % of Sec Education Attained ") + 
  labs(y = "Percentage(%)", x = "Year")

# bachelor
ggplot(df_gp, aes(x = Year, 
                  y = bachelor_a)) + geom_line() + 
  ggtitle("Trend Analysis % of Bachelor Degree Attained ") + 
  labs(y = "Percentage(%)", x = "Year")
