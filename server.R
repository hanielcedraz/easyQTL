#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(DT)
library(plotly)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    
    # ids <<- NULL
    # 
    # observeEvent(input$addInput,{
    #     print(ids)
    #     if (is.null(ids)){
    #         ids <<- 1
    #     }else{
    #         ids <<- c(ids, max(ids)+1)
    #     }
    #     output$inputs <- renderUI({
    #         tagList(
    #             lapply(1:length(ids),function(i){
    #                 textInput(paste0("txtInput",ids[i]), sprintf("Text Input #%d",ids[i]))
    #             })
    #         )
    #     })
    # })
    # 
    
    
    qtldbfile <- reactive({
        inFile1 <- input$file1
        if (is.null(inFile1)) {return(NULL)}
        dataset <- fread(inFile1$datapath, header = FALSE, sep = "\t", quote = "", col.names = c('chr', 'start.pos', 'end.pos', 'QTL', 'V5', 'V6', 'V7', 'V8', 'V9', 'V10', 'V11', 'V12')) %>%
            select(c(chr, start.pos, end.pos, QTL))
        return(dataset)
    })
    
    
    output$qtlTable <- renderDataTable({
        datatable(qtldbfile())
    })

    
    
    qtlList <- reactive({
        Chr <- casefold(input$chromosome, upper = TRUE)
        Chr <- paste0('Chr.', Chr)
        start <- as.numeric(input$start)
        end <- as.numeric(input$end)
        
        qtllist <- select(qtldbfile(), c(chr, start.pos, end.pos, QTL)) %>%
            filter(chr == Chr, start.pos >= start & start.pos <= end | end.pos >= start & end.pos <= end)
        listtable <- data.table(qtllist)
        return(listtable)
    })
    
    
    
    output$showQTLlist <- renderDataTable({
        datatable(qtlList(), colnames = c("Chr", "Start Position", "End Position", "QTL (ID)"))
    })
        
        
    output$qtlListFinal <- downloadHandler(
        filename = function() {
            paste("QTL List", "csv", sep = ".")
        },
        
        content = function(file) {
            fwrite(qtlList(), file, quote = FALSE, sep = "\t")
        }
    )
    
    
        
    output$tb <- renderUI({
        tabsetPanel(
            tabPanel(title = "Raw data",
                     dataTableOutput("qtlTable")
                     ),
            tabPanel(title = "QTL list",
                     dataTableOutput("showQTLlist"),
                     downloadButton("qtlListFinal", "Download the table")
                     )
            )
    })
})
