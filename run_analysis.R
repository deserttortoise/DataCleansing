setwd("C:/R/UCI HAR Dataset")
# Training Set

#Load the Datsets Necesarry for training set
x_train=read.table("./train/X_Train.txt")
y_train=read.table("./train/Y_Train.txt")
train_subject=read.table("./train/subject_Train.txt")
features=read.table("./features.txt")

#create a variable of variable Names from features.txt
fe=features$V2
#Rename the variable names from features.txt
names(x_train)=fe

#Keep all variable names with "Mean" or "Std" using regex
z=grepl( "mean|std" , names( x_train ) )
train=x_train[,z]

name=c("Subject_Number","Activity",names(train))

"Join Subject Number and Activity to training set"
train=cbind(train_subject,y_train,train)
names(train)=name

#Testing Set
#Repeat Steps from training steps on testing set
x_test=read.table("./test/X_Test.txt")
y_test=read.table("./test/Y_Test.txt")
test_subject=read.table("./test/subject_Test.txt")

names(x_test)=fe
z=grepl( "mean|std" , names( x_test ) )
test=x_test[,z]

name=c("Subject_Number","Activity",names(test))

test=cbind(test_subject,y_test,test)
names(test)=name

#Combine the Training and Testing Set
mydata=rbind(train,test)

#Rename Activity Factors
mydata$Activity=factor(mydata$Activity,labels=c("Walking","Walking Upstairs","Walking Downstairs","Sitting","Standing","Laying"))

#Take Average of variables by subject Id and number
aggregate=aggregate(mydata[,3:81],by=list(Category=mydata$Subject_Number,mydata$Activity),FUN=mean)

nv=names(aggregate[,3:81])
xx=paste("Mean of ",nv)

#Rename Variables
names(aggregate)=c("Subject_Number","Activity",xx)

#Write Variables to Table
write.table(aggregate,file="./Tidy_data.csv",row.name=FALSE)