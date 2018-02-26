## ----setup, include = FALSE, cache = FALSE-------------------------------
set.seed(123)
knitr::opts_chunk$set(cache = TRUE, collapse = FALSE)
library(geo2smoof)

## ------------------------------------------------------------------------
alt_s = raster::getData('alt', country='SVN', mask = FALSE)
sf = convertRasterLayerToSmoof(raster.layer = alt_s)
getParamSet(sf)
sf(c(204,103))
plot2DNumeric(sf, render.levels = TRUE, n.samples = 200)

## ------------------------------------------------------------------------
alt_d = raster::getData('alt', country='DEU')
alt_a = raster::getData('alt', country='AUT')
alt_c = raster::getData('alt', country='CHE', mask = FALSE)
alt_i = raster::getData('alt', country='ITA')
alt_all = do.call(raster::merge, list(alt_d, alt_a, alt_c, alt_i, alt_s))
alt_cropped = raster::crop(alt_all, raster::extent(7,16,45.5,47.8))
sf = convertRasterLayerToSmoof(raster.layer = alt_cropped)
getParamSet(sf)
plot2DNumeric(sf, render.levels = TRUE, n.samples = 200)

## ---- eval=FALSE---------------------------------------------------------
#  lat.range = c(28.5, 27.5)
#  lon.range = c(86.5, 87.5)
#  gsf = convertGoogleApiToSmoof(lat.range = lat.range, lon.range = lon.range)
#  gsf(c(29,87))
#  plot2DNumeric(gsf, render.levels = TRUE, n.samples = 5)

