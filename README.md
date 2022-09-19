Exploring Air Quality in Western U.S. since 1971
================

## Introduction

For our project, we wanted to explore the levels of air pollution, and
the Air Quality Index values, throughout the United States during the
years after the passage of the Clean Air Act of 1970, which brought with
it the first establishment of National Ambient Air Quality Standards,
which have remained largely constant since then. In order to answer this
question, we drew upon data from the US EPA. More details on this
dataset can be found below, and in the “data” folder of our repo. For
our visualizations, we decided to make an interactive shiny app with a
choropleth map of the western US over time, colored by county-level
pollution/AQI levels, and some line plots of state-level pollution/AQI
levels over time. More details on our app can be found below, and the
app itself is in the “shiny” folder of our repo.

## Data

The data wrangling aspect of this project was challenging, and very
time-intensive. Loading data from the API could be a very arduous
process, and so we decided to load it in 10-year increments. Even then,
we knew that we could not load daily data—that would have been
county-level data on 6 different pollutants every day for an end-goal
period of 50 years and for multiple states. We initially tried to load
the next time increment of data, quarterly, but that too proved
time-intensive, and so we ultimately decided to use yearly increments.
In addition, due to the sheer amount of data that we still had to load,
we decided to focus our analysis on the 11 states which make up the
“Western” region of the United States, a decision primarily informed by
the knowledge that this is the most wildfire-prone region in the United
States ([Supporting data from
Statista](https://www.statista.com/statistics/217072/number-of-fires-and-acres-burned-due-to-us-wildfires/)).
Even taking all of these pragmatic decisions into account, each dataset
that we loaded — a 10-year increment of yearly county-level data from
one of the 11 states in our analysis — could be up to tens of thousands
of rows, and so given our time constraint for this project, we believe
that limiting our analysis was the correct choice.

After loading all of the data, we had to put it through numerous rounds
of adjustment, filtering, merging, summarizing, pivoting, etc. in order
to get to our final dataset. There were too many steps to explain them
all here, but I will try to explain the sequence of steps that led to
constructing the Air Quality Category variable, which led to the
construction of the Air Quality Category chloropleth map, which is
inspired by similar maps which exist currently for real-time data and
for data from any given historical date, but not in a holistic form,
like ours.

In order to construct this variable, we had to transform each pollution
level (or, more specifically, each arithmetic mean of yearly pollution
levels for a given county) into an air quality index, a calculation
which involves taking the fraction of two differences and multiplying
them by benchmark or air quality levels. This calculation is not
computationally difficult, but may have been challenging to successfully
and efficiently code, and so luckily, we were able to utilize a US
EPA-designed function called con2aqi (literally, concentration to air
quality index) in order to transform rounded pollution levels into air
quality index values We then had to take the maximum index value
produced by each pollutant in a given county and year, and this value
was the final AQI value for that county in the given year. To graph this
in the standard format, we had to then transform this variable into a
discrete variable with six levels, and color-code these levels using the
standard color scale (most of this information is from
[this](https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf)
document published by the US EPA). all of these transformations were
saved into the dataset, enabling us to finally use this dataset to
produce the final choropleth map in the way described below.

We did experience some setbacks with the data, and make one assumption.
The assumption that we made was that no state kept better air quality
records than California. We made this assumption after some brief
high-level googling, but it was not a fully backed-up assumption.
Through making this assumption, we saved ourselves the time that it
would have taken to have checked the availability of data on certain
pollutants for each state over each 10-year period. Instead, we used the
template created by loading the California data, in for which wwe did
exhaustively check for the availability of data on each of the six
pollutants in our analysis, and assumed that this would translate to
other states. We found that it overwhelmingly did translate, meaning
that most states did not have data on fewer pollutants than did
California during these periods. However, there is a possibility that
some states had data on more pollutants than did California during these
periods, and that data was left out of our project.

The main issue that we experienced was a miscalculation of the AQI
variable for the 1980s decade, which we amended by simply running the
code again. We do not know why this code did not work the first time,
and are still unsure about the cause of the relatively low AQI values
during this period, and whether they were caused by an issue in the data
or by real-world phenomena. More research would need to be done in order
to solve this mystery.

Here is a snippet of the data:

| year | state   | county   | county_code | state_code | AQI | pollutant | units_of_measure  | arithmetic_mean | air_quality_index              | fips  |
|-----:|:--------|:---------|:------------|:-----------|----:|:----------|:------------------|----------------:|:-------------------------------|:------|
| 1971 | Arizona | Cochise  | 003         | 04         |  33 | SO2       | Parts per billion |       23.268075 | Good                           | 04003 |
| 1971 | Arizona | Coconino | 005         | 04         |   2 | SO2       | Parts per billion |        0.733333 | Good                           | 04005 |
| 1971 | Arizona | Gila     | 007         | 04         | 115 | SO2       | Parts per billion |       48.123255 | Unhealthy for Sensitive Groups | 04007 |
| 1971 | Arizona | Greenlee | 011         | 04         | 107 | SO2       | Parts per billion |       88.596000 | Unhealthy for Sensitive Groups | 04011 |
| 1971 | Arizona | Maricopa | 013         | 04         | 247 | CO        | Parts per million |        3.478998 | Very Unhealthy                 | 04013 |

The following is a high-level description of an example tibble generated
by our function.

| Variable names    | Description                                                                                          |
|:------------------|:-----------------------------------------------------------------------------------------------------|
| year              | Year of recorded measurement.                                                                        |
| state             | State name.                                                                                          |
| state_code        | Code for chosen state.                                                                               |
| county            | County name.                                                                                         |
| county_code       | Code for county in that state.                                                                       |
| AQI               | Air Quality Index, used by government agencies to communicate to the public the air pollution level. |
| Air Quality Index | The levels of air pollution. Low AQI = “Good”, high AQI = “Hazardous”.                               |
| pollutant         | Name of pollutant.                                                                                   |
| arithmetic_mean   | Arithmetic mean of pollutant concentration.                                                          |
| units_of_measure  | Units of measure of pollutant concentration.                                                         |

## Approach

In order to explore air quality, we created a shiny app containing
choropleth maps and line plots. Our app contains 4 main tabs containing
different information on air pollution plus a tab for data and intro. We
chose to make a shiny app because it allows us to not only present, but
also interact with the visualizations by selecting features such as
pollutant type, year, and state.

We used the sidebar layout so that we can select pollutant type in the
sidebar and click on tabs on the main panel to see different plots. We
put pollutant on the side rather than under each tab because it is a
common variable for both the map (1st tab) and the line plot (3rd tab).
We included different types of pollutants because each pollutant might
indicate a different reason for or consequence of the corresponding air
pollution level. Including them will better inform expert users about
air quality. We also included the AQI plots, because this will allow us
to better communicate the overall air quality to laypeople without
getting into too much details in pollutant types.

The 1st and 2nd tabs contain a choropleth map of western US states and
counties which allows users to compare air quality across space. The 1st
tab filled by selected pollutants, and the 2nd tab filled by AQI levels.
The slider allows users to select a specific year or animate across
years. The maps show the county-level choropleth of pollution levels in
the selected year accordingly.

The 3rd and 4th tabs contain a line plot of air quality against year
which allows users to explore change of air quality across time and to
compare air quality trends across states. The 3rd tab has pollutant
levels on the y-axis as the air quality measure, and the 4th tab has AQI
on the y-axis as the air quality measure. The selectize input allows
users to select up to 8 out of the 11 states, while preventing them from
mispelling or inputing states that were not in our data. The limit of 8
states is for clarity of graphing. We don’t want to cram the graph with
too many lines, which hinders our ability of interpretation. The
resulting line graphs show the trend of air pollution levels of the
selected states across years.

The 5th tab contains a table showing our data. It has a search box on
the top, allowing users to type in any year, county, state, pollutant,
etc. values if they want to check on the data containing the typed value
only.

The 6th tab contains a brief intro of our project and our app, so that
users can better navigate it.

## Code & Visualizations

The shiny app can be accessed using [this
link](https://hanjimin06.shinyapps.io/furredflies/).

Below are the sample graphs of placeholder year 2010 and placeholder
pollutant PM2.5.

Here is the map of PM2.5 data in 2010.

``` r
counties_air %>%
  filter(year == 2010 & pollutant == "PM2.5") %>%
  ggplot() +
  geom_sf(data = WEST.SF) +
  geom_sf(mapping = aes(fill = arithmetic_mean), color = "grey40") +
  coord_sf(datum = NA) +
  scale_fill_gradient(name = paste0("Pollution level \n(Micrograms/cubic meter (LC))"),
                      low = "lightyellow", high = "darkred",
                      na.value = "white") +
  theme_void() +
  labs(title = "Map showing county-level air quality in 2010",
       subtitle = "measured by PM 2.5") +
  theme(legend.position = "left")
```

![](README_files/figure-gfm/tab1-1.png)<!-- -->

Here is the AQI map in 2010.

``` r
# create a color scale
cols <- c("Good" = "green", "Moderate" = "yellow", "Unhealthy for Sensitive Groups" = "orange",
          "Unhealthy" = "red", "Very Unhealthy" = "purple", "Hazardous" = "maroon")

counties_aqi %>%
  filter(year == 2010) %>%
  ggplot() +
  geom_sf(data = WEST.SF) +
  geom_sf(mapping = aes(fill = air_quality_index), color = "grey40") +
  scale_fill_manual(values = cols) +
  coord_sf(datum = NA) +
  labs(title = "Map showing county-level air quality measured by AQI",
       fill = "AQI Levels") +
  theme_void() +
  theme(legend.position = "left")
```

![](README_files/figure-gfm/tab2-1.png)<!-- -->

Here is a sample line graph for PM2.5 levels of some selected states.

``` r
input_state <- c("California", "Arizona", "Washington")
air_quality_state %>%
  filter(state %in% input_state & pollutant == "PM2.5") %>%
  ggplot(aes(year, air_qual_year, color = state)) +
  geom_line() +
  theme_light() +
  labs(title = paste0("Air Quality Across Years in ", paste0(input_state, collapse = ", ")),
       subtitle = paste0("measured by PM2.5"),
       x = "Year", y = "Polution level (Micrograms/cubic meter (LC))",
       color = "State")
```

![](README_files/figure-gfm/tab3-1.png)<!-- -->

Here is a sample line graph for AQI of some selected states.

``` r
aqi_state %>%
  filter(state %in% input_state) %>%
  ggplot(aes(year, mean_aqi, color = state)) +
  geom_line() +
  theme_light() +
  labs(title = paste0("Air Quality Across Years in ", paste(input_state, collapse = ", ")),
       subtitle = paste0("measured by AQI (Air Quality Index)"),
       x = "Year", y = "AQI",
       color = "State")
```

![](README_files/figure-gfm/tab4-1.png)<!-- -->

## Discussion

### Map & Line Plot

In the 1st tab, we study the choropleth map of the US west coast states
for 1971-2021, on various air pollutants. One caveat is that we lack a
great deal of data from the 70s, especially for more rural counties. NO2
and Ozone are almost restrained to data from California in the 70s,
while the PM measures were not collected in this dataset. But looking at
the maps in general, we can see that the reported counties generally
have high levels of pollutant concentration.

We can get a more holistic view of the trend if we look at the 2nd tab
containing the line plot. Most notably, we can see that SO2, NO2, and CO
have a similar trend in which the values for the 70s are extremely high
and they converge to a lower level as we approach the 21st century. We
hypothesize that this trend may be caused from the sheer lack of volume
of data in the 70s (Most likely), and also that the decreasing trend
represents an adapting mechanism for the counties after the policy
enactment in 1970. PM10, although collected from the mid-1980s, have a
similar downward trend. On the other hand, PM2.5 generally stays
constant throughout the years except for an outlier in California. Ozone
had a very unique trend in which all states experience a dip in ozone
levels in the 1980s. More specifically, the levels fall from around 0.06
Parts per Million to less than 0.04, going back up to 0.06 at the
beginning of the 90s. After the 90s, we note a rather constant level of
Ozone despite fluctuations in year-by-year level.

### AQI Map & AQI Line Plot

In the 3rd and 4th tabs respectively, we provide a similar set of maps
and line graphs for AQI, which is a more general and intuitive measure
of pollution derived from the pollutants we presented before. In the
1970s, where many of the values were fluctuating, we see a wide range of
colors in the map. We see that amid mostly green (good) AQI levels,
there are a mix of moderate and unhealthy levels near urban areas.
However, beginning from 1980, the map turns almost completely yellow
(moderate) and stays that way until 2021.

If we translate this trend to the AQI line plot, we can see that
similarly yet much less extremely than our previous plots, the AQI level
dips to the 50-60 range in the 1980s. One possible explanation is that
this is due to the influence of the Ozone plot, because Ozone is more
weighted when computing AQI. Reflecting how most pollutants converge to
a lower level after the 1990s, we can rationalize the fact that AQI
stabilizes to the moderate range (51-100).

## Conclusion

Although the variance in the AQI levels are very small for all of the
states, we can also note that the “larger” and “more urban” states tend
to have slightly higher values of AQI. Those states are California,
Arizona, Colorado, and Utah. We cannot generalize these results to any
normative statements about air pollution or climate change. Also, we
have some constraints due to a lack of data in certain regions. Thus, it
will be reasonable to use this website as a supplementary source
providing a convenient mapping of how pollutant levels have changed
across time. If we were given more time and resources, we would first
expand our computing power to obtain data that covers missing counties
and the rest of the states. Then, we would also try to link this data
with possible causes or results affected by the data, such as
individuals’ health data or the correlation with how “urban” some
counties are.

## Repo organization

-   [proposal](proposal) folder. This folder includes the RMarkDown and
    knitted MarkDown documents which contain the information in this
    proposal.

-   [data](data) folder. This folder contains RMarkDown documents used
    to load, examine, and wrangle data from the RAQSAPI and to load data
    from other sources, the csv files of data loaded from other sources,
    as well as the README file consisting of the codebook.

-   [presentation](presentation) folder. This folder contains code we
    used to create our slides.

-   [shiny](shiny) folder. This folder contains an [app.R](shiny/app.R)
    document consisting of the code used to build the app and a
    [data](shiny/data) folder consisting of the data we used to make
    visualizations in the app.

-   [README_files](README_files) folder. This folder contains select
    visualizations of air quality trends.

-   [This](https://hanjimin06.shinyapps.io/furredflies/) is the link to
    our shiny app website.

-   Each folder has a README.Rmd and README.md file that describe the
    content of the folder.
