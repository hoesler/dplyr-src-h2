context("data-nycflights13")

test_that("nycflights13_h2 has flights table", {
  # when
  library(nycflights13)
  flights_db <- tbl(nycflights13_h2(), "flights")

  # then
  expect_that(flights_db, is_a("tbl_h2"))
  expect_equal(nrow(flights_db), 336776)
  expect_equal(ncol(flights_db), 16)
})