# load measurement files

library(tidyverse)
library(readxl)
library(janitor)

experiments.dir <- file.path(data.raw.dir, "experiments")
experiments.file.pattern <- "(.*/)?([0-9]{8})_([[:alpha:]]+)_([[:alnum:]]+).xlsx"

collect_experiment_files <- function(path = NULL, pattern = NULL ) {
  # browser()
  if (is.null(path)) {
    path <- experiments.dir
  }
  
  if (is.null(pattern)) {
    pattern <-experiments.file.pattern
  }
  
  return(
    list.files(
      path, pattern, full.names = TRUE
    )
  )
}

#' Load bench_design measurements
read_experiment_file <- function(path, pattern = NULL) {
  # browser()
  if (is.null(pattern)) {
    pattern <- experiments.file.pattern
  }
  
  # extract experiment date from path
  experiment.date <- sub(pattern, "\\2", path)
  
  # extract file name without extension from file path
  experiment.id <- str_split(path, "/") %>% 
    last() %>% 
    last() %>% 
    str_split("\\.") %>% 
    first() %>% 
    first()
  
  # read all sheets from excel
  result <- path %>% 
    excel_sheets() %>% 
    set_names() %>% 
    map(read_excel, path = path) %>% 
    enframe() %>% 
    mutate(
      experiment_date = experiment.date,
      experiment_id = experiment.id
    )
    
  
  return(result)
}


#' Generate ready-to-go measurements table
load_experiments <- function(data.files = NULL, path = NULL, pattern = NULL) {
  # browser()
  if (is.null(data.files)) {
    data.files <- collect_experiment_files(path = path, pattern = pattern)
  }
  
  results <- map_dfr(
    data.files, read_experiment_file
  )
  
  return(results)
}



load_spectrophotometer <- function(...){
  
  df.experiments.raw <- load_experiments()
  
  results <- df.experiments.raw %>% 
    filter(name == "OD 730 nm Spectrophotometer") %>% 
    unnest(value) %>% 
    clean_names() %>% 
    pivot_longer(cols = starts_with("T"), 
                 values_to = "OD_730", 
                 names_to = "timepoint") %>% 
    mutate(
      time = as.numeric(str_remove_all(timepoint, "[[:alpha:]]")),
      time_h = ifelse(time == 24,
                      time,
                      time / 60)
    ) %>% 
    separate(sample, into = c("strain", "induction"), sep = " ") %>% 
    select(-c(name, timepoint, time))
  return(results)
}


load_plate_reader_od <- function(...){
  # browser()
  df.experiments.raw <- load_experiments()
  
  results <- df.experiments.raw %>% 
    filter(name == "OD Plate Reader") %>% 
    unnest(value) %>% 
    clean_names() %>% 
    pivot_longer(cols = t0:t24h, 
                 values_to = "OD_730", 
                 names_to = "timepoint") %>% 
    mutate(
      time = as.numeric(str_remove_all(timepoint, "[[:alpha:]]")),
      time_h = ifelse(time == 24,
                      time,
                      time / 60)
    ) %>% 
    separate(sample, into = c("strain", "induction"), sep = " ") %>% 
    mutate(
      sample_type = ifelse(strain == "Blank", "blank", "sample")
    ) %>% 
    select(-c(name, timepoint, time))
  return(results)
}


load_plate_reader_fl <- function(...){
  # browser()
  df.experiments.raw <- load_experiments()
  
  results <- df.experiments.raw %>% 
    filter(name == "Fluorescence Plate Reader") %>% 
    unnest(value) %>% 
    clean_names() %>% 
    pivot_longer(cols = t0:t24h, 
                 values_to = "fl", 
                 names_to = "timepoint") %>% 
    mutate(
      time = as.numeric(str_remove_all(timepoint, "[[:alpha:]]")),
      time_h = ifelse(time == 24,
                      time,
                      time / 60)
    ) %>% 
    separate(sample, into = c("strain", "induction"), sep = " ") %>% 
    mutate(
      sample_type = ifelse(strain == "Blank", "blank", "sample")
    ) %>% 
    select(-c(name, timepoint, time))
  
  return(results)
}


load_full_spectrum <- function(...){
  # browser()
  df.experiments.raw <- load_experiments()
  
  results <- df.experiments.raw %>% 
    filter(name == "Spectrum Spectrophotometer") %>% 
    unnest(value) %>% 
    # clean_names() %>% 
    pivot_longer(cols = EVC_0:`petE_24h +`, 
                 values_to = "abs", 
                 names_to = "id") %>% 
    separate(id, into = c("strain", "id"), sep = "_") %>% 
    separate(id, into = c("timepoint", "induction"), sep = " ") %>% 
    # View()
    mutate(
      time = as.numeric(str_remove_all(timepoint, "[[:alpha:]]")),
      time_h = ifelse(time == 24,
                      time,
                      time / 60)
    ) %>% 
    separate(experiment_id, into = c("dummy1", "location", "dummy2"), sep = "_", remove = F) %>% 
    select(-c(name, timepoint, time, dummy1, dummy2)) 
  
  return(results)
  
}