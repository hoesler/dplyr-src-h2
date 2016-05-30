#' @importFrom DBI dbWriteTable dbGetQuery dbConnect dbGetInfo
#' @importFrom dbj resolve module
#' @import dplyr
#' @importFrom methods new
NULL

#' A wrapper class for JDBCConnection objects created in src_h2. Used for H2 specific dispatch.
#' @export
setClass("H2JDBCConnection", contains = c("JDBCConnection"))

drv_h2 <- function() {
  dbj::driver('org.h2.Driver', resolve(module('com.h2database:h2:1.3.176')))
}               

#' Create a source object for an H2 database.
#' 
#' @param x an URL for the H2 database connection as defined at \url{http://h2database.com/html/features.html#database_url}
#'  without the 'jdbc:h2:' prefix.
#'  If \code{x} is a path to a local file, than the '.h2.db' suffix, if present, is stripped off automatically.
#' @param src a h2 src created with \code{src_h2}.
#' @param from Either a string giving the name of table in database, or
#'   \code{\link{sql}} described a derived table or compound join.
#' @param ... for the src, other arguments passed on to the underlying
#'   database connector, \code{dbConnect}. For the tbl, included for
#'   compatibility with the generic, but otherwise ignored.
#' @export
src_h2 <- function(x, ...) UseMethod("src_h2")

#' @export
#' @describeIn src_h2 Create the source from an H2 URL.
src_h2.character <- function(x, ...) {
  url <- sprintf("jdbc:h2:%s", sub("^(.*)\\.h2\\.db$", "\\1", x))
  dbj_connection <- dbConnect(drv_h2(), url, ...)
  src_h2(dbj_connection, ...)
}

#' @export
#' @describeIn src_h2 Create the source from an JDBC connection.
src_h2.JDBCConnection <- function(x, ...) {
  info <- dbGetInfo(x)
  if (all(startsWith(info$url, "jdbc:h2"))) {
    warning("Expected a jdbc:h2 URL. Is this a valid H2 connection?")
  }
  h2_connection <- new("H2JDBCConnection", x)
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
