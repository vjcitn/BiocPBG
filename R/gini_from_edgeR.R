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

#' obtain the simba max metric for genes
#' @param sce SingleCellExperiment with simba scores available
