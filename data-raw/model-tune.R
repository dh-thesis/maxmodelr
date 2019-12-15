model_tunes <- function(dtm,topics=c(2,5,10,50,seq(100,1000,100))) {
  cat(paste("tune LDA model parameters\n"))
  t1 <- Sys.time()
  cat(paste("start time:", t1, "\n"))
  tunes <- ldatuning::FindTopicsNumber(dtm,
    topics = topics,
    metrics = c("Griffiths2004"),
    method = "Gibbs",
    control = list(seed = 42, iter = 1000),
    verbose = TRUE
  )
  t2 <- Sys.time()
  cat("done tuning LDA model!\n")
  elapsed <- difftime(t2, t1, units="mins")
  cat(paste("time elapsed:", round(elapsed,2), "min\n\n"))
  tunes
}

tune_and_save_plot <- function(dirpath=NULL,fpath=NULL,fid=NULL) {
    if(!is.null(dirpath)) {
        dtm <- plain_to_dtm(dirpath)
        if(!is.null(fid)) {
            fname <- paste0(system.file("plots",package="bsc"),
                            "/", fid, ".png")
        } else {
            fname <- paste0("plot/", name_from_path(dirpath), ".png")
        }
    }
    if (!is.null(fpath)) {
        dtm <- lines_to_dtm(fpath)
        if(!is.null(fid)) {
            fname <- paste0(system.file("plots",package="bsc"),
                            "/", fid, ".png")
        } else {
            fname <- paste0(system.file("plots",package="bsc"),"/", name_from_path(fpath), ".png")
        }
    }
    if (is.null(dirpath) & is.null(fpath)) {
        stop("missing path to txt documents!")
    }
    tunes <- model_tunes(dtm)
    png(filename=fname)
    ldatuning::FindTopicsNumber_plot(tunes)
    dev.off()
}
