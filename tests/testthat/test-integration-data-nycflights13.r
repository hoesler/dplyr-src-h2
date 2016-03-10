context("data-nycflights13")

library(nycflights13)

test_that("nycflights13_h2 has flights table", {
  # when
  flights_db <- tbl(nycflights13_h2(), "flights")

  # then
  expect_is(flights_db, "tbl_h2")
  expect_equal(nrow(flights_db), 336776)
  expect_equal(ncol(flights_db), 16)
})

test_that("filter", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  filtered <- filter(flights_db, month == 1, day == 1)

  expect_is(filtered, "tbl_h2")
})

test_that("arrange", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  arranged <- arrange(flights_db, year, month, day)

  expect_is(arranged, "tbl_h2")
})

test_that("select", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  selected <- select(flights_db, year, month, day)

  expect_is(selected, "tbl_h2")
})

test_that("distinct", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  distinct_tailnum <- distinct(select(flights_db, tailnum))

  expect_is(distinct_tailnum, "tbl_h2")
})

test_that("group_by", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  grouped <- group_by(flights_db, tailnum)

  expect_is(grouped, "tbl_h2")
})

test_that("summarize", {
  flights_db <- tbl(nycflights13_h2(), "flights")

  summarized <- summarise(flights_db,
    count = n(),
    distinct = n_distinct("flight"),
    dist = mean(distance),
    delay = mean(arr_delay),
    min_delay = min(arr_delay),
    max_delay = max(arr_delay),
    sum_delay = sum(arr_delay),
    sd_delay = sd(arr_delay)
  )

  expect_is(summarized, "tbl_h2")
})

