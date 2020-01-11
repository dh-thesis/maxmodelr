#' @export
items_affil_proportion <- function(items) {
  affil_total <- items_affil(items)$Organization
  affil_props <- table(affil_total)
  affil_props <- sapply(affil_props, function(x) x/length(affil_total))
  affil_props <- sort(affil_props, decreasing=TRUE)
  affil_names <- unname(maxplanckr::orgunit_names(names(affil_props)))
  affil_props <- data.frame(
    id=names(affil_props),
    share=as.numeric(affil_props),
    name=affil_names,
    stringsAsFactors=FALSE
  )
  affil_props$parent <- sapply(affil_props$id, function(ou) {
    unname(orgunit_institute(ou))
  })
  dplyr::as_tibble(affil_props)
}

#' @export
items_ous_proportion <- function(items) {
  ctx_total <- items_context(items)$Context
  ctx_maintainer <- maxplanckr::context_maintainer(ctx_total)
  ctx_maintainer_props <- table(ctx_maintainer)
  ctx_maintainer_props <- sapply(ctx_maintainer_props, function(x) x/length(ctx_total))
  ctx_maintainer_props <- sort(ctx_maintainer_props, decreasing=TRUE)
  ctx_maintainer_lab <- unname(maxplanckr::orgunit_names(names(ctx_maintainer_props)))
  ctx_maintainer_props <- data.frame(
    id=names(ctx_maintainer_props),
    share=as.numeric(ctx_maintainer_props),
    name=ctx_maintainer_lab,
    stringsAsFactors=FALSE
  )
  dplyr::as_tibble(ctx_maintainer_props)
}

#' @export
items_ctx_proportion <- function(items) {
  ctx_total <- items_context(items)$Context
  ctx_props <- table(ctx_total)
  ctx_props <- sapply(ctx_props, function(x) x/length(ctx_total))
  ctx_props <- sort(ctx_props, decreasing=TRUE)
  ctx_names <- unname(maxplanckr::context_names(names(ctx_props)))
  ctx_props <- data.frame(
    id=names(ctx_props),
    share=as.numeric(ctx_props),
    name=ctx_names,
    stringsAsFactors=FALSE
  )
  dplyr::as_tibble(ctx_props)
}

items_context <- function(items) {
  if(!exists("sel_items")) {
    cat("load publication data!\n")
    data(sel_items, package="maxplanckr")
  }
  contexts <- sel_items[sel_items$Id %in% items,]
  contexts[,c("Id","Context")]
}

orgunit_institute <- function(ou_id) {
  if(!exists("sel")) {
    cat("load meta data of organizational units!\n")
    data(sel, package="maxplanckr")
  }
  if(ou_id %in% sel$ous$Id) {
    # ou is already an institute!
    return(maxplanckr::orgunit_names(ou_id))
  }
  found <- FALSE
  while(!found) {
    parent <- orgunit_parent(ou_id)
    if(identical(character(0), parent)) {
      # some ous have no parent:
      #   external, max planck society, etc.
      parent <- ou_id
      found <- TRUE
    }
    if(parent %in% sel$ous$Id) {
      found <- TRUE
    } else {
      ou_id <- parent
    }
  }
  maxplanckr::orgunit_names(parent)
}

orgunit_parent <- function(ou_id) {
  if(!exists("sel")) {
    cat("load meta data of organizational units!\n")
    data(sel, package="maxplanckr")
  }
  sel$ous_ous[sel$ous_ous$Source==ou_id,]$Target
}

items_affil <- function(items) {
  if(!exists("sel_items_rel")) {
    cat("load creators data!\n")
    data(sel_items_rel, package="maxplanckr")
  }
  affils <- sel_items_rel$aut[sel_items_rel$aut$Item %in% items,]
  affils[,c("Item", "Organization")]
}
