# Library
library(networkD3)
library(dplyr)

# A connection data frame is a list of flows with intensity for each flow
data <- read.csv("expenses.csv", stringsAsFactors=FALSE)
data$Cost <- as.numeric(gsub('[£]', '', data$Cost))
total <- sum(data$Cost, na.rm=TRUE)
data$Source <- "Income"

# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(
  name=c(as.character(data$Source), 
         as.character(data$Sub.category)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
data$IDsource <- match(data$Source, nodes$name)-1
data$IDtarget <- match(data$Sub.category, nodes$name)-1

# Make the Network
p <- sankeyNetwork(Links = data, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "Cost", NodeID = "name", 
                   sinksRight=FALSE)
p

# save the widget
# library(htmlwidgets)
# saveWidget(p, file=paste0( getwd(), "/HtmlWidget/sankeyBasic1.html"))