#Problem D:

michigan.map <- map("county",region="Michigan", plot = FALSE, fill = TRUE)
IDs <- sapply(strsplit(michigan.map$names, ","), function(x) x[2])
county.sp <- map2SpatialPolygons(michigan.map, IDs = IDs,
            proj4string = CRS("+proj=longlat +ellps=WGS84"))
plot(county.sp)

michigan.map <- map("county",region="Michigan", plot = FALSE, fill = TRUE)
IDs <- sapply(strsplit(michigan.map$names, ","), function(x) x[2])
county.sp <- map2SpatialPolygons(michigan.map, IDs = IDs,
            proj4string = CRS("+proj=utm +zone=16 +datum=WGS84"))
plot(county.sp)


#Problem E:

library(maps)
sat = read.csv("popdata_lab2.csv", header = TRUE, row.names=1)
row.names(sat) = tolower(row.names(sat))
str(sat)
id <- match(row.names(sat), row.names(county.sp))
county.spdf <- SpatialPolygonsDataFrame(county.sp, sat)
spplot(county.spdf)


