# Handling Missing Values -------------------------------------------------

missing_value_imputation <- list(
  tar_target(
    new_linked_nhisV2,
    custom_imputation(new_linked_nhisV1),
    format = 'parquet'
  ),
  tar_target(
    new_linked_nhisV3,
    impute_missing(new_linked_nhisV2, missing_impute),
    format = 'parquet'
  ),
  tar_target(
    new_linked_nhisV4,
    hotdeck_imputation(new_linked_nhisV3, hotdeck_pairs),
    format = 'parquet'
  )
)