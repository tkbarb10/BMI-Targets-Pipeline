## Tune a penalized logistic regression via glmnet
## df: data frame, n: sample size, ctrl: trainControl object

library(caret)
set.seed(100)

glm_tuning <- function(df, n, ctrl) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  glm_grid <- expand.grid(
    alpha = seq(0, 1, by = .1),
    lambda = seq(.001, 1, length.out = 30)
  )
  
  glm_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'glmnet',
    metric = 'ROC',
    tuneGrid = glm_grid,
    trControl = ctrl
  )
  
  return(glm_tuned)
}