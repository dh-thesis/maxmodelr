#' @export
load_couple <- function(k=100) {
  fp <- couple_paths(k)
  names(fp) <- couple_names(k)
  couple <- lapply(fp, readRDS)
  couple <- couple_item_prep(couple, k)
  couple <- couple_theta_prep(couple, k)
  couple
}

couple_paths <- function(k) {
  fp <- list.files(inst("couple"), pattern=".RDS", full.names=T)
  fp <- utlr::filter_paths(fp, pattern=paste0("k",k,".RDS"))
  if(identical(character(0),fp)) stop("no coupling data found!")
  fp
}

couple_names <- function(k) {
  fp_names <- list.files(inst("couple"), pattern=".RDS")
  fp_names <- utlr::filter_paths(fp_names, pattern=paste0("k",k))
  gsub(paste0("_k",k,".RDS"),"",fp_names)
}

couple_item_prep <- function(couple, k) {
  # normalize model names
  names(couple$item) <- gsub(paste0("all_t",k), "lda_all", names(couple$item), fixed=T)
  names(couple$item) <- gsub(paste0("btm_t",k), "btm_all", names(couple$item), fixed=T)
  names(couple$item) <- gsub(paste0("pers_t",k), "lda_pers", names(couple$item), fixed=T)
  names(couple$item) <- gsub(paste0("mpi_t",k), "lda_mpi", names(couple$item), fixed=T)
  couple
}

couple_theta_prep <- function(couple, k) {
  # normalize model names
  names(couple$theta) <- gsub(paste0("all_t",k), "lda_all", names(couple$theta), fixed=T)
  names(couple$theta) <- gsub(paste0("btm_t",k), "btm_all", names(couple$theta), fixed=T)
  names(couple$theta) <- gsub(paste0("pers_t",k), "lda_pers", names(couple$theta), fixed=T)
  names(couple$theta) <- gsub(paste0("mpi_t",k), "lda_mpi", names(couple$theta), fixed=T)
  # clean up IDs of items
  rownames(couple$theta[["btm_all"]]) <- gsub("corpus:","",rownames((couple$theta[["btm_all"]])),fixed=T)
  rownames(couple$theta[["lda_all"]]) <- gsub(".txt","",rownames((couple$theta[["lda_all"]])),fixed=T)
  rownames(couple$theta[["lda_mpi"]]) <- gsub(".txt","",rownames((couple$theta[["lda_mpi"]])),fixed=T)
  rownames(couple$theta[["lda_pers"]]) <- gsub(".txt","",rownames((couple$theta[["lda_pers"]])),fixed=T)
  couple
}

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

#' @export
items_affil_proportion <- function(items) {
  ou_total <- items_affil(items)$Organization
  ou_names <- maxplanckr::orgunit_names(ou_total)
  ou_props <- table(ou_names)
  sapply(ou_props, function(x) x/length(ou_total))
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

items_affil <- function(items) {
  if(!exists("sel_items_rel")) {
    cat("load creators data!\n")
    data(sel_items_rel, package="maxplanckr")
  }
  affils <- sel_items_rel$aut[sel_items_rel$aut$Item %in% items,]
  affils[,c("Item", "Organization")]
}
