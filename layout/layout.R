# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  install.packages("cowplot")
}

library(ggplot2)
library(cowplot)

p <- ggplot(mpg, aes(displ, cty)) +
  geom_point() +
  theme_minimal_grid()

colors <- c('#006692')
heading <- "Is it possible for an age-limited intervention, such as monoclonal
antibodies, to be too good?"


ggdraw(p) + draw_label("Draft", colour = "#80404080", size = 120, angle = 45)


ggdraw() + 
  draw_label(
    heading, 
    colour=colors, 
    fontfamily='Calibri',
    fontface='bold',
    size=24,
    lineheight=0.9,
    x=0, y=1, 
    hjust=0, vjust=1)

#alternative
# windowsFonts(A=windowsFont('Calibri')) # investigate
par(mar=rep(0,4))
plot.new()
text(0,1,heading,c(0,1),cex=2,col=colors,family='Calibri',font=2)

temp <- c(Sun=22,Mon=27,Tue=26,Wed=24,Thu=23,Fri=26,Sat=28)

par(mfrow=c(1,2),mar=c(10,5,5,5)) # mfrow is split, mar is mar in lines (mai is inches)
barplot(temp, main="Barplot")
pie(temp, main="Piechart", radius=1)

par('pin') # plotting area (in)

par('din') # dim of inches

dev.size(units='px') # inches is default, units='cm'

par('mai')
par('mar')

par(mar=rep(0,4))
