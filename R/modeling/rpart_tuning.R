## Tune a CART decision tree using caret
## df: data frame, n: rows to sample for tuning, ctrl: trainControl object

library(caret)
set.seed(100)

rpart_tuning <- function(df, n, ctrl) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  rpart_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'rpart',
    metric = 'ROC',
    tuneLength = 10,
    trControl = ctrl
  )
  
  return(rpart_tuned)
}