# install.packages("rlang")
# install.packages("ggplot2", dependencies = TRUE, repos = "http://cran.us.r-project.org")
# install.packages("tidyverse", dependencies = TRUE, repos = "http://cran.us.r-project.org")
# install.packages("reshape", dependencies = TRUE, repos = "http://cran.us.r-project.org")

library(ggplot2)
library(tidyverse)
library(reshape) # melt
library(scales)

library(showtext)
font_add_google(name="Azeret Mono", family="azeret-mono")
font_add_google(name="Barlow", family="barlow")
showtext_auto()

probability <- read_csv("long-covid-heatmap/long-covid-plain.csv")

melt(as.matrix(t(probability)))

dev.new(width=900, height=900, unit="px", noRStudioGD = TRUE)
ggplot(melt(as.matrix(t(probability))), aes(X1,X2, fill=value)) +
  geom_tile(aes(fill = value), colour = "white") +
  geom_text(aes(label = ifelse(value<.1, "5%", round(value*100,1))), size=4, family="azeret-mono", colour="white") +
  scale_fill_gradientn(values=c(0,0.8,0.95,1), colours=c("darkturquoise","tomato","darkslateblue","midnightblue")) +
  scale_y_reverse(breaks = 1:20) +
  ggtitle("% Probability of Getting Long COVID") +
  xlab(NULL) + ylab("Number of Infections\n") +
  theme(
    legend.position = "none",
    axis.ticks = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(size=12),
    axis.title.y = element_text(size=20,hjust=0.5,family="barlow"),
    plot.title = element_text(size=24,hjust=0.5,family="barlow"),
    plot.margin=margin(2,3,3,3,"lines"),
    panel.background=element_rect(fill="white"),
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    text = element_text(size=50, family="azeret-mono"))

# dev.list()
# showtext_auto(FALSE)