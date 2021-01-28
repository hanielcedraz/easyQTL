#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
# Define UI for application that draws a histogram
# shinyUI(fluidPage(
# 
#     # Application title
#     titlePanel("QTL database"),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             fileInput(inputId = "file1", label = "upload the QTL file"),
#             textInput(inputId = "start", label = "Enter the start position", value = NA),
#             textInput(inputId = "end", label = "Enter the final position", value = NA),
#             textInput(inputId = "chromosome", label = "Enter the chromosome number", value = NA)
#         ),
# 
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             uiOutput("tb")
#         )
#     )
# ))

shinyUI(dashboardPage(
    dashboardHeader(title = "easyQTL", titleWidth = 250),
    dashboardSidebar(width = 250,
        fileInput(inputId = "file1", label = "Upload the QTL file"),
        textInput(inputId = "chromosome", label = "Enter the chromosome number", value = NA, placeholder = "Chr. number"),
        # uiOutput("inputs"),
        # actionButton("addInput", "Add Input"),
        # actionButton("getTexts","Get Input Values"),
        textInput(inputId = "start", label = "Enter the start position", value = NA, placeholder = "Initial position"),
        textInput(inputId = "end", label = "Enter the final position", value = NA, placeholder = "Final position"),
        hr(),
        fluidRow(style = "height:380px;"),
        box(title = "Developed by Haniel Cedraz and Pamela Otto", height = 2, width = 250,
            socialButton(
                url = "https://twitter.com/HanielCedraz",
                type = "twitter"
            ),
            socialButton(
                url = "https://github.com/hanielcedraz",
                type = "github"
            ),
            socialButton(
                url = "https://www.instagram.com/accounts/login/?next=%2Fhanielcedraz%2F&source=follow",
                type = "instagram"
            ),
            socialButton(
                url = "mailto:hanielcedraz@gmail.com",
                type = "envelope"
            ),
            socialButton(
                url = "https://www.researchgate.net/profile/Haniel_Cedraz4",
                type = "researchgate"
            )
            
            # a(actionButton(inputId = "email1",  label = "",
            #                icon = icon("envelope", lib = "font-awesome")),
            #   href = "mailto:hanielcedraz@gmail.com")
        )
    ),
    dashboardBody(
        uiOutput("tb")
    )
))
