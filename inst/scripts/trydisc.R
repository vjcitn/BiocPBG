# this script works from make_triples output for discretized pbmc3k

library(BiocPBG)
tfis = c(train="./tr.tsv", valid="./va.tsv", test="./te.tsv")
edp = gsub(".tsv$", ".partitioned", tfis)
pbg = reticulate::import("torchbiggraph")
palib = reticulate::import("pathlib")
ent = make_entity_schema(pbgref=pbg)
entities=reticulate::dict(all=ent)


entC = make_entity_schema(pbgref = pbg)
entG = make_entity_schema(pbgref = pbg)
ents = list(C = entC, G = entG)

rels = paste0("r", 0:4)
wts = 1.0+(0:4)
rels = lapply(1:5, function(x) make_rel_schema(name = rels[x], lhs='C', rhs='G',
   weight = wts[x], operator='none', all_negs = FALSE, pbgref = pbg))

cc = setup_config_schema(pbgref = pbg, entities = ents, relations = rels,
  entity_path = tempdir(), edge_paths = c("tr", "va", "te"), checkpoint_path = "cp",
  dimension = 50L, dynamic_relations = FALSE, num_epochs=5L )

tt = triples_to_hdf5( cc, tfis, pbgref = pbg, paref = palib )
train_eval( list(config=cc), pbg )

library(rhdf5)
cemb = h5read("cp/embeddings_C_0.v5.h5", "embeddings")
library(uwot)
um = umap(t(cemb))
plot(um)
