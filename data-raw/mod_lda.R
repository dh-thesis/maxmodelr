# devtools::load_all()

topics <- c(2,5,10,50,seq(100,1000,100))
dp_models <- system.file("model", package="maxmodelr")

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start preparing eng title corpus...\n")
  data(titles_eng, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_eng)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start modeling eng titles...\n")
  topmodelr::fit_and_save_models(
    dtcorp,
    topics=topics,
    fileid="all_lang",
    model_dir=dp_models
  )
  cat("done modeling eng titles...\n")
})

# //////////////// #
# /// MPI_LANG /// #
# //////////////// #

system.time({
  cat("start preparing mpi title corpus...\n")
  data(titles_mpi, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_mpi)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp)
  cat("done preparing mpi title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start modeling mpi titles...\n")
  topmodelr::fit_and_save_models(
    dtcorp,
    topics=topics,
    fileid="mpi_lang",
    model_dir=dp_models
  )
  cat("done modeling mpi titles!\n\n")
})

# ///////////////// #
# /// PERS_LANG /// #
# ///////////////// #

system.time({
  cat("start preparing pers title corpus...\n")
  data(titles_pers, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_pers)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp)
  cat("done preparing pers title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start modeling pers titles...\n")
  topmodelr::fit_and_save_models(
    dtcorp,
    topics=topics,
    fileid="pers_lang",
    model_dir=dp_models
  )
  cat("done modeling pers titles!\n\n")
})
