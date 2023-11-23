
    pbg_config = reticulate::dict(  
        # I/O data
        entity_path="data/FB15k",
        edge_paths=list(
            "data/FB15k/freebase_mtr100_mte100-train_partitioned",
            "data/FB15k/freebase_mtr100_mte100-valid_partitioned",
            "data/FB15k/freebase_mtr100_mte100-test_partitioned"
        ),
        checkpoint_path="model/fb15k",
        # Graph structure
#        #entities={"all": {"num_partitions": 1}},
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
        num_epochs=50L,
        batch_size=5000L,
        num_uniform_negs=1000L,
        loss_fn="softmax",
        lr=0.1,
        regularization_coef=1e-3,
        # Evaluation during training
        eval_fraction=0.0,
        # GPU
        num_gpus=1L
)
#    )
#
