Exploring Air Quality in the US since 1971
================
Furred Flies (Caleb Weis, Eva Wu, Jimin Han)

## High-level goal

We have chosen to create an interactive and/or animated spatio-temporal
visualization on a topic of interest to us (we have not yet determined
whether our visualization will be interactive, animated, or both).

## Loading Dataset

| state_code | county_code | site_number | parameter_code | poc | latitude | longitude | datum | parameter | sample_duration         | sample_duration_code | sample_duration_type | pollutant_standard | year | quarter | units_of_measure  | event_type | observation_count | observation_percent | arithmetic_mean | minimum_value | maximum_value | quarterly_criteria_met | actual_days_gt_std | estimated_days_gt_std | valid_samples | valid_day_count | scheduled_samples | percent_days | percent_one_value | monitoring_agency_code | monitoring_agency                               | local_site_name | address                   | state      | county    | city   | tribal_code | tribal_land | cbsa_code | cbsa                   | date_of_last_change |
|:-----------|:------------|:------------|:---------------|----:|---------:|----------:|:------|:----------|:------------------------|:---------------------|:---------------------|:-------------------|-----:|:--------|:------------------|:-----------|------------------:|:--------------------|----------------:|:--------------|:--------------|:-----------------------|-------------------:|:----------------------|:--------------|:----------------|:------------------|-------------:|:------------------|:-----------------------|:------------------------------------------------|:----------------|:--------------------------|:-----------|:----------|:-------|:------------|:------------|:----------|:-----------------------|:--------------------|
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 8-HR RUN AVG BEGIN HOUR | W                    | C                    | Ozone 8-hour 2015  | 2011 | 4       | Parts per million | No Events  |              1540 | 98.0                |          0.0362 | 0.014         | 0.071         | Y                      |                  2 | NA                    | 89.0          | 89.0            | 1564.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 8-HR RUN AVG BEGIN HOUR | W                    | C                    | Ozone 8-Hour 2008  | 2011 | 4       | Parts per million | No Events  |              2164 | 98.0                |          0.0358 | 0.014         | 0.071         | Y                      |                  0 | NA                    | 88.0          | 88.0            | 2208.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 8-HR RUN AVG BEGIN HOUR | W                    | C                    | Ozone 8-Hour 1997  | 2011 | 4       | Parts per million | No Events  |              2164 | 98.0                |          0.0358 | 0.014         | 0.071         | Y                      |                  0 | NA                    | 88.0          | 88.0            | 2208.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 1 HOUR                  | 1                    | O                    | Ozone 1-hour 1979  | 2011 | 4       | Parts per million | No Events  |              2089 | 95.0                |          0.0363 | 0.017         | 0.078         | Y                      |                  0 | NA                    | 90.0          | 90.0            | 2208.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 8-HR RUN AVG BEGIN HOUR | W                    | C                    | Ozone 8-hour 2015  | 2011 | 3       | Parts per million | No Events  |              1516 | 97.0                |          0.0447 | 0.043         | 0.09          | Y                      |                 69 | NA                    | 88.0          | 88.0            | 1564.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |
| 06         | 073         | 1006        | 44201          |   1 | 32.84232 | -116.7683 | NAD83 | Ozone     | 8-HR RUN AVG BEGIN HOUR | W                    | C                    | Ozone 8-Hour 2008  | 2011 | 3       | Parts per million | No Events  |              2119 | 96.0                |          0.0432 | 0.043         | 0.09          | Y                      |                 32 | NA                    | 86.0          | 86.0            | 2208.0            |           NA | 100.0             | 0942                   | San Diego County Air Pollution Control District | Alpine          | 2300 VICTORIA DR., ALPINE | California | San Diego | Alpine | NA          | NA          | 41740     | San Diego-Carlsbad, CA | 2021-11-27          |

## Description of our goals

Our goal for this project is to explore the change in air quality over
time in the United States. We chose this question because air quality is
very important for people’s health and reflects a country’s social and
industrial trends over time. In order to do this, we will primarily rely
upon data from the US EPA Air Quality System API, called RAQSAPI and
developed by Clinton Mccrowey, a Physical Scientist with the US EPA.
This is a very complex API with concentration data on over 25 different
air pollutants, on the county, state, Core Based Statistical Area, air
monitoring site, primary quality assurance organization, and monitoring
agency levels (the latter three are simply different administrative
bodies which collect/oversee air quality data; the third is a
geographical unit defined by the US Census Bureau), which includes
annual, quarterly, and daily summaries stretching back until the early
1960s. We will use county-level quarterly data from each state on the
six components which go into forming an Air Quality Index score
(including Ozone, PM2.5, PM10, CO, SO2, and NO2) over the past 50 years,
in order to form an accurate picture of how air quality has changed
throughout the United States during that time. Each dataset has 42
columns, but we will subset our datasets accordingly to include only the
variables we want. The number of rows all vary depending on the time
range and the state, but generally it’s in the 50.000 - 100,000 range.

Our primary goal is to then use this data in order to construct an
interactive and/or animated map of Air Quality in the United States over
time. We hope to construct such a map using Shiny, and plan to certainly
include a contour map and/or gradient color scale depicting Air Quality
scores throughout that time. In addition, depending on how much time we
have, we would like to add layers to this map for the individual
components which go into forming an Air Quality Index score and perhaps
even components which could have contributed to higher levels of air
pollution, such as forest fires over time or the construction of
industrial facilities. However, we would like to reiterate that our
primary goal is to map air quality in the US over time, and that we are
not sure if we will have time to include those potentially correlated
factors.

## Weekly Plan of Attack:

-   Week 1 (May 12-May 18): Load all necessary data (Caleb). Wrangle
    data into desired structure and calculate AQI Scores from data
    (Caleb). Create README files (Jimin). Edit codebook (Eva). Learn how
    to use Shiny (everyone).

-   Week 2 (May 19-May 25): Construct visualization of data using Shiny
    (everyone). Consider adding layers depicting change in prevalence of
    potentially contributing factors to poor Air Quality over time
    (everyone).

-   Week 3 (May 26-June 1): Complete Write-Up and Presentation (using
    xaringen or Shiny) (everyone). Rehearse Presentation (everyone).

## Repo organization

-   Proposal folder. This folder includes the RMarkDown and knitted
    MarkDown documents which contain the information in this proposal.

-   Data folder. This folder contains RMarkDown documents used to load,
    examine, and wrangle data from the RAQSAPI and to load data from
    other sources, and csvs of data loaded from other sources.

-   Shiny folder. This folder contains Shiny documents used to construct
    our data visualization. (We have yet to learn how to use Shiny, so
    some other documents may be included in this folder as well.)

-   We have a README.Rmd and README.md file for each folder. These files
    explain the structure of the repository. The README files in the
    main directory will include our write-up.
