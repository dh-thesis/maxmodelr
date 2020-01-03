devtools::load_all()

topics <- c(2,5,10,25,50,seq(100,500,100))
dp_tunes <- system.file("tunes", package="maxmodelr")

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start preparing eng title corpus...\n")
  data(titles_eng, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_eng)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp, 1, 1)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start tuning model of eng titles...\n")
  fp <- file.path(dp_tunes, "titles_eng.png")
  tunes <- topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of eng titles...\n")
  saveRDS(tunes,file.path(dp_tunes,"titles_eng_tunes.RDS"))
})

# //////////////// #
# /// MPI_LANG /// #
# //////////////// #

system.time({
  cat("start preparing mpi title corpus...\n")
  data(titles_mpi, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_mpi)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp, 1, 1)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start tuning model of mpi titles...\n")
  fp <- file.path(dp_tunes, "titles_mpi.png")
  tunes <- topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of mpi titles...\n")
  saveRDS(tunes,file.path(dp_tunes, "titles_mpi_tunes.RDS"))
})

# ///////////////// #
# /// PERS_LANG /// #
# ///////////////// #

system.time({
  cat("start preparing pers title corpus...\n")
  data(titles_pers, package="maxplanckr")
  dtcorp <- topmodelr::prepare_dt_corpus(titles_pers)
  dtcorp <- topmodelr::filter_dt_corpus(dtcorp, 1, 1)
  cat("done preparing eng title corpus...\n")
  vocab <- dtcorp$ncol
  docs <- dtcorp$nrow
  cat(paste("corpus has", docs, "documents and", vocab, "terms...\n"))
  cat("start tuning model of pers titles...\n")
  fp <- file.path(dp_tunes, "titles_pers.png")
  tunes <- topmodelr::tune_and_save_plot(dtcorp, topics, fp)
  cat("done tuning model of pers titles...\n")
  saveRDS(tunes, file.path(dp_tunes, "titles_pers_tunes.RDS"))
})
