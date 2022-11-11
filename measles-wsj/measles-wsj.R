# clear workspace
# this is important to zero-out ambient themes
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


# wrap the expression for easier execution
(temp <- p + theme_bw())


# applying a new starting point (try _dark, _gray, _bw, _void, _test)
(temp <- p + theme_classic())


# add breathing room around the plot (note that 'temp' preserves 'p')
(temp <- p +
  theme(
    plot.margin = margin(2,3,4,3,"lines"),
    axis.ticks = element_blank()
  )
)


# the workspace theme can be set, updated, and extended independently
mytheme <- theme_set(theme_classic()) 


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


# apply some scales to set zero and flip the y-axis
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
(p <- p + scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)))


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

# refine the gradient further, and set the legend
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
  ggtitle("Measles") +
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


# style the legend
mytheme <- theme_replace(
  plot.margin=margin(2,3,4,3,"lines"),
  legend.direction = "horizontal",
  legend.position = c(0.5,-.1),
  legend.title = element_blank(),
  legend.text = element_text(size=8),
  legend.key.height = unit(10,'pt'),
  legend.key.width = unit(32,'pt')
)

# check the change
p


# style text and text size
mytheme <- theme_replace(
  text = element_text(size=16, family="sans"),
  title = element_text(size=16),
  axis.text.x = element_text(size=12),
  axis.text.y = element_text(size=8, hjust=1)
)

# check the change
p

# finally, blank the background and edge
mytheme <- theme_replace(
  panel.background = element_rect(fill="white",color="white"),
  axis.line = element_line(color="white")
)

# check the change
p


# add fonts
library(showtext)
font_add_google(name="Azeret Mono", family="azeret-mono")
showtext_auto()

# apply the fonts and update sizes AS OVERRIDE TO PLOT
(p <- p + 
  annotate(
    "text",
    label="Vaccine Introduced",
    family="azeret-mono",
    x=1963,y=54,vjust=1,hjust=0,size=7
  ) +
  theme(
    title = element_text(size=32),
    axis.text.x = element_text(size=24),
    axis.text.y = element_text(size=14, hjust=1),
    text = element_text(size=32, family="azeret-mono"),
    legend.text = element_text(size=16)
  )
)


# set aes to state abbreviations
aesthetic <- aes(y=state, x=year, fill=incidence)
ggplot(datatall, aesthetic) + 
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
  ggtitle("Measles Cases") +
  annotate("text",label="1963 Vaccine Introduced",family="azeret-mono",x=1963,y=54,vjust=1,hjust=0,size=8) +
  guides(fill=guide_colorbar(ticks.colour = NA)) +
  theme(
    title = element_text(size=32),
    axis.text.x = element_text(size=22),
    axis.text.y = element_text(size=14, hjust=1, color="red"),
    text = element_text(size=32, family="azeret-mono"),
    legend.text = element_text(size=16),
    legend.position = c(0.85,0.96),
    legend.background = element_rect(fill=NA),
    plot.margin=margin(2,4,3,4,"lines")
  )


###########################################

# blisters
aesthetic <- aes(y=state, x=year)
ggplot(datatall, aesthetic) + 
  geom_point(aes(size=incidence),color="tomato",stroke=0.5,alpha=0.8) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.5,color="tomato",linetype=3) +
  scale_size_continuous(range=c(0.1,6),breaks=c(0,1e3,2e3),labels=c('0k','1k','2k')) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Measles Cases") +
  annotate("text",label="1963 Vaccine Introduced",family="azeret-mono",x=1963,y=53,vjust=1,hjust=0,size=6,color="tomato") +
  theme(
    title = element_text(size=32),
    axis.text.x = element_text(size=22),
    axis.text.y = element_text(size=14, hjust=1, color="tomato"),
    text = element_text(size=32, family="azeret-mono"),
    legend.text = element_text(size=16,color="tomato"),
    legend.position = c(0.84,0.99),
    legend.background = element_rect(fill=NA),
    plot.margin=margin(2,4,3,4,"lines"),
    panel.background=element_rect(fill="#faf9f5")
  )



###########################################


# TO DO REGIONS


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


######################

datawide$region <- setNames(state.region, state.abb)[datawide$state]
datawide[["region"]][is.na(datawide[["region"]])] <- "Northeast"

datatallr <- datawide %>% group_by(region, year) %>%
  summarise(cases=if(all(is.na(cases))) NA else
    sum(cases, na.rm=T))


aesthetic <- aes(y=region, x=year, fill=cases)

myplot <- ggplot(datatallr, aesthetic) + 
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,max(datatallr$cases)),
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
  theme(
    legend.direction = "horizontal",
    legend.position = c(0.5,-.1),
    legend.title = element_blank(),
    legend.key.height = unit(8, 'pt'),
    plot.margin=margin(2,2,4,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white",color="white"),
    text = element_text(size=15, family="azeret-mono"),
    axis.text.x = element_text(size=20))

# supersedes the existing 'fill' (to correct the label)
myplot + 
  scale_fill_gradientn(
    limits=c(0,max(datatallr$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","121k","242k","363k","484k")
  )

myplot

myplot

myplot + 
  scale_fill_gradientn(
    limits=c(0,max(datatall$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","36k","72k","108k","144k")
  )



# to see what's in the plot (for test)
layer_data(p)
layer_grob(p)
layer_scales(p)
benchplot(p)




ggplot(datatall, aes(y=statename, x=year, fill=cases)) + 
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,max(datatall$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","36k","72k","108k","144k")
  ) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="red",linetype=1) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  theme(
    legend.direction = "horizontal",
    legend.position = c(0.5,-.1),
    legend.title = element_blank(),
    legend.key.height = unit(8, 'pt'),
    plot.margin=margin(2,2,3,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white",color="white"),
    text = element_text(size=15, family="azeret-mono"),
    axis.text.x = element_text(size=20))   


pp <- ggplot() +
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,max(datatall$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","36k","72k","108k","144k")
  ) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="red",linetype=1) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  theme(
    plot.margin=margin(2,2,2,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white",color="white"),
    text = element_text(size=15, family="azeret-mono"),
    axis.text.x = element_text(size=20))


pp + ggplot(datatall, aes(y=statename, x=year, fill=cases))


# add fonts
library(showtext)
font_add_google(name="Azeret Mono", family="azeret-mono")
font_add_google(name="Barlow", family="barlow")
showtext_auto()

ggplot(datatall, aes(y=region, x=year, fill=cases)) + 
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,max(datatall$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","36k","72k","108k","144k")
    ) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=3,color="white") +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="red",linetype=1) +
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL) +
  theme(
    plot.margin=margin(2,2,2,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white",color="white"),
    text = element_text(size=15, family="azeret-mono"),
    axis.text.x = element_text(size=20))    
  




# add the regions to group them
datawide$region <- setNames(state.region, state.abb)[datawide$state]

# DC is NA
datawide[is.na(datawide$region),]

# DC to Northeast
datawide[["region"]][is.na(datawide[["region"]])] <- "Northeast"

# redo the tall
datatall <- datawide %>% group_by(region, state, year) %>%
  summarise(cases=if(all(is.na(cases))) NA else
    sum(cases, na.rm=T))



                      