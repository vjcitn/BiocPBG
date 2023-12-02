

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
   
sce_to_embeddings = function(sce, workdir, N_EPOCHS, N_GENES, N_GPUS=1L, 
   BATCH_SIZE=100000L, pbg, palib) {

   stopifnot(dir.exists(workdir))

   N_EPOCHS = as.integer(N_EPOCHS)
   N_GENES = as.integer(N_GENES)
   BATCH_SIZE = as.integer(BATCH_SIZE)

   owd = getwd()
   setwd(workdir)
   on.exit(setwd(owd))

   sce_to_triples(sce, "basic.tsv", ngenes=N_GENES)
   
   
   entC = make_entity_schema(pbgref = pbg)
   entG = make_entity_schema(pbgref = pbg)
   ents = list(C = entC, G = entG)
   
   rels = paste0("r", 0:4)
   wts = 1.0+(0:4)
   rels = lapply(1:5, function(x) make_rel_schema(name = rels[x], lhs='C', rhs='G',
      weight = wts[x], operator='none', all_negs = FALSE, pbgref = pbg))

   epath = sprintf("./ents%d", N_EPOCHS) 
   
   cc = setup_config_schema(pbgref = pbg, entities = ents, relations = rels,
     entity_path = epath, batch_size=BATCH_SIZE,
     edge_paths = list('tr'="tr"), checkpoint_path = sprintf("cp%d", N_EPOCHS),
     dimension = 50L, dynamic_relations = FALSE, num_epochs=N_EPOCHS, num_gpus=N_GPUS )
   
   tt = triples_to_hdf5( cc, c(train="./basic.tsv"), pbgref = pbg, paref = palib )
   train_eval( list(config=cc), pbg ,evind=1)
   
#   system(sprintf("cp -r cp%d /tmp/KEEP", N_EPOCHS))
#   system(sprintf("cp -r ents%d /tmp/KEEP", N_EPOCHS))
#   library(rhdf5)

   cembpath = sprintf("cp%d/embeddings_C_0.v%d.h5", N_EPOCHS, N_EPOCHS)
   gembpath = sprintf("cp%d/embeddings_G_0.v%d.h5", N_EPOCHS, N_EPOCHS)

#   outcemb = sprintf("cemb%d.rda", N_EPOCHS)
   
#   assign(cob<-paste0("cemb", N_EPOCHS), rhdf5::h5read(embpath, "embeddings"))
   cemb = rhdf5::h5read(cembpath, "embeddings")
   gemb = rhdf5::h5read(gembpath, "embeddings")

# dynamic_rel_names.json  entity_count_G_0.txt   entity_names_G_0.json
# entity_count_C_0.txt    entity_names_C_0.json
   cents = jsonlite::fromJSON(paste0(epath, "/", "entity_names_C_0.json"))
   gents = jsonlite::fromJSON(paste0(epath, "/", "entity_names_G_0.json"))

#   save(list=cob, file=paste0(cob, ".rda")) # "cemb20.rda")
#   library(uwot)
#   um = umap(t(get(cob)))
#   plot(um)
#   dev.off()
  mc = match.call()
  list(cemb=cemb, gemb=gemb, cents=cents, gents=gents, call=mc, config=cc)
}


nn50b = sce_to_embeddings(t3k, "myfold50b", N_EPOCHS=50L, BATCH_SIZE=100000L,
    N_GENES=5000L, N_GPUS=1L, pbg=pbg, palib=palib)
save(nn50b, file="/tmp/KEEP/nn50b.rda")
