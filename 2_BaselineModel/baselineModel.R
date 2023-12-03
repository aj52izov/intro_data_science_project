# Install needed packages
install.packages("mltools")
install.packages("readr")

# Load needed libraries
library(readr)
library(mltools)
library(data.table)


# I- Data Importing
data <- read_csv("/Data/kiwo_umsatz_wetter_data.csv")



# II- feature selection

# one hot encoding for Warengruppe, Month, DayOfWeek, and Bewoelkung since they are categorical variables
#kiwo_umsatz_wetter_data <- one_hot(as.data.table(kiwo_umsatz_wetter_data))
