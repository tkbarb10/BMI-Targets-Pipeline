library(targets)
library(tidyverse)

df <- tar_read(new_linked_nhisV3)


bmi_df <- df %>% select(BMI) %>% filter(BMI != 9999) %>% mutate(BMI = if_else(BMI > 1000, BMI / 100, BMI)) %>% filter(BMI > 50)


filtered_df <- df %>% filter(BMI != 9999) %>% 
  filter(!AWEIGHTP %in% c(997:999)) %>% 
  filter(!AHEIGHT %in% c(97:99)) %>% 
  mutate(BMI = if_else(BMI > 1000, BMI / 100, BMI)) %>% 
  filter(BMI < 80)




#scaling 
filtered_df$BMI_Z <- scale(x = filtered_df$BMI)

df_outliers <- filtered_df[ which(filtered_df$BMI_Z < -3 | filtered_df$BMI_Z >3), ]

View(df_outliers)
#checking largest z-values
#df_sort <- df[ order(- df$BMI_Z), ]
#head(df_sort)



#Handling Sleep variable by transforming values 97, 98, 99 into N/A
table(filtered_df$Sleep)

sleep_df <- filtered_df %>%
  mutate(Sleep = if_else(Sleep %in% c(97, 98, 99), NA_real_, Sleep))

table(sleep_df$Sleep)

#Assigning each value into one of three categories
sleep_cat_df <- sleep_df %>% mutate(Sleep = case_when(
  Sleep < 6 ~ "Short",
  Sleep >= 6 & Sleep <= 8 ~ "Moderate",
  Sleep > 8 ~ "Long"
))

table(sleep_cat_df$Sleep)

#Moving N/A values into each category to maintain original distribution

#Calculating proportions of each category
prop_sleep <- table(sleep_cat_df$Sleep) / sum(table(sleep_cat_df$Sleep))
prop_sleep

#Distribution of N/A values
set.seed(123)
sleep_cat_df$Sleep[is.na(sleep_cat_df$Sleep)] <- sample(names(prop_sleep), 
                                                      sum(is.na(sleep_cat_df$Sleep)), 
                                                      replace = TRUE, 
                                                      prob = prop_sleep)

#Verifying distribution
table(sleep_cat_df$Sleep) / sum(table(sleep_cat_df$Sleep))

View(sleep_cat_df)

#Creating bins for BMI
cat_df <- sleep_cat_df %>% mutate(BMI = case_when(
  BMI < 18.5 ~ "Underweight",
  BMI >= 18.5 & BMI < 25 ~ "Healthy Weight",
  BMI >=25 & BMI < 30 ~ "Overweight",
  BMI >= 30 ~ "Obese"
))


