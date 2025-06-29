# Columns to drop after initial model exploration to prepare for hyperparameter tuning

feature_selection <- function(df, cols_to_drop) {
  
  df <- df %>% select(-any_of(cols_to_drop))
  
  return(df)
}