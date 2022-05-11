Exploring Air Quality in the US since 1960
================
Furred Flies (Caleb Weiss, Eva Wu, Jimin Han)

## High-level goal

We have chosen to create an interactive and/or animated spatio-temporal
visualization on a topic of interest to us (we have not yet determined
whether our visualization will be interactive, animated, or both).

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
seven components which go into forming an Air Quality Index score
(including ) over the past 50 years, in order to form an accurate
picture of how air quality has changed throughout the United States
during that time.

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
    (Caleb). Edit codebook (Eva). Learn how to use Shiny (everyone).
    etc.

-   Week 2 (May 19-May 25): Construct visualization of data using Shiny
    (everyone). Consider adding layers depicting change in prevalence of
    potentially contributing factors to poor Air Quality over time
    (everyone).

-   Week 3 (May 26-June 1): Complete Write-Up and Presentation (using
    xaringen or Shiny) (everyone). Edit shiny README (Jimin). Rehearse
    Presentation (everyone).

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