topics <- c(2,5,10,50,seq(100,1000,100))
dp_tunes <- system.file("tunes", package="maxmodelr")

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start tune model of eng titles...\n")
  fp <- file.path(fp_tunes, "titles_eng.png")
  topmodelr::tune_and_save_plot(maxplanckr::titles_eng, topics)
  cat("done tuning model of eng titles...\n")
})

# //////////////// #
# /// MPI_LANG /// #
# //////////////// #

system.time({
  cat("start tune model of mpi titles...\n")
  fp <- file.path(fp_tunes, "titles_mpi.png")
  topmodelr::tune_and_save_plot(maxplanckr::titles_mpi, topics)
  cat("done tuning model of mpi titles...\n")
})

# ///////////////// #
# /// PERS_LANG /// #
# ///////////////// #

system.time({
  cat("start tune model of pers titles...\n")
  fp <- file.path(fp_tunes, "titles_pers.png")
  topmodelr::tune_and_save_plot(maxplanckr::titles_pers, topics)
  cat("done tuning model of mpi titles...\n")
})
