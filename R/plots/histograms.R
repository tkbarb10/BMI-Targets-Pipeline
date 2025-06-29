# Plot histograms for each numeric column
# df: data frame of continuous variables

histograms <- function(df) {
  
  df %>%
    pivot_longer(everything(), names_to = "Variable", values_to = "Value") %>%
    ggplot(aes(x = Value)) +
    geom_histogram(bins = 15, fill = "blue", alpha = 0.7) +
    facet_wrap(~ Variable, scales = "free") +  # Create separate plots for each column
    labs(title = "Histograms")
}
