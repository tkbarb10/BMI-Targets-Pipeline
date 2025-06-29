### Filters mortality data for confirmed deaths ###


filter_mortality_data <- function(df) {
  df <- df %>% 
    filter(MORTSTAT == 1)
  
  return(df)
}
