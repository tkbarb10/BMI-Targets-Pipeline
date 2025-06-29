# Use the current distribution within a related variable to impute the missing values of a predictor


hotdeck_pairs <- list(
  "AFLHCA7" = "HYPEV",
  "AFLHCA10" = "DiabetesEver",
  "Insulin" = "DiabetesEver"
)

hotdeck_imputation <- function(df, hotdeck_pairs) {
  vars = names(hotdeck_pairs)
  
  for (name in vars) {
    domain = hotdeck_pairs[[name]]
    
    df <- VIM::hotdeck(
      data = df,
      variable = name,
      domain_var = domain,
      imp_var = F
    )
  }
  
  return(df)
}

