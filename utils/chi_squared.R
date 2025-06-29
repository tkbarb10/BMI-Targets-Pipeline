# Chi squared analysis of categorical data.  This compares one variable to every other and returns a dataframe of the results
# Example data frame: df, target variable: "target"

chi_results <- lapply(names(df)[names(df) != "UCOD_LEADING"], function(var) {
  tbl <- table(df[[var]], df$UCOD_LEADING)
  chisq <- chisq.test(tbl)
  data.frame(
    variable = var,
    p.value = chisq$p.value,
    statistic = chisq$statistic
  )
})

chi_results_df <- do.call(rbind, chi_results)

View(chi_results_df)
