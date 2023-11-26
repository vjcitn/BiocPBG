#  def __init__(self) -> None:
#        self.config_dir = tempfile.TemporaryDirectory(  # noqa
#            prefix="torchbiggraph_config_"
#        )

#        module_name = f"torchbiggraph_config_{uuid.uuid4().hex}"
#        shutil.copyfile(path, os.path.join(self.config_dir.name, f"{module_name}

library(BiocPBG)
example(triples_to_hdf5)  # creates tt with tt$config
ut = pbg$util
ut$setup_logging()
si = ut$SubprocessInitializer()
config_py_path = '/home/rstudio/.local/lib/python3.10/site-packages/torchbiggraph/examples/configs/fb15k_config_gpu.py'
#cc = cfl$load_config(config_py_path, NULL)
sl = ut$setup_logging
si$register(sl, 0L)
tmpf = import("tempfile")
ndir = tmpf$TemporaryDirectory(prefix="torchbiggraph_config_")
uuid = import("uuid")
nname = uuid$uuid4()$hex
file.copy(config_py_path, paste0(ndir$name, "/", nname, ".py"))
si$register(pbg$config$add_to_sys_path,  ndir) 

pyatt = import("attr")
trc = pyatt$evolve(tt$config, num_uniform_negs=1000L,   num_epochs=4L,
		   num_gpus=1L, edge_paths=list(tt$config$edge_paths[[1]]))
pbg$train$train(trc, subprocess_init=si)
