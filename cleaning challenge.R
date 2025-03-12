set.seed(112)
library(tidyverse)
library(tools)
library(skimr)
library(randomForest)
library(caret)
library(nnet)

# Reading the dataset

data <- read.csv('dirty_healthcare-data.csv',sep=',')
View(data)
dim(data)
# A quick descriptive statistics

skim(data)
# The brief overview of the dataset reveals numerous inconsistencies,
# including incorrect data types, missing values, empty cells, and more.
# We will clean the dataset systematically, addressing each column
# step by step to ensure it is ready for analysis.

# First, change all empty cells to NA
data[data == ''] <- NA

# Check the number of Missing of observations in the dataset
data.frame(Missing = colSums(is.na(data)))
# The output shows that 4 columns have missing values: Gender, Education, 
# Blood.Type, and Health.Condition. Gender has the highest number of missing 
# values, followed by Education.

# Formatting the Name column to proper case
data[[2]] <-toTitleCase(tolower(data[[2]]))

# Cleaning the Age column
data$Age[data$Age == 'Unknown'] <- NA
data$Age <- as.numeric(data$Age)

# Cleaning the Gender column
data$Gender <- ifelse(grepl('^m',data$Gender,ignore.case = T),'Male',
                      ifelse(grepl('^f',data$Gender,ignore.case = T),
                              'Female',data$Gender))

# Cleaning the City column
data$City <- ifelse(grepl('al(?=b)',data$City,ignore.case = T,perl = T),
                    'Albuquerque',ifelse(grepl('ba(?=l)',data$City,
                                               ignore.case = T,perl = T),
                                         'Baltimore',ifelse(grepl(
                                           'at(?=l)',data$City,
                                           ignore.case = T,perl = T),
                                           'Atlanta',data$City
                                         )))


# Standardizing the Education column
data$Education <- ifelse(grepl('^bach',data$Education,ignore.case = T),
                         'Bachelors',ifelse(grepl('^hig',data$Education,
                                                  ignore.case = T),
                                            'High School',data$Education))


# Cleaning the Employment column
data[[8]] <- case_when(
  grepl('^emp',data[[8]],ignore.case = T) ~ 'Employed',
  grepl('^free',data[[8]],ignore.case = T) ~ 'Freelance',
  grepl('^ret',data[[8]],ignore.case = T) ~ 'Retired',
  grepl('^self',data[[8]],ignore.case = T) ~ 'Self-Employed',
  grepl('^unem',data[[8]],ignore.case = T) ~ 'Unemployed',
  grepl('^gig',data[[8]],ignore.case = T) ~ 'Gig-Worker',
  grepl('^stu',data[[8]],ignore.case = T) ~ 'Student',
  .default = data[[8]]
)


# Cleaning the Salary column
data[[9]] <- gsub('\\s.*','',data[[9]])#remove anything after the salary
data[[9]] <- gsub('\\(','-',data[[9]]) # Replace '(' with '-'
data[[9]] <- gsub('\\)','',data[[9]]) # Remove ')'
data[[9]] <- as.numeric(sapply(data[[9]],function(x) gsub('[$,]','',x))) # Remove '$' and ','


# Cleaning the Health Condition column
data[[10]] <- gsub('\\s\\(.*','',data[[10]]) # Remove text within parentheses

# Cleaning the Credit Score column
table(data$Credit.Score) # Checking the structure of the column
data[[11]] <- gsub('\\s.*','',data[[11]]) # Remove extra text
data[[11]] <-ifelse(grepl('^n',data[[11]],ignore.case = T),NA,data[[11]])
data[[11]] <- as.numeric(data[[11]])

# Cleaning the Admission Date column
data <- subset(data,!grepl('^[a-zA-Z]',data[[12]])) # Remove rows with non-date values
dim(data) # Check the new dimensions of the dataset
data[[12]] <- ymd(parse_date_time(data[[12]],orders = '%Y,%m,%d')) # Convert to proper date format

# Formatting the Name column to proper case
data[[2]] <- toTitleCase(tolower(data[[2]]))

# Cleaning the Age column
data$Age[data$Age == 'Unknown'] <- NA
data$Age <- as.numeric(data$Age)

# Cleaning the Gender column
data$Gender <- ifelse(grepl('^m', data$Gender, ignore.case = TRUE), 'Male',
                      ifelse(grepl('^f', data$Gender, ignore.case = TRUE), 'Female', data$Gender))

# Cleaning the City column
data$City <- ifelse(grepl('al(?=b)', data$City, ignore.case = TRUE, perl = TRUE), 'Albuquerque',
                    ifelse(grepl('ba(?=l)', data$City, ignore.case = TRUE, perl = TRUE), 'Baltimore',
                           ifelse(grepl('at(?=l)', data$City, ignore.case = TRUE, perl = TRUE), 'Atlanta', data$City)))

# Standardizing the Education column
data$Education <- ifelse(grepl('^bach', data$Education, ignore.case = TRUE), 'Bachelors',
                         ifelse(grepl('^hig', data$Education, ignore.case = TRUE), 'High School', data$Education))

# Cleaning the Employment column
data[[8]] <- case_when(
  grepl('^emp', data[[8]], ignore.case = TRUE) ~ 'Employed',
  grepl('^free', data[[8]], ignore.case = TRUE) ~ 'Freelance',
  grepl('^ret', data[[8]], ignore.case = TRUE) ~ 'Retired',
  grepl('^self', data[[8]], ignore.case = TRUE) ~ 'Self-Employed',
  grepl('^unem', data[[8]], ignore.case = TRUE) ~ 'Unemployed',
  grepl('^gig', data[[8]], ignore.case = TRUE) ~ 'Gig-Worker',
  grepl('^stu', data[[8]], ignore.case = TRUE) ~ 'Student',
  .default = data[[8]]
)

# Cleaning the Salary column
data[[9]] <- gsub('\\s.*', '', data[[9]])       # Remove anything after the salary
data[[9]] <- gsub('\\(', '-', data[[9]])        # Replace '(' with '-'
data[[9]] <- gsub('\\)', '', data[[9]])         # Remove ')'
data[[9]] <- as.numeric(sapply(data[[9]], function(x) gsub('[$,]', '', x))) # Remove '$' and ','

# Cleaning the Health Condition column
data[[10]] <- gsub('\\s\\(.*', '', data[[10]]) # Remove text within parentheses

# Cleaning the Credit Score column
table(data$Credit.Score)
data[[11]] <- gsub('\\s.*', '', data[[11]]) # Remove extra text
data[[11]] <- ifelse(grepl('^n', data[[11]], ignore.case = TRUE), NA, data[[11]])
data[[11]] <- as.numeric(data[[11]])

# Cleaning the Admission Date column
data <- subset(data, !grepl('^[a-zA-Z]', data[[12]])) # Remove rows with non-date values
dim(data) # Check the new dimensions of the dataset
data[[12]] <- ymd(parse_date_time(data[[12]], orders = '%Y,%m,%d')) # Convert to proper date format

# Checking the structure of the dataset after cleaning
str(data)
# Checking for missing values again
data.frame(Missing = colSums(is.na(data)))

# Removing the Gender column due to high number of NA values
data <- data[,-4] # Dropping the gender column

# Filling NA values with the median for all numeric columns
f1 <- function(x){ 
  if(is.numeric(x)){
    replace(x,is.na(x),median(x,na.rm = T))
  } else {
    return(x)
  }
}
# Applying the function to the dataset
data <- as.data.frame(lapply(data,f1))

# Filling NA values in character columns with the most frequent value (mode)
f2 <- function(x){
  if(is.character(x)){
      if(length(x) > 0 && any(!is.na(x))){
            mode_value <- names(sort(table(x),decreasing = T))[1]
            x[is.na(x)] <- mode_value
   }
    return(x) # return the modified character columns
  } else {
    return(x)
  }
}

data<-as.data.frame(lapply(data,f2))

# Removing rows with NA in the Date of Admission column
data <- subset(data,!is.na(data$Date.of.Admission))

# Performing descriptive statistics on the cleaned dataset 
skim(data)

# Saving the cleaned dataset to a CSV file
write.csv(data,'clean_health.csv',row.names = F)

# Building the model
# Selecting variables to include in the model
names(data)
new_data <- data[,c(3,4,5,6,7,8,9,10)]
names(new_data)

# creating dummy varibles for city, education, employment status, and
# health condition ( using onehot encoding)

new_data <- cbind(new_data[,-c(2,3,4,5)],class.ind(new_data$City),
                  class.ind(new_data$Blood.Type),class.ind(new_data$Education),
                  class.ind(new_data$Employment.Status))

# Droping the first dummy variable(s) to avoid colinearity among the 
# predictor variables
new_data <- new_data[,-c(5,8,16,21)]

# Splitting the data into training and testing set and normalizing
id <- sample(2,nrow(new_data),replace = T,prob = c(.8,.2))
training <- new_data[id==1,]
testing <- new_data[id==2,]

# Normalizing function
f1 <- function(x){
  if(is.numeric(x)){
    return((x-min(x))/(max(x)-min(x)))
  }else{
    return(x)
  }
}
# Applying the function to the training and testing set
train <- as.data.frame(lapply(training,f1))
test <- as.data.frame(lapply(testing,f1))

View(training)

train$Health.Condition <- factor(train$Health.Condition)
test$Health.Condition <- factor(test$Health.Condition)
# Fitting a random forest model to the training set

model <-randomForest(Health.Condition~.,data=train,
                     ntree=300,
                    )
varImpPlot(model) #Checking important variables
plot(model) # Visualizing the model

model # Model summary
# Checking model performance on test data
confusionMatrix(table(Actual=test$Health.Condition, 
                      Predicted=predict(model,test)))
