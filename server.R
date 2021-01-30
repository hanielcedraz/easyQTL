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
library(knitr)

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
        #if (!is.null(input$file1$datapath)) {
            return(datatable(qtldbfile()))
        # } else {
        #     return(paste("Please, upload the file"))
        # }
    })

    
    qtldbsite <- a("Animal QTL db;", href = "https://www.animalgenome.org/cgi-bin/QTLdb/index", target = "_blank")
    
    output$instructions <- renderUI({
        if (is.null(input$file1$datapath)) {
            box(title = "Instructions for users", solidHeader = TRUE, collapsible = TRUE, width = 6, 
                #HTML(markdown::markdownToHTML(knit('Documents/easyQTL/instructions.Rmd', quiet = TRUE)))
                HTML(paste("1. Access", qtldbsite),
                     '<br>',
                    paste("2. click on the desired specie;",
                          "3. Click on 'All data by bp (choose the genome version)' - bed format;",
                          "4. Click on 'I have read and endorse the terms and conditions' button to download the file;",
                          "5. Uncompress the gz file.",
                          sep = "<br/>"))
            )
        }
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
    
    
    output$warning <- renderText({
        if (is.null(input$file1$datapath)) {
            return(paste("Please upload a QTL file"))
        }
    })
    
    output$showQTLlist <- renderDataTable({
        # validate(
        #     need(!is.null(input$file1$datapath), "Please select a data set")
        # )
        if (!is.null(input$file1$datapath)) {
            datatable(qtlList(), colnames = c("Chr", "Start Position", "End Position", "QTL (ID)"))
        }
    })
        
        
    output$qtlListFinal <- downloadHandler(
        contentType = "csv",
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
                     dataTableOutput(outputId = "qtlTable"),
                     uiOutput(outputId = "instructions")
                     ),
            tabPanel(title = "QTL list",
                     dataTableOutput("showQTLlist"),
                     verbatimTextOutput(outputId = "warning"),
                     downloadButton("qtlListFinal", "Download the table")
                     )
            )
    })
})
