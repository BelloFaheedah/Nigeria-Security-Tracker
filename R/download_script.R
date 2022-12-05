library(tidyverse)
library(janitor)
library(googlesheets4)

# No need for authentication
gs4_deauth()

data <- read_sheet("https://docs.google.com/spreadsheets/d/1_QY-l4xhMu5nZVluprOgRs6rUzgkkBemapdsg5lFzKU/pub?output=xlsx")%>% 
  dplyr::select(-c(49)) %>% clean_names()

# November 28, 2022
no_of_rows <- data %>% nrow()

display_result <- paste("The total number of rows", Sys.Date(), "is:", no_of_rows)


write_csv(data,paste0('data/',Sys.Date(),'_nst_jc_data','.csv'))    


