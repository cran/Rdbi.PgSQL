\name{dbGetResult.PgSQL.result}
\alias{dbGetResult.PgSQL.result}
\title{Fetch results from a query}
\description{
  \code{dbGetResult} returns results stored in a result object.
}
\usage{
\method{dbGetResult}{PgSQL.result}(result)
}
\arguments{
  \item{result}{A result object}
}
\details{
  Results are returned as a data frame.  Some SQL types will be
  converted to R numeric or logical types.  Others will be returned as
  strings.  A generic conversion mechanism is in the works.
}
\value{
  A data frame.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbSendQuery}}}

\keyword{data}
