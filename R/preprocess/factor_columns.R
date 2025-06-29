# Change all categorical variables to factors.  Can include column names you wish to exclude


factor_columns <- function(df) {
  exclude <- c("VIGFREQW", "STRFREQW", "MODFREQW")
  
  df <- df %>% 
    mutate(
      across(where(is.character), ~ as.numeric(as.factor(.))),
      across(
        .cols = setdiff(names(df), exclude),
        .fns = ~ as.factor(.)
      ),
      UCOD_LEADING = if_else(UCOD_LEADING %in% c("1", "7"), 1, 0),
      UCOD_LEADING = factor(UCOD_LEADING, levels = c(0, 1), labels = c('Other', 'HrDib'))
    )
  df$UCOD_LEADING <- relevel(df$UCOD_LEADING, ref = "HrDib")
  
  df <- df %>% mutate(across(where(is.numeric), scale))

  return(df)
}
