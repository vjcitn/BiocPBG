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

#' set up folder with fb15k demo data
#' @param exdir character(1) path to destination
#' @return vector of full paths to demo data
#' @note vector returned is named with 'train', 'test', 'valid' for downstream ordering
#' @examples
#' tfold = fb15k_folder()
#" tfold
#' @export
fb15k_folder = function(exdir = tempdir()) {
  untar( path_to_15k_tgz(), exdir = exdir )
  ans = dir(exdir, patt="freebase", full.names=TRUE, recursive=TRUE)
  trind = grep("train", ans)
  teind = grep("test", ans)
  vaind = grep("valid", ans)
  ans = ans[c(trind, teind, vaind)]
  names(ans) = c("train", "test", "valid")
  ans
}

  

