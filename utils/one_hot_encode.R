# Used for one-hot encoding and removing zero-var columns from the result.  Used for the learning_curve function from caret
# Can also be used for more specific feature selection

one_hot_encode <- function(df) {
  
  dummy_vars <- dummyVars(~ . - UCOD_LEADING, data = df, sep = NULL, fullRank = TRUE)
  
  one_hot <- predict(dummy_vars, df)
  one_hot_df <- as.data.frame(one_hot)
  
  final_df <- cbind(one_hot_df, UCOD_LEADING = df$UCOD_LEADING)

  final_df <- final_df[, setdiff(names(final_df), nearZeroVar(final_df, names = TRUE))]
  
  return(final_df)
}
