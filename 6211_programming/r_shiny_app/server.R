
options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(leaflet)
library(dplyr)

# Define server that analyzes the patterns of crimes in DC
shinyServer(function(input, output) {
  
  # Create an output variable for problem description
  output$text <- renderText({
    
    "TBC"
    
  })
  
  
  # Create a descriptive table for different offenses
  output$table1 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different time slots and different districts
    target1 <- c(input$sub)
    target2 <- c(input$zip)
    NTA_df <- filter(mydata, Subindustry %in% target1 & Postcode %in% target2)
    
    # Create a table for offense
    table(NTA_df$NTA)
    
  })
  
  # Create a descriptive table for different criminal methods
  output$table2 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different time slots and different districts
    target1 <- c(input$sub)
    target2 <- c(input$zip)
    cate_df <- filter(mydata, Subindustry %in% target1 & Postcode %in% target2)
    
    # Create a table for offense
    table(cate_df$Sub_Subindustry)
    
  })
  
  
  # Create a map output variable
  output$map <- renderLeaflet({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return(NULL)
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different time slots and different districts
    target1 <- c(input$sub)
    target2 <- c(input$zip)
    map_df <- filter(mydata, Subindustry %in% target1 & Postcode %in% target2)
    
    # Create colors with a categorical color function
    color <- colorFactor(rainbow(9), map_df$Subindustry)
    
    # Create the leaflet function for data
    leaflet(map_df) %>%
      
      # Set the default view
      setView(lng = -73.9847, lat = 40.75906, zoom = 14) %>%
      
      # Provide tiles
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      
      # Add circles
      addCircleMarkers(
        radius = 6,
        lng= map_df$Longitude,
        lat= map_df$Latitude,
        stroke= FALSE,
        fillOpacity=0.7,
        color=color(Subindustry)
      ) %>%
      
      # Add legends for different types of subindustry
      addLegend(
        "bottomright",
        pal=color,
        values=Subindustry,
        opacity=0.3,
        title="Type of Dining"
      )
  })
})
