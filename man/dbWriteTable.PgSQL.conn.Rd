\name{dbWriteTable.PgSQL.conn}
\alias{dbWriteTable.PgSQL.conn}
\title{Write a data frame to a database}
\description{
  \code{dbWriteTable} writes the contents of a data frame into a
  PostgreSQL table.
}
\usage{
\method{dbWriteTable}{PgSQL.conn}(conn, data, name=deparse(substitute(data)), no.clobber=TRUE, write.row.names=FALSE)
}
\arguments{
  \item{conn}{A connection object}
  \item{data}{A data frame}
  \item{name}{The table name}
  \item{no.clobber}{If true, don't delete existing table of same name}
  \item{write.row.names}{If true, add an additional column containing
    row names}
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbReadTable}}}

\keyword{data}
