devtools::load_all()

# ////////////// #
# /// CORPUS /// #
# ////////////// #

data(titles_eng, package="maxplanckr")
corpus <- as.vector(sapply(titles_eng, function(x) x$content))
corpus_ids <- as.vector(sapply(titles_eng, function(x) gsub(".txt","",x$meta$id,fixed=T)))

#ws <- grepl("\\s",corpus)
#corpus <- corpus[ws]
#corpus_ids <- corpus_ids[ws]

# ////////////// #
# /// MODELS /// #
# ////////////// #

cat("\n\nmodels:\n")

rds_root <- system.file("model", package="maxmodelr")
rds_paths <- list.files(rds_root, full.names=T, pattern="[[:digit:]].RDS")
rds_paths_t100 <- utlr::filter_paths(rds_paths, pattern="t100_")

models <- topmodelr::read_models(rds_paths_t100)
names(models) <- gsub("_[0-9]+\\.[0-9]+\\.[0-9]+","",names(models))
names(models)

# ///////////// #
# /// INFER /// #
# ///////////// #

rds_out <- system.file("infer", package="maxmodelr")

cat("\nbtm theta...\n")
t1 <- Sys.time()
btm_theta <- t(sapply(corpus,
		      function(x) {
			      as.vector(topmodelr::btm_infer(models$btm_all_lang_t100, x))
		      })
)
saveRDS(btm_theta, file.path(rds_out, "btm_theta.RDS"))
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("btm theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))

cat("all theta...\n")
t1 <- Sys.time()
all_theta <- t(sapply(corpus,
		      function(x) {
			      as.vector(topmodelr::lda_infer(models$lda_all_lang_t100, x))
		      })
)
saveRDS(all_theta, file.path(rds_out, "all_theta.RDS"))
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("all theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))

cat("mpi theta...\n")
t1 <- Sys.time()
mpi_theta <- t(sapply(corpus,
		      function(x) {
			        as.vector(topmodelr::lda_infer(models$lda_mpi_lang_t100, x))
		      })
)
saveRDS(mpi_theta, file.path(rds_out, "mpi_theta.RDS"))
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("mpi theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))

cat("pers theta...\n")
t1 <- Sys.time()
pers_theta <- t(sapply(corpus,
		       function(x) {
			       as.vector(topmodelr::lda_infer(models$lda_pers_lang_t100, x))
		       })
)
saveRDS(pers_theta, file.path(rds_out, "pers_theta.RDS"))
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("pers theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))

