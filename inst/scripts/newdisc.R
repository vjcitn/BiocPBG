# this script works from make_triples output for discretized pbmc3k
library(BiocPBG)
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
  entity_path = tempdir(), edge_paths = list('tr'="tr"), checkpoint_path = "cp3",
  dimension = 50L, dynamic_relations = FALSE, num_epochs=35L, num_gpus=1L )

tt = triples_to_hdf5( cc, c(train="./new.tsv"), pbgref = pbg, paref = palib )
train_eval( list(config=cc), pbg )

library(rhdf5)
cemb = h5read("cp2/embeddings_C_0.v35.h5", "embeddings")
save(cemb, file="cemb.rda")
library(uwot)
um = umap(t(cemb))
plot(um)
