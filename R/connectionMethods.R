# -*- R -*-
# $RCSfile: connectionMethods.R,v $
# $Date: 2001/07/31 16:23:10 $
# $Revision: 1.1.1.1 $
# Copyright 2001, Timothy H. Keitt
# Licence: GPL

#
# Methods to implement Rdbi interface
#

PgSQL <- function() {

  out <- list(description = "PostgreSQL object")

  class(out) <- c("PgSQL", "Rdbi")

  return(out)

}

dbConnect.PgSQL <- function(dbObj, ...) {

  conninfo <- list.to.key.pair.string(list(...))
  # list.to.key.pair.string defined in util.R in Rdbi

  conn <- .Call("PgSQLconnect", conninfo)

  class(conn) <- c("PgSQL.conn", "Rdbi.conn")

  attr(conn, "library.call") <- expression(library(Rdbi.PgSQL))
  attr(conn, "connect.call") <- match.call()
  # allows connection to be recreated later

  conninfo <- dbConnectionInfo(conn)

  if (conninfo$status != 0)
    stop(conninfo$last.message)
  else
    dbSendQuery(conn, "SET DATESTYLE TO 'Postgres, US'")
    # Necessary to make dates() and times() work

  return(conn)

}

dbDisconnect.PgSQL.conn <- function(conn) {

  .Call("PgSQLcloseConnection", conn)

}

dbConnectionInfo.PgSQL.conn <- function(conn) {

  conninfo <- .Call("PgSQLconnectionInfo", conn)

  conninfo <- lapply(conninfo, strip.line.feeds)
  
  return(conninfo)
  
}









