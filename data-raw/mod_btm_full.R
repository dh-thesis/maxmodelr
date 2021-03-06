devtools::load_all()

topics <- c(2,5,10,25,50,seq(100,500,100))
dp_models <- system.file("model", package="maxmodelr")

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start preparing biterm corpus...\n")
  data(titles_eng, package="maxplanckr")
  docid <- "all_lang"
  bicorp <- topmodelr::prepare_bi_corpus(titles_eng, docid)
  bicorp <- topmodelr::filter_bi_corpus(bicorp, 1, 1)
  cat("done preparing biterm corpus...\n")
  vocab <- length(unique(bicorp$Term))
  docs <- length(unique(bicorp$Doc))
  cat(paste("corpus has",docs,"documents and",vocab,"terms...\n"))
  cat("start modeling...\n")
  topmodelr::fit_and_save_bi_models_full(
    bicorp,
    topic=topics,
    fileid=docid,
    model_dir=dp_models
  )
  cat("done modeling...\n")
})
