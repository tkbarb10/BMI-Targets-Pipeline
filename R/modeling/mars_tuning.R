## Tune a MARS (earth) model with the caret package
## df: data frame, n: number of rows to sample, ctrl: trainControl object

library(caret)
set.seed(130)

mars_tuning <- function(df, n, ctrl) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  mars_grid <- expand.grid(
    nprune = 1:12,
    degree = c(1:2)
  )
  
  mars_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'earth',
    metric = 'ROC',
    tuneGrid = mars_grid,
    trControl = ctrl
  )
  
  return(mars_tuned)
}