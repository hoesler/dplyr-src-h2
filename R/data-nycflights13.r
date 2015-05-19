#' Database versions of the nycflights13 data
#'
#' These functions cache the data from the \code{nycflights13} database in
#' a local database, for use in examples and vignettes. Indexes are created
#' to making joining tables on natural keys efficient.
#'
#' @keywords internal
#' @name h2-nycflights13
NULL

#' @export
#' @rdname h2-nycflights13
#' @param path location of sqlite database file
nycflights13_h2 <- function(path = NULL) {
  cache_computation("nycflights_h2", {
    src <- src_h2("mem:nycflights")
    dplyr::copy_nycflights13(src)
  })
}

# Environment for caching connections etc
cache <- new.env(parent = emptyenv())

is_cached <- function(name) exists(name, envir = cache)
set_cache <- function(name, value) {
#   message("Setting ", name, " in cache")
  assign(name, value, envir = cache)
  value
}
get_cache <- function(name) {
#   message("Getting ", name, " from cache")
  get(name, envir = cache)
}

cache_computation <- function(name, computation) {
  if (is_cached(name)) {
    get_cache(name)
  } else {
    res <- force(computation)
    set_cache(name, res)
    res
  }
}