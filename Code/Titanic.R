
titanicUri <- 'C:\\Git\\SqlSaturday.Raleigh.2017\\Data\\Titanic.csv'
titanic <- read.csv(titanicUri, header = TRUE)
View(titanic)
nrow(titanic)

titanic <- titanic[complete.cases(titanic),]
titanic$AgeGroup <- cut(titanic$Age, c(0,13,100), labels=c("Young","Old"))
summary(titanic)
nrow(titanic)

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

#Split by survived
#255 died/174 lived
#Split by Sex
#276 male/153 female

#153 Females
#Split by Class
#117 of survivors were in C class, 36 were in non C


#cur.split <- titanic.train[titanic.train$Survived == '0',] 
#cur.split <- titanic.train[titanic.train$Sex == 'male',] 
#cur.split <- titanic.train[titanic.train$Pclass == 1,] 
#nrow(cur.split)



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





