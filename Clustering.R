#this exercise utilizes the statistical method of k-means clustering
#purpose is to split our customer base into groups and identify group that should be targeted for further business

#import needed packages and data
#data consists of customers and their 2022 POS $ + web activity score
library(readxl)
mydata <- read_excel("C:/Users/chines/Downloads/MyData.xlsx")
library(factoextra)
library(cluster)

df <- na.omit(mydata) #omit null values
df <-df[-c(1)] #omit header
df <- scale(df) #scale values
head(df)
fviz_nbclust(df, kmeans, method = "wss") #choose k where leveling occurs
gap_stat <- clusGap(df,
                    FUN = kmeans,
                    nstart = 25,
                    K.max = 10,
                    B = 50)
fviz_gap_stat(gap_stat) #another way to choose k; look for highest point
set.seed(1)
km <- kmeans(df, centers = 4, nstart = 25) #number of centers should equal k where leveling occurs above
km
fviz_cluster(km, data = df) #cluster visualization
aggregate(mydata, by=list(cluster=km$cluster), mean)
final_data <- cbind(mydata, cluster = km$cluster)
head(final_data)

library(openxlsx)
View(final_data) #see companies and their cluster number
write.xlsx(final_data, 'Clusters.xlsx') #export to Excel
