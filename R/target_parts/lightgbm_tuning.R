
# Light GBM Fine-Tune -----------------------------------------------------

lightgbm_tuning <- list(
  tar_target(
    lgb_data,
    prepare_dataset(tuning_df)
  ),
  tar_target(
    lgb_param_grid,
    expand.grid(
      num_leaves = c(20, 30, 40, 50),
      learning_rate = c(.04, .06, .08, .1),
      max_depth = c(-1, 5, 7, 9, 15, 25))
  ),
  tar_target(
    lgb_model,
    lgb_training(
      lgb_data$dtrain, 
      lgb_data$dtest, 
      lgb_param_grid, 
      num_iter = 500)
  )
)
