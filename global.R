## load packages
library(dplyr)
library(leaflet)
library(geosphere)
library(DT)

library(shiny)
library(shiny.semantic)
library(shinycssloaders)

## load custom functions
source(here::here("R/calculateDistance.R"))
source(here::here("R/shipDropdown.R"))

## load data
ships_types_list <- readRDS(here::here("inst/data/ships_types_list.RDS"));
ships_types_names_list <- readRDS(here::here("inst/data/ships_types_names_list.RDS"));

ships_types <- setNames(ships_types_list$SHIPTYPE, ships_types_list$ship_type)