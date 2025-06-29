# Utility function to create a roc object from a model

library(pROC)

create_roc <- function(model) {
  
  roc <- roc(
    model$pred$obs,
    model$pred$HrDib,
    levels = rev(levels(model$pred$obs))
  )
  
  return(roc)
}


