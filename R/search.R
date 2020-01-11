#' @export
search_topic_items <- function(couple, query="information retrieval", model="btm_all", n=10) {
  check_model(model)
  couple_model <- couple$model[[model]]
  # /// infer theta for query /// #
  if(grepl("btm", model)) {
    query_theta <- topmodelr::btm_infer(couple_model, query)
  } else {
    query_theta <- topmodelr::lda_infer(couple_model, query)
  }
  # /// consider only topic of query with highest probability /// #
  query_topic <- which.max(query_theta)
  # /// get the c most likely publications for given topic /// #
  query_items <- topic_items_prob(couple, model=model, topic=query_topic, n=n)
  if(!exists("sel_items")) {
    cat("load publication data!\n")
    data(sel_items, package="maxplanckr")
    # sel_items$Institute <- maxplanckr::context_maintainer(sel_items$Context)
  }
  # /// return items most likely for given topic /// #
  items_subset(sel_items, query_items)[,c("Id", "Label")]
}

#' @export
search_dist_items <- function(couple, query="information retrieval", model="btm_all", n=10, c=10) {
  check_model(model)
  couple_model <- couple$model[[model]]
  # /// infer theta for query /// #
  if(grepl("btm", model)) {
    query_theta <- topmodelr::btm_infer(couple_model, query)
  } else {
    query_theta <- topmodelr::lda_infer(couple_model, query)
  }
  # /// consider only topic of query with highest probability /// #
  query_topic <- which.max(query_theta)
  # /// get the c most likely publications for given topic /// #
  query_items <- topic_items_prob(couple, model=model, topic=query_topic, n=c)
  if(!exists("sel_items")) {
    cat("load publication data!\n")
    data(sel_items, package="maxplanckr")
  }
  query_items <- items_subset(sel_items, query_items)[,c("Id", "Label")]
  # /// compute JSD for query and theta of item subset /// #
  query_items_theta <- couple$theta[[model]][query_items$Id,]
  query_n <- length(rownames(query_items_theta))
  query_dist <- philentropy::JSD(rbind(query_items_theta, query_theta))
  # /// rank items of item subset by JSD values /// #
  query_res <- sort(query_dist[query_n+1,], decreasing = FALSE)
  query_res_probs <- as.double(query_res)
  query_res_items <- query_items$Id[as.integer(gsub("v","",names(query_res)))]
  # /// exclude query from results /// #
  query_exclude <- is.na(query_res_items)
  query_res_probs <- query_res_probs[!query_exclude]
  query_res_items <- query_res_items[!query_exclude]
  # /// sort item subset by ascending distance /// #
  res_items <- query_items[match(query_res_items, query_items$Id),][c("Id","Label")]
  res_items <- tibble::add_column(res_items, "Dist"=query_res_probs)
  # /// only return the first n items /// #
  if (n > c) n <- c
  res_items[1:n,]
}

#' @export
search_topic_items_dist <- function(couple, query="information retrieval", model="btm_all", n=10, limit=TRUE) {
  check_model(model)
  couple_model <- couple$model[[model]]
  # /// infer theta for query /// #
  if(grepl("btm", model)) {
    query_theta <- topmodelr::btm_infer(couple_model, query)
  } else {
    query_theta <- topmodelr::lda_infer(couple_model, query)
  }
  # /// consider only topic of query with highest probability /// #
  query_topic <- which.max(query_theta)
  # /// consider only items with the same most probable topic of query /// #
  query_items <- topic_items(couple, model=model, topic=query_topic)
  # /// check if vector size is reasonable to be computed by jsd /// #
  if(length(query_items$Id) > 5000) {
    if(limit) {
      mssg <- paste0("\nnumber of vectors exceeds reasonable size for similarity calculation.\n")
      mssg <- paste0(mssg, "if you really want to compare ",length(query_items$Id),
                     " vectors, run the function with limit=FALSE !\n\n")
      return(cat(mssg))
    }
  }
  # /// compute JSD for query and theta of topic items /// #
  query_items_theta <- couple$theta[[model]][query_items$Id,]
  query_n <- length(rownames(query_items_theta))
  query_dist <- philentropy::JSD(rbind(query_items_theta, query_theta))
  # /// rank items of item subset by JSD values /// #
  query_res <- sort(query_dist[query_n+1,], decreasing = FALSE)
  query_res_probs <- as.double(query_res)
  query_res_items <- query_items$Id[as.integer(gsub("v","",names(query_res)))]
  # /// exclude query from results /// #
  query_exclude <- is.na(query_res_items)
  query_res_probs <- query_res_probs[!query_exclude]
  query_res_items <- query_res_items[!query_exclude]
  # /// sort item subset by ascending distance /// #
  res_items <- query_items[match(query_res_items, query_items$Id),][c("Id","Label")]
  res_items <- tibble::add_column(res_items, "Dist"=query_res_probs)
  # /// only return the first n items /// #
  res_items[1:n,]
}

check_model <- function(model=NULL) {
  if(is.null(model)) {
    nomodel <- paste0("\tno model specified!\n",
             "either  lda_all,  lda_mpi,  lda_pers\n",
             "or      btm_all\n")
    stop(simpleError(nomodel))
  }
  if(!(model %in% c("btm_all","lda_all","lda_mpi","lda_pers"))) {
      notfound <- paste0("\tmodel not found!\n",
             "either  lda_all,  lda_mpi,  lda_pers\n",
             "or      btm_all\n")
      stop(simpleError(notfound))
  }
}

topic_items_prob <- function(couple, model="btm_all", topic=1, n=10) {
  couple_theta <- couple$theta[[model]][,topic]
  couple_theta <- sort(couple_theta, decreasing=TRUE)
  names(couple_theta)[1:n]
}

topic_items <- function(couple, model="btm_all", topic=1) {
  check_model(model)
  couple_items <- couple$item[[model]]
  topic_items <- couple_items[couple_items$Topic==topic,]$Id
  if(!exists("sel_items")) {
    cat("load publication data!\n")
    data(sel_items, package="maxplanckr")
  }
  items_subset(sel_items, topic_items)
}

items_subset <- function(data, items) {
  data[data$Id %in% items,]
}
