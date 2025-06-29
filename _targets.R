### Pipeline to ingest, preprocess and train models ###

library(targets)
library(tidyverse)
library(crew)
walk(
  list.files("R", pattern = "\\.R$", full.names = TRUE, recursive = TRUE), source
  )
source("utils/Upsampling.R")

controller <- crew_controller_local(workers = 6)

tar_option_set(
  packages = c('tidyverse', 'arrow', 'SAScii', 'VIM', 'caret', 'pROC', "earth", "lightgbm", 'xgboost'), 
  controller = controller,
  garbage_collection = 2)


# Full pipeline -----------------------------------------------------------

list(
  ingest_nhis_data,
  process_mortality_data,
  link_mort_data,
  secondary_pre_process,
  cont_var_plots,
  missing_value_imputation,
  modeling_preparation,
  solo_bmi,
  initial_evaluation,
  hyperparameter_tuning,
  lightgbm_tuning
)
