# Hyperparameter Tuning ---------------------------------------------------

hyperparameter_tuning <- list(
  tar_target(
    n,
    32000
  ),
  tar_target(
    n_tree,
    10000
  ),
  tar_target(
    ctrl,
    trainControl(
      method = 'cv',
      number = 5,
      classProbs = T,
      savePredictions = 'final',
      summaryFunction = twoClassSummary,
      sampling = 'up'
    )
  ),
  tar_target(
    glm_tuned,
    glm_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    rpart_tuned,
    rpart_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    pls_tuned,
    pls_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    centroids_tuned,
    centroids_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    random_forest_tuned,
    rf_tuning(tuning_df, n_tree, ctrl)
  ),
  tar_target(
    xgb_tuned,
    xgb_tuning(tuning_df, n_tree, ctrl)
  ),
  tar_target(
    ada_tuned,
    ada_tuning(tuning_df, n_tree, ctrl)
  )
)