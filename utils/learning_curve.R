# Used to plot learning curves for different methods to get a sense of how much data is actually needed to effectively train a model
# Use dataframe that has been one-hot encoded if the data is sparse, otherwise you'll get errors for variables not being found in
# some folds of the data

learning_curve <- function(df, n, caret_method) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  control_method <- trainControl(
    method = 'cv',
    number = 5,
    classProbs = T,
    savePredictions = 'final',
    summaryFunction = twoClassSummary,
    sampling = 'up'
  )
  
  # Suppressing warning wrapper is because xgbTree method has deprecated parameters that don't affect anything but output a million warnings
  suppressWarnings({
    fit_model <- learning_curve_dat(
      dat = df_small,
      outcome = 'UCOD_LEADING',
      method = caret_method,
      metric = 'ROC',
      proportion = (1:8)/8,
      test_prop = 1/4,
      trControl = control_method
    )
  })
  
  ggplot(fit_model, aes(x = Training_Size, y = ROC, color = Data)) +
    geom_smooth(method = loess, span = .8) +
    theme_bw()
  
}
