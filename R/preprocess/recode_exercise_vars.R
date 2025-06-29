# Exercise size vars are numeric variables, but they include categorical codes.  So recoding those codes  by setting 
# 95 and 96 (Never and unable to exercise respectively) to 0, and transforming the rest to NA and distributing those
# to the other values according to the known distribution

library(VIM)

update_exercise_variables <- function(df) {
  
  exercise_vars = c("STRFREQW", "VIGFREQW", "MODFREQW")
  
  for (name in exercise_vars) {
    
    df <- df %>% mutate(!!name := case_when(
      .data[[name]] %in% c(95, 96) ~ 0,
      .data[[name]] > 96 ~ NA,
      .default = .data[[name]]
    )) %>% 
      hotdeck(
        variable = name,
        imp_var = F
      )
  }
  
  return(df)
}
