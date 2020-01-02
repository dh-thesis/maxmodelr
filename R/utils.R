#' @export
rds_self <- function() {
  system.file("model", package="maxmodelr")
}

#' @export
rds_files <- function() {
  list.files(rds_self(), pattern="\\.RDS", full.names = TRUE)
}
