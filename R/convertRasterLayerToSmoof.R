#' @title Converts a Raster Layer to Single Objective Function
#' @description Takes the altitude informations from a RasterLayer Object as an objective for a smoof function.
#' @param raster.layer [\code{raster::RasterLayer}]
#' @param maximize [\code{logical(1)}]
#' @param use.constraint.fn [\code{logical(1)}]
#'   If \code{TRUE} the \code{smoof} function will also have a constraint function that returns \code{FALSE} for all input coordinates that are outside of the region coverd in the \code{raster.layer}.
#'   Otherwise the function will just return \code{NA} there.
#' @param interpolate [\code{logical(1)}]
#'   Elevation information for this type of data is just available for integer coordinates.
#'   If \code{interpolate} is \code{TRUE} the function will round the input and return the elevation for the closest integer coordinate.
#' @return \code{smoof function}
#' @export

convertRasterLayerToSmoof = function(raster.layer, maximize = TRUE, interpolate = TRUE, use.constraint.fn = FALSE) {
  if (is.list(raster.layer)) {
    assertList(raster.layer, types = "RasterLayer")
  } else {
    assertClass(raster.layer, "RasterLayer")
  }
  assertFlag(maximize)
  assertFlag(interpolate)
  assertFlag(use.constraint.fn)

  alt.mat = t(raster::as.matrix(raster.layer))
  alt.mat = alt.mat[,rev(seq_len(ncol(alt.mat)))]
  # image(alt.mat)
  if (maximize) {
    ref = max(alt.mat, na.rm = TRUE)
  } else {
    ref = min(alt.mat, na.rm = TRUE)
  }
  opt = which(alt.mat == ref, arr.ind = TRUE)
  if (interpolate) {
    ps = makeNumericParamSet('coords', 2, lower = c(1,1), upper = dim(alt.mat))
    fn = function(x) {alt.mat[round(x[1]), round(x[2])]}
    constraint.fn = function(x) {!is.na(alt.mat[round(x[1]), round(x[2])])}
    storage.mode(opt) <- "double"
  } else {
    ps = makeParamSet(
      makeIntegerVectorParam('coords', 2, lower = c(1,1), upper = dim(alt.mat))
    )
    fn = function(x) {alt.mat[x[1], x[2]]}
    constraint.fn = function(x) {!is.na(alt.mat[x[1], x[2]])}
  }
  if (!use.constraint.fn) constraint.fn = NULL
  makeSingleObjectiveFunction(name = coalesce(names(raster.layer), 'RasterLayer'), fn = fn, has.simple.signature = TRUE, par.set = ps, constraint.fn = constraint.fn, global.opt.value = ref, global.opt.params = opt, minimize = !maximize)
}
