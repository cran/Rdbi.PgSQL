\name{dbColumnInfo.PgSQL.result}
\alias{dbColumnInfo.PgSQL.result}
\title{Return column information}
\description{
  \code{dbColumnInfo} return information about table columns stored in a
  result object.
}
\usage{
dbColumnInfo.PgSQL.result(result)
}
\arguments{
  \item{result}{A result object}
}
\details{
  This function is used internally to get column type information.
}
\value{
  A data frame with one row for each column in the result, and one
  column for each type attribute returned.
}
\references{\url{http://rdbi.sourceforge.net}}
\author{Timothy H. Keitt}

\seealso{\code{\link{dbSendQuery}}}

\keyword{data}

