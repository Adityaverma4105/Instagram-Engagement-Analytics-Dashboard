# Source Code
# Required Libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# Load Data
data <- read.csv("insta_data.csv")

ui <- fluidPage(
  titlePanel("Instagram Engagement Analytics Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("metric", "Select Engagement Metric:",
                  choices = c("Likes", "Comments", "Reach", "Saves"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Bar Chart", plotlyOutput("barPlot")),
        tabPanel("Average Comparison", plotlyOutput("avgPlot")),
        tabPanel("Trend Line", plotlyOutput("trendPlot"))
      )
    )
  )
)

server <- function(input, output) {
  
  # Bar Chart by Post ID
  output$barPlot <- renderPlotly({
    p <- ggplot(data, aes_string(x = "PostID", y = input$metric, fill = "PostType")) +
      geom_bar(stat = "identity") +
      labs(title = paste(input$metric, "Per Post"), x = "Post ID", y = input$metric) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Average by Post Type
  output$avgPlot <- renderPlotly({
    avg_data <- data %>%
      group_by(PostType) %>%
      summarise(Average = mean(get(input$metric)))
    
    p <- ggplot(avg_data, aes(x = PostType, y = Average, fill = PostType)) +
      geom_col() +
      labs(title = paste("Average", input$metric, "by Post Type"),
           x = "Post Type", y = paste("Avg", input$metric)) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Engagement Trend Line
  output$trendPlot <- renderPlotly({
    p <- ggplot(data, aes_string(x = "PostID", y = input$metric, color = "PostType", group = "PostType")) +
      geom_line(size = 1.2) +
      geom_point(size = 3) +
      labs(title = paste(input$metric, "Trend Across Posts"), x = "Post ID", y = input$metric) +
      theme_minimal()
    ggplotly(p)
  })
  
}

shinyApp(ui, server)

