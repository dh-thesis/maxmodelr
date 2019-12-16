topics <- c(2,5,10,50,seq(100,1000,100))
dp_models <- system.file("model", package="maxmodelr")

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start modeling eng titles...\n")
  topmodelr::fit_and_save_models(
    tm::DocumentTermMatrix(maxplanckr::titles_eng),
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
  cat("start modeling mpi titles...\n")
  topmodelr::fit_and_save_models(
    tm::DocumentTermMatrix(maxplanckr::titles_mpi),
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
  cat("start modeling pers titles...\n")
  topmodelr::fit_and_save_models(
    tm::DocumentTermMatrix(maxplanckr::titles_pers),
    topics=topics,
    fileid="pers_lang",
    model_dir=dp_models
  )
  cat("done modeling pers titles!\n\n")
})
