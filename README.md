# Instagram-Engagement-Analytics-Dashboard
🧩 1. Installing and Loading Packages
install.packages(c("shiny", "dplyr", "ggplot2", "plotly"))
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)


shiny → used to build interactive web apps in R.

dplyr → used for data manipulation (filtering, grouping, summarizing, etc.).

ggplot2 → used for creating data visualizations (bar charts, line charts, etc.).

plotly → makes ggplot2 charts interactive (hover, zoom, etc.).

📂 2. Loading the Dataset
data <- read.csv("insta_data.csv")


This loads Instagram post data from a CSV file into a variable called data.
👉 The file must exist in the current working directory, otherwise you’ll get an error.

Example columns in insta_data.csv:

PostID	PostType	Likes	Comments	Reach	Saves
P1	Reel	120	20	500	15
P2	Photo	90	10	400	12
🖥️ 3. UI (User Interface)
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

Breakdown:

fluidPage() → builds a responsive web layout.

titlePanel() → sets the app’s title.

sidebarLayout() → divides the screen into two parts:

Sidebar (left): allows user to select which engagement metric to view (Likes, Comments, etc.).

Main panel (right): shows the three interactive charts inside tabs:

Bar Chart → Shows engagement per post.

Average Comparison → Shows average engagement by post type.

Trend Line → Shows engagement trends across posts.

⚙️ 4. Server Logic
server <- function(input, output) {


This part defines how the app reacts when users interact with it.

(a) Bar Chart
output$barPlot <- renderPlotly({
  p <- ggplot(data, aes_string(x = "PostID", y = input$metric, fill = "PostType")) +
    geom_bar(stat = "identity") +
    labs(title = paste(input$metric, "Per Post"), x = "Post ID", y = input$metric) +
    theme_minimal()
  ggplotly(p)
})


🔹 What it does:

Draws a bar chart showing the selected engagement metric (Likes, Comments, etc.) for each post.

Bars are colored by PostType (e.g., Reel, Photo, Story).

ggplotly(p) makes it interactive (hover tooltips, zoom, etc.).

(b) Average Comparison Chart
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


🔹 What it does:

Groups posts by PostType and calculates the average of the selected metric.

Plots a bar chart comparing average Likes, Comments, etc., between types of posts.

(c) Trend Line Chart
output$trendPlot <- renderPlotly({
  p <- ggplot(data, aes_string(x = "PostID", y = input$metric, color = "PostType", group = "PostType")) +
    geom_line(size = 1.2) +
    geom_point(size = 3) +
    labs(title = paste(input$metric, "Trend Across Posts"), x = "Post ID", y = input$metric) +
    theme_minimal()
  ggplotly(p)
})


🔹 What it does:

Plots a line chart showing how each engagement metric changes across posts.

Useful for analyzing trends (e.g., did Likes increase over time?).

🚀 5. Run the App
shinyApp(ui, server)


This function runs the complete Shiny app by combining:

the UI (what the app looks like)

and the Server (how the app behaves).

💡 Output Summary
Tab	Visualization	Purpose
Bar Chart	Interactive bar chart	Compare engagement per post
Average Comparison	Average metric by post type	Find best-performing post types
Trend Line	Engagement trends	Identify growth/decline patterns
