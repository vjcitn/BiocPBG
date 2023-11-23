#' cache and/or retrieve path to fb15k.tgz
#' @import BiocFileCache
#' @export
path_to_15k_tgz = function (cache = BiocFileCache::BiocFileCache()) 
{
    qans = BiocFileCache::bfcquery(cache, "fb15k.tgz")
    if (nrow(qans) > 0) 
        return(as.character(qans$rpath[1]))
    as.character(BiocFileCache::bfcadd(cache, "https://dl.fbaipublicfiles.com/starspace/fb15k.tgz", 
        rname = "fb15k.tgz", action = "copy", rtype = "web"))
}

#' set up folder with fb15k test data
#' @param exdir character(1) path to destination
#' @return vector of full paths to test data
#' @examples
#' tfold = fb15k_folder()
#" tfold
#' @export
fb15k_folder = function(exdir = tempdir()) {
  untar( path_to_15k_tgz(), exdir = exdir )
  dir(exdir, patt="freebase", full.names=TRUE, recursive=TRUE)
}

  

