# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

# install.packages('ggplot')
# install.packages('png')
# install.packages('ggfx')

library(ggplot2)
library(png)
library(ggfx) # with_shadow

theme_set(theme_gray())

steps <- seq(-16,16,0.25)
wave <- data.frame(Time=steps,Amplitude=cos(steps))
  
p = ggplot(wave,aes(Time,Amplitude,colour='cosine')) +
  scale_color_manual(values=c('tomato'),name='wave') +
  scale_x_continuous(
    expand=c(0,0), 
    limits=c(-16,16),
    breaks=c(-3,0,3)) +
  scale_y_continuous(
    expand=c(0,0), 
    limits=c(-4,4),
    breaks=c(-0.4,0,0.4)) +
  xlab(label='🠦  Elapsed Time  🠦' ) +
  ylab(label='🠤 Amplitude 🠦') +
  theme(
    text=element_text(size=unit(20,'pt')),
    plot.margin=margin(4,4,3,3,'lines'),
    #plot.window=,
    panel.background=element_rect(fill='lightblue'),
    axis.ticks=element_blank(),
    axis.text=element_blank(),
    legend.text=element_text(),
    legend.direction='horizontal',
    legend.position=c(0.85,0.9),
    legend.background=element_rect(fill='white'),
    legend.key=element_blank(),
    legend.title=element_text(size=unit(15,'pt')),
    legend.margin=margin(c(0.5,1,0.5,1),unit="lines")
  ) +
  ggtitle('Getting the Resolution Correct') +  
  annotate('text', 0, 0, label='SIZE', color='white', alpha=0.7,
    family='sans', fontface='bold', size=unit(48,'pt')) +
  geom_point(color='white',size=4) +
  geom_point(color='red',size=2)
  # with_shadow(geom_point(size=2),sigma=5,x_offset=0,y_offset=30,colour='#8cc6d9')



p

p$layers[[1]]$aes_params$size # annotation dim

theme_get()$text$size

p

png('resolution/output/PLOTA.png', width=898, height=698)
p$layers[[1]]$aes_params$size <- unit(72,'pt')
plot(p + (theme(text = element_text(size=unit(22,'pt')))))
plot(p)
dev.off()

ggsave(
  filename = 'plot-2x4x3x200.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  scale = 2, # +/- dimension
  width = 4,
  height = 3, 
  units = c('in'),
  dpi = 200 # +/- resolution
)

ggsave(
  filename = 'plot-3x3x2x200.png', 
  plot = p,
  device = png, 
  path = 'resolution/output',
  scale = 3.25, # +/- dimension
  width = 3,
  height = 2.25, 
  units = c('in'),
  dpi = 200 # +/- resolution
)


