#' @title Saves a list of geo2smoof configuration settings to file.
#'
#' @description
#' The new configuration is automatically assigned.
#'
#' @param google.apikey [\code{character(1)}]
#'   The Google Maps Elevation API Key.
#' @param overwrite [\code{logical(1)}]\cr
#'   Should an existing file be overwritten?
#'   Default is \code{FALSE}.
#' @export
saveGeo2SmoofConfig = function(google.apikey = NULL, overwrite = FALSE) {
  assertString(google.apikey, null.ok = FALSE)
  assertFlag(overwrite)

  # we always store the config in the same place
  path = "~/.config/geo2smoof"

  if (file.exists(path) && !overwrite) {
    stopf("Configuration file %s already exists. Set overwrite to TRUE to force overwriting.", path)
  }

  if (!file.exists(dirname(path))) {
    dir.create(dirname(path), showWarnings = TRUE, recursive = TRUE)
  }

  conf = list(google.apikey = paste0('"',google.apikey,'"'))
  lines = paste(names(conf), conf, sep = "=")
  con = file(path, "w")
  on.exit(close(con))
  writeLines(lines, con = con)

  Sys.setenv(GEO2SMOOF_GOOGLEAPI = google.apikey)
  invisible()
}
