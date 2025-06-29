## This function is used for simple imputation of missing values

missing_impute <- list(
  "HYPDIFV" = "HYPEV",
  "PaidSickLeave" = 9,
  "AFLHCA18" = 8,
  "Industry" = 99,
  "Occupation" = 99,
  "DIABETES" = 0,
  "HYPERTEN" = 0
)

impute_missing <- function(df, variable_list) {
  names = names(variable_list)
  
  for (name in names) {
    value <- variable_list[[name]]
    
    if (is.character(value) && value %in% colnames(df)) {
      df <- df %>% 
        mutate(!!name := if_else(is.na(.data[[name]]), .data[[value]], .data[[name]]))
    } else {
      df <- df %>% 
        mutate(!!name := if_else(is.na(.data[[name]]), value, .data[[name]]))
    }
    
  }
  
  return(df)
}




