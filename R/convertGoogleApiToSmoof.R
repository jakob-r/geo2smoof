#' @title Converts a Google Maps API Call to Single Objective Function
#' @description Receives the JSON from Google Maps API and extracts height
#' @param lat.range [\code{numeric(2)}]
#' @param lon.range [\code{numeric(2)}]
#' @param maximize [\code{logic(2)}]
#' @param google.apikey [\code{character(1)}]
#'   The Google Maps Elevation API Key.
#'   Will be read from config file.
#' @return \code{smoof function}
#' @export

convertGoogleApiToSmoof = function(lat.range, lon.range, maximize = TRUE, google.apikey = NULL) {
  assertNumeric(lat.range, lower = -90, upper = 90, any.missing = FALSE, len = 2)
  assertNumeric(lon.range, lower = -180, upper = 180, any.missing = FALSE, len = 2)
  assertFlag(maximize)
  assertString(google.apikey, null.ok = TRUE)

  lat.range = sort(lat.range)
  lon.range = sort(lon.range)
  google.apikey = coalesce(google.apikey, Sys.getenv('GEO2SMOOF_GOOGLEAPI'))
  if (!nzchar(google.apikey) || is.null(google.apikey)) {
    path = "~/.config/geo2smoof"
    if (file.exists(path)) {
      ee = new.env()
      source(file = path, local = ee)
      google.apikey = ee$google.apikey
      rm(ee)
      Sys.setenv(GEO2SMOOF_GOOGLEAPI = google.apikey)
    }
  }
  ps = makeParamSet(
    makeNumericParam('latitude', lower = lat.range[1], upper = lat.range[2]),
    makeNumericParam('longitude', lower = lon.range[1], upper = lon.range[2])
  )
  fn = function(x) {
    if (is.vector(x)) x = t(as.matrix(x))
    api.url = 'https://maps.googleapis.com/maps/api/elevation/json'
    query = list(locations = paste(sprintf('%.6f,%.6f', x[,1], x[,2]), collapse = '|'))
    if (!is.null(google.apikey)) {
      query$key = google.apikey
    }
    httr.res = httr::GET(api.url, query = query, httr::accept_json())
    if (httr::status_code(httr.res) != 200) {
      stopf("The server returned an unexpected result: %s", httr::content(httr.res, "text"))
    }
    res = httr::content(httr.res)
    if (!is.null(res$error_message)) {
      stopf("Googe Altitude API Error message: \"%s\" for API-Key: \"%s\"", res$error_message, gsub(x = google.apikey, pattern = "(.{5}).{9}(.*)", replacement = "\\1*********\\2", perl = FALSE))
    }
    sapply(res$results, function(x) x$elevation)
  }
  makeSingleObjectiveFunction(name = 'Google Maps API', fn = fn, has.simple.signature = TRUE, par.set = ps, minimize = !maximize, vectorized = TRUE)
}

saveGoogleAPI = function(api.key) {

}
