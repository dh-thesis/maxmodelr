#' Search interface for queries based on different topic models
#'
#' @export
topicsearch <- function(){
  shiny::runApp(system.file("shiny/topicsearch", package="maxmodelr"), launch.browser = T)
}
