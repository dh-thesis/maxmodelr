library(shiny)

cat("start ui\n")

ui <- fluidPage(
  titlePanel("Topic Search"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("load_models"),
      sliderInput("words", "Number of words to display",
        min = 1, max = 10, value = 5, step = 1),
      sliderInput("topics", "Number of topics to display",
        min = 1, max = 5, value = 1, step = 1),
      textInput("search", "Enter search query:", "Natural Language Processing"),
      actionButton("button", "Go")
    ),
    mainPanel(
      h4("Results"),
      verbatimTextOutput("value", placeholder=T)
    )
  )
)
