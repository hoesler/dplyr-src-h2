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
nycflights13_h2 <- function() {
  cache_load("nycflights_h2", {
    src <- src_h2("mem:nycflights")
    dplyr::copy_nycflights13(src)
  })
}

# Environment for caching
cache <- new.env(parent = emptyenv())

is_cached <- function(name) exists(name, envir = cache)
cache_insert <- function(name, value) {
  assign(name, value, envir = cache)
  value
}
cache_get <- function(name) {
  get(name, envir = cache)
}

cache_load <- function(name, computation) {
  if (is_cached(name)) {
    cache_get(name)
  } else {
    res <- force(computation)
    cache_insert(name, res)
    res
  }
}