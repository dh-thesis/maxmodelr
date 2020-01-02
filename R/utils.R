#' @export
inst <- function(i="model") {
  system.file(i, package="maxmodelr")
}

#' @export
inst_rds <- function(i="model") {
  list.files(inst(i), pattern="\\.RDS", full.names = TRUE)
}
