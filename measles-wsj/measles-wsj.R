


tycho <-  read_csv("measles-wsj/tycho_161555.csv")

# prepare the data
datawide <- data.frame(tycho)
datawide <- melt(datawide, id.vars = c("WEEK","YEAR","Admin1Name","Admin1ISO","CountValue"), measure.vars = integer())
colnames(datawide) <- c("week","year","statename","state","cases")

# truncate the state abbreviations
datawide$state <- substr(datawide$state,4,5)

# remove the territories
datawide <- datawide[!(datawide$state %in% c('AS','GU','MP','PR','VI')),]

# wide to tall, sum weeks to year
datatall <- datawide %>% group_by(statename, state, year) %>%
  summarise(cases=if(all(is.na(cases))) NA else
    sum(cases, na.rm=T))



# basics
p <- ggplot(datatall, aes(y=statename, x=year, fill=cases))
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
divs <- floor(max(datatall$cases)/4)
p <- p +
  scale_fill_gradientn(
    limits=c(0,max(datatall$cases)),
    values=c(0,0.01,0.05,0.1,0.6,1), 
    colours=c("aliceblue","darkcyan","yellow","orangered","firebrick"),
    breaks=(seq(0,divs*4,by=divs)),
    labels=c("0k","36k","72k","108k","144k")
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


# legends and titles






###########################################

datawide$region <- setNames(state.region, state.abb)[datawide$state]
datawide[["region"]][is.na(datawide[["region"]])] <- "Northeast"

datatallr <- datawide %>% group_by(region, year) %>%
  summarise(cases=if(all(is.na(cases))) NA else
    sum(cases, na.rm=T))


aesthetic <- aes(y=region, x=year, fill=cases)

divs <- floor(max(datatallr$cases)/4)

myplot <- ggplot(datatallr, aesthetic) + 
  geom_tile(width=1, height=1, colour="white", size=0.5) +
  theme_minimal() +
  scale_fill_gradientn(
    limits=c(0,max(datatallr$cases)),
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



                      