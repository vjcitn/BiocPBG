
library(BiocPBG)
library(SingleCellExperiment)
load("../../data/t3knr.rda")

library(scran)
stats = modelGeneVar(assay(t3knr, "logcounts", withDimnames=FALSE))
dim(stats)
head(stats)
tt = getTopHVGs(stats, n=5000)

assays(t3knr)$disc = disc_matrix(assays(t3knr)$logcounts)
allt = make_triples(t3knr, "t3k.tsv")
