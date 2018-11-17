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

install.packages('data.table', dependencies=TRUE, repos='http://cran.rstudio.com/')
require('pacman')
p_load('tidyverse')
p_load('Hmisc')

### GETTING DATA ################################################

filelist <- list.files(path="data")

# for(i in filelist){
#   tmp <- read.csv(paste("data/",i,sep=""),sep=',',stringsAsFactors=F)
#   assign(i,tmp)
# }

### EXPLORING DATA ##############################################

## Getting an idea whether or not this data can be used as features
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


  
  



