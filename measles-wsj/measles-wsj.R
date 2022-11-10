


tycho <-  read_csv("measles-wsj/data/tycho_measles_1928_2010.csv")

# prepare the data
datatall <- data.frame(tycho)
datatall <- melt(datatall, id.vars = c("Year","AdminISO","AdminName","Population","Cases","Incidence"), measure.vars = integer())
colnames(datatall) <- c("year","state","statename","population","cases","incidence")


# the aesthetic
aesthetic <- aes(y=statename, x=year, fill=incidence)


# basics
p <- ggplot(datatall, aesthetic)
p


# themed
p <- p + 
  theme_minimal() +
  theme(
    plot.margin=margin(2,2,2,2,"lines")
  )
p


# blank the grid
p <- p +
  theme(
    plot.margin=margin(2,2,2,2,"lines"),
    axis.ticks = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(),
    panel.background=element_rect(fill="white"))
p


# reorient y, expand x, remove labels, add breaks
p <- p +  
  scale_x_continuous(expand=c(0,0),breaks=seq(1920,2010,by=10)) +
  scale_y_discrete(limits = rev) +
  xlab(NULL) + ylab(NULL)
p


# apply the tile
p <- p +
  geom_tile(width=1, height=1)
p


# apply the gradient
p <- p +
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
p


# stroke and annotate
p <- p +
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  geom_segment(x=1962.5,xend=1962.5,y=0,yend=60,size=0.3,color="black",linetype=1) +
  theme(
    panel.background=element_rect(fill="white", color="white")
  )
p


# style the legend
p <- p +
  theme(
    plot.margin=margin(2,2,4,2,"lines"),
    legend.direction = "horizontal",
    legend.position = c(0.5,-.1),
    legend.title = element_blank(),
    legend.key.height = unit(8,'pt'),
    legend.key.width = unit(32,'pt')
  )
p


# annotate and title
p <- p + 
  ggtitle("Measles") +
  annotate(
    "text",
    label="Vaccine Introduced", 
    x=1963, 
    y=53, 
    vjust=1, 
    hjust=0, 
    size=8
  )
p


# text and text size
pp <- p +
  theme (
    text = element_text(size=16, family="sans"),
    title = element_text(size=32),
    axis.text.x = element_text(size=20),
    axis.text.y = element_text(size=12)
  )
pp


# add fonts
library(showtext)
font_add_google(name="Azeret Mono", family="azeret-mono")
font_add_google(name="Barlow", family="barlow")
showtext_auto()


# apply fonts and use state abbreviations too
aesthetic <- aes(y=state, x=year, fill=incidence)
ggplot(datatall, aesthetic) + 
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



                      