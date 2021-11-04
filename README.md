# Cyano Interlab study

This a repository to analyze the data from the Cyano Interlab study.

## Project directory structure:

The project contains the following directories:

```
project
│   README.md
│   settings.R   
│
└───data
│   │
│   └───raw
│   │   │   experiments.R
│   │   └── experiments
│   │       │
│   │       │  YYYYMMDD_location_runlabel.xlsx
│   │       │  ...
│   │
│   └───processed
│
└───reports
    │   
    └───bench_spectrophotometer
    │
    │
    └───plate_reader
    │
    │
    └───test_run_analysis
```

### Data files

The raw data files of each experiment run and location are stored in `data/raw/experiments`. 

### Loading data

To read and process each raw data file, the file `data/raw/experiments.R` must be sourced from the Rmarkdown/script file where data is analyzed. This file (`experiments.R`) contains dedicated functions to extract and label the different data sources (plate reader, spectrophotometer OD and full spectrum) from the sheets of the raw excel files.

To read all the data, execute the following code:

```
library(tidyverse)

# load project settings
source(here::here("settings.R"))
# load functions
source(file.path(data.raw.dir, "experiments.R"))

df.pr.od.raw <- load_plate_reader_od()

df.pr.fl.raw <- load_plate_reader_fl()

df.spectrophotometer <- load_spectrophotometer() 

df.full.spectrum.raw <- load_full_spectrum()
```

Note: the `settings.R` file contains the paths to all the directories in the project as well as some axes labels for plotting.


## Reports

The `reports` folder contains Rmarkdown files to process, normalize and visualize the data.



