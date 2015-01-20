context("src_h2")

test_that("an h2 src can be created by supplying an URL", {
  # when
  src <- src_h2("jdbc:h2:mem:")

  # then
  expect_that(src, is_a("src_h2"))
})

test_that("an h2 src can be created by supplying a H2Connection", {
  # when
  src <- src_h2(dbConnect(H2(), "mem:", "sa", ""))

  # then
  expect_that(src, is_a("src_h2"))
})