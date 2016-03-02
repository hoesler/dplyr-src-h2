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
#' @param use_cache Use cached database if present.
#' @param clear_cache Remove database from cache if present.
#' @rdname h2-nycflights13
nycflights13_h2 <- function(use_cache = TRUE, clear_cache = FALSE) {
  if (use_cache) {
    cache_load("nycflights_h2", {
      nycflights_h2_create()
    }, clear_cache)
  } else {
    nycflights_h2_create()
  }
}

nycflights_h2_create <- function() {
  url <- getOption("nycflights.h2.url")
  if (is.null(url)) {
    url <- paste0(tempfile("nycflights"), "/nycflights")
  }
  src <- src_h2(url)
  message("Caching nycflights db at ", url)
  dplyr::copy_nycflights13(src)
}

# Environment for caching
cache <- new.env(parent = emptyenv())

is_cached <- function(name) exists(name, envir = cache)

cache_insert <- function(name, value) {
  assign(name, value, envir = cache)
}

cache_get <- function(name) {
  get(name, envir = cache)
}

cache_rm <- function(name) {
  if (is_cached(name)) {
    rm(name, envir = cache)
  }
}

cache_load <- function(name, computation, force = FALSE) { 
  if (!force && is_cached(name)) {
    cache_get(name)
  } else {
    res <- force(computation)
    cache_insert(name, res)
    res
  }
}