# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  install.packages('showtext')
  install.packages('ggtext')
  install.packages('patchwork')
  install.packages('cowplot')
  install.packages('magick')
  install.packages('rsvg')
  install.packages('ggimage')
}

library(ggplot2)
library(showtext)
library(ggtext)
library(patchwork)
library(cowplot)
library(magick)
library(rsvg)
library(ggimage)

# create some simple data
cycles.interval <- pi/8
cycles <- seq(0,4*pi, cycles.interval)
waves <- data.frame(Time=cycles, Amplitude=sin(cycles))

# interpolate values with splines
cycles.interval.new <- pi/64
cycles.interpolate <- seq(0, 4*pi, cycles.interval.new)
weight <- splinefun(waves)
waves.spline <- data.frame(Time=cycles.interpolate, Amplitude=weight(cycles.interpolate))

# load the special font
font_add_google(name='Playfair Display', family='playfair') 
font_add_google(name='IBM Plex Sans', family='plexsans',regular.wt=300)

# give font rendering to showtext
showtext_auto(T)

# chose an underlying theme PLUS special font
theme_set(theme_void(base_family='playfair', base_size=28))

# set an aspect ratio
ratio.aspect <- 16/9
ratio.breadth <- (max(waves$Time)-min(waves$Time))/(max(waves$Amplitude)-min(waves$Amplitude))

# plot the data
chartplot <- ggplot(waves.spline, aes(Time, Amplitude, size=Amplitude, colour=Amplitude)) + 
  coord_fixed(ratio.breadth / ratio.aspect) +
  # ggtitle('The change of seasons is not date certain') +
  geom_segment(x=-2, xend=14, y=.6, yend=.6, linewidth=0.1, color='steelblue', linetype=3) +
  geom_segment(x=-2, xend=14, y=-.6, yend=-.6, linewidth=0.1, color='steelblue', linetype=3) +
  geom_path(lineend='round') +
  annotate('text',label='feels like Spring',x=13,y=.7,hjust=1,color='steelblue',family='plexsans',size=10) +
  annotate('text',label='feels like Winter',x=-.5,y=-.7,hjust=0,color='steelblue',family='plexsans',size=10) +
  scale_x_continuous(breaks=c(0,4,8,12),labels=c('FEB','MAR','APR','MAY')) +
  scale_y_discrete(expand=c(.1,-.05)) +
  theme(
    plot.background=element_rect(fill='cornsilk', color='grey'),
    plot.margin=margin(0,1,0,0,'lines'),
    axis.text.x=element_text(color='black'),
    legend.position='NONE'
  )

chartplot

copy <- 'It\'s important to note that the timing and duration of seasonal transitions can also be influenced by natural variability, weather patterns, and climate change. In recent years, some regions have experienced more erratic or unpredictable seasonal transitions **due to changing climatic conditions**.'

textplot <- ggplot(waves, aes(Time, Amplitude)) +
  # annotate('text', x=0, y=0, label=copy, color='black', size=18, family='playfair') +
  # geom_text(aes(x=0, y=0, label=copy), color='red', size=18, family='playfair') + 
  coord_fixed(1) +
  geom_textbox(
    aes(x=0, y=0, label=copy, box.colour='goldenrod'), 
    fill='ivory',
    width=1,
    color='orangered', 
    size=11, 
    family='playfair',
    lineheight=0.68,
    box.padding=unit(1.5,'lines'),
    box.margin=unit(1,'pt')
  ) +
  theme(
    plot.background=element_rect(fill='cornsilk', color='grey')
  )

textplot

combo <- chartplot + textplot

combo

copyright <- '&copy; 2023 Bill & Melinda Gates Foundation. All rights reserved.'
logo_url <- 'https://comps.idmod.org/app/shell/img/logo/logo_IDM_horz1_RGB.svg'
logo     <- image_read_svg(logo_url, width=800)

theme_set(theme_classic())

install.packages('grImport2')
library(grImport2)
library(rsvg)

rsvg_svg(logo_url,'logo_cairo.svg')
logo_svg <- readPicture('logo_cairo.svg')
grid.picture(logo_svg)


combo + 
  plot_annotation(
    title = 'The change of seasons is not date certain',
    subtitle='',
    caption = "&copy; 2023 Bill & Melinda Gates Foundation. All rights reserved.",
    theme = theme(
      plot.title = element_markdown(family='playfair', size=72, color="steelblue"),
      plot.margin=margin(c(1,3,3,3), unit='lines'),
      plot.background=element_rect(fill='whitesmoke', color='transparent'),
      plot.caption=element_markdown(family='plexsans', size=24, color="steelblue", hjust=0, margin=margin(2,0,0,0,'lines'))
    )
  ) +
  inset_element(
    p=grid.picture(logo_svg),
    top=0,
    right=200,
    bottom=100, 
    left=0,
    align_to='full',
    clip=F
  )

# return font rendering to normal
# showtext_auto(F)


