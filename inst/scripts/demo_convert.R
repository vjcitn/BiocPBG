        
# this program sets up test, train and validate triple folders
# from fb15k_folder(), then set up configuration so that
# convert_input_data will succeed in producing hdf5 'input' for embedding

library(BiocPBG)
library(reticulate)
palib = reticulate::import("pathlib")
pbg = try(reticulate::import("torchbiggraph"))

fb_txt_paths = fb15k_folder() # .txt files
fb_part_paths = gsub(".txt", "_partitioned", fb_txt_paths)

edge_paths = vector("list", length(fb_part_paths))
for (i in seq_len(length(fb_part_paths))) edge_paths[[i]] = fb_part_paths[i]

root_folder = dirname(fb_txt_paths[1])

txtpl = reticulate::r_to_py(lapply(fb_txt_paths, function(x) palib$Path(x)))

rs = pbg$config$RelationSchema(name='all_edges', 
                lhs='all', rhs='all', weight=1.0, 
                operator='complex_diagonal', all_negs=FALSE)

ent = pbg$config$EntitySchema(num_partitions=1L)
pbg$converters$importers$convert_input_data(
       reticulate::dict(all=ent),
       list(rs),
       root_folder,
       edge_paths,
       txtpl,  # input
       pbg$converters$importers$TSVEdgelistReader(lhs_col=0L, rhs_col=2L, rel_col=1L),
       dynamic_relations = TRUE)

