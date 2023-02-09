# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  install.packages('tidyverse')
  install.packages('ggplot2')
  install.packages('scales')
  install.packages('reshape2')
}

library(tidyverse) # read_csv
library(ggplot2)
library(scales) # dollars
library(reshape2) # melt

costs <- read_csv('composition/data/costs.csv', col_names=FALSE)

mytheme <- theme_set(theme_classic()) 
mytheme <- theme_update(
  # establish a fundamental charting theme
  text = element_text(size=11, family=''),
  plot.margin = margin(5,10,4,8,'lines'),
  axis.ticks = element_blank(),
  panel.background = element_rect(fill='white',color='white'),
  axis.line = element_line(color='transparent'),
  axis.text.x = element_blank(),
  axis.text.y = element_text(colour='black',size=11),
  legend.position = "NONE"
)

ggplot(costs,aes(y=reorder(X1,X2,sum),x=X2)) + 
  # plot the very basics
  geom_col(width=9/10,fill='dodgerblue') +
  geom_text(label=dollar(costs$X2),color='dodgerblue',position='dodge',size=4,hjust=-1/10) +
  scale_x_continuous(expand=c(0,0)) +
  xlab(NULL) + ylab(NULL) +
  coord_cartesian(clip="off")


ggplot(costs,aes(y=reorder(X1,X2,sum),x=X2)) + 
  # plot to give a hint
  geom_col(width=9/10,fill='forestgreen') +
  geom_text(label=dollar(costs$X2),color='forestgreen',position='dodge',size=4,hjust=-1/10) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_discrete(limits=rev) +
  xlab(NULL) + ylab(NULL) +
  coord_cartesian(clip='off')


# a stack will 'center' the bars...
most <- max(costs$X2)
costsplus <- transform(costs,X3=ceiling((most-X2)/2))
coststall <- melt(costsplus,id.vars=c('X1'))


ggplot(coststall,aes(y=reorder(X1,value,sum),x=value,fill=variable)) + 
  # plot to make it more obvious
  geom_col(position='stack',width=9/10) +
  geom_text(aes(label=ifelse(variable=='X2',dollar(value),'')),size=4,hjust=-1/10,position="stack",color='forestgreen') +
  scale_fill_manual(values=c("forestgreen", "beige")) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_discrete(limits=rev) +
  xlab(NULL) + ylab(NULL) +
  coord_cartesian(clip='off')


# add to styles for the titles
mytheme <- theme_update(
  plot.margin = margin(5,15,4,12,'lines'),
  plot.title = element_text(color='deeppink',face='bold',size=20,hjust=5/10,vjust=9),
  plot.subtitle = element_text(color='deeppink',size=13,hjust=5/10,vjust=14),
  plot.caption = element_text(size=10,hjust=5/10,vjust=-12)
)

ggplot(coststall,aes(y=reorder(X1,value,sum),x=value,fill=variable)) + 
  # plot the finishing touches
  geom_segment(x=most/2,xend=most/2,y=-1,yend=1,size=12,color="sienna",linetype=1) +
  geom_col(position='stack',width=9/10) +
  geom_text(aes(label=ifelse(variable=='X2',dollar(value),'')),size=4,hjust=-1/10,position="stack",color='forestgreen') +
  geom_text(aes(label=ifelse(variable=='X3',X1,'')),size=4,hjust=11/10,position="stack",color='black') +
  scale_fill_manual(values=c("forestgreen", "white")) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_discrete(limits=rev,labels=NULL) +
  annotate('text',x=most/2,y=26.5,label='\u269D',size=16,color='gold') +
  labs(
    title='The Cost of Christmas Around the World',
    subtitle='Money Spent on Food, Decorations, and Gifts (in US dollars)',
    caption='Data: World Report, 2022  |  Source: Genuine Imact'
  ) +
  xlab(NULL) + ylab(NULL) +
  coord_cartesian(clip='off')


# to add a font...
# to get output right (use a device 2048 x 1259)...

library(showtext)
font_add_google(name="Ubuntu Condensed", family="ubuntu-condensed")
theme_update(
  plot.margin = margin(8,24,6,24,'lines'),
  plot.title = element_text(color='deeppink',face='bold',size=40,hjust=5/10,vjust=9),
  plot.subtitle = element_text(color='deeppink',size=24,hjust=5/10,vjust=14),
  plot.caption = element_text(size=20,hjust=5/10,vjust=-10)
)
showtext_auto(T)
ggplot(coststall,aes(y=reorder(X1,value,sum),x=value,fill=variable)) + 
  # plot the finishing touches
  geom_segment(x=most/2,xend=most/2,y=-1,yend=1,size=12,color="sienna",linetype=1) +
  geom_col(position='stack',width=9/10) +
  geom_text(aes(label=ifelse(variable=='X2',dollar(value),'')),size=7,hjust=-1/10,position="stack",color='forestgreen',family='ubuntu-condensed') +
  geom_text(aes(label=ifelse(variable=='X3',X1,'')),size=7,hjust=11/10,position="stack",color='black',family='ubuntu-condensed') +
  scale_fill_manual(values=c("forestgreen", "white")) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_discrete(limits=rev,labels=NULL) +
  annotate('text',x=most/2,y=26.5,label='\u269D',size=16,color='gold',family='') +
  labs(
    title='The Cost of Christmas Around the World',
    subtitle='Money Spent on Food, Decorations, and Gifts (in US dollars)',
    caption='Data: World Report, 2022  |  Source: Genuine Impact  '
  ) +
  xlab(NULL) + ylab(NULL) +
  coord_cartesian(clip='off')
showtext(F)
