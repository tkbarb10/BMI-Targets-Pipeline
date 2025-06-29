# Script to train models using numeric BMI as the only predictor

library(caret)
library(e1071)

set.seed(100)

ctrl <- trainControl(
  method = 'cv',
  number = 5,
  sampling = 'up',
  classProbs = T,
  savePredictions = 'final',
  summaryFunction = twoClassSummary
)


bmi_models <- function(data, target, control = ctrl) {
  
  trained_models = list()
  
  model_methods <- c("glm", "earth", "rpart", "nb")
  
  formula <- as.formula(paste(target, "~ ."))
  
  for (model in model_methods) {
    
    fit <- train(
      formula,
      data = data,
      method = model,
      preProcess = c('center', "scale"),
      trControl = ctrl,
      metric = 'ROC'
    )
    
    trained_models[[model]] <- fit
  }
  
  return(trained_models)
  
}
