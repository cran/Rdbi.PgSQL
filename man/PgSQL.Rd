\name{PgSQL}
\alias{PgSQL}
\title{Return an object of type PgSQL}
\description{
  \code{PgSQL} generates an object of type PgSQL
}
\usage{
PgSQL()
}
\details{
  \code{PgSQL} is called for it's side effects.  First, it returns an
  object of type PgSQL, so that the generic function \code{dbConnect}
  knows which specialization to use.  Second, calling \code{PgSQL}
  autoloads the Rdbi.PgSQL package.
}
\value{
  An object of class PgSQL.
}
\references{\url{http://rdbi.sourceforge.net/}}
\author{Timothy H. Keitt}

\seealso{\code{\link{autoload}}}

\keyword{data}
