\name{dbDisconnect.PgSQL.conn}
\alias{dbDisconnect.PgSQL.conn}
\title{Drop a connection}
\description{
  \code{dbDisconnect} disconnects from the backend and frees all
  resources associated with the connection.
}
\usage{
\method{dbDisconnect}{PgSQL.conn}(conn)
}
\arguments{
  \item{conn}{A connection object}
}
\details{
  Some attempt is made to disconnect connection object when exiting R.
  Your mileage may vary.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbConnect}}}

\keyword{data}
