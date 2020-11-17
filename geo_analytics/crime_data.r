# analysing crime data 
library(rgdal)
library(tmap)

install.packages("tmap")
police_data <- read.csv("2019-12-metropolitan-street.csv")

head(police_data)

# filter "camden" in LOSL column
police_data <- police_data[grepl('Camden', police_data$LSOA.name),]

#By unsing FUN=length we are asking that the aggregate function counts the number of times a crime.ID appears at a location.
crime_count<- aggregate(police_data$Crime.ID, by=list(police_data$Longitude, police_data$Latitude,police_data$LSOA.code,police_data$Crime.type), FUN=length)

#We need to rename our columns (note these are abbreviated from the originals)
names(crime_count)<- c("Long","Lat","LSOA","Crime","Count")

# Create spatial object
# proj4string - type of projection that data are in
crime_count_sp<- SpatialPointsDataFrame(crime_count[,1:2], crime_count, proj4string = CRS("+init=epsg:4326"))

# tm_bubbles - type of map
# size - big/small bubble
# column - type of crime that occurred
# legend - not present
# tm_layout - adding some layout 
# size of text, size of title

# can map to make it easier to see
pdf("crime_bubble_dec19.pdf", width=10, height=12)
tm_shape(crime_count_sp) + 
  tm_bubbles(size = "Count", col = "Crime", legend.size.show = FALSE) +
  tm_layout(legend.text.size = 1.1, legend.title.size = 1.4, frame = FALSE)
dev.off()


# scale map
pdf("crime_bubble_dec19_scaled.pdf", width=10, height=12)
tm_shape(crime_count_sp) + 
  tm_bubbles(size = "Count", col = "Crime", legend.size.show = FALSE, scale=3) +
  tm_layout(legend.text.size = 1.1, legend.title.size = 1.4, frame = FALSE)
dev.off()

# add a facet function
# breakdown each type of crime into different maps
tm_shape(crime_count_sp) + tm_bubbles(size = "Count", legend.size.show = FALSE) +
  tm_layout(legend.text.size = 1.1, legend.title.size = 1.4, frame = FALSE)+tm_facets(by="Crime")


# Aggregate polygon data
library(`tidyr`)
police_data <- read.csv("2019-12-metropolitan-street.csv")
#First aggregate the data to each LSOA (rather than the specific latitude and longitude as we did before)
crime_LSOA<- aggregate(police_data$Crime.ID, by=list(police_data$LSOA.code,police_data$Crime.type), FUN=length)
#We need to rename our columns (note these are abbreviated from the originals)
names(crime_LSOA)<- c("LSOA","Crime","Count")


# The arguments to spread():
# - data: Data object
# - key: Name of column containing the new column names
# - value: Name of column containing values
crime_LSOA <- spread(crime_LSOA,Crime,Count)
