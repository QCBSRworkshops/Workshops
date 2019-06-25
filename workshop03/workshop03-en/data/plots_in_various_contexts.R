library(ggpubr)

library(ggplot2)
library(dplyr)
library(tidyr)

if(!require(ggpubr)) install.packages("ggpubr")
if(!require(ggpubr)) library(ggpubr)

if(!require(ggsignif)) install.packages("ggsignif")
if(!require(ggsignif)) library(ggsignif)

if(!require(rworldmap)) install.packages("rworldmap")
if(!require(rworldmap)) library(rworldmap)

if(!require(maps)) install.packages("maps")
if(!require(maps)) library(maps)

if(!require(vioplot)) install.packages("vioplot")
if(!require(vioplot)) library(vioplot)

if(!require(ggdendro)) install.packages("ggdendro")
if(!require(ggdendro)) library(ggdendro)

if(!require(ggvegan)) devtools::install_github("gavinsimpson/ggvegan")
if(!require(ggvegan)) library(ggvegan)

# GGplot assumes that your data is recorded in a database properly (the categories are well defined)

# Blank -------------------------------------------------------------------
gblank <- ggplot(mtcars, aes(wt, mpg))
gblank <- gblank + theme(plot.subtitle = element_text(vjust = 1), 
                        plot.caption = element_text(vjust = 1)) +
  labs(title = "Blank plot")
plot(mpg~wt, data = mtcars, type = "n")


# Data exploration  -------------------------------------------------------

# Data exploration
pairs(iris)

# library(IDPmisc)

panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col="blue4", ...)
}

panel.cor <- function(x, y, digits=2, prefix="", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y, method = "pearson")) # can be "spearman"
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex <- 0.7/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex * r)
}

betterPairs <- function(YourData, col = c("black")){
  return(pairs(YourData, 
               lower.panel=function(...) {
                 par(new=TRUE);
                 panel.smooth(col=col,
                              col.smooth = "gold",...)},
               diag.panel=panel.hist, 
               upper.panel=panel.cor))
}

betterPairs(iris)


# Histogram ---------------------------------------------------------------
ghis = ggplot(diamonds, aes(carat)) + geom_histogram(binwidth = .5) + labs(title = "Histogram")
hist(diamonds$carat)


# Barplot  --------------------------------------------------------------------
gbar = ggplot(mpg, aes(class)) + geom_bar()+ labs(title = "Barplot")
gbar = gbar + theme(plot.subtitle = element_text(vjust = 1), 
                    plot.caption = element_text(vjust = 1), 
                    axis.text.x = element_text(angle = 90))
barplot(table(mpg$class))
ir.s=iris %>% 
  group_by(Species) %>% 
  summarise(mean.sp = mean(Sepal.Length))
iris %>% 
  group_by(Species) %>% 
  summarise(pval = t.test(Sepal.Length, 
                          var.equal = TRUE)$p.value)



dat <- data.frame(Group = c("S1", "S1", "S2", "S2"),
                  Sub   = c("A", "B", "A", "B"),
                  Value = c(3,5,7,8),
                  low = c(2.5,4.5,6,7.5),
                  high = c(3.5,5.5,7,8.5))  



gbar2 = ggplot(data = dat, aes(x = Group, y = Value,fill = Sub)) +
  geom_bar(#aes(fill = Sub), 
    stat="identity", 
    position="dodge", 
    width=.5) +
  geom_errorbar(aes(ymin=low, 
                    ymax=high),
                width = 0.1,
                position =  position_dodge(.5), colour="black") +
  labs(title = "Barplot") +
  scale_fill_manual(values = c("grey80", 
                               "grey20")) + 
  geom_signif(stat="identity",
              data=data.frame(x=c(0.875, 1.875),
                              xend=c(1.125, 2.125),
                              y=c(5.8, 8.8),
                              Sub=c("A","B"),
                              annotation=c("**", "NS")),
              aes(x=x,xend=xend, y=y, yend=y,
                  annotation=annotation)) +
  geom_signif(comparisons=list(c("S1", "S2")),
              annotations="***",
              y_position = 9.3,
              tip_length = 0,
              vjust=0.4)

gbar2

df=data.frame(S1 = c(3,5), S2=c(7,8))
my.bp =barplot(as.matrix(df),
               beside = TRUE,
               xlab = "Group",
               ylab = "Value",
               main = "Barplot",
               ylim = c(0,12),
               legend = rownames(df),
               args.legend = list(x = "topright", 
                                  bty = "n", 
                                  inset=c(-0.07, 0))
               # args.legend=list(
               #   x=ncol(df)+4,
               #   y=min(colSums(df)),
               #   bty = "n"
               # )
)
sign.bar = function(pos,select.pair, y, offset = 0.2, label, mid = FALSE) {
  # create the y coordinate of the line
  y <- y
  # set an offset for tick lengths
  offset <- offset
  # draw first horizontal line
  if (!mid) {
    lines(pos[select.pair],c(y, y))
    # draw ticks
    lines(pos[c(select.pair[1],select.pair[1])],c(y, y-offset))
    lines(pos[c(select.pair[2],select.pair[2])],c(y, y-offset))
  } else {
    lines(x = c(c(pos[select.pair[1]-1]+
                    pos[select.pair[1]])/2,
                c(pos[select.pair[2]]+
                    pos[select.pair[2]+1])/2),
          c(y, y))
    # draw ticks
    lines(c(c(pos[select.pair[1]-1]+
                pos[select.pair[1]])/2,
            c(pos[select.pair[1]-1]+
                pos[select.pair[1]])/2),
          c(y, y-offset))
    lines(c(c(pos[select.pair[2]]+
                pos[select.pair[2]+1])/2,
            c(pos[select.pair[2]]+
                pos[select.pair[2]+1])/2),
          c(y, y-offset))
  }
  # draw asterics
  text(pos[select.pair[1]]+((pos[select.pair[2]]-pos[select.pair[1]])/2),y+offset*2,
       labels = label) 
}
sign.bar(my.bp, select.pair = c(1,2),y =6,label = "**")
sign.bar(my.bp, select.pair = c(3,4),y =8.8,label = "NS")
sign.bar(my.bp, select.pair = c(2,3),y =10,label = "***",mid = TRUE)


# Linear model --------------------------------------------------------------------
gsmooth <- ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(method = lm)+ labs(title = "Plot")

# predicts + interval
lm.out  <- lm(hwy~displ, data = mpg)
newx <- seq(min(mpg$displ), max(mpg$displ), length.out=100)
preds <- predict(lm.out, newdata = data.frame(displ=newx), 
                 interval = 'confidence')
plot(hwy~displ, data = mpg, bg = "black", col = "black", pch =21)
polygon(c(rev(newx), newx), 
        c(rev(preds[ ,3]), preds[ ,2]), 
        col = 'grey80', border = NA)
abline(lm.out)
lines(newx, preds[ ,3], lty = 'dashed', col = 'red')
lines(newx, preds[ ,2], lty = 'dashed', col = 'red')


glinear.iris <- ggplot(data = iris,aes(x = Sepal.Length, y = Sepal.Width, col = Species)) + geom_point() + geom_smooth(method = "lm")+ labs(title = "Plot with categories")
glinear.iris
# Boxplot -----------------------------------------------------------------
gbox = ggplot(data = iris, aes(Species, Sepal.Length)) + 
  geom_boxplot()+ 
  labs(title = "Boxplot")+  
  geom_signif(comparisons = list(c("versicolor", "virginica")), 
              map_signif_level=TRUE)
gviolin = ggplot(data = iris, aes(Species, Sepal.Length)) + geom_violin()+ labs(title = "Violin plot")


boxplot(iris$Sepal.Length ~ iris$Species) # For analysis of variance 
library(vioplot)
vioplot(iris$Sepal.Length[iris$Species == "setosa"],
        iris$Sepal.Length[iris$Species == "versicolor"],
        iris$Sepal.Length[iris$Species == "virginica"],
        col = "lightblue")



# Error bar ---------------------------------------------------------------
df <- data.frame(
  trt = factor(c(1, 1, 2, 2)),
  resp = c(1, 5, 3, 4),
  group = factor(c(1, 2, 1, 2)),
  upper = c(1.1, 5.3, 3.3, 4.2),
  lower = c(0.8, 4.6, 2.4, 3.6)
)

p <- ggplot(df, aes(trt, resp, colour = group))
p + geom_linerange(aes(ymin = lower, ymax = upper))
p + geom_pointrange(aes(ymin = lower, ymax = upper))
p + geom_crossbar(aes(ymin = lower, ymax = upper), width = 0.2)
gerror =p + geom_errorbar(aes(ymin = lower, 
                              ymax = upper), 
                          width = 0.2) + labs(title = "Plot with error bars")


df <- data.frame(grp = c("A", "B"), fit = 4:5, se = 1:2)
k <- ggplot(df, aes(grp, fit, ymin = fit-se, ymax = fit+se))
k + geom_crossbar(fatten = 2)
k + geom_errorbar()
k + geom_linerange()
k + geom_pointrange()


plot(y~x,
     type = "p",
     pch =21,
     bg = "black",
     col = "black",
     ylim = c(0,4),
     xlim = c(0,3),
     xaxt="n",
     main = "My graph",
     xlab = "Site Category",
     ylab = "Mean")
axis(side = 1, at = c(1,2), labels = levels(c("yo","man")), cex.lab =1, cex.axis =1)
x = as.numeric(c(1,2))
y = c(2,3)
mean = mean(y)

error.bar <- function(x,
                      y,
                      epsilon = NULL, 
                      se = NULL, 
                      se.mul = 1,
                      col = "black") {
  x = as.numeric(x)
  if(is.null(se)){
    stderr <- function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))
    se = se.mul*stderr(y)
  } else {se = se.mul*se}
  
  segments(x, y-se,x, y+se,col = col)
  if(is.null(epsilon)){
    epsilon = 0.02} else {epsilon = epsilon}
  segments(x-epsilon,y-se,x+epsilon,y-se,col = col)
  segments(x-epsilon,y+se,x+epsilon,y+se,col = col)
}
error.bar(x,y)




# maps --------------------------------------------------------------------

crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimesm <- reshape2::melt(crimes, id = 1)
library(maps)
states_map <- map_data("state")
gmap <- ggplot(crimes, aes(map_id = state)) +
  geom_map(aes(fill = Murder), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) + coord_map()+ labs(title = "Map")

library(rworldmap)
newmap <- rworldmap::getMap(resolution = "high")
plot(newmap, xlim = c(-92, -89)
     , ylim = c(-1.5, 0.5)
     , asp = 1
     , main = "Galapagos islands"
)


# Density graph  ----------------------------------------------------------
gdensity = ggplot(diamonds, aes(carat)) +geom_density()+ labs(title = "Density graph")

plot(density(c(-20, rep(0,98), 20)), xlim = c(-4, 4),
     main = "Density graph")



# Dendrogram --------------------------------------------------------------

library("ggplot2")
library("ggdendro")
# Visualization using the default theme named theme_dendro()
gdendro = ggdendrogram(hc)+ labs(title = "Dendrogram")
ggdendrogram(hc, rotate = TRUE, theme_dendro = FALSE)

USArrests.short = USArrests[1:10,]
hc <- hclust(dist(USArrests.short), "ave")
plot(hc, hang = -1, main = "Dendrogram")



# Multivariate stuff ------------------------------------------------------

library(ggvegan)
dune.pca <- rda(dune)
gpca = autoplot(dune.pca)+ labs(title = "PCA") # your result object


# Data exploration
pairs(iris)
betterPairs(iris)


par(mfrow=c(3,4))
# par(mfrow=c(1,1))
plot(mpg~wt, data = mtcars, type = "n", main = "Blank plot")

hist(diamonds$carat, xlab = "Carat", main = "Histogram")

df=data.frame(S1 = c(3,5), S2=c(7,8))
my.bp =barplot(as.matrix(df),
               beside = TRUE,
               xlab = "Group",
               ylab = "Value",
               main = "Barplot",
               ylim = c(0,12)#,
               # legend = rownames(df),
               # args.legend = list(x = "topright", 
               #                    bty = "n", 
               #                    inset=c(-0.07, 0))
               # args.legend=list(
               #   x=ncol(df)+4,
               #   y=min(colSums(df)),
               #   bty = "n"
               # )
)

# foo = barplot(table(mpg$class), main = "Barplot", xaxt = "n")
arrows(x0=my.bp,
       y0=as.matrix(df)+as.matrix(df)*.1,
       y1=as.matrix(df)-as.matrix(df)*.1,
       angle=90,
       code=3,length=0.05)
sign.bar(my.bp, select.pair = c(1,2),y =6,label = "**")
sign.bar(my.bp, select.pair = c(3,4),y =10.0,label = "NS")
sign.bar(my.bp, select.pair = c(2,3),y =11,label = "***",mid = TRUE)

# labs <- paste(names(as.matrix(df)), "", sep = "")
# text(cex=1, x=my.bp, y=0, labs, xpd=TRUE, srt=90,adj = 1)

plot(hwy~displ, data = mpg, main = "Plot",
     bg = "black", col = "black", pch =21)
polygon(c(rev(newx), newx), 
        c(rev(preds[ ,3]), preds[ ,2]), 
        col = 'grey80', border = NA)
abline(lm.out)
lines(newx, preds[ ,3], lty = 'dashed', col = 'red')
lines(newx, preds[ ,2], lty = 'dashed', col = 'red')


c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", 
  "Species")
plot(Sepal.Width~ Sepal.Length,
     data = iris, 
     pch = 21, 
     main = "Plot with categories",
     col = iris$Species, 
     bg = iris$Species) # lm
sp.names=unique(iris$Species)
color = c("black","red","green")
for (i in 1:length(unique(iris$Species))) {
  tmp = iris[iris$Species == sp.names[i],]
  tplm=lm(Sepal.Width~ Sepal.Length, data = tmp)
  abline(tplm,col = color[i])
}

bp1 =boxplot(iris$Sepal.Length ~ iris$Species, 
             main = "Boxplot",ylim = c(min(iris$Sepal.Length)-.5,
                                       max(iris$Sepal.Length)+.5)) # For analysis of variance 
sign.bar(pos = 2:3,y = 8.3,offset = .1, select.pair = c(1,2),label = "***")




library(vioplot)
vioplot(iris$Sepal.Length[iris$Species == "setosa"],
        iris$Sepal.Length[iris$Species == "versicolor"],
        iris$Sepal.Length[iris$Species == "virginica"],
        col = "lightblue")
title(main = "Violin Plot")

x = as.numeric(c(1,2))
y = c(2,3)

plot(y~x,
     type = "p",
     pch =21,
     bg = "black",
     col = "black",
     ylim = c(0,4),
     xlim = c(0,3),
     xaxt="n",
     main = "Plot with error bars",
     xlab = "Site Category",
     ylab = "Mean")
axis(side = 1, at = c(1,2), 
     cex.lab =1, 
     cex.axis =1)
error.bar(x,y)


plot(newmap, xlim = c(-92, -89)
     , ylim = c(-1.5, 0.5)
     , asp = 1
     , main = "Map"
)

plot(density(c(-20, rep(0,98), 20)), xlim = c(-4, 4),main = "Density graph")

USArrests.short = USArrests[1:10,]
hc <- hclust(dist(USArrests.short), "ave")
plot(hc, hang = -1, main = "Dendrogram")


# require(graphics); require(grDevices)
# car.x  <- as.matrix(mtcars)
# x.dat = car.x[1:10,]
# # rc <- rainbow(nrow(x), start = 0, end = .3)
# # cc <- rainbow(ncol(x), start = 0, end = .3)
# hd=heatmap(x.dat, 
#         # col = cm.colors(256), 
#         scale = "column",
#         # RowSideColors = rc, 
#         # ColSideColors = cc, margins = c(5,10),
#         xlab = "Specification variables",
#         # ylab =  "Car Models",
#         main = "Heatmap")

library(vegan)
data(dune)
data(dune.env)
dune.Manure <- rda(dune ~ Manure, dune.env)
plot(dune.Manure, main = "PCA") 


library(grid)
library(gridExtra)
grid.arrange(gblank, ghis, gbar2, gsmooth,
             glinear.iris, gbox, gviolin, gerror,
             gmap, gdensity, gdendro, gpca, nrow = 3)
