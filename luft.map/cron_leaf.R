require(jsonlite)
library(curl)

rad <- 5

luft <- fromJSON(paste("http://api.luftdaten.info/v1/filter/area=48.775322,9.176396,",rad, sep = ""), flatten = T,simplifyDataFrame = T)

require(tidyr)
luft <- unnest(luft)
luft$location.longitude <- as.numeric(luft$location.longitude)
luft$location.latitude <- as.numeric(luft$location.latitude)
luft$value <- as.numeric(luft$value)

tmp <- luft$id[luft$value<0]
luft <- luft[!(luft$id %in% tmp),]
luft <- luft[luft$value<500,]

## choose data set, P2 = P2.5
dat <- luft[luft$value_type == "P2",]
# bin <- 2

#slice <- aggregate(dat[,c("value","location.latitude","location.longitude")], 
#                   by = list(sensor.id=dat$sensor.id), 
#                   FUN = "mean")

slice <- aggregate(dat[,c("value", "sensor.id")], 
                   by = list(location.longitude=dat$location.longitude,location.latitude=dat$location.latitude), 
                   FUN = "mean")

# save(slice,file = "/srv/shiny-server/luft.map/dat.rdata")

mar <- 0.007*rad
bb <- data.frame(ll.lat = min(luft$location.latitude)-mar, ll.lon = min(luft$location.longitude)-mar, 
                 ur.lat = max(luft$location.latitude)+mar, ur.lon = max(luft$location.longitude)+mar
)

require(sp)
grd <- expand.grid(
  x = seq(from = bb[, 2], to = bb[, 4], by = 0.00005*rad),
  y = seq(from = bb[, 1], to = bb[, 3], by = 0.00005*rad)
)  # expand points to grid

coordinates(grd) <- ~ x + y
gridded(grd) <- TRUE
coordinates(slice) = ~ location.longitude + location.latitude

require(gstat)
idw <- krige(formula = value ~ 1,
             locations = slice,
             newdata = grd)

library(raster)
r = raster(idw, "var1.pred")

int <- (max(idw$var1.pred)-min(idw$var1.pred))/10
c <- rasterToContour(r, levels = seq(min(idw$var1.pred),max(idw$var1.pred),by = int))
c$level <- as.numeric(as.character(c$level))

p <- slice
save(p,file = "/srv/shiny-server/luft.map/dat.rdata")
save(c,file = "/srv/shiny-server/luft.map/contour.rdata")

# z <-
#   matrix(idw$var1.pred,
#          nrow = idw@grid@cells.dim[1],
#          ncol = idw@grid@cells.dim[2])
# 
# # save(z, file = "/srv/shiny-server/3dmap/krige.rdata")
# 
# levels <- round((max(z)-min(z))/2)
# lines <- contourLines(z,nlevels = levels)
# # save(lines,file = "/srv/shiny-server/3dmap/contour.rdata")
# 
# points <- slice@coords
# points <- apply(points, 2, FUN = function(x) (x - min(x)+mar)/(max(x)-min(x)+mar*2))
# points <- cbind(points, slice@data)

# save(points,file = "/srv/shiny-server/3dmap/points.rdata")

