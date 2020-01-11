#' topicsearch
#'
#' interface for querying different topic models
#'
#' @export
topicsearch <- function(){
  shiny::runApp(system.file("shiny/topicsearch", package="maxmodelr"), launch.browser = T)
}
