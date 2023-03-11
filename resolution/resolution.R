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

theme_set(theme_gray())

steps <- seq(-16,16,0.3)
wave <- data.frame(Time=steps,Amplitude=cos(steps))
  
p = ggplot(wave,aes(Time,Amplitude,colour='cosine')) +
  scale_color_manual(values=c('tomato'),name='wave') +
  geom_point(color='white',size=3) +
  geom_point(aes(labels='cosine'),color='red',size=1) +
  scale_x_continuous(
    expand=c(0,0), 
    limits=c(-16,16),
    breaks=c(-3,0,3)) +
  scale_y_continuous(
    expand=c(0,0), 
    limits=c(-4,4),
    breaks=c(-0.4,0,0.4)) +
  xlab(label='The x-axis should be exactly as wide as these words') +
  ylab(label='The y-axis should be exactly this tall') +
  theme(
    text=element_text(size=unit(20,'pt')),
    plot.margin=margin(4,4,3,3,'lines'),
    panel.background=element_rect(fill='lightblue'),
    axis.ticks=element_blank(),
    axis.text=element_blank(),
    #legend.text=element_text(),
    legend.direction='horizontal',
    legend.position=c(0.9,0.9),
    legend.background=element_rect(fill='white'),
    #legend.key=element_blank(),
    legend.title=element_text(size=unit(15,'pt')),
    legend.margin=margin(c(0.5,1,0.5,1),unit="lines")
  ) +
x



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


