test_that("`normalize_address()` works", {
  skip()

  address <- "\u5317\u6d77\u9053\u672d\u5e4c\u5e02\u897f\u533a24-2-2-3-3"
  level <- c("town", "pref")

  normalized <- normalize_address(address = address,
                                  level = level)
  expect_equal(as.character(normalized$level), level)
})
