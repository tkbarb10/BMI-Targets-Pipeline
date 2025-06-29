library(lightgbm)
library(Metrics)

set.seed(125)

# Example grid (expand as needed)
param_grid <- expand.grid(
  num_leaves = c(20, 30, 40, 50),
  learning_rate = c(.04, .06, .08, .1),
  max_depth = c(-1, 5, 7, 9, 15, 25)
)

best_score <- Inf
best_params <- list()

for (i in 1:nrow(param_grid)) {
  params <- as.list(param_grid[i, ])
  params$objective <- "binary"
  params$metric <- "auc"
  
  model <- lgb.train(
    params,
    data = dtrain,
    nrounds = 750,
    valids = list(test = dtest),
    early_stopping_rounds = 10,
    verbose = -1
  )
  
  score <- min(unlist(model$record_evals$test$auc$eval))
  if (score < best_score) {
    best_score <- score
    best_params <- params
  }
}

print(best_params)

model$best_score

preds <- model$predict(X_test)
pred_labels <- ifelse(preds > 0.5, 1, 0)

pred_labels <- as.factor(pred_labels)
levels(pred_labels) <- c("HrDib", 'Other')

y_pred <- as.factor(y_test)
levels(y_pred) <- c("HrDib", 'Other')

confusionMatrix(pred_labels, y_pred)





