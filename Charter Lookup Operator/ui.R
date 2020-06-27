#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Welcome to public company lookup interface"),
  
  fluidRow(
    column(3, wellPanel(
      textInput("text1", "Please input CIK Code Number", '14272'),
      textInput("text2", "OR Please enter Name of Company", 'BRISTOL MYERS SQUIBB CO'),
      textInput("text3", "OR Please input Company Ticker Symbol", 'BMY'),
      submitButton("Submit")
    )),
    
    column(8,  
           h4("'Charter Version that was effective of January 1st of that given year'"),
           verbatimTextOutput("display")
    ),
    
    DT::dataTableOutput("table")
    
    
    
  )
))
