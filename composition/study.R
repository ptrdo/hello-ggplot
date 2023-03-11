# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  install.packages('tidyverse')
  install.packages('ggplot2')
  install.packages('magick')
  install.packages('ggimage')
}

options

library(tidyverse) # read_csv
library(ggplot2)
library(magick) # ggimage
library(ggimage) # ggbackground

study <- read_csv('composition/data/study.csv', col_names=FALSE)
study <- mutate(study,positive=X2>0)

mytheme <- theme_set(theme_classic()) 
mytheme <- theme_update(
  # establish a fundamental charting theme
  plot.margin = margin(6,4,6,2,'lines'),
  axis.ticks = element_blank(),
  panel.background = element_rect(color='transparent'),
  axis.line = element_line(color='transparent'),
  axis.text.x = element_blank(),
  axis.text.y = element_text(colour = 'transparent'),
  legend.position = 'NONE'
)

mypalette <- c('red','dodgerblue')

percent <- function(x,digits=2,format='f',...) {
  paste0(formatC(100*x,format=format,digits=digits,...),'%')
}

ggplot(study,aes(y=reorder(X1,X2,sum),x=X2,fill=positive)) + 
  # plot the very basics
  geom_col() +
  geom_text(label=percent(study$X2,0),position='dodge',size=7,hjust=ifelse(study$positive,13/10,-2/10)) +
  scale_x_continuous(expand=c(0,0)) +
  scale_fill_manual(values=mypalette) +
  xlab(NULL) + ylab(NULL)


# illustrate the gist

mypalette <- c('pink','yellow')
img <- 'composition/assets/board.png'

p <- ggplot(study,aes(y=reorder(X1,X2,sum),x=X2,fill=positive,color=positive)) + 
  # plot a little more
  geom_col(width=8/10,size=5/10,linetype=4) +
  geom_text(label=percent(study$X2,0),color='black',position='dodge',size=7,hjust=ifelse(study$positive,13/10,-2/10)) +
  scale_x_continuous(expand=c(0,0)) +
  scale_fill_manual(values=mypalette) +
  scale_color_manual(values=mypalette) +
  xlab(NULL) + ylab(NULL)

ggbackground(p, img)


# lastly...

library(showtext)
font_add_google(name='Ubuntu Condensed', family='ubuntu-condensed')
theme_update(
  plot.title = element_text(size=36,color='white',hjust=1,vjust=5),
  plot.margin = margin(4,4,6,2,'lines'),
  text = element_text(size=11, family='ubuntu-condensed'),
  axis.text.y = element_text(colour='white',size=21)
)
p <- ggplot(study,aes(y=reorder(X1,X2,sum),x=X2,fill=positive,color=positive)) + 
  # plot fancy
  geom_col(width=8/10,size=5/10,linetype=4) +
  geom_text(label=percent(study$X2,0),color='black',position='dodge',size=8,hjust=ifelse(study$positive,13/10,-2/10),family='ubuntu-condensed') +
  scale_x_continuous(expand=c(0,0)) +
  scale_fill_manual(values=mypalette) +
  scale_color_manual(values=mypalette) +
  labs(title='Fastest Growing—and Shrinking—Fields of Study, US Colleges, 2010-2021') +
  xlab(NULL) + ylab(NULL)
showtext_auto(T)
ggbackground(p,img)
showtext_auto(F)


# to get output right (use a device 2048 x 1259)...

mytheme <- theme_update(
  plot.title = element_text(size=53,color='white',hjust=1,vjust=8),
  plot.margin = margin(7,5,10,3,'lines'),
  text = element_text(size=11, family='ubuntu-condensed'),
  axis.text.y = element_text(colour='transparent',size=27)
)
pf <- ggplot(study,aes(y=reorder(X1,X2,sum),x=X2,fill=positive,color=positive)) + 
  # plot fancy
  geom_col(width=9/10,size=0,linetype=4) +
  geom_text(label=percent(study$X2,0),color='black',position='dodge',size=10,hjust=ifelse(study$positive,13/10,-2/10),family='ubuntu-condensed') +
  scale_x_continuous() +
  scale_fill_manual(values=mypalette) +
  scale_color_manual(values=mypalette) +
  labs(title='Fastest Growing—and Shrinking—Fields of Study, US Colleges, 2010-2021') +
  xlab(NULL) + ylab(NULL)
showtext_auto(T)
ggbackground(pf,img)
showtext_auto(F)
