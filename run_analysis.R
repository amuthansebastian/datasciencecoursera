## Set directory

setwd("C:/Users/u0130359/Downloads/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")


## Read Test Data
df.X_test   = read.table("./test/X_test.txt",header=FALSE)
df.Y_test   = read.table("./test/Y_test.txt",header=FALSE)
df.testSub  = read.table("./test/subject_test.txt",header=FALSE)
df.test = cbind(df.X_test,df.testSub,df.Y_test)
df.test = data.frame("Test",df.test)

## Read Train Data
df.X_train  = read.table("./train/X_train.txt",header=FALSE)
df.Y_train  = read.table("./train/Y_train.txt",header=FALSE)
df.trainSub = read.table("./train/subject_train.txt",header=FALSE)
df.train = cbind(df.X_train,df.trainSub,df.Y_train)
df.train = data.frame("Train",df.train)

## Assign Column names to the data frame & Merge the data set
df.features = read.table("features.txt")
df.features = as.data.frame(t(df.features))
df.features = df.features[2,]
df.features = data.frame("Observation.Type", df.features,"Subject","Action")
mylist <- unlist(df.features[1,])
colnames(df.train) <- unlist(df.features[1,])
colnames(df.test) <- unlist(df.features[1,])
df.data = rbind(df.test,df.train)

## transform Activity code into description
df.data$Action = sub("1","WALKING", df.data$Action)
df.data$Action = sub("2","WALKING UPSTAIRS", df.data$Action)
df.data$Action = sub("3","WALKING DOWNSTAIRS
", df.data$Action)
df.data$Action = sub("4","SITTING", df.data$Action)
df.data$Action = sub("5","STANDING", df.data$Action)
df.data$Action = sub("6","LAYING", df.data$Action)

## Populated Tidydata
df.tidydata = data.frame( df.data$Observation.Type, df.data$Subject, df.data$Action, df.data[grep("mean",names(df.data))],df.data[grep("std",names(df.data))]) 

## Rename the columns into user readable columns
x = names(df.tidydata)
y = sub("^t","Time.",x)
y = sub("^f","Filtered.",y)
y = sub("[Gg]ravity", "Gravity",y)
y = gsub("[Bb]ody", "Body",y)
y = sub("[Gg]yro", "Gyroscope",y)
y = sub("Mag", "Magnitude",y)
y = sub("Acc", "Acceleration",y)
y = sub("std", "StdDev",y)
y = sub("mean","Mean", y) 
colnames(df.tidydata) = y

## Write the data out to a flat file
write.table(df.tidydata, file = "tidydata.csv", sep = ",",row.names = FALSE)

## Prepare the Average for activity & Subject
MyMelt <- melt(df.tidydata,id=c("df.data.Action","df.data.Subject"),measure.vars=c(grep("Mean",names(df.tidydata)),grep("StdDev",names(df.tidydata))))
MySubjectMean <- dcast(MyMelt, df.data.Subject ~ variable, mean)
MyActionMean <- dcast(MyMelt, df.data.Action ~ variable, mean)

## Dump the data out into a flat file
write.table(MySubjectMean , file = "MySubjectMean.csv", sep = ",",row.names = FALSE)
write.table(MyActionMean , file = "MyActionMean.csv", sep = ",",row.names = FALSE)


## end of program

