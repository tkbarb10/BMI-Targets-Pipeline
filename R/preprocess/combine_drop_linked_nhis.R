## Combines columns that are the same but have different names depending on year, and drop ID cols that
## were only needed for linking mortality data with nhis data


col_pairs <- list(
  "Industry" = c('INDSTRN2', "INDSTRY2"),
  "Sleep" = c('SLEEP', "ASISLEEP"),
  'DiabetesAge' = c('DIBAGE', 'DIBAGE1'),
  "Occupation" = c('OCCUPN2', "OCCUP2"),
  "DiabetesEver" = c('DIBEV', "DIBEV1"),
  "AlcoholStatus" = c("ALCSTAT", "ALCSTAT1"),
  "PaidSickLeave" = c("PDSICK", "PDSICKA"),
  'Insulin' = c("INSLN", "INSLN1")
)

id_cols_drop <-  c('HHX', 'FMX', 'PX', 'FPX', 'ELIGSTAT', 'DODQTR', 'DODYEAR', 'WGT_NEW', 'SA_WGT_NEW')

cols_drop <- c(unlist(col_pairs), id_cols_drop)

combine_columns <- function(df, col_pairs, cols_drop) {
  
  for (new_name in names(col_pairs)) {
    pair <- col_pairs[[new_name]]
    df[[new_name]] <- coalesce(df[[pair[1]]], df[[pair[2]]])
  }
  
  new_df <- df[, !names(df) %in% cols_drop]
  
  return(new_df)
}








