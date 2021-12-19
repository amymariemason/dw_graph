library(reticulate)

library(readr)
mystring <- read_file("C:/Users/Amy/Documents/GitHub/dw_graph/data.txt")

py_run_string("from collections import OrderedDict ")
py_run_string(paste0("od=", mystring))

items<-py_run_string("od.items()")

Rlist<-items$od #list of items in R

library (tibble)
library(tidyverse)

test<- reshape2::melt(Rlist)
names(test)<-c("value","title","Season", "Doctor")

test$data_order<-1:nrow(test)

mydf <- data.frame(id = unique(test$title), v1 = 1)
mydf$storynum <- 1:nrow(mydf)
test<-merge(test,mydf[,c("id", "storynum")], by.x="title", by.y="id",sort = FALSE)

mydf <- data.frame(id = test$title, story=test$storynum, v1 = 1)
mydf$partnumber <- ave(mydf$v1, mydf$id, FUN = seq_along)
mydf$totalparts <- ave(mydf$partnumber, mydf$story, FUN = max)
mydf$episode_frac<- (mydf$partnumber-1)/(mydf$totalparts)
mydf$episode_number<-mydf$story+mydf$episode_frac

test$episode_number<-mydf$episode_number

test<-test[,c("Doctor", "Season", "data_order","title", "episode_number", "value")]

test$Type<-ifelse(test$data_order==696, "Movie",
                  ifelse(test$data_order<696, "Old Who", "New Who"))

test$value<-ifelse(test$value==-1, NA, test$value)

test$Doctor<-as.numeric(as.character(test$Doctor))

test$score_type<-ifelse(test$Doctor<=4, "Score1",
                        ifelse(test$Doctor<=8, "Score2",
                               ifelse(test$Doctor>=13&test$data_order>783,
                                      "Score4", "Score3")))


test$Doctor<-as.factor(test$Doctor)
# season change


mydf <- data.frame(id = paste0(as.character(test$Season),"+", as.character(test$Doctor)),
                   num = test$episode_number,
                   v1 = 1)
mydf$seasoncountalong<- ave(mydf$v1, mydf$id, FUN = seq_along)
mydf$newseason<-ifelse(mydf$seasoncount==1,1,0)
keep<-mydf[mydf$newseason==1,"num"]
keep<-keep-0.5

##

#minmax evaluations
library(dplyr)
minmax<-  test %>%
  group_by(Doctor) %>%
  summarise(min.score = min(value, na.rm = T),
            max.score = max(value, na.rm = T),
            min.ep = min(episode_number, na.rm = T),
            max.ep = max(episode_number, na.rm = T),)

test<-merge(test,as.data.frame(minmax), by="Doctor", sort=FALSE)

##

library(ggplot2)
ggplot(data=test)+
          geom_point(aes(x=episode_number,
                         y=value,
                         color=Doctor,
                         shape=score_type)) +
          geom_vline(xintercept = keep, color="grey")+
          geom_errorbarh(aes(xmin=min.ep, xmax=max.ep,
                             y=min.score), color="black")+
          geom_errorbarh(aes(xmin=min.ep, xmax=max.ep,
                             y=max.score), color="black")+
          xlab("Episode number")+
          ylab("Audience Appreciation Index")+
          ylim(0,100)+
          xlim(0,300)+
          labs(title="Doctor Who Through the Years")+
          theme_light()+
          theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                axis.line = element_line(colour = "black"))


