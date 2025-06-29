# Prepare dataset for Light GBM modeling.  Ensure that the categorical predictors are factors
# Convert factors into dummy variables.  Split into train and test sets.  Oversample the training data
# Target needs to be coded as 1 and 0
# Turn into lgb data set

library(lightgbm)
library(caret)
set.seed(125)

prepare_dataset <- function(df, split_percent = 0.75){
  
  dummy_vars <- dummyVars(~ . - UCOD_LEADING, data = df, sep = NULL, fullRank = TRUE)
  
  one_hot <- predict(dummy_vars, df)
  one_hot_df <- as.data.frame(one_hot)
  
  df <- cbind(one_hot_df, UCOD_LEADING = df$UCOD_LEADING)
  
  df <- df[, setdiff(names(df), nearZeroVar(df, names = TRUE))]
  
  n <- nrow(df)
  sample_size <- floor(split_percent * n)
  idx <- sample(seq_len(n), size = sample_size)
  
  train <- df[idx, ]
  test <- df[-idx, ]
  
  train_oversampled <- upSample(
    x = train[, setdiff(names(train), "UCOD_LEADING")],
    y = train$UCOD_LEADING,
    yname = "UCOD_LEADING"
  )
  
  X_train <- data.matrix(train_oversampled[, setdiff(names(train_oversampled), "UCOD_LEADING")])
  y_train <- as.numeric(train_oversampled$UCOD_LEADING) - 1
  
  X_test <- data.matrix(test[, setdiff(names(test), "UCOD_LEADING")])
  y_test <- as.numeric(test$UCOD_LEADING) - 1
  
  dtrain <- lgb.Dataset(X_train, label = y_train)
  dtest <- lgb.Dataset(X_test, label = y_test)
  
  list(dtrain = dtrain, dtest = dtest, X_test = X_test, y_test = y_test)
}

