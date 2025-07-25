### Pipeline to ingest, preprocess and train models ###

library(targets)
library(tidyverse)
library(crew)
walk(
  list.files("R", pattern = "\\.R$", full.names = TRUE, recursive = TRUE), source
)

controller <- crew_controller_local(workers = 6)

tar_option_set(
  packages = c('tidyverse', 'arrow', 'caret', 'pROC', "earth", "lightgbm", 'xgboost', 'nhanesA'), 
  controller = controller,
  garbage_collection = 2)


# Full pipeline -----------------------------------------------------------

list(
  ingest.nhanes.data
)