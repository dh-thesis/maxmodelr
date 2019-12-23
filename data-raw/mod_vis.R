devtools::load_all()

dp_models <- system.file("model", package="maxmodelr")
mod_paths <- list.files(dp_models, full.names=T, pattern="[[:digit:]].RDS")
dir.create(file.path(".", "doc"), showWarnings = F)

# //////////////// #
# /// ALL_LANG /// #
# //////////////// #

system.time({
  cat("start visualize model of eng titles...\n")
  dtm <- topmodelr::prepare_dt_corpus(maxplanckr::titles_eng)
  lda_all <- utlr::filter_paths(mod_paths, pattern="lda_all_lang_t[[:digit:]]")
  for(lda in lda_all) { topmodelr::vis_from_rds(lda, dtm, browser=F) }
  cat("done visualizing model of eng titles!\n")
})

# //////////////// #
# /// MPI_LANG /// #
# //////////////// #

system.time({
  cat("start visualize models of mpi titles...\n")
  dtm <- topmodelr::prepare_dt_corpus(maxplanckr::titles_mpi)
  lda_mpi <- utlr::filter_paths(mod_paths, pattern="lda_mpi_lang_t[[:digit:]]")
  for(lda in lda_mpi) { topmodelr::vis_from_rds(lda, dtm, browser=F) }
  cat("done visualizing models of mpi titles!\n")
})

# ///////////////// #
# /// PERS_LANG /// #
# ///////////////// #

system.time({
  cat("start visualize models of pers titles...\n")
  dtm <- topmodelr::prepare_dt_corpus(maxplanckr::titles_pers)
  lda_pers <- utlr::filter_paths(mod_paths, pattern="lda_pers_lang_t[[:digit:]]")
  for(lda in lda_pers) { topmodelr::vis_from_rds(lda, dtm, browser=F) }
  cat("done visualizing models of pers titles!\n\n")
})



