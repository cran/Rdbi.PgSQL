\name{dbAppendTable.PgSQL.conn}
\alias{dbAppendTable.PgSQL.conn}
\title{Append data to a PgSQL table}
\description{
  \code{dbAppendTable} appends data to a table.
}
\usage{
\method{dbAppendTable}{PgSQL.conn}(conn, name, data)
}
\arguments{
  \item{conn}{A connection object}
  \item{name}{The table name}
  \item{data}{Data to be appended}
}
\details{
  When passed a data frame, column names in the data frame are matched
  to column names in the database table so that you can append to a
  subset of the columns.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbWriteTable}}}

\keyword{data}

