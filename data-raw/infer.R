devtools::load_all()

rds_out <- "inst/infer"
dir.create(rds_out, showWarnings = FALSE, recursive = TRUE)

# ////////////// #
# /// CORPUS /// #
# ////////////// #

data(titles_eng, package="maxplanckr")
# titles_eng <- titles_eng[1:500]

titles_dt <- topmodelr::prepare_dt_corpus(titles_eng)
titles_bi <- topmodelr::prepare_bi_corpus(titles_eng)

# ////////////// #
# /// MODELS /// #
# ////////////// #

k <- 100

rds_root <- system.file("model", package="maxmodelr")
rds_paths <- list.files(rds_root, full.names=T, pattern="[[:digit:]].RDS")
rds_paths_k <- utlr::filter_paths(rds_paths, pattern=paste0("t",k,"_"))

models <- topmodelr::read_models(rds_paths_k)
names(models) <- gsub("_[0-9]+\\.[0-9]+\\.[0-9]+","",names(models))

cat("\n\nmodels:\n")
names(models)

# ///////////// #
# /// INFER /// #
# ///////////// #

library(BTM)
library(topicmodels)

cat("\nbtm theta...\n")
btm <- topmodelr::get_models(models, "btm_all_lang_t")
t1 <- Sys.time()
btm_theta <- predict(btm, newdata=titles_bi)
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("btm theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))
saveRDS(btm_theta, file.path(rds_out, paste0("btm_t",k,"_theta.RDS")))

cat("all theta...\n")
t1 <- Sys.time()
lda <- topmodelr::get_models(models, "lda_all_lang_t")
all_theta <- topicmodels::posterior(lda, titles_dt, lda@control)$topics
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("all theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))
saveRDS(all_theta, file.path(rds_out, paste0("all_t",k,"_theta.RDS")))

cat("mpi theta...\n")
t1 <- Sys.time()
lda <- topmodelr::get_models(models, "lda_mpi_lang_t")
mpi_theta <- topicmodels::posterior(lda, titles_dt, lda@control)$topics
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("mpi theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))
saveRDS(mpi_theta, file.path(rds_out, "mpi_t100_theta.RDS"))

cat("pers theta...\n")
t1 <- Sys.time()
lda <- topmodelr::get_models(models, "lda_pers_lang_t")
pers_theta <- topicmodels::posterior(lda, titles_dt, lda@control)$topics
t2 <- Sys.time()
elapsed <- difftime(t2, t1, units="mins")
cat("pers theta done!\n")
cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))
saveRDS(pers_theta, file.path(rds_out, paste0("pers_t", k, "_theta.RDS")))

cat("all done!\n")
