#A. SCRIPT SETUP
#set working directory
setwd("F:/NRE543/Lab4")
#clear all variables
rm(list=ls())
#load libraries
install.packages(c("rgdal"))
install.packages(c("sp","rgeos","RColorBrewer","lattice"))
library(sp); library(rgeos); library(RColorBrewer); 
library(lattice); library(rgdal)

#read olinda census and river shapefile
olinda <- readOGR(".", "olinda1")
stream_utm <- readOGR(".", "stream")

olinda_utm <- spTransform(olinda, CRS("+init=epsg:31985"))
stream_utm <- spTransform(stream_utm, CRS("+init=epsg:31985"))
plot(olinda_utm, axes=TRUE); 
plot(stream_utm, col="blue", add=TRUE)

#get unary union merge of olinda. new comment. Hahahaha
oScale <- getScale() #record original rgeos utility scale
setScale(1e+4) #set to coarse scale
bounds <- gUnaryUnion(olinda_utm)
setScale(oScale) #return to original scale
sapply(slot(slot(bounds, "polygons")[[1]], "Polygons"), slot, "area")
plot(bounds, lwd=2, add=TRUE)

#get centroid points
olinda_pnt = gCentroid(olinda_utm, byid=TRUE)
plot(olinda_pnt, pch=1, cex=0.4, col="red", add=TRUE)

#read raster data
pan <- readGDAL("L7_ETM8s.tif") #landset panchromatic band
TM <- readGDAL("L7_ETMs.tif") #landsat bands 1-7
names(TM) <- c("TM1", "TM2", "TM3", "TM4", "TM5", "TM7")
dem <- readGDAL("olinda_dem_utm25s.tif") #digital elevation model

#dem[dem <= 0] = NA

dem$band1[dem$band1 <= 0] = NA
image(dem, col=terrain.colors(10, alpha=0.5), add=TRUE)

#redefine the raster projection
proj4string(pan) #original raster projection
#Note: the new projection is essentially the same as the original;
#      we just need the CRS string to exactly match the vector CRS string 
#      (ignore warnings).
proj4string(pan) <- CRS(proj4string(bounds))
proj4string(TM) <- CRS(proj4string(bounds))
proj4string(dem) <- CRS(proj4string(bounds))

#determine population density and plot it
olinda_utm$area <- sapply(slot(olinda_utm, "polygons"), slot, "area")
olinda_utm$dens <- olinda_utm$V014/(olinda_utm$area/1000000)
spplot(olinda_utm, "dens", at=c(0, 8000, 12000, 15000, 20000, 60000), 
       col.regions=brewer.pal(6, "YlOrBr")[-1], col="grey30", lwd=0.5, 
       colorkey=list(space="right", labels=list(cex=0.7), width=1))

#determine NDVI and plot it
TM$ndvi <- (TM$TM4 - TM$TM3)/(TM$TM4 + TM$TM3)
spplot(TM, "ndvi",cuts=4,col.regions= brewer.pal(5, "Greens"))
agg.ndvi <- aggregate(TM["ndvi"], olinda_utm, mean)
spplot(agg.ndvi,  at=c(-.4,-0.2,-0.1,0,0.1,0.2,0.4), 
       col.regions=brewer.pal(8, "Greens"))

#create a grid that covers Olinda
olinda.grid=SpatialGrid(GridTopology(cellcentre.offset=c(288000,9110000),
                                     cellsize=c(100,100),cells.dim=c(150,120)))
proj4string(olinda.grid) =  CRS(proj4string(bounds))
gridded(olinda.grid) =FALSE #convert grid to points
plot(bounds)
plot(olinda.grid, add=TRUE, cex=0.1)

#get distance from each grid point to the streams
sdist=gDistance(stream_utm, olinda.grid, byid=TRUE)
sdistm=apply(sdist,1,"min")
olinda.distgrid=SpatialPointsDataFrame(olinda.grid,as.data.frame(sdistm))
summary(olinda.distgrid)
gridded(olinda.distgrid) =TRUE #convert points to grid
spplot(olinda.distgrid,sp.layout=list("sp.lines",stream_utm))

#NDVI by census tract
agg.ndvi <- aggregate(TM["ndvi"], olinda_utm, mean)
spplot(agg.ndvi, 
at=c(-.4,-0.2,-.1,0,0.1,0.2,0.4), 
col.regions=brewer.pal(8, "Greens"))

#4. 
lm.ba=lm(olinda_utm$dens~(agg.ndvi$ndvi))
summary(lm.ba)

#5
agg.dem <- aggregate(dem, olinda_utm, mean)
spplot(agg.dem, 
at=c(0,20,40,60,80,100), 
col.regions=brewer.pal(8, "Greens"))

lm.a=lm(olinda_utm$dens~(agg.dem$band1))
summary(lm.a)

#6
lm.c=lm(olinda_utm$dens ~(agg.dem$band1 + agg.ndvi$ndvi))
summary(lm.c)

#8
print(spplot(TM, c("TM4", "TM5", "TM7", "TM1","TM2", "TM3" ),
cuts=8, col.regions= brewer.pal(9, "Greys"),
             key.space="right", main = "Landsat Bands", scales=list(draw=TRUE, cex=0.4), cex = .5), 
split=c(1,2,1,2))

#10:
agg.olinda.distgrid <- aggregate(olinda.distgrid, olinda_utm, mean)
spplot(agg.olinda.distgrid, 
at=c(0,100,200,300,400,500,600),
col.regions=brewer.pal(8, "Reds"))
plot(stream_utm, col="blue",add=TRUE)





