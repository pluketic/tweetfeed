#Problem A

set.seed(20)
x1=rnorm(100)
x2=rnorm(100)
x3=rnorm(100)
t=data.frame(a=(x1),b=(x1+x2),c=(x1+x2+x3))
t
plot(t)
plot(t$a, type="l",ylim=range(t),lwd=3,col=rgb(1,0,0,0.3))
lines(t$b, type="s", lwd=2,col=rgb(0.3,0.4,0.3,0.9))
points(t$c,pch=20,cex=4,col=rgb(0,0,1,0.3))

plot(t$a,t$c, col="blue", xlab="a", ylab="b(blue) and c(red)")
points(t$b, pch=22, col="red")
abline(t$a, t$c, lty="dashed", col="gray")

#Problem B

write.table(t,file="lab1_timj.csv")

#Problem C

fun1=function(x,y){p=c()
r=seq(from=x,to=y)
for(i in -4:0){p[i]=r[i]*0.5}
for(i in 0:4){p[i]=r[i]*2}}
fun1(x=1,y=100)
p
mean(p)

#Problem D

lm.ba=lm(t$b~t$a)
summary(lm.ba)


