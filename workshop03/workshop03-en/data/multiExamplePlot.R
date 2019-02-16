# create an apporpriate viewport.  Modify the dimensions and coordinates as needed
commm.h = .39 # This will change the "Height" of the ggplot graphs
y = 0.42 # This will change the relative position on the "y" axis of the graph output
vp.BottomRight <- viewport(height= unit(commm.h, "npc"),
                           width = unit(0.333, "npc"),
                           just  = c("left","top"),
                           y = y, x = .333)

vp.bbright <- viewport(height= unit(commm.h, "npc"),
                       width = unit(0.333, "npc"),
                       just  = c("left","top"),
                       y = y, x = .666)

# plot your base graphics
par(mfrow=c(2,3))
plot(iris[,c("Sepal.Length","Sepal.Width")], main = "Density plot",
     pch = 21, col = iris$Species,
     bg = iris$Species)
abline(lm(iris[iris$Species =="setosa",c("Sepal.Width","Sepal.Length")]),    col = "black")
abline(lm(iris[iris$Species =="versicolor",c("Sepal.Width","Sepal.Length")]),col = "red" )
abline(lm(iris[iris$Species =="virginica",c("Sepal.Width","Sepal.Length")]), col = "green" )

plot(density(iris[,c("Sepal.Length"),]), main = "Density plot")
hist(iris[,c("Sepal.Length")],
     main = "Histogram",
     xlab = "Sepal.Length",
     breaks = 12)
boxplot(iris[,c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")],
        main = "Boxplot",
        xlab = "Traits",
        breaks = 12)

#create your ggplot object
p <- ggplot(data = iris,aes(x = Sepal.Length,
                            y = Sepal.Width,
                            col = Species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme(legend.position="none")

q <- ggplot(data = iris,aes(x = Species,
                            y = Sepal.Width,
                            col = Species,
                            fill = Species)) +
  geom_violin() +
  theme(legend.position="none")

# plot the ggplot using the print command
print(p, vp=vp.BottomRight)
print(q, vp=vp.bbright)