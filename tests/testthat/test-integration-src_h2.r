context("src_h2")

test_that("a h2 src can be created by supplying an URL", {
  # when
  src <- src_h2("mem:")

  # then
  expect_that(src, is_a("src_h2"))
})
