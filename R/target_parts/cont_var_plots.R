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