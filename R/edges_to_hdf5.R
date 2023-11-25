#' produce RelationSchema for torchbiggraph configuration
#' @param name character(1)
#' @param lhs character(1)
#' @param rhs character(1)
#' @param weight numeric(1)
#' @param operator character(1)
#' @param all_negs character(1)
#' @param pbgref python reference to torchbiggraph module
#' @export
make_rel_schema = function(name='all_edges', lhs='all', rhs='all', weight=1.0,
    operator='complex_diagonal', all_negs=FALSE, pbgref) {
  pbgref$config$RelationSchema(name=name,
                lhs=lhs, rhs=rhs, weight=weight,
                operator=operator, all_negs=all_negs)
}

#' produce HDF5 files for edges defined in tsv files of triples (left, rel, right)
#' @param triple_paths character(3) with test, train, valid edge sets in order
#' @param num_partitions integer(1)
#' @param relname character(1), passed to make_rel_schema
#' @param lhs character(1), passed to make_rel_schema
#' @param rhs character(1), passed to make_rel_schema
#' @param weight numeric(1), passed to make_rel_schema
#' @param operator character(1), passed to make_rel_schema
#' @param all_negs character(1), passed to make_rel_schema
#' @param pbgref python reference to torchbiggraph module
#' @param pathlibref python reference to pathlib module
#' @examples
#' tfis = fb15k_folder()
#' pbg = reticulate::import("torchbiggraph")
#' palib = reticulate::import("pathlib")
#' nn = triples_to_hdf5(tfis, pbgref = pbg, pathlibref=palib)
#' nn
#' rhdf5::h5ls(dir(nn$edge_paths[[1]], full=TRUE))
#' @export
triples_to_hdf5_raw = function(triple_paths, num_partitions=1L, 
  relname = 'all_edges', lhs='all', rhs='all', weight=1.0,
    operator='complex_diagonal', all_negs=FALSE, pbgref,
   pathlibref) {
  ent = pbgref$config$EntitySchema(num_partitions=num_partitions)
  rs = make_rel_schema( name=relname,
                lhs=lhs, rhs=rhs, weight=weight,
                operator=operator, all_negs=all_negs, pbgref=pbgref)

  triple_paths = unname(triple_paths)
  root_folder = dirname(triple_paths[1])
  part_paths = gsub(".txt", "_partitioned", triple_paths)
  edge_paths = vector("list", length(part_paths))
  for (i in seq_len(length(part_paths))) edge_paths[[i]] = part_paths[i]
  txtpl = reticulate::r_to_py(lapply(triple_paths, function(x) palib$Path(x)))
  triple_reader = pbgref$converters$importers$TSVEdgelistReader(lhs_col=0L, rhs_col=2L, rel_col=1L)
#
# it appears that convert_input_data uses positional 
# argument management
#
  pbgref$converters$importers$convert_input_data(
       reticulate::dict(all=ent),
       list(rs),
       root_folder,
       edge_paths,
       txtpl,  # input
       triple_reader,
       dynamic_relations = TRUE)
  list(edge_paths = edge_paths, relations = list(rs))
}

#' use config object
#' @param config ConfigSchema instance from `setup_config_schema`
#' @param trvate_triple_paths character(3) paths to train, validation, test triple files
#' @param dynamic_relation logical(1)
#' @param lhs_col integer(1) position of lhs in triple tsv file
#' @param rhs_col integer(1) position of rhs in triple tsv file
#' @param rel_col integer(1) position of relation in triple tsv file
#' @param pbgref python reference to torchbiggraph module
#' @param paref python reference to pathlib module
#' @examples
#' tfis = fb15k_folder()
#' edp = gsub(".txt$", "partitioned", tfis)
#' pbg = reticulate::import("torchbiggraph")
#' palib = reticulate::import("pathlib")
#' ent = make_entity_schema(pbgref=pbg)
#' entities=reticulate::dict(all=ent)
#' rs = BiocPBG::make_rel_schema(pbgref=pbg)
#' cs = setup_config_schema( pbgref = pbg, entities = entities,
#'    relations = list(rs), entity_path = paste0(tempdir(), "/uconf"), edge_paths = edp,
#'    checkpoint_path = paste0(tempdir(), "/uconf/chk"))
#' tt = triples_to_hdf5( cs, tfis, pbgref = pbg, paref = palib )
#' @export
triples_to_hdf5 = function(config, trvate_triple_paths, dynamic_relations = FALSE,
  lhs_col=0L, rhs_col=2L, rel_col=1L, pbgref, paref) {
  stopifnot(inherits(trvate_triple_paths, "character"))
  trpaths = reticulate::r_to_py(unname(lapply(trvate_triple_paths,
      paref$Path)))
  ans = pbgref$converters$importers$convert_input_data(
    config$entities,
    config$relations,
    config$entity_path,
    config$edge_paths,
    trpaths,
    pbgref$converters$importers$TSVEdgelistReader(lhs_col=lhs_col, rhs_col=rhs_col, rel_col=rel_col),
    dynamic_relations = config$dynamic_relations)
  list(config=config, trpaths=trpaths)
}
    
