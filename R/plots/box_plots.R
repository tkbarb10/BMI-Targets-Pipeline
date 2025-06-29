# Create boxplots for all numeric columns in a data frame
# df: data frame of continuous variables

box_plots <- function(df) {
  
  df %>%
    pivot_longer(everything(), names_to = "Variable", values_to = "Value") %>%
    ggplot(aes(x = Value)) +
    geom_boxplot(fill = "blue", alpha = 0.6) +
    facet_wrap(~ Variable, scales = "free") +
    coord_flip() +
    labs(title = "Boxplots") +
    theme_minimal()
  
}
