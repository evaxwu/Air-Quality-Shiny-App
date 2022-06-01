Writeup
================
Furred Flies - Jimin Han, Eva Wu, Caleb Weis

# Introduction

For our project, we wanted to explore the levels of air pollution, and
the Air Quality Index values, throughout the United States during the
years after the passage of the Clean air Act of 1970, which brought with
it the first establishment of National Ambient Air Quality Standards,
which have remained largely constant since then. In order to answer this
question, we drew upon data from the US EPA. More details on this
dataset can be found below, and in the ‘data’ folder of our repo. For
our visualization, we decided to make an interactive shiny app with a
chloropleth map of the western US over time, colored by pollutant/AQI
levels, and some line plots of pollution/AQI levels over time. More
details on our app can be found below, and the app itself is in the
‘shiny’ folder of our repo.

# Data

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
‘Western’ region of the United States, a decision primarily informed by
the knowledge that this is the most wildfire-prone region in the United
States ([Supporting data from
Statista](https://www.statista.com/statistics/217072/number-of-fires-and-acres-burned-due-to-us-wildfires/)).
Even taking all of these pragmatic decisions into account, each dataset
that we loaded—a 10-year increment of yearly county-level data from one
of the 11 states in our analysis—could be up to tens of thousands of
rows, and so given our time constraint for this project, we believe that
limiting our analysis was the correct choice.

After loading all of the data, we had to put it through numerous rounds
<<<<<<< HEAD
of adjustment, filtering, merging, summarizing, pivoting, etc. in order
=======
of adjustment, filtering, merging, summarizing pivoting, etc. in order
>>>>>>> main
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
<<<<<<< HEAD
produce the final chloropleth map in the way described below.
=======
produce the final choropleth map in the way described below.
>>>>>>> main

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

<<<<<<< HEAD
Here is a snippet of the data:

``` r
df <- read_csv("/Users/eva/Desktop/proj2-furred-flies/data/AllStates_overall.csv") %>%
  select(year, state, state_code, county, county_code, AQI, `Air Quality Index`, 
         pollutant, arithmetic_mean, units_of_measure)

kable(head(df, 5))
```

| year | state      | state_code | county  | county_code | AQI | Air Quality Index | pollutant | arithmetic_mean | units_of_measure  |
|-----:|:-----------|:-----------|:--------|:------------|----:|:------------------|:----------|----------------:|:------------------|
| 1971 | California | 06         | Alameda | 001         |  67 | Moderate          | CO        |        2.719067 | Parts per million |
| 1971 | California | 06         | Alameda | 001         |  67 | Moderate          | NO2       |       69.150943 | Parts per billion |
| 1971 | California | 06         | Alameda | 001         |  67 | Moderate          | SO2       |        3.448786 | Parts per billion |
| 1971 | California | 06         | Butte   | 007         |  39 | Good              | CO        |        1.773927 | Parts per million |
| 1971 | California | 06         | Butte   | 007         |  39 | Good              | NO2       |       40.564972 | Parts per billion |

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

=======
>>>>>>> main
# Approach

# Analysis

Our project contains 4 main tabs containing different information on air
pollution.

## Map & Line Plot

In this tab, we study the choropleth map of the US west coast states for
1971-2021, on various air pollutants. One caveat is that we lack a great
deal of data from the 70s, especially for more rural counties. NO2 and
Ozone are almost restrained to data from California in the 70s, while
the PM measures were not collected in this dataset. But looking at the
maps in general, we can see that the reported counties generally have
high levels of pollutant concentration.

We can get a more holistic view of the trend if we look at the line plot
tab. Most notably, we can see that SO2, NO2, and CO have a similar trend
in which the values for the 70s are extremely high and they converge to
a lower level as we approach the 21st century. We hypothesize that this
trend may be caused from the sheer lack of volume of data in the 70s
(Most likely), and also that the decreasing trend represents an adapting
mechanism for the counties after the policy enactment in 1970. PM10,
although collected from the mid-1980s, have a similar downward trend. On
the other hand, PM 2.5 generally stays constant throughout the years
except for an outlier in California. Ozone had a very unique trend in
which all states experience a dip in ozone levels in the 1980s. More
specifically, the levels fall from around 0.06 Parts per Million to less
than 0.04, going back up to 0.06 at the beginning of the 90s. After the
90s, we note a rather constant level of Ozone despite fluctuations in
year-by-year level.

## AQI Map & AQI Line Plot

In these tabs, we provide a similar set of maps and line graphs for AQI,
which is a more general and intuitive measure of pollution derived from
<<<<<<< HEAD
the pollutants we presented before.
=======
the pollutants we presented before. In the 1970s, where many of the
values were fluctuating, we see a wide range of colors in the map. We
see that amid mostly green(good) AQI levels, there are a mix of moderate
and unhealthy levels near urban areas. However, beginning from 1980, the
map turns almost completely yellow (moderate) and stays that way until
2021.

If we translate this trend to the AQI line plot, we can see that
similarly yet much less extremely than our previous plots, the AQI level
dips to the 50-60 range in the 1980s. One possible explanation is that
this is due to the influence of the Ozone plot, because Ozone is more
weighted when computing AQI. Reflecting how most pollutants converge to
a lower level after the 1990s, we can rationalize the fact that AQI
stabilizes to the moderate range (51-100).
>>>>>>> main

## Conclusion

Although the variance in the AQI levels are very small for all of the
states, we can also note that the ‘larger’ and ‘more urban’ states tend
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
individuals’ health data or the correlation with how ‘urban’ some
counties are.
