# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  install.packages('ggplot')
  install.packages('png')
}

library(ggplot2)
library(png)

theme_set(theme_light())

steps <- seq(-16,16,0.2)
wave <- data.frame(Time=steps,Amplitude=cos(steps))
  
p = ggplot(wave,aes(Time,Amplitude,colour='key')) +
  ggtitle('Getting the Resolution Correct') +  
  annotate('text',0,0,label='SIZE',color='white',alpha=0.2,fontface='bold',size=unit(30,'pt')) +
  scale_color_manual(values=c('cyan'),name='title') +
  geom_point(size=1) +
  # geom_point(size=1) +
  scale_x_continuous(
    expand=c(0,0), 
    limits=c(-16,16),
    breaks=c(-2,2)) +
  scale_y_continuous(
    expand=c(0,0), 
    limits=c(-4,4),
    breaks=c(-0.4,0,0.4)) +
  xlab(label='The x-axis should be exactly as wide as these words') +
  ylab(label='The y-axis should be about this tall') +
  annotate('text',-9.4,-1.6,label='Points should\nbarely touch',color='cyan',size=unit(4,'pt')) +
  theme(
    text=element_text(size=unit(20,'pt')),
    plot.margin=margin(3,3,3,3,'lines'),
    panel.background=element_rect(fill='darkslategrey'),
    axis.ticks=element_blank(),
    axis.text=element_blank(),
    legend.text=element_text(size=unit(15,'pt'),color='white'),
    legend.title=element_text(size=unit(15,'pt'),color='white'),
    legend.justification='right',
    legend.direction='horizontal',
    legend.position=c(1,1),
    legend.background=element_rect(fill='transparent'),
    legend.key=element_blank(),
    legend.margin=margin(c(4,1,1,1),unit="lines"),
    panel.grid.major=element_line(colour="transparent"),
    panel.grid.minor=element_line(colour="cyan")
  )



p


p$layers[[1]]$aes_params$size # annotation dim
theme_get()$text$size


png('resolution/output/PLOTA.png', width=1200, height=900) 

if (F) { 
  # plot(p + (theme(axis.title.x=element_text(size=unit(44,'pt'))))) # does nothing
  
  p$layers[[1]]$aes_params$size <- unit(72,'pt') # corrects "SIZE" size
  p$layers[[3]]$aes_params$size <- unit(8,'pt')
  
  p$theme$legend.title$size <- unit(36,'pt')
  p$theme$legend.text$size <- unit(36,'pt')
}

plot(p)
dev.off()


ggsave(
  filename = 'plot-4x3x2x200.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  units = c('in'),
  width = 4,
  height = 3, 
  scale = 2, # +/- dimension
  dpi = 200 # +/- resolution
)

ggsave(
  filename = 'plot-4x3x2x150.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  units = c('in'),
  width = 4,
  height = 3, 
  scale = 2, # +/- dimension
  dpi = 150 # +/- resolution
)

ggsave(
  filename = 'plot-4x3x2x300.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  units = c('in'),
  width = 4,
  height = 3, 
  scale = 2, # +/- dimension
  dpi = 300 # +/- resolution
)


dev.list()
dev.cur()
dev.next()
dev.cur()
dev.set(1)
dev.cur()

##########

theme_set(theme_minimal())

autoplot1 <- ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy, color=drv), size=4) +
  ggtitle('Fuel efficiency of vehicles by engine size and transmission') + 
  labs(color="Transmission") +
  xlab(label='Engine displacement in liters') +
  ylab(label='Highway miles per gallon') +
  scale_x_continuous(expand=c(0,0),limits=c(1.5,7)) +
  scale_y_continuous(expand=c(0,0),limits=c(5,50)) +
  scale_color_manual(
    values=c('dodgerblue','magenta','#FFB000'),
    breaks=c('f','r','4'),
    labels=c('Front','Rear','All/Four')) +
  coord_cartesian(clip='off') +
  theme(
    plot.margin=margin(3.5,0.5,4.5,0.5,'lines'),
    plot.title=element_text(face='bold'),
    legend.justification='right',
    legend.position=c(0.9,0.8),
    legend.background=element_rect(fill='white'),
    legend.key=element_blank()
  )

autoplot1

ggsave(
  filename = 'autoplot1-3x3x3x192.png', 
  path = 'resolution/output',
  plot = autoplot1,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 3,
  height = 3, 
  scale = 3, # +/- dimension
  dpi = 192 # +/- resolution
)

autoplot1$theme$plot.title$size # NULL
autoplot1$theme$axis.title.x$size # NULL
autoplot1$theme$legend.title$size # NULL


autoplot2 <- ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy, color=drv), size=4) +
  ggtitle('Fuel efficiency of vehicles by engine size and transmission') + 
  labs(color="Transmission") +
  xlab(label='Engine displacement in liters') +
  ylab(label='Highway miles per gallon') +
  scale_x_continuous(expand=c(0,0),limits=c(1.5,7)) +
  scale_y_continuous(expand=c(0,0),limits=c(5,50)) +
  scale_color_manual(
    values=c('dodgerblue','magenta','#FFB000'),
    breaks=c('f','r','4'),
    labels=c('Front','Rear','All/Four')) +
  coord_cartesian(clip='off') +
  theme(
    plot.margin=margin(5,0.5,3,0.5,'lines'),
    plot.title=element_text(hjust=0.5,vjust=9,face='bold',size=unit(20,'pt')),
    axis.title.x=element_text(margin=margin(t=17),size=unit(20,'pt'),hjust=0.55),
    axis.title.y=element_text(margin=margin(r=17),size=unit(20,'pt'),hjust=0.6),
    axis.text.x=element_text(size=unit(17,'pt'),colour='#778899'),
    axis.text.y=element_text(size=unit(17,'pt'),colour='#778899'),
    legend.justification='right',
    legend.position=c(0.93,0.78),
    legend.background=element_rect(fill='white',colour='#778899',size=7/10),
    legend.margin=margin(c(0.8,1,1,1),unit="lines"),
    legend.key=element_blank(),
    legend.text=element_text(size=unit(17,'pt'),margin=margin(t=8),vjust=2),
    legend.title=element_text(size=unit(17,'pt')),
    legend.spacing.y=unit(12,'pt'),
    panel.grid.minor=element_line(colour='transparent'),
    panel.grid.major=element_line(size=7/10,linetype=3,colour='#778899'),
    axis.line.x=element_line(size=15/10,color='#778899'),
    axis.line.y=element_line(size=15/10,color='#778899')
  )

autoplot2


ggsave(
  filename = 'autoplot2-3x3x3x192.png', 
  path = 'resolution/output',
  plot = autoplot2,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 3,
  height = 3, 
  scale = 3, # +/- dimension
  dpi = 192 # +/- resolution
)


autoplot3 <- ggplot(data=mpg) + 
  geom_point(mapping=aes(x=class, y=hwy, color=drv), size=5, shape=17) +
  ggtitle('Fuel efficiency of vehicles by class and transmission') + 
  labs(color="Transmission") +
  xlab(label='Class of vehicle') +
  ylab(label='Highway miles per gallon') +
  scale_x_discrete(
    limits=c('2seater','subcompact','compact','midsize','minivan','pickup','suv'),
    labels=c('Coupe','Mini','Compact','Midsize','Minivan','Pickup','SUV')
  ) +
  scale_y_continuous(expand=c(0,0),limits=c(5,50)) +
  scale_color_manual(
    values=c('dodgerblue','magenta','#FFB000'),
    breaks=c('f','r','4'),
    labels=c('Front','Rear','All/Four')) +
  coord_cartesian(clip='off') +
  theme(
    plot.margin=margin(5,0.5,3,0.5,'lines'),
    plot.title=element_text(hjust=0.5,vjust=9,face='bold',size=unit(20,'pt')),
    axis.title.x=element_text(margin=margin(t=17),size=unit(20,'pt')),
    axis.title.y=element_text(margin=margin(r=17),size=unit(20,'pt'),hjust=0.6),
    axis.text.x=element_text(size=unit(17,'pt'),colour='#778899'),
    axis.text.y=element_text(size=unit(17,'pt'),colour='#778899'),
    legend.justification='right',
    legend.position=c(0.83,0.78),
    legend.background=element_rect(fill='white',colour='#778899',size=7/10),
    legend.margin=margin(c(0.8,1,1,1),unit="lines"),
    legend.key=element_blank(),
    legend.text=element_text(size=unit(17,'pt'),margin=margin(t=8),vjust=2),
    legend.title=element_text(size=unit(17,'pt')),
    legend.spacing.y=unit(12,'pt'),
    panel.grid.minor=element_line(colour='transparent'),
    panel.grid.major=element_line(size=7/10,linetype=3,colour='#778899'),
    axis.line.x=element_line(size=15/10,color='#778899'),
    axis.line.y=element_line(size=15/10,color='#778899')
  )

autoplot3


ggsave(
  filename = 'autoplot3-3x3x3x192.png', 
  path = 'resolution/output',
  plot = autoplot3,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 3,
  height = 3, 
  scale = 3, # +/- dimension
  dpi = 192 # +/- resolution
)

