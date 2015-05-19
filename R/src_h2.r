#' @import assertthat
#' @import DBI
#' @import RH2
#' @import dplyr
NULL

#' Connect to a H2 database.
#' 
#' @param x an URL for the H2 database connection as defined at \url{http://h2database.com/html/features.html#database_url}
#'  without the 'jdbc:h2:' prefix or a \code{\linkS4class{H2Connection}} object.
#'  If \code{x} is a path to a local file, than the '.h2.db' suffix, if present, is stripped off automatically.
#' @param src a h2 src created with \code{src_h2}.
#' @param from Either a string giving the name of table in database, or
#'   \code{\link{sql}} described a derived table or compound join.
#' @param ... for the src, other arguments passed on to the underlying
#'   database connector, \code{dbConnect}. For the tbl, included for
#'   compatibility with the generic, but otherwise ignored.
#' @export
src_h2 <- function(x) UseMethod("src_h2")

#' @rdname src_h2
#' @export
src_h2.character <- function(x, ...) {
  assert_that(requireNamespace("RH2", quietly = TRUE))
  con <- DBI::dbConnect(RH2::H2(), x, ...)
  src_h2(con, ...)
}

#' @rdname src_h2
#' @export
src_h2.H2Connection <- function(x, ...) {
  assert_that(requireNamespace("RH2", quietly = TRUE))
  info <- DBI::dbGetInfo(x)
  src_sql("h2", x, info = info, ...)
}

#' @export
#' @rdname src_h2
tbl.src_h2 <- function(src, from, ...) {
  tbl_sql("h2", src = src, from = from, ...)
}

#' @export
src_desc.src_h2 <- function(x) {
  info <- x$info

  sprintf("H2 %s [%s@%s]", x$database_product_version, x$user_name, x$url)
}

#' @export
src_translate_env.src_h2 <- function(x) {
  sql_variant(
    base_scalar,
    sql_translator(.parent = base_agg,
      n = function(arg="*") { build_sql("COUNT(", ident(arg), ")") }
    )
  )
}

# DBI methods ------------------------------------------------------------------
