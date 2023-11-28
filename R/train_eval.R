
#' run training and evaluation
#' @param tripout list resulting from `triples_to_hdf5`
#' @param pbg torchbiggraph reference
#' @param evind numeric(1) index in edge_paths to use for evaluation
#' @note when a full set of train/validate/test paths are provided,
#' then evind should be set to 3
#' @examples
#' example(triples_to_hdf5)  # creates tt with tt$config
#' pyatt = import("attr")
#' tt2 = list()
#' tt2$config = pyatt$evolve(tt$config, num_epochs=4L, num_uniform_negs=1000L,
#'    num_gpus=1L)
#' train_eval(tt2, pbg)
#' @export
train_eval = function(tripout, pbg, evind=3) {
  ut = pbg$util
  ut$setup_logging()
  si = ut$SubprocessInitializer()
  config_py_path = system.file("python/fb15k_config_gpu.py", package="BiocPBG")
#  '/home/rstudio/.local/lib/python3.10/site-packages/torchbiggraph/examples/configs/fb15k_config_gpu.py'
  sl = ut$setup_logging
  si$register(sl, tripout$config$verbose)
  tmpf = reticulate::import("tempfile")
  ndir = tmpf$TemporaryDirectory(prefix="torchbiggraph_config_")
  uuid = reticulate::import("uuid")
  nname = uuid$uuid4()$hex
  file.copy(config_py_path, paste0(ndir$name, "/", nname, ".py"))
  si$register(pbg$config$add_to_sys_path,  ndir) 
  
  pyatt = import("attr")
  trc = pyatt$evolve(tripout$config, 
  	edge_paths=list(tripout$config$edge_paths[[1]]))

  pbg$train$train(trc, subprocess_init=si)
  
  nr = lapply( trc$relations, function(x) pyatt$evolve(x, all_negs=TRUE))
  trc2 = pyatt$evolve(trc, edge_paths = list(tripout$config$edge_paths[[evind]]),
      relations=nr, num_uniform_negs = 0L)
  pbg$eval$do_eval(trc2, subprocess_init = si)
}

