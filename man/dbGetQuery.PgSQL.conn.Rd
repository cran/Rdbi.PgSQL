\name{dbGetQuery.PgSQL.conn}
\alias{dbGetQuery.PgSQL.conn}
\title{Submit a query and fetch result}
\description{
  \code{dbGetQuery} sends a query to the backend and fetches the result
  as a data frame.
}
\usage{
\method{dbGetQuery}{PgSQL.conn}(conn, ...)
}
\arguments{
  \item{conn}{A connection object}
  \item{\dots}{A query string}
}
\details{
  All arguments after the connection object will be pasted together and
  passed to the backend as a query string.
}
\value{
  A data frame with the result of the query.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbSendQuery}}}

\keyword{data}
