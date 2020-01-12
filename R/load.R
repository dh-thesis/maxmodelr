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
  if(identical(character(0),fp)) {
    mssg <- paste0("no coupling data found with k = ",k,"!")
    stop(simpleError(mssg))
  }
  fp
}

couple_names <- function(k) {
  fp_names <- list.files(inst("couple"), pattern=".RDS")
  fp_names <- utlr::filter_paths(fp_names, pattern=paste0("k",k,".RDS"))
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
