#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

data(mammals)
mammals$body_log <- log(mammals$body)
mammals$brain_log <- log(mammals$brain)

# Define server logic required to draw a histogram

shinyServer(function(input, output) {

  bb_lin <- lm(brain ~ body, data=mammals)
  bb_log <- lm(brain_log ~ body_log, data=mammals)

 # if(!input$lin_log) {
  pred_lin <- reactive({
    predict(bb_lin, newdata = data.frame(body=input$body))
    })
  # } else {
  pred_log <- reactive({
    predict(bb_log, newdata = data.frame(body_log=input$body_log))
      })      
  #}  
  
  
#   inp_body <- reactive({input$body})
  
   
  output$body <- renderText(input$body)
  
    output$body_brain <- renderPlot({

    pred_point_lin <- data.frame(input$body, pred_lin())
    colnames(pred_point_lin) <- c("body","brain")
    pred_point_log <- data.frame(exp(input$body_log), exp(pred_log()))
    colnames(pred_point_log) <- c("body","brain")
    
    bb_plot <- ggplot(mammals, aes(body,brain))
    bb_plot <- bb_plot + geom_point() + geom_smooth(method="lm",color=2) + 
                coord_cartesian(xlim = c(0, round(max(mammals$body),digits=2)/10**input$factor_of_10)*1.1,
                                ylim = c(0, round(max(mammals$brain),digits=2)/10**input$factor_of_10)*1.1) +
                geom_point(data=pred_point_lin,aes(body,brain), color=2, size=4) +
                geom_point(data=pred_point_log,aes(body,brain), color=3, size=4)
    bb_plot  
  })

  output$body_brain_log <- renderPlot({

    pred_point_log <- data.frame(input$body_log, pred_log())
    colnames(pred_point_log) <- c("body","brain")
    pred_point_lin <- data.frame(log(input$body), log(pred_lin()))
    colnames(pred_point_lin) <- c("body","brain")
    
    bb_plot <- ggplot(mammals, aes(log(body),log(brain)))
    bb_plot <- bb_plot + geom_point() + geom_smooth(method="lm",color=3) +
                geom_point(data=pred_point_log,aes(body,brain), color=3, size=4) + 
                geom_point(data=pred_point_lin,aes(body,brain), color=2, size=4)
    bb_plot  
    
  })
  
  # if (!input$lin_log) {
  output$brain_pred_lin <- renderText({c("Linear fit: ",input$body,"kg of body mass yield", round(pred_lin(),digits=2),"g of brain mass")})
  # } else {
  output$brain_pred_log <- renderText({c("Lin-log-log fit: ",round(exp(input$body_log),digits=2),"kg of body mass yield", round(exp(pred_log()),digits=2),"g of brain mass")})  
  #}
  
  
})
