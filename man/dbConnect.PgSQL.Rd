\name{dbConnect.PgSQL}
\alias{dbConnect.PgSQL}
\title{Connect to PostgreSQL backend}
\description{
  \code{dbConnect} establishes a connection to the PostgreSQL database
  when passed a PgSQL object.
}
\usage{
\method{dbConnect}{PgSQL}(dbObj, ...)
}
\arguments{
  \item{dbObj}{An object of class PgSQL}
  \item{\dots}{Additional arguments to pass to the database}
}
\details{
  The first argument must be an object of class PgSQL.  See the function
  \code{\link{PgSQL}} for details.  Additional arguments can be passed
  after the database object.  The most important of these will be
  'host', 'dbname' and 'user'.  Check your PostgreSQL documentation for
  a full list of options.
}
\value{
  A connection object
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{PgSQL}}}

\keyword{data}
