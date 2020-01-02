cat("start server\n")
source("share.R", local = TRUE)

server <- function(input, output) {
  cat("start server routine\n")
  output$load_models <- renderUI({
    selectInput("models", "Choose a model:",
    choices = mod_fps, selected = mod_fps[1])
  })
  res <- eventReactive(input$button, {
    tts(
      input$models,
      input$search,
      input$words,
      input$topics)
  })
  output$value <- renderText({res()}, sep="")
}
