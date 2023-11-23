#' produce configuration torchbiggraph fun, with defaults for FB15k test
#' @param entity_path character(1) path to entity text
#' @examples
#' fbpaths = fb15k_folder() # .txt files
#' ppaths = gsub(".txt", "_partitioned", fbpaths)
#' fbpl = lapply(fbpaths, force)
#' pppl = lapply(ppaths, force) # vec2list
#' pbg = try(reticulate::import("torchbiggraph"))
#' if (!inherits(pbg, "try-error")) {
#'   confdict = make_pbg_config(entity_path = dirname(fbpl[[1]]),
#'                                edge_paths=fbpl)
#'   pbg$converters$importers$convert_input_data( pbg$config$EntitySchema(num_partitions=1L),
#'       confdict$relations,
#'       confdict$entity_path, confdict$edge_paths,
#'       pppl, # input edge paths
#'       pbg$converters$importers$TSVEdgeListReader(lhs_col=0L, rhs_col=2L, rel_col=1L),
#'       dynamic_relations = confdict$dynamic_relations)
#' }
#' @export
make_pbg_config = function(
        # I/O data
        entity_path="data/FB15k",
        edge_paths=list(
            "data/FB15k/freebase_mtr100_mte100-train_partitioned",
            "data/FB15k/freebase_mtr100_mte100-valid_partitioned",
            "data/FB15k/freebase_mtr100_mte100-test_partitioned"
        ), checkpoint_path="model/fb15k",
        entities=list("all"=list("num_partitions"=1L)),
        relations=list(
            list(
                "name"= "all_edges",
                "lhs"= "all",
                "rhs"= "all",
                "operator"= "complex_diagonal"
            )
        ),
        dynamic_relations=TRUE,
#        # Scoring model
        dimension=400L,
        global_emb=FALSE,
        comparator="dot",
#        # Training
        num_epochs=50L, batch_size=5000L, num_uniform_negs=1000L,
        loss_fn="softmax", lr=0.1, regularization_coef=1e-3,
        # Evaluation during training
        eval_fraction=0.0,
        # GPU
        num_gpus=1L
) {
    reticulate::dict(  
        # I/O data
        entity_path=entity_path,
        edge_paths=edge_paths,
        checkpoint_path=checkpoint_path,
        # Graph structure
#        #entities={"all": {"num_partitions": 1}},
        entities=entities,
        relations=relations,
        dynamic_relations=dynamic_relations,
#        # Scoring model
        dimension=dimension,
        global_emb=global_emb,
        comparator=comparator,
#        # Training
        num_epochs=num_epochs,
        batch_size=batch_size,
        num_uniform_negs=num_uniform_negs,
        loss_fn=loss_fn,
        lr=lr,
        regularization_coef=regularization_coef,
        # Evaluation during training
        eval_fraction=eval_fraction,
        # GPU
        num_gpus=num_gpus
)
}

# candidates:
# |  ConfigSchema(*
##  entities: Dict[str
##  torchbiggraph.config.EntitySchema]
##  relations: List[torchbiggraph.config.RelationSchema]
##  dimension: int
##  init_scale: float = 0.001
##  max_norm: Optional[float] = None
##  global_emb: bool = True
##  comparator: str = 'cos'
##  bias: bool = False
##  loss_fn: str = 'ranking'
##  margin: float = 0.1
##  regularization_coef: float = 0
##  regularizer: str = 'N3'
##  entity_path: str
##  edge_paths: List[str]
##  checkpoint_path: str
##  init_path: Optional[str] = None
##  checkpoint_preservation_interval: Optional[int] = None
##  num_epochs: int = 1
##  num_edge_chunks: Optional[int] = None
##  max_edges_per_chunk: int = 1000000000
##  bucket_order: torchbiggraph.config.BucketOrder = <BucketOrder.INSIDE_OUT: 'inside_out'>
##  workers: Optional[int] = None
##  batch_size: int = 1000
##  num_batch_negs: int = 50
##  num_uniform_negs: int = 50
##  disable_lhs_negs: bool = False
##  disable_rhs_negs: bool = False
##  lr: float = 0.01
##  relation_lr: Optional[float] = None
##  eval_fraction: float = 0.05
##  eval_num_batch_negs: Optional[int] = 1000
##  eval_num_uniform_negs: Optional[int] = 1000
##  background_io: bool = False
##  verbose: int = 0
##  hogwild_delay: float = 2
##  dynamic_relations: bool = False
##  num_machines: int = 1
##  num_partition_servers: int = -1
##  distributed_init_method: Optional[str] = None
##  distributed_tree_init_order: bool = True
##  num_gpus: int = 0
##  num_groups_for_partition_server: int = 16
##  num_groups_per_sharded_partition_server: int = 1
##  partition_shard_size: int = 250
##  half_precision: bool = False) -> None
## #
