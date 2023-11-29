#' update a SingleCellExperiment with UMAP reductions of 
#' embeddings produced with PyTorch-BigGraph
#' @param trout output of `BiocPBG::train_eval`
#' @param sce SingleCellExperiment instance derived from or consistent with
#' the one from which `trout` was produced
#' @param ncomp numeric(1) passed as `n_components` to `uwot::umap`
#' @param \dots named arguments other than `n` to be passed to `uwot::umap`
#' @return
#' The `sce` is updated to include a `reducedDim` component named `UMAP`
#' based on the cell embedding, and the
#' rowData component is updated to include the UMAP applied to gene
#' embedding
#' @export
umap_CG = function(trout, sce, ncomp=3, ...) {
  umapc = uwot::umap(t(trout$cemb), n_components=ncomp, ...)
  o = match(sce$Barcode, trout$cents)
  umapc = umapc[o,]
  umapg = uwot::umap(t(trout$gemb), n_components=ncomp, ...)
  o = match(rownames(sce), trout$gents)
  umapg = umapg[o,]
  colnames(umapg) = paste0("UM", seq_len(ncomp))
#  list(C_umap=umapc, G_umap=umapg)
  reducedDim(sce, "UMAP") <- umapc
  rowData(sce) = cbind(rowData(sce), umapg)
  sce
}

#' update a SingleCellExperiment with PCA (via irlba) reductions of 
#' embeddings produced with PyTorch-BigGraph
#' @param trout output of `BiocPBG::train_eval`
#' @param sce SingleCellExperiment instance derived from or consistent with
#' the one from which `trout` was produced
#' @param ncomp numeric(1) passed as `n` to `irlba::prcomp_irlba`
#' @param \dots named arguments other than `n` to be passed to irlba
#' @return
#' The `sce` is updated to include a `reducedDim` component named `PCA`
#' based on the cell embedding, and the
#' rowData component is updated to include the PCA applied to gene
#' embedding
#' @examples
#' data(nn50)
#' data(t3k)
#' twp = pca_CG(nn50, t3k)
#' pairs(reducedDim(twp, "PCA"), pch=19, col=factor(twp$celltype3))
#' @export
pca_CG = function(trout, sce, ncomp=3, ...) {
  pca_c = irlba::prcomp_irlba(t(trout$cemb), n=ncomp, ...)$x
  o = match(sce$Barcode, trout$cents)
  pca_c = pca_c[o,]
  pca_g = irlba::prcomp_irlba(t(trout$gemb), n=ncomp, ...)$x
  o = match(rownames(sce), trout$gents)
  pca_g = pca_g[o,]
  colnames(pca_g) = paste0("PCA", seq_len(ncomp))
#  list(C_pca_=pca_c, G_pca_=pca_g)
  reducedDim(sce, "PCA") <- pca_c
  rowData(sce) = cbind(rowData(sce), pca_g)
  sce
}
