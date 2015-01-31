#A. SCRIPT SETUP
#set working directory
setwd("G:/NRE543/Lab3")
#clear all variables
rm(list=ls())
#load libraries
install.packages(c("sp","gstat","RColorBrewer"))
library(sp); library(gstat); library(RColorBrewer)

#B. load meuse points, polygons, and grid, and convert to Spatial objects
data(meuse)
coordinates(meuse) = c("x", "y")
data(meuse.riv)
meuse.lst = list(Polygons(list(Polygon(meuse.riv)), "meuse.riv"))
meuse.pol = SpatialPolygons(meuse.lst)
data(meuse.grid)
coordinates(meuse.grid) = c("x", "y")
gridded(meuse.grid) = TRUE

#C. create plot using traditional plotting methods (plot)
#create interpolated grid of log(zinc)
zn.idw = krige(log(zinc) ~ 1, meuse, meuse.grid)
#create plot
cols <- brewer.pal(4, "Reds")
image(zn.idw, col = cols, breaks=log(c(100,200,400,800,1800)))
plot(meuse.pol, add = TRUE)
plot(meuse, pch = 1, cex = sqrt(meuse$zinc)/20, add = TRUE)
legVals <- c(100, 200, 500, 1000, 2000)
legend("bottomleft", legend=legVals, pch = 1, pt.cex = sqrt(legVals)/20, bty = "n",
       title="measured, ppm", cex=0.7, y.inter=0.9)
legend("topleft", fill = cols, legend=c("100-200","200-400","400-800",
                                        "800-1800"), bty = "n", title = "interpolated, ppm", cex=0.7, y.inter=0.9)
title("measured and interpolated zinc")


#D. create multi-panel plot using Trellis graphic system (spplot)
cuts=c(0,20,50,200,500,2000)
redss <- brewer.pal(7, "Reds")
print(spplot(meuse[1:4], main = "ppm", cuts=cuts, cex=.5, 
             col.regions=redss, key.space="right"),split=c(1,1,1,2),more=TRUE)
meuse$lead.st = as.vector(scale(meuse$lead))
meuse$zinc.st = as.vector(scale(meuse$zinc))
meuse$copper.st = as.vector(scale(meuse$copper))
meuse$cadmium.st = as.vector(scale(meuse$cadmium))
cuts2=c(-1.2,0,1,2,3,5)
print(spplot(meuse, c("cadmium.st", "copper.st", "lead.st", "zinc.st"), 
             key.space="right", main = "standardised", cex = .5, 
             cuts = cuts2, col.regions=redss), split=c(1,2,1,2))
#Note: 'split' is a vector of 4 integers, c(x,y,nx,ny) , that says to position the current 
#      plot at the x,y position in a regular array of nx by ny plots. (Note: this has origin at top left)


#Problem A:
river <- list("sp.polygons", meuse.pol)

cuts=c(0,20,50,200,500,2000)
redss <- brewer.pal(7, "Reds")
print(spplot(meuse[1:4], main = "ppm", sp.layout = river, cuts=cuts, cex=.5, 
             col.regions=redss, key.space="right"),split=c(1,1,1,2),more=TRUE)
meuse$lead.st = as.vector(scale(meuse$lead))
meuse$zinc.st = as.vector(scale(meuse$zinc))
meuse$copper.st = as.vector(scale(meuse$copper))
meuse$cadmium.st = as.vector(scale(meuse$cadmium))
cuts2=c(-1.2,0,1,2,3,5)
print(spplot(meuse, c("cadmium.st", "copper.st", "lead.st", "zinc.st"), 
             key.space="right", main = "standardised", cex = .5, sp.layout = river, 
             cuts = cuts2, col.regions=redss),
		 split=c(1,2,1,2))

 