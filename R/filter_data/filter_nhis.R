library(tidyverse)
library(arrow)

filter_nhis <- function (dataframe, variables){
  
  id_cols <- c("SRVY_YR", "HHX", "FPX", "FMX", "PX")
  
  filtered_data <- dataframe %>% 
    select(any_of(variables)) %>% 
    
    # handles discrepancies in data types between years
    
    mutate(across(any_of(id_cols), as.character)) %>%
    
    # Pads variables so they align with PUBLICID in the mortality data
    
    mutate(
      HHX = str_pad(HHX, width = 6, side = "left", pad = "0")
    ) %>%
    mutate(
      across(any_of(c("FPX", "FMX", "PX")), ~str_pad(.x, width = 2, side = "left", pad = "0"))
    ) %>%
    
    # creates a unique ID to link with mortality data
    
    mutate(
      UUID = ifelse(SRVY_YR > 2003, paste0(SRVY_YR, HHX, FMX, FPX), paste0(SRVY_YR, HHX, FMX, PX))
    ) 
  
  year <- filtered_data$SRVY_YR[1]
  
  return(filtered_data)
}
