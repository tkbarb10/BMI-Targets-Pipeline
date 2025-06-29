library(lightgbm)
library(caret)
source("utils/Upsampling.R")

set.seed(125)

n <- nrow(encoded_df)
sample_size <- floor(0.75 * n)
idx <- sample(seq_len(n), size = sample_size)

train <- encoded_df[idx, ]
test <- encoded_df[-idx, ]

upsampled <- upsampled(train)


X_train <- data.matrix(upsampled[, setdiff(names(upsampled), "UCOD_LEADING")])
y_train <- as.numeric(upsampled$UCOD_LEADING) - 1

X_test <- data.matrix(test[, setdiff(names(test), "UCOD_LEADING")])
y_test <- as.numeric(test$UCOD_LEADING) - 1

dtrain <- lgb.Dataset(X_train, label = y_train)
dtest <- lgb.Dataset(X_test, label = y_test)

params <- list(
  objective = "binary",
  metric = "auc",
  verbose = 1,
  eta = .06
)

fit_model <- lgb.train(
  params = params,
  data = dtrain,
  nrounds = 1000
)

pred_probs <- predict(fit_model, X_test)
pred_labels <- ifelse(pred_probs > 0.5, 1, 0)

pred_labels <- as.factor(pred_labels)
levels(pred_labels) <- c("HrDib", 'Other')

y_pred <- as.factor(y_test)
levels(y_pred) <- c("HrDib", 'Other')

confusionMatrix(pred_labels, y_pred)
