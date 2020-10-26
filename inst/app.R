rm(list = ls())
source('global.R')

ui <- semanticPage(
  title = "Recruitment Task",
  
  flow_layout(
    cell_width = 300,
    div(class = "ui raised segment",
        div( p(class="ui green ribbon label", "@Appsilon 2020"),
             tags$img(src='avatar-appsilon.png', align = "right", height='60',width='60'),
             p(""),
             p("Recruitment task")
        )
    )
  ),
  
  br(),
  
  sidebar_layout(
    sidebar_panel(
      width = 1,
      shipSelectorUI("id"),
      br(),
      p("For the selected vessel, the map shows two consecutive observations in which it sailed the longest distance."),
      p("In case of ties the latests observations are shown."),
      p("The first observation corresponds to the green marker while the red one corresponds to the second one.")
    ),
    main_panel(
      withSpinner( leafletOutput("my_map") )
    )
  ),
  br(),
  fluidRow( withSpinner( verbatimTextOutput("note") ) ),
  br(),
  fluidRow( 
    tabset(tabs =
             list(
               list(menu = "Map Markers", 
                    content = withSpinner( DTOutput("marker_points") ), 
                    id = "first_tab"),
               list(menu = "All Registers", 
                    content = DTOutput("all_points"), 
                    id = "second_tab")
             ),
           active = "first_tab",
           id = "exampletabset"
    )
  )
)


server <- function(input, output, session) {
  
  shipId <- callModule(shipSelectorServer, "id")
  
  myData <- reactive({
    readRDS(paste0(here::here("data/ships_data/"), shipId(), ".RDS"));
  })

  myDist <- reactive(calculateDistance(myData()));

  ## main panel output  

  output$my_map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng=myData()[myDist()$start, "LON"], lat=myData()[myDist()$start, "LAT"], popup="Start") %>%
      addMarkers(lng=myData()[myDist()$end, "LON"], lat=myData()[myDist()$end, "LAT"], popup="End") %>%
      addMiniMap();
  })

  output$note <- renderText(
  print(paste0("Ship ", unique(myData()$SHIPNAME), " heading ", unique(myData()[myDist()$end, ]$DESTINATION),
               ". The maximun distance between two consecutive observations (measured within three minutes) corresponds to ", 
               round(as.numeric(myDist()$distance)), " meters."))
  )
  
  ## tabset outputs
  
  output$marker_points <- renderDT({
      myData()[c(myDist()$start, myDist()$end), ] %>% 
        select("SHIPNAME", "ship_type", "DATETIME", "LAT", "LON", "SPEED", "DESTINATION") %>%
      rename("Vessel"="SHIPNAME", "Vessel Type"="ship_type", "Datetime" = "DATETIME", 
             "Speed"="SPEED", "Destination"="DESTINATION")
  })

  output$all_points <- renderDT({
    myData() %>% arrange(DATETIME) %>%
      select("SHIPNAME", "ship_type", "DATETIME", "LAT", "LON", "SPEED", "DESTINATION") %>%
      rename("Vessel"="SHIPNAME", "Vessel Type"="ship_type", "Datetime" = "DATETIME", 
             "Speed"="SPEED", "Destination"="DESTINATION")
  })
  
    
}
shinyApp(ui, server)
