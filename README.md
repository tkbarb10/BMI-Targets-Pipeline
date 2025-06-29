# ADS503-Project

This repository contains an R-based workflow for the ADS503 BMI Challenge. It ingests National Health Interview Survey (NHIS) data and linked mortality files from the CDC, preprocesses the data and fits a variety of machine learning models. The project uses the [targets](https://github.com/ropensci/targets) package with the [crew](https://github.com/wlandau/crew) backend to ensure reproducible pipelines.

## Goal

BMI is not a great predictor of health outcomes and carries a lot of social stigma, so the goal of this project is to create a better model to understand ones risk for certain health outcomes using easily accessible data

# Requirements and Environment

## Basics

-   R (version 4.0 or later)
-   Packages listed in `_targets.R`: `targets`, `crew`, `tidyverse`, `arrow`, `SAScii`, `VIM`, `caret`, `pROC`, `earth`

## Fully reproduce

-   All package dependencies and versions are recorded and managed with [renv](https://rstudio.github.io/renv/)
-   To restore the exact environment used for this analysis:

``` r
install.packages("renv")
renv::restore()
```

-   See sessionInfo.txt for details of the analysis environment.

# Running the pipeline

Clone the repository and execute the workflow from the project root:

``` bash
git clone <repo-url>
cd ADS503-NHIS-BMI-Project
Rscript -e "targets::tar_make()"
```

Downloading the NHIS data directly from the CDC can take awhile, so the first run of the pipeline uses the raw_data in the repository, links it with the mortality data, then processes the data and trains models. All data is publicly available. Subsequent runs reuse the stored results. The specific code for downloading NHIS data directly from the CDC can be found in the ingest directory.

You can run individual stages by specifying target names, for example:

``` r
library(targets)
# only train BMI-only models
tar_make(names = "solo_bmi")
```

Results can be loaded back into R with `tar_read()`:

``` r
library(targets)
model_df <- tar_read(modeling_df)
```

For a full tutorial of how the `targets` package works, visit this link [targets](https://books.ropensci.org/targets/)

## Viewing the pipeline

Visualize the workflow with:

``` r
library(targets)  
tar_visnetwork()
```

This command launches an interactive network graph showing all targets defined in `_targets.R`.

For a higher level view of the important parts

``` r
tar_glimpse()
```

For a table view with more details

``` r
tar_manifest()
```

## Pipeline overview

The main stages declared in `_targets.R` (and implemented under `R/target_parts/`) are:

1.  **ingest_nhis_data** – download and filter NHIS survey data.
2.  **process_mortality_data** – download mortality files and tidy them.
3.  **link_mort_data** – link survey records with mortality data.
4.  **secondary_pre_process** – combine columns with differing names across years.
5.  **cont_var_plots** – produce exploratory plots of numeric predictors.
6.  **missing_value_imputation** – impute missing values using custom rules and hot-deck methods.
7.  **modeling_preparation** – final cleaning and conversion of variables to factors.
8.  **solo_bmi** – fit baseline models using BMI alone.
9.  **initial_evaluation** – train and evaluate a set of baseline models.
10. **hyperparameter_tuning** – perform cross-validated tuning for several algorithms..

All scripts used in the pipeline are found in the R directory

# Dataset/Variable information

-   NHIS data is sourced from the [CDC](https://www.cdc.gov/nchs/nhis/documentation/index.html) and linked to the mortality [data](https://www.cdc.gov/nchs/data-linkage/mortality.htm)
-   Depending on year, there are anywhere from 500 to 700+ total variables in the publicly available datasets. Descriptions and notes of the ones we chose are found in the variables folder
-   Survey descriptions, linked mortality data information, and variable codes and summaries from a few of the years can be found in the documents directory
-   Full set of variables used for first round of modeling (and subsequently filtered) can be found in `R/ingest_data/variables_to_use.R`. These can be adjust to your liking

## References

Landau, W. (2025). The {targets} R package user manual. Eli Lilly and Company. <https://books.ropensci.org/targets/>

National Center for Health Statistics. (2000–2018). National Health Interview Survey (NHIS): Documentation. Centers for Disease Control and Prevention. <https://www.cdc.gov/nchs/nhis/documentation/index.html>

National Center for Health Statistics. (2000-2018). Linked Mortality Files. Centers for Disease Control and Prevention. <https://www.cdc.gov/nchs/data-linkage/mortality.htm>
