# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()

if (F) {
  # when starting fresh...
  install.packages('ggplot2')
  install.packages('showtext')
  install.packages('ggtext')
  install.packages('patchwork')
  install.packages('magick')
  install.packages('rsvg')
}

library(ggplot2)
library(showtext)
library(ggtext)
library(patchwork)
library(magick)
library(rsvg)


# set an existing destination for output relative to the R workspace...
output_path <- 'hello-ggplot/powerpoint/output'

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1. CREATE A CHART FOR A POWERPOINT SLIDE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# create some simple data
cycles.interval <- pi/64
cycles <- seq(0,4*pi, cycles.interval)
waves <- data.frame(Time=cycles, Amplitude=sin(cycles))

# chose an underlying theme
theme_set(theme_classic())

# plot the data
chartplot <- ggplot(waves, aes(Time, Amplitude)) + 
  ggtitle('The change of seasons is not date certain') +
  geom_segment(x=-2, xend=14, y=.6, yend=.6, linewidth=0.2, linetype=3) +
  geom_segment(x=-2, xend=14, y=-.6, yend=-.6, linewidth=0.2, linetype=3) +
  geom_line() +
  annotate('text', label='feels like Spring', x=13, y=.7, hjust=1) +
  annotate('text', label='feels like Winter', x=-.5, y=-.7, hjust=0) +
  theme(
    plot.margin=margin(3,3,3,3,'lines')
  )

# view the plot
chartplot

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. CONSTRAIN THE CHART WITH AN ASPECT RATIO AND ADD SPECIAL FONTS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# set an aspect ratio
ratio.aspect <- 16/9
ratio.breadth <- (max(waves$Time)-min(waves$Time))/(max(waves$Amplitude)-min(waves$Amplitude))

# load the special font
font_add_google(name='Playfair Display', family='playfair') 
font_add_google(name='IBM Plex Sans', family='plexsans',regular.wt=300)

# give the font rendering to showtext
showtext_auto(T)

# chose an underlying theme PLUS special font
theme_set(theme_void(base_family='playfair', base_size=18))

# interpolate values with splines
cycles.interval.new <- pi/64
cycles.interpolate <- seq(0, 4*pi, cycles.interval.new)
weight <- splinefun(waves)
waves.spline <- data.frame(Time=cycles.interpolate, Amplitude=weight(cycles.interpolate))

# plot the data
chartplot <- ggplot(waves.spline, aes(Time, Amplitude, linewidth=Amplitude, colour=Amplitude)) + 
  coord_fixed(ratio.breadth / ratio.aspect) +
  # ggtitle('The change of seasons is not date certain') +
  geom_segment(x=-2, xend=14, y=.6, yend=.6, linewidth=0.2, color='steelblue', linetype=3) +
  geom_segment(x=-2, xend=14, y=-.6, yend=-.6, linewidth=0.2, color='steelblue', linetype=3) +
  geom_path(lineend='round') +
  annotate('text',label='feels like Spring',x=13,y=.7,hjust=1,color='steelblue',family='plexsans',size=8) +
  annotate('text',label='feels like Winter',x=-.5,y=-.7,hjust=0,color='steelblue',family='plexsans',size=8) +
  scale_x_continuous(breaks=c(0,4,8,12),labels=c('FEB','MAR','APR','MAY')) +
  scale_y_discrete(expand=c(.1,-.05)) +
  theme(
    plot.background=element_rect(fill='cornsilk', color='grey'),
    plot.margin=margin(0,1,0,0,'lines'),
    axis.text.x=element_text(color='black'),
    legend.position='NONE'
  )

# view the plot
chartplot

# output to the intended resolution
ggsave(
  filename = 'powerpoint_fig_02.png', 
  path = output_path,
  plot = chartplot,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 16,
  height = 9, 
  scale = 1, # +/- dimension
  dpi = 180 # +/- resolution
)

# The scale and dpi above combine to generate an image with the aspect ratio
# of a PowerPoint slide and sufficient resolution to be placed at 50% scale,
# resulting in crisp graphics during presentation at various dimensions 


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3. CREATE A TEXT BLOCK FOR THE POWERPOINT SLIDE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# store the markdown content that will be required
richtext <- 'It\'s important to note that the timing and duration of seasonal transitions can also be influenced by natural variability, weather patterns, and climate change. In recent years, some regions have experienced more erratic or unpredictable seasonal transitions **due to changing climatic conditions**.'
copyright <- '&copy; 2023 Bill & Melinda Gates Foundation. All rights reserved.'

# plot some text to the same space as the chart (but square)
textplot <- ggplot(waves, aes(Time, Amplitude)) +
  coord_fixed(1) +
  geom_textbox(
    aes(x=0, y=0, label=richtext, box.colour='goldenrod'), 
    fill='lemonchiffon',
    width=1,
    color='black', 
    size=unit(7,'pt'), 
    family='plexsans',
    lineheight=unit(1.5,'lines'),
    box.padding=unit(3,'lines'),
    box.margin=unit(2,'pt')
  ) +
  theme(
    plot.background=element_rect(fill='cornsilk', color='grey')
  )

# view the plot
textplot

# combine the chart and text plots with patchwork
combo <- chartplot + textplot

# view the patchwork
combo

# output to the intended resolution
ggsave(
  filename = 'powerpoint_fig_03.png', 
  path = output_path,
  plot = combo,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 16,
  height = 9, 
  scale = 1, # +/- dimension
  dpi = 180 # +/- resolution
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. CREATE THE BOTTOM LINE OF THE POWERPOINT SLIDE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# prepare the requirements for the copyright & logo assembly
logo_url <- 'https://comps.idmod.org/app/shell/img/logo/logo_IDM_horz1_RGB.svg'
logo_file <- 'logo_cairo.svg'

# convert original svg to local cairo svg
rsvg_svg(logo_url,paste(output_path,logo_file,sep='/'))

# import the converted svg
logo_svg <- image_read_svg(paste(output_path,logo_file,sep='/'))

# to view result
# View(logo_svg)

# create a simple space to plot the copyright and logo
df <- data.frame(x=0:1,y=0:1)

# chart the copyright & logo
tailplot <- ggplot(df) +
  scale_x_continuous(
    expand=c(0,0), 
    limits=c(0,3)) +
  scale_y_continuous(
    expand=c(0,0), 
    limits=c(0,.1)) +
  coord_fixed(1) +
  geom_richtext(
    aes(x=0, y=.1/3, label=copyright, label.colour='transparent'), 
    hjust=0, 
    size=5,
    family='playfair',
    color='steelblue') +
  annotation_raster(
    logo_svg, 
    xmin=3-(5.699/10), 
    xmax=3, 
    ymin=0, 
    ymax=(1/10)
  ) +
  theme(
    plot.margin=margin(0,0,0,0,'lines'),
    plot.background=element_rect(fill='cornsilk', color='grey')
  )

# view the plot
tailplot

# output to the intended resolution
ggsave(
  filename = 'powerpoint_fig_04.png', 
  path = output_path,
  plot = tailplot,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 16,
  height = 9, 
  scale = 1, # +/- dimension
  dpi = 180 # +/- resolution
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 5. ASSEMBLE THE PARTS OF THE POWERPOINT SLIDE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# prescribe the layout for the entire assembly
layout <- '
  112
  333
'

# plot everything together
combo <- chartplot + textplot + tailplot +
  plot_layout(widths = 1, heights = c(1,.1), design = layout)

# view the results
combo

# add the title and margins
assembly <- combo + 
  plot_annotation(
    title='The change of seasons is not date certain',
    theme=theme(
      plot.title = element_markdown(family='playfair', size=40, color='steelblue'),
      plot.margin=margin(c(1,3,3,3), unit='lines'),
      plot.background=element_rect(fill='whitesmoke', color='transparent')
    )
  )

# output to the intended resolution
ggsave(
  filename = 'powerpoint_fig_05.png', 
  path = output_path,
  plot = assembly,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 16,
  height = 9, 
  scale = 1, # +/- dimension
  dpi = 180 # +/- resolution
)
  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 6. PRINT THE FINAL RESULT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# patchwork again but with a theme to cancel the background coloring
combo <- chartplot + textplot + tailplot +
  plot_layout(widths = 1, heights = c(1,.1), design = layout) &
  theme(plot.background=element_rect(fill='white', color='transparent'))

# redo the title but with a theme to cancel the background coloring
slide <- combo + 
  plot_annotation(
    title='The change of seasons is not date certain',
    theme=theme(
      plot.title = element_markdown(family='playfair', size=40, color='steelblue'),
      plot.margin=margin(c(40,60,40,60), unit='pt'),
      plot.background=element_rect(fill='white', color='transparent')
    )
  )

# save the final file
ggsave(
  filename = 'powerpoint.png', 
  path = output_path,
  plot = slide,
  device = png, 
  bg = 'white',
  units = c('in'),
  width = 16,
  height = 9, 
  scale = 1, # +/- dimension
  dpi = 180 # +/- resolution
)

# 2880 x 1624 pixels
# The scale and dpi above combine to generate an image with the aspect ratio
# of a PowerPoint slide and sufficient resolution to be placed at 50% scale,
# resulting in crisp graphics during presentation at various dimensions 


# finally, return font rendering to normal
showtext_auto(F)

