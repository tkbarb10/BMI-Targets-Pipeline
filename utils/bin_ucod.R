# Utility function to bin the leading cause of death variable into a binary

bin_ucod <- function(df){

  df <- df %>% mutate(UCOD_LEADING = if_else(
      UCOD_LEADING %in% c("001", "007"), "HrDib", "Other"))
  
  df$UCOD_LEADING <- factor(df$UCOD_LEADING, levels = c("HrDib", 'Other'))
  
  return(df)
}
