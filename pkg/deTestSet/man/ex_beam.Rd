\name{beam}
\alias{beam}
\title{Motion of Inextensible Elastic Beam, ODE}
\description{
The beam modulator problem is a problem from mechanics, describing the 
motion of an elastic beam, supposed inextensible, of length 1 and thin.

It is an ordinary differential equation of dimension 80.

}
\usage{
beam (times=seq(0, 5, by = 0.01), yini = NULL,  ...) 
}

\arguments{
  \item{yini }{the initial (state) values for the DE system. If \code{y}
    has a name attribute, the names will be used to label the output
    matrix.
  }
  \item{times }{time sequence for which output is wanted; the first
    value of \code{times} must be the initial time.
  }
  \item{... }{additional arguments passed to the solver .
  }
}
\value{
  A matrix of class \code{deSolve} with up to as many rows as elements in
  \code{times} and as many
  columns as elements in \code{yini}, plus an additional column (the first) 
  for the time value.

  There will be one row for each element in \code{times} unless the
  solver returns with an unrecoverable error.  If
  \code{yini} has a names attribute, it will be used to label the columns
  of the output value.
      
}
\author{Karline Soetaert 

Francesca Mazzia
}
\examples{
out <- beam()
plot(out, mfrow = c(4, 4), col = "darkblue", lwd = 2)
mtext(side = 3, line = -1.5, "beam", cex = 1.25, outer = TRUE)

# compare with reference solution
max(abs(out[nrow(out),-1]- reference("beam")))    

}
\references{
\url{http://www.dm.uniba.it/~testset}

}
\details{
There are no parameters  
}
\keyword{utilities}
