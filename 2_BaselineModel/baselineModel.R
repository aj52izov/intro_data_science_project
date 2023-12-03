# Install needed packages
install.packages("mltools")
install.packages("readr")

# Load needed libraries
library(readr)
library(ggplot2)
library(mltools)
library(data.table)


# I- Data Importing
data <- read_csv("Data/kiwo_umsatz_wetter_data.csv")
data$Warengruppe <- factor(data$Warengruppe)
data$Month <- factor(data$Month)
data$DayOfWeek <- factor(data$DayOfWeek)
data$Bewoelkung <- factor(data$Bewoelkung)

data$Datum <- as.Date(data$Datum)
# sort data by date
data <- data[order(data$Datum), ]



# II- feature selection data splitting

# Delete outliers from the data(rows with Umsatz > 1000)
data <- data[data$Umsatz < 1000, ]

# one hot encoding for Warengruppe, Month, DayOfWeek, and Bewoelkung since they are categorical variables
data <- one_hot(as.data.table(data))

# set data from 2013-07-01 to 2017-07-31 as training data and the rest as test data
training_start_date <- as.Date("2013-07-01")
training_end_date <- as.Date("2017-07-31")

training_data <- data[
  data$Datum >= training_start_date &
    data$Datum <= training_end_date,
]
print("Training data dimensions:")
training_shape <- dim(training_data)
print(training_shape)


test_data <- data[
  data$Datum > training_end_date,
]
print("Test data dimensions:")
test_shape <- dim(test_data)
print(test_shape)


# delete the date column from the training and test data
training_data$Datum <- NULL
test_data_date <- test_data$Datum
test_data$Datum <- NULL




# III- model training
# we will use a simple linear regression model
# Set a random seed for reproducibility
set.seed(42)
mod <- lm(Umsatz ~ ., training_data)
summary(mod)




# IV- model evaluation

# Make predictions using the test data
predicted_values <- predict(mod, newdata = test_data)

# Compare the predicted values with the actual values
comparison <- data.frame(Actual = test_data$Umsatz, Predicted = predicted_values)
comparison$Datum <- test_data_date # add the date column to the comparison data frame

# Calculate the mean squared error (RMSE)
rmse <- sqrt(mean((comparison$Actual - comparison$Predicted)^2))
cat("RMSE:", rmse, "\n")


# Calculate the mean absolute error (MAE)
mae <- mean(abs(comparison$Actual - comparison$Predicted))
cat("MAE:", mae, "\n")

# plot the actual and predicted values
colors <- c("Actual" = "blue", "Predicted" = "red")
ggplot() +
  geom_line(data = comparison, aes(x = Datum, y = Actual), color = "blue", size = 0.7) +
  geom_line(data = comparison, aes(x = Datum, y = Predicted), color = "red", size = 0.7) +
  labs(x = "Date", y = "Umsatz", title = "Actual vs Predicted Umsatz", color="Legend") +
  scale_color_manual(values = colors)





