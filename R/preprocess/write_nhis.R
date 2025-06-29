# combines the filtered NHIS dataframes and writes to disk


write_nhis <- function(df) {
  
  combined <- dplyr::bind_rows(df)
  write_parquet(combined, "data/combined_NHIS.parquet")
  
  return(combined)
}