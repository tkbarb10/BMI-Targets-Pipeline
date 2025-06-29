# Modeling Prep -----------------------------------------------------------

modeling_preparation <- list(
  tar_target(
    modeling_df_step1,
    final_clean(new_linked_nhisV4),
    format = 'parquet'
  ),
  tar_target(
    modeling_df,
    factor_columns(modeling_df_step1),
    format = 'parquet'
  ),
  tar_target(
    cols_to_drop,
    c("Industry", "Occupation", "AlcoholStatus", "VIGFREQW", 
      "STRFREQW", "Sleep", "AHSTATYR", "PaidSickLeave")
  ),
  tar_target(
    tuning_df,
    feature_selection(modeling_df, cols_to_drop),
    format = 'parquet'
  )
)