# -*- R -*-
# $RCSfile: ioMethods.R,v $
# $Date: 2001/07/31 16:23:10 $
# $Revision: 1.1.1.1 $
# Copyright 2001, Timothy H. Keitt
# Licence: GPL

#
# Methods to implement Rdbi interface
#

dbSendQuery.PgSQL.conn <- function(conn, ...) {

  query <- paste(...)

  if (getOption("verbose")) cat(query, "\n") # Fix me
  
  result <- .Call("PgSQLsendQuery", conn, query)

  class(result) <- c("PgSQL.result", "Rdbi.result")

  return(result)

}

dbGetQuery.PgSQL.conn <- function(conn, ...)
  dbGetResult(dbSendQuery(conn, ...))

dbListTables.PgSQL.conn <- function(conn, pattern = NULL, all = FALSE) {

  query <- paste("SELECT relname FROM pg_class WHERE relkind = 'r'")

  if (!is.null(pattern))
    query <- paste(query, "AND relname ~", single.quote(pattern))
  # match by regular expression

  if (!all)
    query <- paste(query, "AND NOT relname ~ '^pg_'")
  # match by regular expression

  query <- paste(query, "ORDER BY relname")

  tables <- dbGetQuery(conn, query)
  
  return(tables)
  
}

dbReadTable.PgSQL.conn <- function(conn, table.name, row.names = NULL,
                                   col.names = NULL, as.is = FALSE) {
  
  result <- dbSendQuery(conn, "SELECT * FROM",
                        double.quote(table.name))

  out <- dbGetResult(result)
  
  as.is <- expand.asis(as.is, ncol(out))

  types <- dbColumnInfo(result)[["Type"]]

  for (i in 1:ncol(out)) {
    
    if (is.character(out[[i]]) && !as.is[i]) {
      
      data.col <- out[[i]]
      
      class(data.col) <- as.character(types[i])
      
      out[[i]] <- rpgsql.cast.values(data.col)
      
    }
    
  }
  
  if (!is.null(col.names)) {
    
    names(out) <- make.names(col.names, unique=T)

  }
  
  if (!is.null(row.names)) {
    
    row.names(out) <- as.character(row.names)
    
  } else if ("R_row_names" %in% names(out)) {
    
    row.names(out) <- out[["R_row_names"]]
    
    out[["R_row_names"]] <- NULL
    
  }

  return(out)

}

dbWriteTable.PgSQL.conn <- function(conn, data,
                                    name = deparse(substitute(data)),
                                    no.clobber = TRUE,
                                    write.row.names = FALSE) {

  if (no.clobber) {
    
    if (name %in% dbListTables(conn))
      stop(paste("Table name", name, "exists in database"))
    
  } else {
    
    if (name %in% dbListTables(conn))
      dbSendQuery(conn, "DROP TABLE", double.quote(name))
    
  }

  if (!is.data.frame(data)) data <- as.data.frame(data)
  
  if (write.row.names) data[["R_row_names"]] <- row.names(data)
  
  query <- paste("CREATE TABLE", double.quote(name))
  
  column.names <- lapply(names(data), double.quote)
  
  data.types <- lapply(data, rpgsql.data.type)
  
  table.columns <- vector(mode = "character")
  
  for (col in 1:ncol(data)) {
    
    column.def <- paste(column.names[col], data.types[col])
    
    table.columns <- append(table.columns, column.def)
    
  }
  
  query <- paste(query, "(", list.to.csv(table.columns), ")")

  on.exit(dbSendQuery(conn, "DROP TABLE", double.quote(name)))
  
  dbSendQuery(conn, query)
  # create the table
  
  dbAppendTable(conn, name, data)
  # fill the table

  on.exit(dbSendQuery(conn, "VACUUM ANALYZE", double.quote(name)))
  
  return(invisible())
  
}

dbAppendTable.PgSQL.conn <- function(conn, name, data) {

  if (!name %in% dbListTables(conn))
    stop(paste("Table", name, "does not exist"))

  if (!is.data.frame(data)) data <- as.data.frame(data)

  dbSendQuery(conn, "BEGIN TRANSACTION")
  
  on.exit(dbSendQuery(conn, "ROLLBACK TRANSACTION"))

  preamble <- paste("INSERT INTO", double.quote(name))

  column.names <- sapply(names(data), double.quote)
    
  formatted.data <- matrix(nrow=nrow(data), ncol=ncol(data))
  # this is necessary because if columns are converted to strings,
  # they will get coerced to factors (I'm sure there is a way around
  # this; I just don't know what it is.)
  
  for (i in seq(along = column.names))
    formatted.data[,i] <- rpgsql.format.values(data[[i]])
  
  boiler <- paste(preamble, "(", list.to.csv(column.names), ")")
  
  for (i in 1:nrow(data)) {
    
    insert.values <- list.to.csv(formatted.data[i,])
    
    dbSendQuery(conn, boiler, "VALUES (", insert.values, ")")
    
  }
  
  on.exit(dbSendQuery(conn, "COMMIT TRANSACTION"))
  
  return(invisible())  

}

