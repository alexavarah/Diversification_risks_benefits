# Count complete observations
# i.e., don't count NAs
nobs <- function(x) length(x[!is.na(x)])