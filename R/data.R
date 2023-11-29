#' embeddings for PBMC3K based on 50 epochs of training by
#' torch-biggraph for 2000 highly variable genes
#' @docType data
#' @format named list
#' @examples
#' data(nn50)
#' names(nn50)
#' nn50$call
"nn50"

#' a SingleCellExperiment for PBMC3K that includes assay elements
#' logcounts (produced by scran::logNormCounts) and disc (produced
#' by BiocPBG::disc_matrix)
#' @format SingleCellExperiment
#' @examples
#' data(t3k)
#' assayNames(t3k)
"t3k"
