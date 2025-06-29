# Full pipeline, can be adjusted and rerun at will

# Ingest and filter NHIS data then combine and save to disk--------------------------------------------------------

ingest_nhis_data <- list(
  tar_target(
    survey_years,
    c(2000:2018)
  ),
  tar_target(
    nhis_dataframes,
    readRDS(sprintf("data/raw_data/NHIS_data/NHIS_%s.rds", survey_years)),
    pattern = map(survey_years)
  ),
  tar_target(
    variables_to_use,
    source("R/ingest_data/variables_to_use.R")$value
  ),
  tar_target(
    filtered_nhis_dataframes,
    filter_nhis(nhis_dataframes, variables_to_use),
    pattern = map(nhis_dataframes)
  ),
  tar_target(
    combined_nhis,
    write_nhis(filtered_nhis_dataframes)
  )
)

# Ingest mortality data, combine, filter by confirmed deceased ----------------------


process_mortality_data <- list(
  tar_target(
    mortality_years,
    2000:2018
  ),
  tar_target(
    mortality_dataframes,
    mortality_df(mortality_years),
    pattern = map(mortality_years),
    format = 'parquet'
  ),
  tar_target(
    combined_mort,
    bind_rows(mortality_dataframes),
    format = 'parquet'
  ),
  tar_target(
    filtered_mort,
    filter_mortality_data(combined_mort),
    format = 'parquet'
  )
)


# Link mortality and nhis -------------------------------------------------


link_mort_data <- list(
  tar_target(
    linked_nhis,
    inner_join(combined_nhis, filtered_mort, by = join_by(UUID == PUBLICID)),
    format = 'parquet'
  )
)


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


# EDA continuous variable plots -------------------------------------------

cont_var_plots <- list(
  tar_target(
    filtered_nhis_cont_vars,
    filter_continuous_variables(combined_nhis, cont_vars, filter_codes)
  ),
  tar_target(
    combined_histograms,
    histograms(filtered_nhis_cont_vars)
  ),
  tar_target(
    combined_density_plots,
    density_plots(filtered_nhis_cont_vars)
  ),
  tar_target(
    combined_box_plots,
    box_plots(filtered_nhis_cont_vars)
  )
)


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

# Hyperparameter Tuning ---------------------------------------------------

hyperparameter_tuning <- list(
  tar_target(
    n,
    32000
  ),
  tar_target(
    n_tree,
    10000
  ),
  tar_target(
    ctrl,
    trainControl(
      method = 'cv',
      number = 5,
      classProbs = T,
      savePredictions = 'final',
      summaryFunction = twoClassSummary,
      sampling = 'up'
    )
  ),
  tar_target(
    glm_tuned,
    glm_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    rpart_tuned,
    rpart_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    pls_tuned,
    pls_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    centroids_tuned,
    centroids_tuning(tuning_df, n, ctrl)
  ),
  tar_target(
    random_forest_tuned,
    rf_tuning(tuning_df, n_tree, ctrl)
  ),
  tar_target(
    xgb_tuned,
    xgb_tuning(tuning_df, n_tree, ctrl)
  ),
  tar_target(
    ada_tuned,
    ada_tuning(tuned_df, n_tree, ctrl)
  )
)








