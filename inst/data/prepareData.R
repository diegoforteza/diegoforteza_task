#' @title prepareData
#' @description In order to speed up the shiny app data was splited into an RDS file per ship and 
#' two data.frames used in shipDropdown module for intializing the app
library(dplyr)
# ships <- read.csv(here::here("inst/data/ships_data/ships.csv"));
save(ships, file=here::here("inst/data/ships_data/ships.rda"));

for(ship_id in unique(ships$SHIP_ID)){
  
  ships %>% filter(SHIP_ID == ship_id) %>% 
    saveRDS(., file=paste0(here::here("inst/data/ships_data/"), ship_id, ".RDS"))
  
}

ships_types_names_list <- ships %>% 
  select(SHIPTYPE, ship_type, SHIPNAME, SHIP_ID) %>% 
  filter(!duplicated(.)) %>% saveRDS(., file=here::here("inst/data/ships_types_names_list.RDS"));

ships_types_list <- ships %>% 
  select(SHIPTYPE, ship_type) %>% 
  filter(!duplicated(.)) %>% saveRDS(., file=here::here("inst/data/ships_types_list.RDS"));
