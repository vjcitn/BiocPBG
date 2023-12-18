#' Helper function to recursively flatten nested lists
#' produced by Chat-GPT 3
#' @param x list as produced by fromJSON
#' @param prefix character(1)
flatten_json <- function(x, prefix = "") {
  out <- list()
  for (key in names(x)) {
    new_key <- if (prefix == "") key else paste(prefix, key, sep = "_")
    if (is.list(x[[key]])) {
      out <- c(out, flatten_json(x[[key]], new_key))
    } else {
      out[[new_key]] <- x[[key]]
    }
  }
  return(out)
}

#' get pbg_metrics data frames
#' @importFrom jsonlite fromJSON
#' @param simba_ref reference to simba module
#' @param gg_dirname character(1) the dirname specified for build_and_train_pbg,
#' defaults to 'graph0'
#' @param tr_output character(1) the output specified for build_and_train_pbg
#' defaults to 'model'
#' @param jsonpath character(1) path to training_stats.json
#' @return a list with two data.frames of training statistics
#' @examples
#' # full run-based, commented out as too long
#' # p3k = get_10x3kpbmc_path(overwrite=TRUE) # allow repetition
#' # ref = simba_ref()
#' # pp = ref$read_h5ad(p3k)
#' # bb = basic_preproc(pp, simba_ref=ref)
#' # gg = build_and_train_pbg( bb, simba_ref=ref )
#' # ts = ingest_training_stats(ref)
#' # head(ts$df1)
#' #
#' # use archived pbg output
#' #
#' tpath = system.file(file.path("extdata", "pbg3k.tar.xz"), package="Simba4Bioc")
#' untar(tpath, exdir = tempdir())
#' jsonpath = paste0(tempdir(), "/pbg/graph0/model/training_stats.json")
#' ts = ingest_training_stats(jsonpath=jsonpath)
#' head(ts$df1)
#' @export
ingest_training_stats = function(simba_ref,
  gg_dirname = 'graph0', tr_output = 'model', jsonpath) {
  if (missing(jsonpath)) jsonpath = sprintf(
     paste0(simba_ref$settings$workdir, "/pbg/%s/%s/training_stats.json"),
     gg_dirname, tr_output)
  txt = readLines(jsonpath)
  parsed_stats = lapply(txt, jsonlite::fromJSON)
  # seems to be alternating document schemata
  ntxt = length(parsed_stats)
  odd = seq(1, ntxt, 2)
  ev = seq(2, ntxt, 2)
  df1 = do.call(rbind, lapply(parsed_stats[odd], 
     function(x) data.frame(flatten_json(x)))) 
  df2 = do.call(rbind, lapply(parsed_stats[ev], 
     function(x) data.frame(flatten_json(x)))) 
  list(df1=df1, df2=df2)
}
