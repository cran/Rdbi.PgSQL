# -*- R -*-
# $RCSfile: resultMethods.R,v $
# $Date: 2001/07/31 16:23:09 $
# $Revision: 1.1.1.1 $
# Copyright 2001, Timothy H. Keitt
# Licence: GPL

#
# Methods to implement Rdbi interface
#

dbGetResult.PgSQL.result <- function(result)
  .Call("PgSQLgetResult", result)

dbClearResult.PgSQL.result <- function(result)
  .Call("PgSQLclearResult", result)

dbResultInfo.PgSQL.result <- function(result) {

  result.info <- .Call("PgSQLresultInfo", result)

  result.info <- lapply(result.info, strip.line.feeds)
  
  return(result.info)
  
}

dbColumnInfo.PgSQL.result <- function(result)
  .Call("PgSQLcolumnInfo", result)


