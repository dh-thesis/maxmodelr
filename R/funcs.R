#' lda_topic_items
#'
#' topic model-based search for publications
#'
#' @param lda model trained on 221386 title documents `all_lang`
#' @param topic number of topic whose items should be returned
#'
#' @export
lda_topic_items <- function(lda, topic=1) {
  if(!exists("sel_items")) {
    cat("load data to fetch items of topic...\n")
    data(sel_items, package="maxplanckr")
    cat("data loaded succesfully!\n")
  }
  topic_items <- names(topmodelr::lda_topic_docs(lda, topic))
  topic_items <- gsub(".txt", "", topic_items, fixed=T)
  maxplanckr::sel_items[match(topic_items, sel_items$Id),][,c("Id","Label","Year")]
}
