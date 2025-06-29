# Plot kernel density curves for each numeric column
# df: data frame of continuous variables

density_plots <- function(df) {
  
  df %>%
    pivot_longer(everything(), names_to = "Variable", values_to = "Value") %>%
    ggplot(aes(x = Value)) +
    geom_density(fill = "blue", alpha = 0.6) +
    facet_wrap(~ Variable, scales = "free") +
    labs(title = "Density Plots") +
    theme_minimal()
  
}

