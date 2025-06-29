# Prepare the data frame for modeling with BMI as the only predictor

bmi_model_subset <- function(df) {
  
  df <- df %>% 
    mutate(
      BMI = if_else(BMI >= 1000 & BMI != 9999, BMI / 100, BMI))
  
  df <- df %>% select(c("BMI", "UCOD_LEADING")) %>% filter(BMI < 95)
  
  df <- df %>% mutate(UCOD_LEADING = if_else(
    UCOD_LEADING %in% c("001", "007"), "HrDib", "Other"))
  
  df$UCOD_LEADING <- factor(df$UCOD_LEADING, levels = c("HrDib", 'Other'))
  
  return(df)
}