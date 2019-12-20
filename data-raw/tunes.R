# devtools::load_all()

topics <- c(2,5,10,50,seq(100,1000,100))
dp_tunes <- system.file("tunes", package="maxmodelr")

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
  cat("start tuning model of eng titles...\n")
  fp <- file.path(dp_tunes, "titles_eng.png")
  topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of eng titles...\n")
})

# //////////////// #
# /// MPI_LANG /// #
# //////////////// #

system.time({
  cat("start preparing eng title corpus...\n")
  data(titles_mpi, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_mpi)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start tuning model of mpi titles...\n")
  fp <- file.path(dp_tunes, "titles_mpi.png")
  topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of mpi titles...\n")
})

# ///////////////// #
# /// PERS_LANG /// #
# ///////////////// #

system.time({
  cat("start preparing pers title corpus...\n")
  data(titles_pers, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_pers)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start tuning model of pers titles...\n")
  fp <- file.path(dp_tunes, "titles_pers.png")
  topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of pers titles...\n")
})
