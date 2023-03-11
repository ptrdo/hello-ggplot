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
  filename = 'plot-4x3x3x200.png', 
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
  filename = 'plot-4x3x3x150.png', 
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
  filename = 'plot-4x3x3x300.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  units = c('in'),
  width = 4,
  height = 3, 
  scale = 2, # +/- dimension
  dpi = 300 # +/- resolution
)


