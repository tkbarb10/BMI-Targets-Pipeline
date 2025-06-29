# second round of modeling with feature selection and up sampling

library(caret)
set.seed(100)

second_round_modeling <- function(data, target) {
  
  data <- data %>% select(-c("Industry", "Occupation", "AlcoholStatus", "VIGFREQW", "STRFREQW"))
  
  trained_models = list()
  
  model_methods <- c("glm", "earth", "rpart", "pls",'lda', 'pam')
  
  control_method <- trainControl(
    method = 'cv',
    number = 5,
    classProbs = T,
    savePredictions = 'final',
    summaryFunction = twoClassSummary,
    sampling = 'up'
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