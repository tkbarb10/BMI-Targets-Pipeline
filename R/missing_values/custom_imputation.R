# All code for variables that needed individual attention

custom_imputation <- function(df) {

  # Drop columns we aren't using
  
  cols_to_drop <- c("ALCHRC12", "ALC12MWK", "ALC12MYR", "ALCAMT", "ALC7STAT", "SMKQTY")
  
  df[, cols_to_drop] <- NULL
  
  
  # Fix UCOD_LEADING
  
  df[, "UCOD_LEADING"] <- ifelse(df$UCOD_LEADING == "   ", "010", df$UCOD_LEADING)
  
  
  # Take care of SMKNOW
  
  df <- df %>%
    mutate(SMKNOW = if_else(
      is.na(SMKNOW) & SMKSTAT2 %in% c(4, 9),
      SMKSTAT2,
      SMKNOW
    ))
  
  
  # Take care of DiabetesEver and DiabetesAge
  
  df <- df %>% 
    mutate(DiabetesEver = if_else(
      is.na(DiabetesEver) & DiabetesAge < 90,
      1,
      if_else(
        is.na(DiabetesEver) & DiabetesAge > 90,
        9,
        DiabetesEver
      )
    )) %>% 
    select(-DiabetesAge)
  
  
  # Recode and bin sleep, then fill in NA's with current distribution
  
  df <- df %>%
    mutate(Sleep = if_else(Sleep %in% c(97, 98, 99), NA_real_, Sleep))
  
  
  df <- df %>% mutate(Sleep = case_when(
    Sleep < 6 ~ "Short",
    Sleep >= 6 & Sleep <= 8 ~ "Moderate",
    Sleep > 8 ~ "Long"
  ))
  
  sleep_table <- table(df$Sleep)
  
  prop_sleep <- prop.table(sleep_table)
  
  set.seed(123)
  df$Sleep[is.na(df$Sleep)] <- sample(names(prop_sleep), 
                                      sum(is.na(df$Sleep)), 
                                      replace = TRUE, 
                                      prob = prop_sleep)
  
  return(df)
  
}
