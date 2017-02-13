#Get Data
View(Titanic)

#titanicUri <- 'https://kaggle2.blob.core.windows.net/competitions-data/kaggle/3136/train.csv?sv=2012-02-12&se=2016-08-21T12%3A15%3A36Z&sr=b&sp=r&sig=BYAiZNedJiqO49pSVUEfdEFuPca6RhExQ%2B1DMwOjAI4%3D'
titanicUri <- 'C:\\Git\\Avid.MachineLearning\\Lesson01\\Data\\Titanic.train.csv'
titanic <- read.csv(titanicUri, header = TRUE)

titanic <- titanic[complete.cases(titanic),]
titanic$AgeGroup <- cut(titanic$Age, c(0,13,100), labels=c("Young","Old"))
summary(titanic)

#airquality$TempRange <- cut(airquality$Temp, c(0,25,50,75,100), labels=c("cold","mild","nice","hot"))


#Review Data
View(titanic)
head(titanic)
summary(titanic)

titanic$Pclass <- as.factor(titanic$Pclass)
titanic$Survived <- as.factor(titanic$Survived)
plot(titanic)

plot(titanic$Survived,log(titanic$Fare))
plot(titanic$Survived,titanic$Pclass)
plot(titanic$Survived,titanic$Age)
plot(titanic$Survived,titanic$Sex)

#Remove abnormalities
titanic$Cabin <- as.character(titanic$Cabin)
titanic$Cabin[titanic$Cabin == ""] <- "S"
titanic$Cabin <- as.factor(titanic$Cabin)

#Select/Create Features
titanic$Name <- as.character(titanic$Name)
titanic$Title <- sapply(titanic$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})

#Split Data
install.packages("caret")
library(caret)
library(datasets)
titanic.split<-createDataPartition(y = titanic$Survived, p = 0.6, list = FALSE)
titanic.train<-titanic[titanic.split,]
titanic.test<-titanic[-titanic.split,]

#Select Model
library("rpart")
titanic.model <- rpart(Survived ~ Age + Sex + Pclass, method="class", data=titanic.train)
printcp(titanic.model)
plotcp(titanic.model)  
summary(titanic.model)
plot(titanic.model, uniform=TRUE, main="Classification Tree for Titanic Survival")
text(titanic.model, use.n=TRUE, all=TRUE, cex=.8)

#Evaluate Model
titanic.predict <- predict(titanic.model,newdata=titanic.test,type="class")
confusion.matrix <- table(titanic.test$Survived, titanic.predict)
print(confusion.matrix)

#Accuracy
(confusion.matrix[1,1] + confusion.matrix[2,2])/length(titanic.test$Survived)





