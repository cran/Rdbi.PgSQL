\name{dbListTables.PgSQL.conn}
\alias{dbListTables.PgSQL.conn}
\title{List tables in a database}
\description{
  \code{dbListTables} lists the tables associated with a database connection.
}
\usage{
\method{dbListTables}{PgSQL.conn}(conn, pattern=NULL, all=FALSE)
}
\arguments{
  \item{conn}{A connection object}
  \item{pattern}{An SQL matching pattern}
  \item{all}{If true, also list system tables}
}
\value{
  A list of table names.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbConnect}}}

\keyword{data}

