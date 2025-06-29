# Initial Modeling --------------------------------------------------------

initial_evaluation <- list(
  tar_target(
    first_models,
    first_round_modeling(modeling_df, target = "UCOD_LEADING")
  ),
  tar_target(
    second_models,
    second_round_modeling(modeling_df, target = 'UCOD_LEADING')
  )
)