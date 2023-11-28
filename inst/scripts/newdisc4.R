
# this script works from make_triples output for discretized pbmc3k

Sys.setenv("RETICULATE_PYTHON"="/usr/bin/python3.10")
N_EPOCHS = 30L
N_GENES = 2000L
embpath = sprintf("cp%d/embeddings_C_0.v%d.h5", N_EPOCHS, N_EPOCHS)
outcemb = sprintf("cemb%d.rda", N_EPOCHS)

library(BiocPBG)
library(SingleCellExperiment)
data(t3k)

sce_to_triples(t3k, "t3k.tsv", ngenes=N_GENES)

pbg = import("torchbiggraph")
palib = import("pathlib")

entC = make_entity_schema(pbgref = pbg)
entG = make_entity_schema(pbgref = pbg)
ents = list(C = entC, G = entG)

rels = paste0("r", 0:4)
wts = 1.0+(0:4)
rels = lapply(1:5, function(x) make_rel_schema(name = rels[x], lhs='C', rhs='G',
   weight = wts[x], operator='none', all_negs = FALSE, pbgref = pbg))

cc = setup_config_schema(pbgref = pbg, entities = ents, relations = rels,
  entity_path = sprintf("./ents%d", N_EPOCHS), 
  edge_paths = list('tr'="tr"), checkpoint_path = sprintf("cp%d", N_EPOCHS),
  dimension = 50L, dynamic_relations = FALSE, num_epochs=N_EPOCHS, num_gpus=1L )

tt = triples_to_hdf5( cc, c(train="./t3k.tsv"), pbgref = pbg, paref = palib )
train_eval( list(config=cc), pbg ,evind=1)

system(sprintf("cp -r cp%d /tmp/KEEP", N_EPOCHS))
system(sprintf("cp -r ents%d /tmp/KEEP", N_EPOCHS))
library(rhdf5)

assign(cob <- paste0("cemb", N_EPOCHS), h5read(embpath, "embeddings"))
save(get(cob), file=paste0(cob, ".rda")) # "cemb20.rda")
library(uwot)
um = umap(t(get(cob)))
plot(um)
dev.off()
