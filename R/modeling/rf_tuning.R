## Tune a Random Forest model using caret.  The ranger method was used because rf is slow
## df: data frame, n_tree: rows to sample for tuning, ctrl: trainControl object

rf_tuning <- function(df, n_tree, ctrl) {


  df_small <- df[sample(nrow(df), n_tree), ]
  
  
  rf_grid <- expand.grid(
    mtry = c(1, 2, 3, 5),
    splitrule = c("gini", 'extratrees'),
    min.node.size = c(1, 2, 3, 5)
  )
  
  rf_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'ranger',
    metric = 'ROC',
    tuneGrid = rf_grid,
    trControl = ctrl
  )
  
  return(rf_tuned)
}