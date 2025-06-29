# BMI Modeling ------------------------------------------------------------

solo_bmi <- list(
  tar_target(
    bmi_model_prep,
    bmi_model_subset(new_linked_nhisV4),
    format = 'parquet'
  ),
  tar_target(
    bmi_model_list,
    bmi_models(bmi_model_prep, target = "UCOD_LEADING")
  )
)