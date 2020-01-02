cat("init share\n")

# ////////////// #
# /// MODELS /// #
# ////////////// #

rds_root <- ""

if(""!=Sys.getenv(c("MODEL_RDS"))) {
  rds_root <- Sys.getenv(c("MODEL_RDS"))
} else {
  rds_root <- system.file("model",package="maxmodelr")
}

cat(paste("rds root:", rds_root, "\n"))
cat(paste("work dir:", getwd(),"\n"))

mod_fps <- list.files(
  rds_root,
  pattern="[[:digit:]]\\.RDS",
  full.names=T
)

mod_ids <- gsub("_[0-9]+-[0-9]+-[0-9]+","",
  topmodelr::name_from_path(mod_fps)
)

mod_fps <- setNames(mod_fps, mod_ids)

tt <- 0
ttn <- 5

x <- 1
top_model <- setNames(x, "x")

# ////////////// #
# /// SEARCH /// #
# ////////////// #

tts <- function(path, query, w=5, t=3) {
  cat("search topic\n")
  cat(paste0(path,"\n"))
  cat(paste0(query,"\n"))
  prepro <- topmodelr::corpus_prep(tm::VCorpus(tm::VectorSource(query)))
  query <- prepro[[1]]$content
  mod_name <- make.names(topmodelr::name_from_path(path))
  if(mod_name != names(top_model)) {
    cat("reading model from disk...\n")
    cat(paste("requested:", mod_name, "\n"))
    cat(paste("previous:", names(top_model), "\n"))
    top_model <<- topmodelr::read_models(path[1])
    cat(paste0(names(top_model),"\n"))
    if (length(grep("btm_", path)) ==1) {
      cat("preload topic term table...\n")
      tt <<- topmodelr::btm_topics_words(top_model[[1]], w)
      ttn <<- w
    }
    cat("finished reading model from disk!\n")
  }
  if(length(grep("lda_",path)) == 1) {
    res <- topmodelr::lda_search(top_model[[1]], query, n=w, t=t+1)
  }
  if(length(grep("btm_",path)) == 1) {
    if (w != ttn) {
      cat("preload topic term table...\n")
      tt <<- topmodelr::btm_topics_words(top_model[[1]], w)
      ttn <<- w
    }
    res <- topmodelr::btm_search(top_model[[1]], query, n=w, t=t+1, tt=tt)
  }
  topic_no <- colnames(res)[1:t]
  paste0(sapply(topic_no, function(x) {c(toupper(x),res[,x],"\n")}),"\n")
}
