\name{dbReadTable.PgSQL.conn}
\alias{dbReadTable.PgSQL.conn}
\title{Read a PostgreSQL table}
\description{
  \code{dbReadTable} fetches all values in a table and returns them in a
  data frame.
}
\usage{
dbReadTable.PgSQL.conn(conn, table.name, row.names=NULL, col.names=NULL, as.is=FALSE)
}
\arguments{
  \item{conn}{A connection object}
  \item{table.name}{The name of the table}
  \item{row.names}{A vector of row names}
  \item{col.names}{A vector of column names}
  \item{as.is}{List character-type columns that should not be converted to factors}
}
\details{
  The \code{as.is} argument act like its equivalent in \code{read.table}.
}
\value{
  A data frame.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbWriteTable}}}

\keyword{data}
