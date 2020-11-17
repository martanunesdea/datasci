### PLOTTING DEMO #########################################################
library(ggplot2)
# Chapter 1
data(mpg)
# A simple plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

## Aesthetic mappings ##################
# A simple plot with color as a distinguishing factor
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# A simple plot with size as a distinguishing factor
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
# Transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy, alpha = class))
# Shape - note six shapes maximum, the other classes will go unplotted
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

#names(mpg) <- c("col1", "col2", "col3", "col4", "col5", "col6", "col7", "col8", "col9", "col10", "col11")

## Facets #################
# Adding facet grids 
# several graphs in one
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = col3, y = col8)) + 
  facet_wrap(~ col2, nrow = 3)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(col4 ~ col10)

# comes from this:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

# first side only
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# second side only
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

## Geometric objects #############
# Changing to a different geom
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv)) +
  geom_point(mapping = aes(x=displ, y = hwy, color = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

# smooth plot without shadow
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# same as before but different syntax
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# actual different meaning; geom_smooth is average across all mpg
# geom_point is differentiating for classes only
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# geom smooth is now only reppresentative of subcompacts and doesn't show shaded area
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


### Statistical Transformations ###
data(diamonds)
# barplot
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
# stat_count and geom_bar are fairly interchangeable...
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
# although, sometimes it is necessary to bypass the default stat from geom_bar
# e.g. if you want more info. 
ggplot(data = diamonds) + 
  stat_summary( mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
)



## Positional adjustments ##
# can colour with fill or colour
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
# map the fill variable to a second variable: get them stacked
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clar))

# when using fill, add position as dodge for elements to be beside one another
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
# or, add position as fill, and get them all relative to the fullest bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
# or, add position as identity, to get different elements overlapped (more useful for 2-d point charts)
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
# another identity barplot
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

# when using geom point, use jitter to evaluate the actually quantity of points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


## Coordinate systems ###
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
# makes long labels more readable
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

# maps coordinates - example
install.packages("maps")
nz <- map_data("nz")

# looks distorted
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

# looks better with coord_quickmap()
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# polar coordinates - example
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar
bar + coord_flip()
bar + coord_polar()


