% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convertRasterLayerToSmoof.R
\name{convertRasterLayerToSmoof}
\alias{convertRasterLayerToSmoof}
\title{Converts a Raster Layer to Single Objective Function}
\usage{
convertRasterLayerToSmoof(raster.layer, maximize = TRUE, interpolate = TRUE,
  use.constraint.fn = FALSE)
}
\arguments{
\item{raster.layer}{[\code{raster::RasterLayer}]}

\item{maximize}{[\code{logical(1)}]}

\item{interpolate}{[\code{logical(1)}]
Elevation information for this type of data is just available for integer coordinates.
If \code{interpolate} is \code{TRUE} the function will round the input and return the elevation for the closest integer coordinate.}

\item{use.constraint.fn}{[\code{logical(1)}]
If \code{TRUE} the \code{smoof} function will also have a constraint function that returns \code{FALSE} for all input coordinates that are outside of the region coverd in the \code{raster.layer}.
Otherwise the function will just return \code{NA} there.}
}
\value{
\code{smoof function}
}
\description{
Takes the altitude informations from a RasterLayer Object as an objective for a smoof function.
}
