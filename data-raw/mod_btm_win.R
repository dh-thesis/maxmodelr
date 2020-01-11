library(BTM)

rds_root <- "inst/window"
dir.create(rds_root, showWarnings=FALSE, recursive=TRUE)

data(titles_eng, package="maxplanckr")
bi_corpus <- topmodelr::prepare_bi_corpus(titles_eng)

r <- c(2, 3, seq(5,75,5))
t <- c(100)

cat("start infering biterm model with different context sizes...\n\n")

for(w in r) {
  cat(paste0("\ncontext size: w = ", w, "\n\n"))
  for(k in t) {
    bimod <- topmodelr::fit_bi_model(bi_corpus, k, w=w)
    bt <- terms(bimod, type = "biterms")
    saveRDS(list("btm"=bimod,"count"=bt),
            file.path(rds_root, paste0("btm_all_lang_t",k,"_w",w,".RDS")))
  }
}

cat("all done!\n\n")
