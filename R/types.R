# -*- R -*-
# $RCSfile: types.R,v $
# $Date: 2001/07/31 16:23:10 $
# $Revision: 1.1.1.1 $
# Copyright 2001, Timothy H. Keitt

rpgsql.data.type <- function(x) UseMethod("rpgsql.data.type")

rpgsql.data.type.default <- function(x) {
  if(is.factor(x)) return("TEXT")
  if(is.integer(x)) return("INTEGER")
  if(is.double(x)) return("REAL")
  if(is.logical(x)) return("BOOL")
  if(is.complex(x)) warning("Complex data stored as text")
  return("TEXT")
}

rpgsql.data.type.dates <- function(x) return("DATE")
rpgsql.data.type.times <- function(x) return("TIME")

rpgsql.format.values <- function(x) UseMethod("rpgsql.format.values")

rpgsql.format.values.default <- function(x)
  return(format.null.values(single.quote(x)))

rpgsql.format.values.dates <- function(x) {
  attr(x, "format") <- "day mon year"
  return(rpgsql.format.values.default(x))
}

rpgsql.format.values.times <- function(x) {
  attr(x, "format") <- "h:m:s"
  return(rpgsql.format.values.default(x))
}

rpgsql.cast.values <- function(x) UseMethod("rpgsql.cast.values")
# does not get called for integer, logical and real types

rpgsql.cast.values.default <- function(x) {
  if(!is.null(class(x)))
    warning(paste("Coercing PGSQL type", class(x), "to character"))
  return(as.character(x))
}

rpgsql.cast.values.25 <- function(x) return(unclass(x))#text
rpgsql.cast.values.1082 <- function(x) return(dates(x, format='m-d-y'))#date
rpgsql.cast.values.1083 <- function(x) return(times(x))#time
rpgsql.cast.values.1042 <- function(x) return(unclass(x))#bpchar
rpgsql.cast.values.1043 <- function(x) return(unclass(x))#varchar





