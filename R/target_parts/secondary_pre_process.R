# Secondary Pre-processing -------------------------------------------------

secondary_pre_process <- list(
  tar_target(
    new_linked_nhis,
    combine_columns(linked_nhis, col_pairs, cols_drop),
    format = 'parquet'
  ),
  tar_target(
    new_linked_nhisV1,
    update_exercise_variables(new_linked_nhis),
    format = 'parquet'
  )
)
