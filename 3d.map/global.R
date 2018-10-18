library(shiny)
library(viridis)
library(rgl)

# options(rgl.useNULL=TRUE)

rad <- 1
realtime <- T
surface <- F
variable <- "P2"

if(realtime) source("load.R") else {
  
  tryCatch({
    load(paste("contour",rad,".rdata",sep = ""))
    load(paste("krige",rad,".rdata",sep = ""))
    load(paste("points",rad,".rdata",sep = ""))
    
    levels <- round((max(z)-min(z))/2)
    lev <- pretty(range(z, na.rm = TRUE), levels)
    linecol <- plasma(length(lev))
    
  }, 
  error = source("load.R"))
  
  
}