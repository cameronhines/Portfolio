library(readr)
wine <- read_csv("C:/Users/chines/Downloads/winequality-red.csv") #hundreds of wines and their associated quantitative variables + average critic score on 1-10 scale
View(wine)

#can a wine's quality score be predicted by its quantitative variables?

#standard multiple linear regression model
reg1<-lm(`quality` ~ `fixed acidity`+`volatile acidity`+`citric acid`+`residual sugar`+chlorides+`free sulfur dioxide`+`total sulfur dioxide`+density+pH+sulphates+alcohol, data = wine)
summary(reg1)
#R-squared of .3606

#alternate model 1: forward stepwise selection
intercept_only <- lm(`quality` ~ 1, data=wine)
forward <- step(intercept_only, direction='forward', scope=formula(reg1), trace=0)
summary(forward)
#R-squared of .3595 - didn't improve original model

#alternate model 2: backward stepwise selection
backward <- step(reg1, direction='backward', scope=formula(reg1), trace=0)
summary(backward)
#R-squared of .3595 - didn't improve original model

#alternate model 3: drop variables exhibiting multicollinearity
library(car)
vif(reg1) #any variable with a VIF > 5 should be manually dropped
vifreg<-lm(`quality` ~ `volatile acidity`+`citric acid`+`residual sugar`+chlorides+`free sulfur dioxide`+`total sulfur dioxide`+pH+sulphates+alcohol, data = wine)
summary(vifreg)
#R-squared of .3602 - didn't improve original model

#analysis
#whatever way you slice it, these models can only explain around 36% of the variation in wine quality scores; not bad, but too much unexplained variation to feel good about making a precise prediction
#it seems that there are other lurking variables that can influence the score a critic gives a particular wine - possibly including name brand, vineyard location, presence of particular flavors, etc.
#still, there are several significant variables among these quantitative descriptors of wine; for example, it is clear that we can expect a lower wine quality score the higher the volatile acidity is

