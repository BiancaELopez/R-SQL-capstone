# extracts species and weights for a given year from portal rodent 
# database; makes a fancy plot and saves the plot to a file

library(RSQLite)
library(ggplot2)

# get command-line arguments
args <- commandArgs(TRUE)
if (length(args)==0) {
  stop("Script requires a year argument", call.=FALSE)
} else if (length(args)==1) {
  year <- args[1]
}

print(paste("Getting data for year",year))

# create a connection to the database
# 
myDB <- "~/Desktop/Portal_data/portal_mammals.sqlite"
conn <- dbConnect(drv = SQLite(), dbname= myDB)

# some database functions for listing tables and fields
dbListTables(conn)
dbListFields(conn,"surveys")

# constructing a query
query_string <- "SELECT count(*) FROM surveys"
dbGetQuery(conn,query_string)

# write a query that gets the non-null weights for 
# all species in this year
query_string <- "SELECT species_id,weight FROM surveys WHERE (year=year) AND (weight IS NOT NULL);"
result <- dbGetQuery(conn,query_string)
head(result)

# plot the data and save to a png file
ggplot(data = result, aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.3, color='tomato') + # adds the data
  geom_boxplot(alpha = 0)
outputfilename <- paste("weight by species", year, ".png")
ggsave(outputfilename)
