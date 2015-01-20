#' @import assertthat
#' @import DBI
#' @import RH2
#' @import dplyr
NULL

#' Connect to a H2 database.
#' 
#' @export
src_h2 <- function(x) UseMethod("src_h2")

#' @param uri the URI for the database of a path to a file which will be converted into an URI.
#' @param user the username
#' @param password the password for the user
#' @rdname src_h2
src_h2.character <- function(uri, user = "sa", password = "", ...) {
  assert_that(requireNamespace("RH2", quietly = TRUE))
  con <- DBI::dbConnect(RH2::H2(), uri, user, password)
  src_h2(con, ...)
}

#' @param con a \code{\linkS4class{H2Connection}} object
#' @rdname src_h2
src_h2.H2Connection <- function(con, ...) {
  assert_that(requireNamespace("RH2", quietly = TRUE))
  info <- DBI::dbGetInfo(con)
  src_sql("h2", src = con, info, ...)
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