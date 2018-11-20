# ############################################################# #
# ##################### Fun with Yelp ######################### #
# ############################################################# #
#                                                               #
#   Version: 1.0                                                #
#   Author: Florian Guetzlaff                                   #
#   Last Update: 2018-1-20                                      #
#   Description:                                                #
#     XGBoost Model for Prediction of Star Rating               #
#                                                               #
#                                                               #
#                                                               #
# ############################################################# #

### LIBRARIES ###################################################

require('pacman')
p_load('car')
p_load('caret')
p_load('xgboost')
# Loading raw data
#setwd("PATH_TO_THE_REPO/fun-with-yelp/")
source("main.R", chdir = T)

### DATA MANIPULATION ###########################################

# Transforming business attributs to 0/1 - NA's to 0 
df.atr<- as.tibble(yelp_business_attributes.csv) 
df.atr[ df.atr == "Na" ] <- 0
df.atr[ df.atr == "True" ] <- 1
df.atr[ df.atr == "False" ] <- 0
df.atr[ is.na(df.atr) ] <- 0

# Character to numeric
id <- c(2,3:ncol(df.atr)) 
df.atr[,id] <- as.numeric(as.character(unlist(df.atr[,id])))

# Creating feature dataframe

df.star_pred <- df.business %>% 
  select(business_id,stars,avg_checkins) %>% 
  left_join(df.atr, by = "business_id")
df.star_pred[ is.na(df.star_pred) ] <- 0

# Identifying values close to zero

df.star_pred <- df.star_pred[,c(TRUE,TRUE,colSums(df.star_pred[,3:ncol(df.star_pred)])>1000)]
# Alternativ:
# nearZeroIndex <- nearZeroVar(df.star_pred, freqCut = 95/5, uniqueCut = 10, saveMetrics = FALSE,
#             names = FALSE, foreach = FALSE, allowParallel = TRUE)
#df.star_pred <- df.star_pred[, -nearZeroIndex] 

### MODEL########################################################

# Test/Train Split

trainIndex <- createDataPartition(df.star_pred$stars, p=.7, list=F)
star.train <- df.star_pred[trainIndex, ]
star.test <- df.star_pred[-trainIndex, ]

# Model Parameters

tune_grid <- expand.grid(nrounds = 200,
                         max_depth = 5,
                         eta = 0.05,
                         gamma = 0.01,
                         colsample_bytree = 0.75,
                         min_child_weight = 0,
                         subsample = 0.5)

trctrl <- trainControl(verboseIter = TRUE)

# Training the Model

xgb_fit <- caret::train(stars ~ avg_checkins              
                        +BusinessAcceptsCreditCards
                        +BusinessParking_garage    
                        +BusinessParking_street    
                        +BusinessParking_validated 
                        +BusinessParking_valet     
                        +GoodForKids               
                        +WheelchairAccessible     
                        +BikeParking              
                        +Alcohol                   
                        +Caters                   
                        +HappyHour                
                        +BestNights_monday         
                        +GoodForMeal_dinner       
                        +GoodForMeal_breakfast    
                        +DogsAllowed , data = star.train, method = "xgbTree",
                        trControl=trctrl,
                        tuneGrid = tune_grid,
                        tuneLength = 10)

# Prediction
predict.stars <- predict(xgb_fit, star.test)

print(xgb_fit)
varImp(xgb_fit)

