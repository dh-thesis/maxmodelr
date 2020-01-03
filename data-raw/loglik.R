devtools::load_all()

rds_out <- "inst/loglik"
dir.create(rds_out, showWarnings = FALSE, recursive = TRUE)

library(BTM)

dp_models <- system.file("model", package="maxmodelr")
btm_fp <- list.files(dp_models, pattern="btm-full", full.names=TRUE)
names(btm_fp) <- topmodelr::name_from_path(btm_fp)

btm_ll <- lapply(btm_fp, function(x) {
  cat(paste0("reading model : ",topmodelr::name_from_path(x),"\n"))
  full <- readRDS(x)
  cat("calculate log-likelihood...\n")
  fit <- logLik(full$model, data=full$count$biterms)
  cat("calculation finished!\n")
  fit$ll
})

saveRDS(btm_ll, file.path(rds_out, "btm_ll.RDS"))
