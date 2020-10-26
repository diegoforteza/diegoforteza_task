#' @title shipSelectorUI
#' @description shipSelectorUI
#' @export
shipSelectorUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    selectInput(inputId = ns("vessel_type"), 
                choices = ships_types,
                label = "Please select a vessle type"),
    br(),
    uiOutput(ns("shipDropdown_ui"))
  )
  
}

#' @title shipSelectorServer
#' @description shipSelectorServer
#' @export
shipSelectorServer <- function(input, output, session) {

  output$shipDropdown_ui <- renderUI({
    ns <- session$ns;
    
    aux_ships_names <- ships_types_names_list %>% filter(SHIPTYPE == input$vessel_type);
    ships_names <- setNames(aux_ships_names$SHIP_ID, aux_ships_names$SHIPNAME);
    
    selectInput(inputId=ns("ship_id"), 
                label="Please select a vessle:", 
                choices=ships_names);
    
  })
  
  ship_id=reactive({ input$ship_id });
  
  return( ship_id )
}
