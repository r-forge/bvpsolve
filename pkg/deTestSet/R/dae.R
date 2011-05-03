dae <- function (y, times, parms, dy, res = NULL, func = NULL,
    method = c("mebdfi", "daspk", "radau", "gamd"), ...)
{
    if (is.null(method))
        method <- "mebdfi"
    else if (is.function(method) & !is.null(res))
        out <- method(y=y, times=times, parms=parms, dy=dy, res=res, ...)
    else if (is.function(method) & !is.null(func))
        out <- method(y=y, times=times, parms=parms, func=func, ...)
    else if(!is.null(res)) out <- switch(match.arg(method),
      mebdfi = mebdfi(y=y, times=times, parms=parms, dy=dy, res=res, ...),
      daspk  = daspk (y=y, times=times, parms=parms, dy=dy, res=res, ...))
    else out <- switch(match.arg(method),
      mebdfi = mebdfi(y=y, times=times, parms=parms, dy=dy, func=func, ...),
      daspk  = daspk (y=y, times=times, parms=parms, dy=dy, func=func, ...),
      radau  = radau (y=y, times=times, parms=parms, func=func, ...),
      gamd   = gamd  (y=y, times=times, parms=parms, func=func, ...))
    return(out)
}