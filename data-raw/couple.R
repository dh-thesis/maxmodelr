devtools::load_all()

rds_out <- "inst/couple"
dir.create(rds_out, showWarnings = FALSE, recursive = TRUE)

# ////////////// #
# /// MODELS /// #
# ////////////// #

k <- 100

rds_root <- system.file("model", package="maxmodelr")
rds_paths <- list.files(rds_root, full.names=T, pattern="[[:digit:]].RDS")
rds_paths_k <- utlr::filter_paths(rds_paths, pattern=paste0("t",k,"_"))

models <- topmodelr::read_models(rds_paths_k)
names(models) <- gsub("_[0-9]+\\.[0-9]+\\.[0-9]+","",names(models))
names(models) <- gsub("btm_all_lang","btm", names(models), fixed=T)
names(models) <- gsub("lda_","", names(models), fixed=T)
names(models) <- gsub("_lang","", names(models), fixed=T)

saveRDS(
  models,
  file.path(
    rds_out,
    paste0("model_k",k,".RDS")
  )
)

# ////////////// #
# /// COUPLE /// #
# ////////////// #

rds_src <- system.file("infer", package="maxmodelr")
rds_src <- list.files(rds_src, pattern=".RDS", full.names=T)
rds_src_k <- utlr::filter_paths(rds_src, pattern=paste0("t",k,"_"))

thetas <- sapply(rds_src_k, readRDS, simplify=F)
names(thetas) <- utlr::name_from_path(names(thetas))
names(thetas) <- gsub("_theta","",names(thetas),fixed = TRUE)

saveRDS(
  thetas,
  file.path(
    rds_out,
    paste0("theta_k",k,".RDS")
  )
)

topics <- sapply(thetas, function(x) {
  apply(x, 1, which.max)
}, simplify = FALSE)

titles_id <- names(topics[[names(thetas)[1]]])
titles_id <- gsub("corpus:","",titles_id,fixed=T)
titles_id <- gsub(".txt","",titles_id,fixed=T)

topics <- lapply(topics, function(x){
  stats::setNames(x, titles_id) 
})

topics <- lapply(topics, function(x) {
  item_ids <- names(x)
  item_top <- as.integer(x)
  df <- data.frame(
    "Id" = item_ids,
    "Topic" = item_top,
    stringsAsFactors = FALSE
  )
  dplyr::as_tibble(df)
})

saveRDS(
  topics,
  file.path(
    rds_out,
    paste0("item_k",k,".RDS")
  )
)
