## Tune a ADA boost tree model using caret
## df: data frame, n_tree: rows to sample for tuning, ctrl: trainControl object
library(ada)
set.seed(125)

ada_tuning <- function(df, n_tree, ctrl) {


  df_small <- df[sample(nrow(df), n_tree), ]
  
  ada_grid <- expand.grid(
    iter = c(50, 100, 250),
    maxdepth = c(1, 2, 3, 5),
    nu = c(.08, .1, .3, .5, .8)
  )
  
  ada_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'ada',
    metric = 'ROC',
    tuneGrid = ada_grid,
    trControl = ctrl
  )
  
  return(ada_tuned)
}