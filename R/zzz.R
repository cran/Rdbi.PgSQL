## -*- R -*-
## $RCSfile: zzz.R,v $
## $Date: 2001/07/31 16:23:10 $
## $Revision: 1.1.1.1 $
## Copyright 2001, Timothy H. Keitt
.First.lib <- function(lib, pkg) {
  if(!require(Rdbi))
    stop("Could not load package Rdbi")
  library.dynam("Rdbi.PgSQL", pkg, lib)
  autoload("times", "chron")
  autoload("dates", "chron")
  return(invisible())
}

