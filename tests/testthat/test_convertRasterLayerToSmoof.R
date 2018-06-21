context("convertRasterLayerToSmoof")

test_that("convertRasterLayerToSmoof works", {
  alt = raster::getData('alt', country='SVN')
  sf = convertRasterLayerToSmoof(raster.layer = alt)
  expect_class(sf, "smoof_function")
  points = generateRandomDesign(n = 20, par.set = getParamSet(sf))
  res = apply(points, 1, sf)
  expect_numeric(res, lower = 0, upper = 9000, all.missing = FALSE, len = 20)
})
