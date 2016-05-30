context("src_h2")

test_that("src_h2() creates an src_h2 object", {
  # when
  src <- src_h2("mem:")

  # then
  expect_is(src, "src_h2")
})
