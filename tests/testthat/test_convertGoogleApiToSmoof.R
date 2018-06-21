context("convertGoogleApiToSmoof")

test_that("convertGoogleApiToSmoof works", {
  google_api_key = Sys.getenv('GEO2SMOOF_GOOGLEAPI')
  skip_if(!nzchar(google_api_key))
  # approx germany range
  lat.range = c(54.91, 47.26)
  lon.range = c(5.79, 15.03)
  sf = convertGoogleApiToSmoof(lat.range = lat.range, lon.range = lon.range)
  expect_class(sf, "smoof_function")
  grid = generateGridDesign(getParamSet(sf), resolution = 2)
  res = sf(as.matrix(grid))
  expect_numeric(res, lower = -2000, upper = 9000, all.missing = FALSE, len = 4)  
})
