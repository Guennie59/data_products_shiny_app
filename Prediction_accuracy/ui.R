#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(MASS)


data(mammals)

slider_text <- "body weight in kg"
slider_text_log <- "log of body weight in kg"
slider_text_factor <- "enlargement-factor in powers of 10"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predictions for brain volumes in g for mammals"),
  
  # Sidebar with a slider input for body weight 
  sidebarLayout(
    sidebarPanel(
      # checkboxInput("lin_log", "Use log slider?", value = FALSE),
      h5("This shiny app is meant to demonstrate the effect of a linear model fit to a wide range of data points."),
      br(),
      sliderInput("body",
                  slider_text,
                  min = min(mammals$body),
                  max = max(mammals$body),
                  value = median(mammals$body)),
      br(),
      h5("The following slider could be used to enlarge the plot in powers of 10. "),
      br(),
      sliderInput("factor_of_10",
                 slider_text_factor,
                 min = 0,
                 max = round(log10(max(mammals$body)),digits = 2),
                 value = 0),
     h5("The plot in the upper part depicts a linear fit to the mammals data set, whereas below a linear fit to the respective log-values is shown."),
     br(),  
     sliderInput("body_log",
                 slider_text_log,
                 min = round(min(log(mammals$body)),digits=2),
                 max = round(max(log(mammals$body)),digits=2),
                 value = round(median(log(mammals$body)),digits=2)),
     br(),  
     h5("The mammals dataset is part of the MASS library."),
     br(), 
     h5("Watch how the color marked (red=linear, green=lin-log-log) points are moving with slider value changes.")
     ),

    # Show a plot of the generated distribution
    mainPanel(
      
      plotOutput("body_brain"),
      
      plotOutput("body_brain_log"),
      
      textOutput("brain_pred_lin"),
     
      textOutput("brain_pred_log")
    )
  )
))
