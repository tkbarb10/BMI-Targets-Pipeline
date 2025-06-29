# Uses data and SAS link from CDC website to load the data.  SAS is downloaded and converted to utf-8 encoding,
# then read and written to file in parquet.  Output is a data frame

library(SAScii)
library(arrow)

mortality_df <- function (year) {

  url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/NHIS_%s_MORT_2019_PUBLIC.dat"
  
  sas_url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/SAS_ReadInProgramAllSurveys.sas"
  
  year <- year
  
  # Download the SAS input file to a temp location
  sas_temp <- tempfile(fileext = ".sas")
  download.file(sas_url, sas_temp, mode = "wb")
  
  # Convert SAS script to UTF-8 and save to a new temp file
  sas_utf8 <- tempfile(fileext = ".sas")
  sas_lines <- readLines(sas_temp, encoding = "latin1")
  sas_lines <- iconv(sas_lines, from = "latin1", to = "UTF-8")
  writeLines(sas_lines, sas_utf8)
  
  # Read with SAScii using the UTF-8 SAS script
  df <- read.SAScii(sprintf(url, year), sas_utf8)
  
  save_path <- sprintf("data/raw_data/mort_data/MORT_%s.parquet", year)
  
  write_parquet(df, save_path)
  
  return(df)

}
