
library(shiny)
library(readxl)
library(dplyr)
my_data1 <- read_excel("training_sheet (2).xlsx", sheet = "Agilent")
my_data2 <- read_excel("training_sheet (2).xlsx", sheet = "Bristol Myers Squibb")
my_data3 <- read_excel("training_sheet (2).xlsx", sheet = "Booking Holdings Inc")
my_data4 <- read_excel("training_sheet (2).xlsx", sheet = "Wisconsin Public Service")
my_data <- rbind(my_data1,my_data2,my_data3,my_data4)

my1_data <- read.csv("tickers_ciks_names_IRRC.csv")

shinyServer(function(input, output) {
   
  output$display <- renderPrint({
    
    if(input$text1 == input$text1 & input$text2 == "" & input$text3 == ""){
      
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    } else if(input$text1 == "" & input$text2 == input$text2 & input$text3 == ""){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == "" & input$text2 == "" & input$text3 == input$text3){
      
      aa = my_data %>% filter(grepl(input$text3 , Ticker ))
      
    } else if(input$text1 == "" & input$text2 == input$text2 & input$text3 == input$text3){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == input$text1 & input$text2 == "" & input$text3 == input$text3){
      
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    } else if(input$text1 == input$text1 & input$text2 == input$text2 & input$text3 == ""){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == input$text1 & input$text2 == input$text2 & input$text3 == input$text3){
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    }
    
    gg= aa$CIK_SEC[1]
    ff= aa$Name_SEC[1]
    ww = aa$Ticker[1]
    
    hh= my1_data %>%  filter(grepl(input$text3, TICKER))
    
    print(paste('You entered the CIK :',gg))
    print(paste('This correpsonds to the issuer:',ff))
    print(paste('Correpsonds to the ticker symbol:',ww))
    
    
    
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    
    
    if(input$text1 == input$text1 & input$text2 == "" & input$text3 == ""){
      
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    } else if(input$text1 == "" & input$text2 == input$text2 & input$text3 == ""){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == "" & input$text2 == "" & input$text3 == input$text3){
      
      aa = my_data %>% filter(grepl(input$text3 , Ticker ))
      
    } else if(input$text1 == "" & input$text2 == input$text2 & input$text3 == input$text3){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == input$text1 & input$text2 == "" & input$text3 == input$text3){
      
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    } else if(input$text1 == input$text1 & input$text2 == input$text2 & input$text3 == ""){
      
      aa = my_data %>% filter(grepl(input$text2 , Name_SEC ))
      
    } else if(input$text1 == input$text1 & input$text2 == input$text2 & input$text3 == input$text3){
      aa = my_data %>% filter(CIK_SEC == input$text1)
      
    }
    
        
    
    bb = aa %>% select('Filing Details URL', 'Full charter text? Y/N')
    pattern1 <- "2[0-9][0-9][0-9]" 
    pattern2 <- "1[0-9][0-9][0-9]" 
    
    dates = c()
    for (i in 1:length(aa$Date)) {
      
      if (is.na(aa$Date[i]) == T ) {
        break
      }
      
      tx = regmatches(aa$Date[i], regexpr(pattern1, aa$Date[i])) 
      ty = regmatches(aa$Date[i], regexpr(pattern2, aa$Date[i])) 
      tz = max(c(tx,ty))
      dates[i] = tz
    }
    
    if (length(dates) == 0) {
      reject = 'Sorry there are no entries please try again'
      oput = data.frame('Error' = reject)
    } else {
      oput = cbind(dates,bb[1:length(dates),])
      
    }
    
   oput 
    
  }
  ,options = list(searching = F)
  ))
  
  
  
})

