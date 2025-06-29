##########

# This is the function to read in all 18 years of the data as ASCII files for simplicity
# Uses zip file and SAS file from CDC website to read in NHIS survey data and save to directory
# Zip file is downloaded and saved to a temp file, then the .dat file is extracted and read 
# The SAS file is downloaded to a temp file and encoded to utf-8 (early 2000's and prior they were encoded in
# latin1, causing issues in the modern era), then both are used to save to disk as RDS and output a dataframe

##########

library(SAScii)

pre2019 <- function (data_year) {
  url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/%s/samadult.zip"
  sas_url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Program_Code/NHIS/%s/SAMADULT.sas"
  
  year <- data_year
  
  # Download the zip file
  temp_zip <- tempfile(fileext = ".zip")
  download.file(sprintf(url, year), temp_zip, mode = "wb")
  
  # Extract the .dat file from the zip to a temp directory
  unzip_dir <- tempdir()
  dat_file <- unzip(temp_zip, list = TRUE)$Name[1]
  unzip(temp_zip, files = dat_file, exdir = unzip_dir)
  dat_path <- file.path(unzip_dir, dat_file)
  
  # Download the SAS input file to a temp location
  sas_temp <- tempfile(fileext = ".sas")
  download.file(sprintf(sas_url, year), sas_temp, mode = "wb")
  
  # Convert SAS script to UTF-8 and save to a new temp file
  sas_utf8 <- tempfile(fileext = ".sas")
  sas_lines <- readLines(sas_temp, encoding = "latin1")
  sas_lines <- iconv(sas_lines, from = "latin1", to = "UTF-8")
  writeLines(sas_lines, sas_utf8)
  
  # Read with SAScii using the UTF-8 SAS script
  df <- read.SAScii(dat_path, sas_utf8)
  
  # Save the result
  saveRDS(df, sprintf("data/raw_data/NHIS_data/NHIS_%s.rds", year))
  
  return(df)
}

