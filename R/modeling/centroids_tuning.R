## Tune a centroid-based classifier (PAM)
## df: data frame, n: rows to sample, ctrl: trainControl object

library(caret)
set.seed(125)

centroids_tuning <- function(df, n, ctrl) {
  
  df_small <- df[sample(nrow(df), n), ]
  
  centroid_tuned <- train(
    UCOD_LEADING ~ .,
    data = df_small,
    method = 'pam',
    metric = 'ROC',
    tuneLength = 10,
    trControl = ctrl
  )
  
  return(centroid_tuned)
}