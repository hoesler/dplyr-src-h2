#' @import assertthat
#' @import DBI
#' @import dbj
#' @import dplyr
NULL

setClass("H2JDBCConnection", contains = c("JDBCConnection"))

drv_h2 <- function() {
  dbj::driver('org.h2.Driver', maven_jar('com.h2database', 'h2', '1.3.176'))
}

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
src_h2 <- function(x, ...) {
  assert_that(requireNamespace("dbj.h2", quietly = TRUE))
  h2_driver <- drv_h2()
  url <- sprintf("jdbc:h2:%s", sub("^(.*)\\.h2\\.db$", "\\1", x))
  dbj_connection <- DBI::dbConnect(h2_driver, url, ...)
  h2_connection <- new("H2JDBCConnection", dbj_connection)
  info <- DBI::dbGetInfo(h2_connection)
  src_sql("h2", h2_connection, info = info, ...)
}

#' @export
#' @rdname src_h2
tbl.src_h2 <- function(src, from, ...) {
  tbl_sql("h2", src = src, from = from, ...)
}

#' @export
#' @rdname src_h2
src_desc.src_h2 <- function(x) {
  info <- x$info
  with(info, sprintf("%s %s [%s@%s]", dbname, db.version, username, url))
}

#' @export
#' @rdname src_h2
src_translate_env.src_h2 <- function(x) {
  sql_variant(
    base_scalar,
    sql_translator(.parent = base_agg,
      n = function(arg="*") { build_sql("COUNT(", ifelse(arg == "*", arg, ident(arg)), ")") },
      n_distinct = function(x) {
        build_sql("COUNT(DISTINCT ", ident(x), ")")
      },
      sd =  sql_prefix("stddev_samp"),
      var = sql_prefix("var_samp")
    )
  )
}

# DBI methods ------------------------------------------------------------------

#' @export
db_insert_into.H2JDBCConnection <- function(con, table, values, ...) {
  dbWriteTable(con, table, values, append = TRUE)
  invisible()
}

#' @export
db_analyze.H2JDBCConnection <- function(con, table, ...) {
  sql <- build_sql("ANALYZE", con = con)
  dbGetQuery(con, sql)
}
