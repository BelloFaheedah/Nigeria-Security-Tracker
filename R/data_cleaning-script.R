
library(tidyverse)
library(janitor)

nst_data <- read_csv(paste0('data/',Sys.Date(),'_nst_jc_data','.csv')) 

# https://www.codingprof.com/3-ways-to-replace-nas-with-zeros-in-r-examples/
# https://sparkbyexamples.com/r-programming/replace-na-with-empty-string-in-r-dataframe/

nst_data_cleaned <- nst_data |> 
  mutate_if(is.character, ~replace_na(.,"None")) |> 
  mutate_if(is.numeric, ~replace_na(., 0)) |> 
  mutate_if(is.logical, ~replace_na(., FALSE)) |> View()


# sectarian_actor_v
nst_data  <- nst_data |> 
  pivot_longer(
    cols = ends_with("_p"),
    names_to = "perpetrators",
    names_prefix = "wk",
    values_to = "rank",
    values_drop_na = TRUE
  )


# new_sp_m014
who_data <- who|> pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnosis", "gender", "age"),
  names_pattern = "new_?(.*)_(.)(.*)",
  values_to = "count"
)

who |> View()
# Missing values
perpetrators <- nst_data[, 7:15] %>%
  dplyr::mutate(across(.cols = everything(), ~ if_else(is.na(.x), 0, 1)))

victims <- nst_data[, 16:27] %>%
  dplyr::mutate(across(.cols = everything(), ~ if_else(is.na(.x), 0, .x)))

weapons <- nst_data[, 28:33] %>%
  dplyr::mutate(across(.cols = everything(), ~ if_else(is.na(.x), 0, 1)))

venues <- nst_data[, 34:40] %>%
  dplyr::mutate(across(.cols = everything(), ~ if_else(is.na(.x), 0, 1)))

sources <- nst_data[, 41:44] %>%
  dplyr::mutate(across(.cols = everything(), ~ if_else(is.na(.x), "Not Available", .x)))

# Bind the data frames to nst_data[,1:6]
nst_data <-
  bind_cols(nst_data[, 1:6], perpetrators, victims, weapons, venues, sources)

nst_data <- nst_data[which(!is.na(nst_data$Date)),]

nst_data <- nst_data %>%
  mutate(Year = lubridate::year(Date))

