.gini_from_edgeR = function (x) 
{
#
# GPL2 licensed in edgeR
#
    x <- as.matrix(x)
    d <- dim(x)
    for (j in 1:d[2]) x[, j] <- sort.int(x[, j], na.last = TRUE)
    i <- 1:d[1]
    m <- 0.75 * d[1]
    S1 <- colSums((i - m) * x, na.rm = TRUE)
    S2 <- colSums(x, na.rm = TRUE)
    (2 * (S1/S2 + m) - d[1] - 1)/d[1]
}

#' gini coefficients from rows of a matrix
#' @param x matrix
#' @return vector of gini coefficients
#' @note source extracted from edgeR 'gini'
#' @export
gini = function(x) .gini_from_edgeR(x)

#' obtain the simba norm metric for genes
#' @param sce SingleCellExperiment with simba scores available
#' @export
norm_scores = function(sce) {
 stopifnot("sprobs" %in% altExpNames(sce))
 x = qlogis(assay(altExps(sce)$sprobs)) # undo the softmax
 t(apply(x,1,function(x)(x-log(mean(exp(x))))))
}

#' obtain the simba max metric for genes
#' @param sce SingleCellExperiment with simba scores available
#' @param N number of cells with highest scores to average
#' @examples
#' data(nn50)
#' data(t3k)
#' t3k = add_simba_scores(nn50, t3k)
#' gi = gini(t(assay(altExps(t3k)$sprobs)))
#' ma = as.numeric(max_scores(t3k))
#' plot(ma, gi)
#' mydf = data.frame(max=as.numeric(ma), gini=gi, gene=rowData(t3k)$Symbol)
#' litd = mydf[order(mydf$gini,decreasing=TRUE),][1:25,]
#' hh = mydf[mydf$gene=="GAPDH",] 
#' litd = rbind(litd, hh)
#' mm = ggplot(mydf, aes(x=max, y=gini, text=gene)) + geom_point() 
#' mm + ggrepel::geom_text_repel(data=litd, 
#'          aes(x=max, y=gini, label=gene), colour="purple")
#' @export
max_scores = function(sce, N=50) {
 nn = norm_scores(sce)
 t(apply(nn,1,function(x)mean(sort(x,decreasing=TRUE)[seq_len(N)])))
}
