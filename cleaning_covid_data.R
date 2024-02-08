# packages
library(readxl)
library(stringr)

# read in covid data
# cols: "date"   "county" "state"  "fips"   "cases"  "deaths"
counties20 = read.csv("/Users/johnkim/Desktop/capstone/data/us-counties-2020.csv")
counties21 = read.csv("/Users/johnkim/Desktop/capstone/data/us-counties-2021.csv")
counties22 = read.csv("/Users/johnkim/Desktop/capstone/data/us-counties-2022.csv")
counties23 = read.csv("/Users/johnkim/Desktop/capstone/data/us-counties-2023.csv")
# combine all to one dataset
covid = rbind(counties20, counties21, counties22, counties23)
nrow(covid) # 3,525,161 rows!
# convert fips col to character (merge column)
covid$fips = as.character(covid$fips)
covid$fips = str_pad(covid$fips, width = 5, side = "left", pad = "0")


# read in mask data
# cols: COUNTYFP NEVER RARELY SOMETIMES FREQUENTLY ALWAYS
mask = read.csv("/Users/johnkim/Desktop/capstone/data/mask-use-by-county.csv")
# convert fips col to character (merge column)
mask$COUNTYFP = as.character(mask$COUNTYFP)
mask$COUNTYFP = str_pad(mask$COUNTYFP, width = 5, side = "left", pad = "0")


# merge covid + mask data on fips columns
covid_mask = merge(covid, mask, by.x = "fips", by.y = "COUNTYFP", all.x = TRUE)
nrow(covid_mask) # check 3525161
# read in county socio-economic data
education = read_excel("/Users/johnkim/Desktop/capstone/data/Education.xlsx", skip = 3, col_names = TRUE)
population = read_excel("/Users/johnkim/Desktop/capstone/data/PopulationEstimates.xlsx", skip = 4, col_names = TRUE)
poverty = read_excel("/Users/johnkim/Desktop/capstone/data/PovertyEstimates.xlsx", skip = 4, col_names = TRUE)
unemployment = read_excel("/Users/johnkim/Desktop/capstone/data/Unemployment.xlsx", skip = 4, col_names = TRUE)
# merge covid-mask data with socio-economic data on fips columns
# takes a bit of time
merged_edu = merge(covid_mask, education, by.x = "fips", by.y = "Federal Information Processing Standard (FIPS) Code", all.x = TRUE)
merged_pop = merge(merged_edu, population, by.x = "fips", by.y = "FIPStxt", all.x = TRUE)
merged_unempl = merge(merged_pop, unemployment, by.x = "fips", by.y = "FIPS_Code", all.x = TRUE)
all_county_data = merge(merged_unempl, poverty, by.x = "fips", by.y = "FIPS_Code", all.x = TRUE)

#save to csv
write.csv(all_county_data,"all_county_data.csv")

# for memory errors, read in data again
all_county_data = read.csv("/Users/johnkim/Desktop/capstone/data/all_county_data.csv")

# drop columns
names(all_county_data)
columns_to_drop = c(12:57, 66:72, 78:190, 217:222, 224:249)
county_data = all_county_data[, -columns_to_drop]
View(county_data)

#save to csv
write.csv(county_data,"county_data.csv")
county_data$fips
View(county_data)

# read county_data
county_data = read.csv("/Users/johnkim/Desktop/capstone/data/county_data.csv")
