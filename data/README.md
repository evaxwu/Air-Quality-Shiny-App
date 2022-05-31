Data Description
================

This is the README document explaining the data that we will use for
this project. The [data-cleaning-prep.Rmd](data-cleaning-prep.Rmd) file
outlines the code we used to obtain and clean the data.

Our data is from the US EPA Air Quality System API, called RAQSAPI and
developed by Clinton Mccrowey, a Physical Scientist with the US EPA.
This is a very complex API with concentration data on over 25 different
air pollutants, on the county, state, Core Based Statistical Area, air
monitoring site, primary quality assurance organization, and monitoring
agency levels (the latter three are simply different administrative
bodies which collect/oversee air quality data; the third is a
geographical unit defined by the US Census Bureau), which includes
annual, quarterly, and daily summaries stretching back until the early
1960s.

What this API does is provide a multitude of functions that can be used
to generate data frames (tibbles) of the available data, and a few
functions which also list the pollutants, states, which include data on
the pollutants, Core Based Statistical Areas, air monitoring sites,
primary quality assurance organizations, and monitoring agencies
available in the dataset.

In order to use this API, one must first register their email at
<https://aqs.epa.gov/data/api/signup?email=myemail@example.com>, but
replacing “<myemail@example.com>” with their email. Then, they must
simply follow the instructions at
<file:///Library/Frameworks/R.framework/Versions/4.1/Resources/library/RAQSAPI/doc/RAQSAPIvignette.html>.

We have chosen to use data spanning the past 50 years for all 50 US
states and Washington, DC, at the county-level, and to include the
necessary variables in our data to calculate Air Quality Indices for
each quarter (3-month period) within those 50 years. In order to
generate our data, we used the function
`aqs_quarterlysummary_by_state()`, defining the “parameter,” “bdate”
(begin date), “edate” (end date), and “state_FIPS” (state FIPS code)
variables.

The following is a snippet of the data:

    ## Rows: 23336 Columns: 10
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (7): state, county, county_code, state_code, pollutant, units_of_measure...
    ## dbl (3): year, AQI, arithmetic_mean
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

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
