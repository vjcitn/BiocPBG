
#' make ConfigSchema
#' @param pbgref instance of torchbiggraph module
#' @param entities EntitySchema instance
#' @param relations list of RelationSchema instances
#' @examples
#' pbgref = reticulate::import("torchbiggraph")
#' ent = make_entity_schema(pbgref=pbgref)
#' entities=reticulate::dict(all=ent)
#' rs = BiocPBG::make_rel_schema(pbgref=pbgref)
#' cs = setup_config_schema( pbgref = pbgref, entities = entities,
#'    relations = list(rs), entity_path = tempdir(), edge_paths = c("tr", "va", "te"),
#'    checkpoint_path = "cp" )
#' cs
#' @export
setup_config_schema = function( pbgref, entities, relations, entity_path,
 edge_paths, checkpoint_path,
 dimension=400L, init_scale=0.001, max_norm=NULL, global_emb=FALSE, comparator='dot',
 bias=FALSE, loss_fn='softmax', margin=0.1, regularization_coef=0.001, regularizer='N3',
 init_path=NULL, checkpoint_preservation_interval=NULL, num_epochs=50L,
 num_edge_chunks=NULL, max_edges_per_chunk=1000000000L, 
 bucket_order=pbgref$config$BucketOrder$INSIDE_OUT,
 workers=NULL, batch_size=1000L, num_batch_negs=50L, num_uniform_negs=1000L,
 disable_lhs_negs=FALSE, disable_rhs_negs=FALSE, lr=0.1, relation_lr=NULL,
 eval_fraction=0.0, eval_num_batch_negs=1000L, eval_num_uniform_negs=1000L, background_io=FALSE,
 verbose=0L, hogwild_delay=2.0, dynamic_relations=TRUE, num_machines=1L,
 num_partition_servers=-1L, distributed_init_method=NULL, distributed_tree_init_order=TRUE, num_gpus=0L,
 num_groups_for_partition_server=16L, num_groups_per_sharded_partition_server=1L, 
 partition_shard_size=250L, half_precision=FALSE) {
 pbgref$config$ConfigSchema(
  entities = entities, relations=relations,
  entity_path = entity_path, edge_paths = edge_paths, checkpoint_path = checkpoint_path,
  dimension=dimension,
  init_scale=init_scale,
  global_emb=global_emb,
  comparator=comparator,
  bias=bias,
  loss_fn=loss_fn,
  margin=margin,
  regularization_coef=regularization_coef,
  regularizer=regularizer,
  num_epochs=num_epochs,
  max_edges_per_chunk=max_edges_per_chunk,
  bucket_order = bucket_order,
  batch_size=batch_size,
  num_batch_negs=num_batch_negs,
  num_uniform_negs=num_uniform_negs,
  disable_lhs_negs=disable_lhs_negs,
  disable_rhs_negs=disable_rhs_negs,
  lr=lr,
  eval_fraction=eval_fraction,
  eval_num_batch_negs=eval_num_batch_negs,
  eval_num_uniform_negs=eval_num_uniform_negs,
  background_io=background_io,
  verbose=verbose,
  hogwild_delay=hogwild_delay,
  dynamic_relations=dynamic_relations,
  num_machines=num_machines,
  num_partition_servers=num_partition_servers,
  distributed_tree_init_order=distributed_tree_init_order,
  num_gpus=num_gpus,
  num_groups_for_partition_server=num_groups_for_partition_server,
  num_groups_per_sharded_partition_server=num_groups_per_sharded_partition_server
)
}
#
#class ConfigSchema(torchbiggraph.schema.Schema)
# |  ConfigSchema(*,
# entities: Dict[str,
# torchbiggraph.config.EntitySchema],
# relations: List[torchbiggraph.config.RelationSchema],
# dimension: int,
# init_scale: float = 0.001,
# max_norm: Optional[float] = None,
# global_emb: bool = True,
# comparator: str = 'cos',
# bias: bool = False,
# loss_fn: str = 'ranking',
# margin: float = 0.1,
# regularization_coef: float = 0,
# regularizer: str = 'N3',
# entity_path: str,
# edge_paths: List[str],
# checkpoint_path: str,
# init_path: Optional[str] = None,
# checkpoint_preservation_interval: Optional[int] = None,
# num_epochs: int = 1,
# num_edge_chunks: Optional[int] = None,
# max_edges_per_chunk: int = 1000000000,
# bucket_order: torchbiggraph.config.BucketOrder = <BucketOrder.INSIDE_OUT: 'inside_out'>,
# workers: Optional[int] = None,
# batch_size: int = 1000,
# num_batch_negs: int = 50,
# num_uniform_negs: int = 50,
# disable_lhs_negs: bool = False,
# disable_rhs_negs: bool = False,
# lr: float = 0.01,
# relation_lr: Optional[float] = None,
# eval_fraction: float = 0.05,
# eval_num_batch_negs: Optional[int] = 1000,
# eval_num_uniform_negs: Optional[int] = 1000,
# background_io: bool = False,
# verbose: int = 0,
# hogwild_delay: float = 2,
# dynamic_relations: bool = False,
# num_machines: int = 1,
# num_partition_servers: int = -1,
# distributed_init_method: Optional[str] = None,
# distributed_tree_init_order: bool = True,
# num_gpus: int = 0,
# num_groups_for_partition_server: int = 16,
# num_groups_per_sharded_partition_server: int = 1,
# partition_shard_size: int = 250,
# half_precision: bool = False) -> None
#

#ConfigSchema(entities={'C': EntitySchema(num_partitions=1, featurized=False, dimension=None), 'G': EntitySchema(num_partitions=1, featurized=False, dimension=None)}, relations=[RelationSchema(name='r0', lhs='C', rhs='G', weight=1.0, operator='none', all_negs=False), RelationSchema(name='r1', lhs='C', rhs='G', weight=2.0, operator='none', all_negs=False), RelationSchema(name='r2', lhs='C', rhs='G', weight=3.0, operator='none', all_negs=False), RelationSchema(name='r3', lhs='C', rhs='G', weight=4.0, operator='none', all_negs=False), RelationSchema(name='r4', lhs='C', rhs='G', weight=5.0, operator='none', all_negs=False)], dimension=50, init_scale=0.001, max_norm=None, global_emb=False, comparator='dot', bias=False, loss_fn='softmax', margin=0.1, regularization_coef=0.0, regularizer='N3', wd=0.015495, wd_interval=10, entity_path='result_simba_rnaseq/pbg/graph0/input/entity', edge_paths=['result_simba_rnaseq/pbg/graph0/input/edge'], checkpoint_path='result_simba_rnaseq/pbg/graph0/model', init_path=None, checkpoint_preservation_interval=None, num_epochs=10, num_edge_chunks=None, max_edges_per_chunk=1000000000, bucket_order=<BucketOrder.INSIDE_OUT: 'inside_out'>, workers=12, batch_size=1000, num_batch_negs=50, num_uniform_negs=50, disable_lhs_negs=False, disable_rhs_negs=False, lr=0.1, relation_lr=None, eval_fraction=0.05, eval_num_batch_negs=50, eval_num_uniform_negs=50, early_stopping=False, background_io=False, verbose=0, hogwild_delay=2, dynamic_relations=False, num_machines=1, num_partition_servers=-1, distributed_init_method=None, distributed_tree_init_order=True, num_gpus=0, num_groups_for_partition_server=16, half_precision=False)

library(BiocPBG)
pbg = import("torchbiggraph")

entC = make_entity_schema(pbgref = pbg)
entG = make_entity_schema(pbgref = pbg)
ents = list(C = entC, G = entG)

rels = paste0("r", 0:4)
wts = 1.0+(0:4)
rels = lapply(1:5, function(x) make_rel_schema(name = rels[x], lhs='C', rhs='G',
   weight = wts[x], operator='none', all_negs = NULL, pbgref = pbg))

rel0 = make_rel_schema(name = 'r0', lhs='C', rhs='G', weight=1.0, operator='none',
   all_negs = NULL, pbgref = pbg)

cc = setup_config_schema(pbgref = pbg, entities = ents, relations = rels,
  entity_path = tempdir(), edge_paths = c("tr", "va", "te"), checkpoint_path = "cp",
  dimension = 50L, dynamic_relations = FALSE )
