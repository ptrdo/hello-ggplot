# clear the workspace!
# this is important to zero-out ambient theme adjustments!
rm(list=ls())
ls()


library(tidyverse) # read_csv
library(reshape) # melt


tycho <-  read_csv("measles-wsj/data/tycho_measles_1928_2010.csv")

# prepare the data
datatall <- data.frame(tycho)
datatall <- melt(datatall, id.vars = c("Year","AdminISO","AdminName","Population","Cases","Incidence"), measure.vars = integer())
colnames(datatall) <- c("year","state","statename","population","cases","incidence")


# basics
ggplot(data=datatall, aes(x=population, y=statename))


# store the aesthetic
aesthetic = aes(x=population, y=statename)


# add a plot method (try _col, _line, _point, _jitter, _boxplot, _blank)
ggplot(datatall, aesthetic) + geom_point()


# alternative with infix (chain) operator
datatall %>%
  ggplot(aesthetic) +
  geom_col(aes(fill=year))


# storing the plot
p <- ggplot(datatall, aesthetic) +
  geom_col(aes(fill=year))
p


# wrap the expression for easier execution ("temp" isn't necessary, we're just making a copy)
(temp <- p + theme_bw())


# applying a new starting point (try _dark, _gray, _bw, _void, _test)
(temp <- p + theme_classic())


p # stays the same


# add breathing room around the plot (note that 'temp' preserves 'p')
(temp <- p +
  theme(
    plot.margin = margin(2,3,4,3,"lines"),
    axis.ticks = element_blank()
  )
)


# the workspace theme can be set, updated, and extended independently
mytheme <- theme_set(theme_classic()) 
temp # a reminder (if this was left as "classic")
p # stays the same


# verify what the 'default' now is
theme_get()$panel.background


# modify the custom theme
mytheme <- theme_replace(
  plot.margin = margin(2,3,4,3,"lines"),
  axis.ticks = element_blank(),
  panel.background=element_rect(fill="beige")
)


# check again (see:fill)
theme_get()$panel.background


# verify that the change works (using the workspace theme)
p
temp

# apply some scales to expand to zero and flip the y-axis
(temp <- temp +  
    scale_x_continuous(expand=c(0,0)) +
    scale_y_discrete(limits = rev) +
    xlab(NULL) + ylab(NULL)
)


# remake the aesthetic to chart incidence (not population)
aesthetic = aes(x=year, y=statename, fill=incidence)


# change the chart method to 'tile', keeping the basics (from above)
(p <- ggplot(datatall, aesthetic) +
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL)
)

# updates to line-items will supersede previous (see:breaks)
(p <- p + 
    scale_x_continuous(
      expand=c(0,0),
      breaks=seq(1920,2010,by=10)
    )
)


# apply a simple gradient scale 
(p <- p + 
  scale_fill_gradientn(
    limits=c(0,4000),
    values=c(0,1),
    colours=c("gold","red")
  )
)

# refine (and supersede) gradient scale, and account for NA data
(p <- p + 
    scale_fill_gradientn(
      limits=c(0,4000),
      values=c(0,0.05,0.2,1),
      colours=c("beige","gold","red","firebrick"),
      na.value="white"
    )
)

# just a reminder...
temp

# refine the gradient further (per original), update legend
(p <- p +
  scale_fill_gradientn(
    limits=c(0,4000),
    values=c(
      0,
      0.01,
      0.02,
      0.03,
      0.09,
      0.1,
      0.15,
      0.25,
      0.4,
      0.5,
      1), 
    colours=c(
      "#e7f0fa",
      "aliceblue",
      "lightblue",
      "deepskyblue",
      "seagreen",
      "gold",
      "orange",
      "goldenrod",
      "brown",
      "orangered",
      "firebrick"),
    breaks=(seq(0,4e3,by=1e3)),
    labels=c("0k","1k","2k","3k","4k"),
    na.value="ghostwhite"
  )
)


# title and annotate
(p <- p +
  ggtitle("Measles Instances") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.5,color="black",linetype=1) +
  annotate(
    "text",
    label="Vaccine Introduced", 
    x=1963, 
    y=53, 
    vjust=1, 
    hjust=0, 
    size=4
  )
)

# DO NOT DO! Customizing fonts size WILL become defaults!

# INSTEAD: Respect the base size (11)
theme_get()$text$size
mytheme <- theme_replace(
  text = element_text(size=11, family="sans")
)
theme_get()$text$size


# check any change
p

# style the plot itself (applies ONLY to this chart!)
(p <- p + 
  theme(
    title = element_text(size=16),
    axis.text.y = element_text(size=7),
    plot.margin=margin(2,4,4,3,"lines"),
    legend.direction = "horizontal",
    legend.position = c(0.5,-.1),
    legend.title = element_blank(),
    legend.text = element_text(size=8),
    legend.key.height = unit(10,'pt'),
    legend.key.width = unit(32,'pt'),
    
    # leave the default colors to help when building charts...
    panel.background = element_rect(fill="white",color="white"),
    axis.line = element_line(color="white")
  )
)

# save this as a checkpoint
p_original <- p


##########################
# Customizing the font...
##########################

# add fonts
library(showtext)
font_add_google(name="Azeret Mono", family="azeret-mono")
showtext_auto(T)

# apply the fonts and update sizes AS OVERRIDE TO PLOT
(p <- p_original + 
  annotate(
    "text",
    label="Vaccine Introduced",
    family="azeret-mono",
    x=1963,y=54,vjust=1,hjust=0,size=4
  ) +
  theme(
    text = element_text(size=11, family="azeret-mono"),
    title = element_text(size=14),
    # axis.text.x = element_text(size=24),
    # axis.text.y = element_text(size=14, hjust=1),
    # legend.text = element_text(size=16)
  )
)
showtext_auto(F)


# NOTE: the original is preserved
p_original


showtext_auto(T)
p
showtext_auto(F)


################################
# Simplify the gradient...
################################


# set aes to state abbreviations
aesthetic <- aes(y=state, x=year, fill=incidence)
p_simple <- ggplot(datatall, aesthetic) + 
  geom_tile(width=1,height=1,colour="white",size=0.5) +
  scale_fill_gradientn(
    limits=c(0,4000),
    values=c(0,0.05,0.2,0.4,1), 
    colours=c("seashell","tomato","red","firebrick","firebrick"),
    breaks=(seq(0,4e3,by=1e3)),
    labels=c("0k","1k","2k","3k","4k"),
    na.value="white"
  ) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="red",linetype=1) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Measles Instances") +
  annotate("text",label="1963 Vaccine Introduced",family="azeret-mono",x=1963,y=54,vjust=1,hjust=0,size=4) +
  guides(fill=guide_colorbar(ticks.colour = NA)) +
  theme(
    text = element_text(size=16, family="azeret-mono"),
    title = element_text(size=14),
    axis.text.x = element_text(size=12),
    axis.text.y = element_text(size=6, hjust=1, color="red"),
    legend.title = element_blank(),
    legend.text = element_text(size=10),
    legend.position = c(0.86,0.96),
    legend.direction = "horizontal",
    legend.key.height = unit(10,'pt'),
    legend.key.width = unit(24,'pt'),
    legend.background = element_rect(fill=NA),
    plot.margin=margin(2,5,4,5,"lines"),
    panel.background = element_rect(fill="white",color="white"),
    axis.line = element_line(color="white")
  )


showtext_auto(T)
p_simple
showtext_auto(F)

#remember...
p_original

################################
# Measles!...
################################

# reorient the data
aesthetic <- aes(y=state, x=year)
p_point <- ggplot(datatall, aesthetic) + 
  geom_point(aes(size=incidence),color="tomato",stroke=0.5,alpha=0.8) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.5,color="tomato",linetype=6) +
  scale_size_continuous(range=c(0.1,6),breaks=c(0,1e3,2e3),labels=c('0k','1k','2k')) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Measles Instances") +
  annotate("text",label="1963 Vaccine Introduced",family="azeret-mono",x=1963,y=53,vjust=1,hjust=0,size=4,color="black") +
  theme(
    text = element_text(size=16, family="azeret-mono"),
    title = element_text(size=14),
    axis.text.x = element_text(size=12),
    axis.text.y = element_text(size=6, hjust=1, color="tomato"),
    legend.title = element_blank(),
    legend.text = element_text(size=10,color="tomato"),
    legend.position = c(0.875,0.99),
    legend.direction = "horizontal",
    legend.background = element_rect(fill=NA),
    plot.margin=margin(2,4,4,4,"lines"),
    panel.background=element_rect(fill="#faf9f5",color="white"),
    axis.line = element_line(color="white")
  )

showtext_auto(T)
p_point
showtext_auto(F)


################################
# Using a device
################################

# the plot pane is the default device
p_original
dev.off()

# new devices can be made
dev.new(width=1600, height=900, unit="px", noRStudioGD=T)
p_point

# the current (cur) device is where plots are rendered
p_original

# a list is available
dev.list()
dev.cur()

# make another device to plot something else
dev.new(width=1600, height=900, unit="px", noRStudioGD=T)
p_point

# off() will close
dev.next()
dev.off()


################################
# Saving a plot
################################


# saving can be unlike plotting to a device
ggsave(
  "p_point.png", 
  plot = p_point, 
  unit = "px", 
  width = 1600, 
  height = 900
)

# not the same as this
p_point

# resolution matters!
ggsave(
  "p_point.png", 
  plot = p_point, 
  width = 16, 
  height = 9, 
  units = "in", 
  dpi = 96 # ~default screen resolution
)

# 96 dpi * 16x19 = 1152x648 pixels

ggsave(
  "p_point.png", 
  plot = p_point + theme(
    text = element_text(size=20),
    title = element_text(size=20)), 
  width = 16, 
  height = 9, 
  units = "in", 
  dpi = 96 # ~default screen resolution
)


################################
# Next up: Put them all together...
################################


showtext_auto(F)
p_original
showtext_auto(T)
p_simple
p_point

# install.packages("egg")
library(egg)

ggarrange(p_simple,
          p_point,
          labels = c("TILE", "POINT"),
          nrow = 2)

# install.packages("patchwork")
library(patchwork)

(q <- p_original + theme(title=element_text(size=28))) / p_point


################################
# Extra credit: Adding Regions...
################################

# Categorize states into regions
datatall$region <- setNames(state.region, state.abb)[datatall$state]

# Incorporate DC into Northeast region
datatall[["region"]][is.na(datatall[["region"]])] <- "Northeast"

dataregions <- datatall %>% 
  group_by(region, year) %>%
  summarise_at(
    vars(population, cases),
    list(sum = sum),
    na.rm = TRUE
  )

dataregions <- dataregions %>% 
  mutate(incidence=cases_sum*100/population_sum)

# apply fonts and use state abbreviations too
aesthetic <- aes(y=region, x=year, fill=incidence)
ggplot(dataregions, aesthetic) + 
  geom_tile(width=1,height=1,colour="white",size=0.5) +
# geom_tile(data = . %>% filter(region == "South"),width=1,height=1,colour="white",size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,4000),
    values=c(0,0.01,0.02,0.03,0.09,0.1,0.15,0.25,0.4,0.5,1), 
    colours=c("#e7f0fa","aliceblue","lightblue","deepskyblue","seagreen","gold","orange","goldenrod","brown","orangered","firebrick"),
    breaks=(seq(0,4e3,by=1e3)),
    labels=c("0k","1k","2k","3k","4k"),
    na.value="ghostwhite"
  ) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="red",linetype=1) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Measles") +
  annotate("text",label="Vaccine Introduced",family="azeret-mono",x=1963,y=53,vjust=1,hjust=0,size=7) +
  theme(
    legend.direction = "horizontal",
    legend.position = c(0.5,-.1),
    legend.title = element_blank(),
    legend.key.height = unit(8,'pt'),
    legend.key.width = unit(32,'pt'),
    plot.margin=margin(2,2,4,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white",color="white"),
    text = element_text(size=20,family="azeret-mono"),
    title = element_text(size=32),
    axis.text.x = element_text(size=20),
    axis.text.y = element_text(size=16)
  )
