# install needed libraries

library(readr)

# I- Data Importing

# read data
kiwo_data <- read_csv("Data/kiwo.csv")
kiwo_data$Datum <- as.Date(kiwo_data$Datum)
kiwo_data <- kiwo_data[order(kiwo_data$Datum), ]

umsatz_data <- read_csv("Data/umsatzdaten_gekuerzt.csv")
umsatz_data$Datum <- as.Date(umsatz_data$Datum)
umsatz_data <- umsatz_data[order(umsatz_data$Datum), ]

wetter_data <- read_csv("Data/wetter.csv")
wetter_data$Datum <- as.Date(wetter_data$Datum)
wetter_data <- wetter_data[order(wetter_data$Datum), ]




# II- Merging, Cleaning, and Handling Missing Values

# delete Wettercode column because don't know to handle missing values on this column and it is not needed
wetter_data$Wettercode <- NULL

# merge kiwo and umsatz data
kiwo_umsatz_data <- merge(umsatz_data, kiwo_data, by = "Datum", all = TRUE)

# set 0 for NA in KielerWoche
kiwo_umsatz_data$KielerWoche[is.na(kiwo_umsatz_data$KielerWoche)] <- 0

# merge kiwo_umsatz_data and wetter data
kiwo_umsatz_wetter_data <- merge(kiwo_umsatz_data, wetter_data, by = "Datum", all = TRUE)

# delete rows with NA
kiwo_umsatz_wetter_data <- na.omit(kiwo_umsatz_wetter_data)




# III- Constructing New Variables

# change data colum to day, month, and day of week
kiwo_umsatz_wetter_data$Day <- as.numeric(format(kiwo_umsatz_wetter_data$Datum, "%d"))
kiwo_umsatz_wetter_data$Month <- factor(format(kiwo_umsatz_wetter_data$Datum, "%m"))
kiwo_umsatz_wetter_data$DayOfWeek <- factor(format(kiwo_umsatz_wetter_data$Datum, "%u"))


# IV- Data Transformation

# transform Bewoelkung and Warengruppe to factor
kiwo_umsatz_wetter_data$Bewoelkung <- factor(kiwo_umsatz_wetter_data$Bewoelkung)
kiwo_umsatz_wetter_data$Warengruppe <- factor(kiwo_umsatz_wetter_data$Warengruppe)

# V store the resulting data frame in a csv file
write.csv(kiwo_umsatz_wetter_data, "Data/kiwo_umsatz_wetter_data.csv", row.names = FALSE)


