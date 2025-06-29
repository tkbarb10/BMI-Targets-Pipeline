## final bit of cleaning the data frame to prep for modeling.  Dropping weight and height now
# instead of earlier because used those variables to decide what to do with BMI

library(tidyverse)

final_clean <- function(df) {
  
  cols_to_drop <-  c("SRVY_YR", 'MORTSTAT', "UUID", "AHEIGHT", "AWEIGHTP", "DIABETES", "HYPERTEN")
  
  df <-  df %>% select(-any_of(cols_to_drop))
  
  # Bin BMI
  
  df <- df %>% 
    mutate(
      BMI = if_else(BMI >= 1000 & BMI != 9999, BMI / 100, BMI)) %>% 
    filter(BMI < 99) %>% 
    mutate(BMI = case_when(
      BMI < 18.5 ~ "Underweight",
      BMI >= 18.5 & BMI < 25 ~ "Healthy Weight",
      BMI >=25 & BMI < 30 ~ "Overweight",
      BMI >= 30 ~ "Obese"
    ))
  
  return(df)
}
