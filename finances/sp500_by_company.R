# Source of data: https://www.kaggle.com/datasets/paytonfisher/sp-500-companies-with-financial-information?rvi=1

companies_data <- read.csv("financials.csv", stringsAsFactors=FALSE)
us_billion <- 1000000000
companies_data$Market.Cap <- companies_data$Market.Cap / us_billion
total_market_cap <- sum(companies_data$Market.Cap)

companies_data$weight <- companies_data$Market.Cap / total_market_cap * 100
total_weight <- sum(companies_data$weight)

data <- select(companies_data, Name, Symbol, weight, Sector)

data <- data %>% arrange(desc(companies_data$weight))

data <- data[-3, ] # remove Alphabet C stock (dupe)


treemap(data,
        index="Symbol",
        vSize="weight",
        type="index"
)


treemap(data, 
        index=c("Sector","Symbol"),     
        vSize="weight", 
        type="index",
        
        fontsize.labels=c(10,9),                # size of labels. Give the size per level of aggregation: size for group, size for subgroup, sub-subgroups...
        fontcolor.labels=c("white","black"),    # Color of labels
        fontface.labels=c(2,1),                  # Font of labels: 1,2,3,4 for normal, bold, italic, bold-italic...
        bg.labels=c("transparent"),              # Background color of labels
        align.labels=list(
          c("center", "center"), 
          c("right", "bottom")
        ),                                   # Where to place labels in the rectangle?
        overlap.labels=0.5,                      # number between 0 and 1 that determines the tolerance of the overlap between labels. 0 means that labels of lower levels are not printed if higher level labels overlap, 1  means that labels are always printed. In-between values, for instance the default value .5, means that lower level labels are printed if other labels do not overlap with more than .5  times their area size.
        inflate.labels=F,                        # If true, labels are bigger when rectangle is bigger.
        palette = "Set2",                        # Select your color palette from the RColorBrewer presets or make your own.
        title="S&P500 Companies by Market Weight Cap",                      # Customize your title
        fontsize.title=12,   
)
