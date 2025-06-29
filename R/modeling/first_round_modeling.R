# Function for training select models for initial evaluation of the data.  Returns a list of model objects.  Can utilize any models and control
# method desired


library(caret)
set.seed(100)

first_round_modeling <- function(data, target) {
  
  trained_models = list()
  
  model_methods <- c("glm", "earth", "rpart", "pls",'lda', 'pam')
  
  control_method <- trainControl(
    method = 'cv',
    number = 5,
    classProbs = T,
    savePredictions = 'final',
    summaryFunction = twoClassSummary
  )
  
  formula <- as.formula(paste(target, "~ ."))
  
  for (model in model_methods) {
    
    fit <- train(
      formula,
      data = data,
      method = model,
      preProcess = "nzv",
      trControl = control_method,
      metric = 'ROC'
    )
    
    trained_models[[model]] <- fit
  }
  
  return(trained_models)
  
}

