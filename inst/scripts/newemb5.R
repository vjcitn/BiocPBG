

# this script works from make_triples output for discretized pbmc3k
# used to revise nn50.rda on 2 Dec 2023 to deal with duplicated rownames

Sys.setenv("RETICULATE_PYTHON"="/usr/bin/python3.10")

library(BiocPBG)
library(SingleCellExperiment)
data(t3k)
rownames(t3k) = make.names(rownames(t3k), unique=TRUE)
print(length(unique(rownames(t3k))))
#
pbg = import("torchbiggraph")
palib = import("pathlib")
   


nn5b = sce_to_embeddings(t3k, "myfold5b", N_EPOCHS=5L, BATCH_SIZE=1000L,
    N_GENES=5000L, N_GPUS=0L, pbg=pbg, palib=palib)
save(nn5b, file="nn5b.rda")
