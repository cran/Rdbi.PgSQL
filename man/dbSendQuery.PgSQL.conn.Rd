\name{dbSendQuery.PgSQL.conn}
\alias{dbSendQuery.PgSQL.conn}
\title{Send a query to the backend}
\description{
  \code{dbSendQuery} sends a query to the PostgreSQL server.
}
\usage{
\method{dbSendQuery}{PgSQL.conn}(conn, ...)
}
\arguments{
  \item{conn}{A connection object}
  \item{\dots}{A query string}
}
\details{
  Arguments past the connection object will be pasted together and sent
  to the backend for processing.
}
\value{
  A result object.
}
\references{\url{http://rdbi.sourceforge.net}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbResultInfo}}}

\keyword{data}
