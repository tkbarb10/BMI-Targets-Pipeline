# 2019 - 2024 -------------------------------------------------------------

post2018 <- function (data_year, twoDyear) {
  url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/%s/adult%scsv.zip"
  
  year <- data_year
  
  two_d_year <- twoDyear
  
  temp_zip <- tempfile(fileext = ".zip")
  
  download.file(sprintf(url, year, two_d_year), temp_zip, mode = "wb")
  
  
  csv_files <- unzip(temp_zip, list = T)$Name
  
  
  df <- read.csv(unz(temp_zip, csv_files[1]))
  
  saveRDS(df, sprintf("data/raw_data/NHIS_%s.rds", year))
}

years <- c(2019:2024)
twoDyear <- c(19:24)

mapply(post2018, years, twoDyear)

# 2016 - 2018 -------------------------------------------------------------

url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/%s/samadultcsv.zip"

year <- "2018"

temp_zip <- tempfile(fileext = ".zip")

download.file(sprintf(url, year), temp_zip, mode = "wb")


csv_files <- unzip(temp_zip, list = T)$Name


df <- read.csv(unz(temp_zip, csv_files[1]))

saveRDS(df, sprintf("data/NHIS_%s.rds", year))

# 2015 --------------------------------------------------------------------

url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/2015/samadult.zip"

temp_zip <- tempfile(fileext = ".zip")

download.file(url, temp_zip, mode = "wb")


csv_files <- unzip(temp_zip, list = T)$Name

df <- read.csv(unz(temp_zip, csv_files[1]))

saveRDS(df, sprintf("data/NHIS_%s.rds", year))

# 2005 - 2014 -------------------------------------------------------------

library(SAScii)

# CDC used fixed-width files prior to 2015, so this way of loading files is really slow

pre2014 <- function (data_year) {
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
  saveRDS(df, sprintf("data/raw_data/NHIS_%s.rds", year))
}






