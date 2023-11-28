

#' filter a discretized SCE using getTopHVGs from scran, the produce triples (edges)
#' (cell - weight - gene)
#' @import SingleCellExperiment
#' @import scran
#' @param sce instance of SingleCellExperiment with assays logcounts and disc
#' @param outtsv character(1) file to hold triples in tsv format
#' @param ngenes numeric(1) number of genes to retain from getTopHVGs after
#' scran::modelGeneVar on logcounts
#' @export
sce_to_triples = function(sce, outtsv, ngenes=5000) {
stats = scran::modelGeneVar(assay(sce, "logcounts", withDimnames=FALSE))
tt = scran::getTopHVGs(stats, n=ngenes)

assays(sce)$disc = disc_matrix(assays(sce)$logcounts)
make_triples(sce, outtsv)
}

