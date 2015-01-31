
library(gstat)
data(meuse)
class(meuse)
names(meuse)

coordinates(meuse)=~x+y
class(meuse)
summary(meuse)

coordinates(meuse)[1:5,]

bubble(meuse,"zinc",col=c("#00ff0088","#00ff0088"), main="zinc concentrations (ppm")


##Problem A:

meuse1=meuse[is.na(meuse$om)==FALSE,]
bubble(meuse1,"om",col=c("#00ff0088","#00ff0088"), main="organic matter (ppm)")


#Section 4: Spatial Data on a regular grid
data(meuse.grid)
summary(meuse.grid)
class(meuse.grid)
coordinates(meuse.grid)=~x+y
class(meuse.grid)
gridded(meuse.grid)=TRUE
class(meuse.grid)
image(meuse.grid["dist"])
title("distance to river (red=0)")
zinc.idw=krige(zinc~1,meuse,meuse.grid)

class(zinc.idw)

spplot(zinc.idw["var1.pred"], main="zinc inverse distance weighted interpolations")

plot(log(zinc)~sqrt(dist),meuse)
abline(lm(log(zinc)~sqrt(dist),meuse))
class(zinc.idw)
?gridded