df_small <- df[sample(nrow(df), 5000), ] 

control_method <- trainControl(
  method = 'cv',
  number = 5,
  classProbs = T,
  savePredictions = 'final',
  summaryFunction = twoClassSummary,
  sampling = 'up'
)

fit_model <- train(
  UCOD_LEADING ~.,
  data = df_small,
  method = "xgbTree",
  trControl = control_method,
  metric = "ROC",
  tuneLength = 5
)

plot(fit_model)

fit_model$finalModel

confusionMatrix(fit_model$pred$pred, fit_model$pred$obs)