#! /usr/bin/Rscript

# ############################################################# #
# ##################### Fun with Yelp ######################### #
# ############################################################# #
#                                                               #
#   Version: 1.0                                                #
#   Author: Florian Gützlaff                                    #
#   Last Update: 2018-1-20                                      #
#   Description:                                                #
#     TBD                                                       #
#                                                               #
#                                                               #
#                                                               #
# ############################################################# #

### LIBRARIES ###################################################

install.packages('pacman', dependencies=TRUE, repos='http://cran.rstudio.com/')
require('pacman')
p_load('tidyverse')
p_load('Hmisc')
p_load('data.table')

### GETTING DATA ################################################

filelist <- list.files(path="data")

# for(i in filelist){
#   tmp <- read.csv(paste("data/",i,sep=""),sep=',',stringsAsFactors=F)
#   assign(i,tmp)
# }

### EXPLORING DATA ##############################################

## Getting an idea whether or not businees attributes can be used as features
df.atr<- as.tibble(yelp_business_attributes.csv) 
df.atr[ df.atr == "Na" ] <- NA
df.atr[ df.atr == "True" ] <- TRUE
df.atr[ df.atr == "False" ] <- FALSE
df.atr <- df.atr %>% 
  select(-business_id) %>% 
  summarise_all(funs(na_ratio = sum(is.na(.))/n())) 


df.distinct_attr <- as.tibble(setNames(data.frame(t(df.atr[,-1])),df.atr[,1]))
colnames(df.distinct_attr) <- "na_ratio"  
df.distinct_attr <- setDT(df.distinct_attr, keep.rownames = TRUE)[] %>% 
  arrange(na_ratio) %>% 
  top_n(.,-10,na_ratio)


## Business check-ins and first appearance on yelp

df.first_entry <- yelp_review.csv %>% 
  group_by(business_id) %>% 
  summarise(prox_start_date = min(as.Date(date)))
  
df.business_activity <- yelp_checkin.csv %>% 
  group_by(business_id) %>% 
  summarise(avg_checkins = mean(checkins))

df.business <- yelp_business.csv %>% 
  left_join(df.first_entry, by = "business_id") %>% 
  left_join(df.business_activity, by = "business_id")


#counts = as.data.frame(xtabs(~text))
#strsplit(df.business$categories[1],';')

