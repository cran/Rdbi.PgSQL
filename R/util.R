# -*- R -*-
# $RCSfile: util.R,v $
# $Date: 2001/07/31 16:23:10 $
# $Revision: 1.1.1.1 $
# Copyright 2001, Timothy H. Keitt

make.db.names <- function(name)
  return(gsub("\\.", "_", as.character(name)))

format.null.values <- function(...) {
  pattern <- "' *NA'|' *NaN'|' *Inf'|' *-Inf'"
  return(gsub(pattern, "NULL", as.character(...)))
}

psql <- function(conn) {

  conninfo <- dbConnectionInfo(conn)

  command <- "psql"

  if (conninfo$database.name != "")
    command <- paste(command, "-d", conninfo$database.name)

  if (conninfo$host.name != "")
    command <- paste(command, "-h", conninfo$host.name)

  if (conninfo$port != "")
    command <- paste(command, "-p", conninfo$port)

  if (conninfo$user.name != "")
    command <- paste(command, "-U", conninfo$user.name)

  system(command)
  
}



