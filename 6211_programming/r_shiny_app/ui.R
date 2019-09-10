library(shiny)
library(leaflet)
library(shinythemes)
library(markdown)


# Define UI for application that analyzes the patterns of crimes in DC
shinyUI(navbarPage("Food Locater @ TIME SQUARE",
                   
                   # Change the theme to flatly
                   theme = shinytheme("darkly"),
                   
                   
                   # Three sidebars for uploading files, selecting time slots and districts
                   tabPanel("Map",
                            sidebarLayout(
                              sidebarPanel(
                                
                                # Create a file input
                                fileInput("file","Choose A CSV File Please",
                                          multiple = TRUE,
                                          accept = c("text/csv",
                                                     "text/comma-separated-values,text/plain",
                                                     ".csv")),
                                
                                # Create a multiple checkbox input for time slot
                                hr(),
                                helpText("Please Select The Subindustry You Want To Find in the Time Square"),
                                helpText("You Can Choose More Than One"),
                                
                                hr(), 
                                checkboxGroupInput("sub",
                                                   "Type of Dining:",
                                                   c("Bar / Lounge","Café / Deli","Catering","Coffee","Comsumables","Full Serve","Quick Serve")
                                ),
                                
                                
                                hr(),
                                helpText("Please Select The Districts You Want To Search For Food and Beverage"),
                                helpText("You Can Choose More Than One"),
                                hr(),
                                
                                # Create a multiple checkbox input for police districts
                                checkboxGroupInput("zip",
                                                   "Districts:",
                                                   choices = list("District 1"= 10018,"District 2"= 10019,"District 3"= 10020,
                                                                  "District 4"= 10023,"District 5"= 10036)
                                )
                                
                              ),
                              mainPanel(
                                leafletOutput("map", height=800)
                              ),
                              position = "left",
                              fluid = TRUE)
                            
                            
                   ),
                   
                   
                   # Create two tabs
                   tabPanel("More Info",
                            mainPanel(
                              hr(),
                              tabsetPanel(type="tabs",
                                          
                                          #Add a tab for problem description
                                          tabPanel("App Description", textOutput("text")),
                                          
                                          #Add a tab for decriptive table
                                          tabPanel("More Infomation",
                                                   
                                                   #Add two subtabs
                                                   tabsetPanel(
                                                     tabPanel("Neighborhood",verbatimTextOutput("table1")),
                                                     tabPanel("Dining Category",verbatimTextOutput("table2"))
                                                   )
                                          )
                                          
                                          
                              )
                            )
                   )
))

