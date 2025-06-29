## Tune a PLS model using caret
## df: data frame, n: rows to sample, ctrl: trainControl object

library(caret)
set.seed(125)

pls_tuning <- function(df, n, ctrl) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  pls_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'pls',
    metric = 'ROC',
    tuneLength = 10,
    trControl = ctrl
  )
  
  return(pls_tuned)
}