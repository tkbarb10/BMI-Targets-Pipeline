## Tune a XGB boost tree model using caret.  Specific method is xgbTree
## df: data frame, n_tree: rows to sample for tuning, ctrl: trainControl object
library(xgboost)

xgb_tuning <- function(df, n_tree, ctrl) {


  df_small <- df[sample(nrow(df), n_tree), ]
  
  
  xgb_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'xgbTree',
    metric = 'ROC',
    tuneLength = 5,
    trControl = ctrl
  )
  
  return(xgb_tuned)
}