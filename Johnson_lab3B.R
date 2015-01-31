t=read.table (file="Temp_Jan1_2004.txt", header=TRUE)
summary(t)
hist(t$forecast)
hist(t$obs)
var(t$forecast)
var(t$obs)
hist(meuse$zinc)

coordinates(t) =c("longitude", "latitude")
proj4string = CRS("+proj=longlat +ellps=WGS84")

state.map <- map("state", plot = FALSE, fill = TRUE)
IDs <- sapply(strsplit(state.map$names, ":"), function(x) x[1])
state.sp <- map2SpatialPolygons(state.map, IDs = IDs,
            proj4string = CRS("+proj=longlat +ellps=WGS84"))
plot(state.sp)


plot(temp.grid, axes=TRUE)

#Problem C:
#forecast temperatures
temp.grid=SpatialGrid(GridTopology(c(-125,42),c(0.25,0.25),c(36,30)))
idw3 = krige (forecast~1, t, temp.grid)
proj4string(temp.grid)=CRS("+proj=longlat +ellps=WGS84")
cols <- brewer.pal(7, "Reds")
cols2 <- brewer.pal(7, "Blues")

image(idw3, col = cols, breaks=(c(250,255,260,265,270,275,280,285)), axes=TRUE)
plot(state.sp, add = TRUE)
plot(t, pch = 1, col=cols2, cex=sqrt(t$forecast-249)/5, add = TRUE)
legend("bottomleft", fill = cols, legend=c("250-255","255-260","260-265", "265-270", 
	"270-275", "275-280", "280-285"), bty = "n", title = "Interpolated Forc.(Kelvin)", cex=0.55, y.inter=0.7)
title("Forecast Temperatures for Washington and Oregon, 2004")
legVals <- c(250, 255, 260, 265, 270, 275, 280, 285)
legend("topleft", fill=cols2, legend=legVals, pt.cex=sqrt(legVals-249)/5, bty = "n",
       title="Measured Forc.(Kelvin)", cex=0.55, y.inter=0.7)

#Observed Forecasts:
temp.grid=SpatialGrid(GridTopology(c(-125,42),c(0.25,0.25),c(36,30)))
idw2 = krige (obs~1, t, temp.grid)
proj4string(temp.grid)=CRS("+proj=longlat +ellps=WGS84")
cols <- brewer.pal(7, "Reds")
cols2 <- brewer.pal(7, "Blues")

image(idw2, col = cols, breaks=(c(250,255,260,265,270,275,280,285)), axes=TRUE)
plot(state.sp, add = TRUE)
plot(t, pch = 1, col=cols2, cex=sqrt(t$obs-249)/5, add = TRUE)
legend("bottomleft", fill = cols, legend=c("250-255","255-260","260-265", "265-270", 
	"270-275", "275-280", "280-285"), bty = "n", title = "Interpolated Obs.(Kelvin)", cex=0.55, y.inter=0.7)
title("Observed Temperatures for Washington and Oregon, 2004")
legVals <- c(250, 255, 260, 265, 270, 275, 280, 285)
legend("topleft", fill=cols2, legend=legVals, pt.cex=sqrt(legVals-249)/5, bty = "n",
       title="Observed Forc.(Kelvin)", cex=0.55, y.inter=0.7)

#Problem D:
pts=list("sp.points",t,col='black')
pal=function(n=9)brewer.pal(n,"cols")
spplot(agg,sp.layout=pts,col.region=pal,cuts=9)
red <- brewer.pal(7, "Reds")

print(spplot(t$obs, main = "Observed Forecasts, 2004", cuts=c(250,255,260,265,270,275,280,285), cex=.5, 
             col.regions=red, key.space="right"),split=c(1,2,1,2),more=TRUE)

country<-list("sp.polygons",state.sp)
print(spplot(t[4:3],sp.layout=country, main = "Measured and Observed Forecasts, 2004",cuts=c(250,255,260,265,270,275,280,285), cex=.5, 
             col.regions=red, key.space="right"),split=c(1,1,1,1),more=TRUE)

