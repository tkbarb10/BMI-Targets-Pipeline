library(lightgbm)
set.seed(125)

lgb_training <- function(df_train, df_test, param_grid, num_iter = 500){
  best_score <- Inf
  best_params <- list()
  
  for (i in 1:nrow(param_grid)) {
    params <- as.list(param_grid[i, ])
    params$objective <- "binary"
    params$metric <- "auc"
    
    model <- lgb.train(
      params,
      data = df_train,
      nrounds = num_iter,
      valids = list(test = df_test),
      early_stopping_rounds = 10,
      verbose = -1
    )
    
    score <- min(unlist(model$record_evals$test$auc$eval))
    if (score < best_score) {
      best_score <- score
      best_params <- params
    }
  }
  
  list(lgb_model = model, best_params = best_params)
}