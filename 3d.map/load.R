require(jsonlite)
library(curl)

options(rgl.useNULL=TRUE)

# rad <- 5

luft <- fromJSON(paste("http://api.luftdaten.info/v1/filter/area=48.775322,9.176396,",rad, sep = ""), flatten = T,simplifyDataFrame = T)

require(tidyr)
luft <- unnest(luft)
luft$location.longitude <- as.numeric(luft$location.longitude)
luft$location.latitude <- as.numeric(luft$location.latitude)
luft$value <- as.numeric(luft$value)

luft <- luft[luft$value<300,]

## choose data set, P2 = P2.5
dat <- luft[luft$value_type == variable,]
# bin <- 2

slice <- aggregate(dat[,c("value","location.latitude","location.longitude")], 
                 by = list(sensor.id=dat$sensor.id), 
                 FUN = "mean")


mar <- 0.005*rad
bb <- data.frame(ll.lat = min(luft$location.latitude)-mar, ll.lon = min(luft$location.longitude)-mar, 
                 ur.lat = max(luft$location.latitude)+mar, ur.lon = max(luft$location.longitude)+mar
)

require(sp)
grd <- expand.grid(
  x = seq(from = bb[, 2], to = bb[, 4], by = 0.0002*rad),
  y = seq(from = bb[, 1], to = bb[, 3], by = 0.0002*rad)
)  # expand points to grid

coordinates(grd) <- ~ x + y
gridded(grd) <- TRUE
coordinates(slice) = ~ location.longitude + location.latitude

require(gstat)
idw <- krige(formula = value ~ 1,
             # idp = 2.5,
             # indicators = T,
             # nsim = 1,
             locations = slice,
             newdata = grd)

z <-
  matrix(idw$var1.pred,
         nrow = idw@grid@cells.dim[1],
         ncol = idw@grid@cells.dim[2])


levels <- round((max(z)-min(z))/2)
lines <- contourLines(z,nlevels = levels)
lev <- pretty(range(z, na.rm = TRUE), levels)
surfcol <- cut(z,breaks = lev)
linecol <- plasma(length(lev))

points <- slice@coords
points <- apply(points, 2, FUN = function(x) (x - min(x)+mar)/(max(x)-min(x)+mar*2))
points <- cbind(points, slice@data)

save(points,file = paste("points",rad,".rdata",sep = ""))
save(z,file = paste("krige",rad,".rdata",sep = ""))
save(lines,file = paste("contour",rad,".rdata",sep = ""))

if(!file.exists(paste("map",rad,".png",sep = ""))){
  require(ggmap)
  map <- get_map(location = c(bb[1,2],bb[1,1],bb[1,4],bb[1,3]),maptype = "satellite")
  
  require(imager)
  img <- as.cimg(map)
  img <- mirror(img,"y")
  img <- grayscale(img)
  img <- add.color(img)
  img <- as.raster(img)
  png(paste("map",rad,".png",sep = ""), dim(img)[2], dim(img)[1])
  # jpeg("map.jpeg", dim(img)[2], dim(img)[1])
  require(grid)
  grid.raster(img, interpolate =F)
  dev.off()
}
