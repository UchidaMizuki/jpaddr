test_that("`normalize_address()` works", {
  address <- "北海道札幌市西区24-2-2-3-3"
  level <- c("town", "pref")

  normalized <- normalize_address(address = address,
                                  level = level)
  expect_equal(as.character(normalized$level), level)
})
