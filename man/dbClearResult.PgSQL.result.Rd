\name{dbClearResult.PgSQL.result}
\alias{dbClearResult.PgSQL.result}
\title{Clear results}
\description{
  \code{dbClearResult} clears all resources associated with a
  PgSQL.result object.
}
\usage{
\method{dbClearResult}{PgSQL.result}(result)
}
\arguments{
  \item{result}{A result object}
}
\details{
  Result object do not need to be explicitely cleared as their resources
  will automatically be freed during garbage collection.  This function
  forces the resource to be immediately released.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbSendQuery}}}

\keyword{data}

