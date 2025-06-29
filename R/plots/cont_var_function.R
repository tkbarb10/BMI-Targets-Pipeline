# Filter out continuous variables from combined_nhis for plotting

cont_vars <- c(
  "SLEEP",
  "BMI", # drop 9999 then filter for above 1000 and divide by 100
  "AHEIGHT", # drop 96-99
  "AWEIGHTP", # drop 996-999
  "MODFREQW",
  "VIGFREQW",
  "STRFREQW",
  "DIBAGE", # but drop 97, 98 and 99, those are codes
  "DIBAGE1"
)

filter_codes <- c(96, 97, 98, 99, 996, 997, 998, 999, 9999)

filter_continuous_variables <- function(df, cont_vars, filter_codes) {
  selected_vars <- df %>% 
    select(all_of(cont_vars)) %>% 
    filter(!if_any(everything(), ~ .x %in% filter_codes))
  
  return(selected_vars)
}
