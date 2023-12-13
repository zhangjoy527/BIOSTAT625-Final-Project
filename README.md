# Analysis of Diabetes Predictors
This is the repository for the BIOSTAT 625 final project.
## Background
Diabetes is a chronic disease that impacts 38 million adults in the United States, ranking as the eighth leading cause of death (CDC 2023). The data extracted from 2015 CDC Behavioral Risk Factor Surveillance System (BRFSS) survey dataset, an annual health-related telephone survey, from [Kaggle](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset). The survey gathered information on participants' health-related risk behaviors, chronic health conditions, and their engagement with preventative services. Within our balanced dataset, we have a Diabetes_binary variable denoting 1 for prediabetes or diabetes and 0 for the absence of diabetes.

## Overview
This repository contains the code and process for creating a dataset from raw diabetes data stored in "diabetes_data_raw.csv". The goal is to categorize three variables of interest into 2 to 4 groups for further analysis. The coding process is documented in the "Dataset Creation.R" script, and the resulting dataset is saved as "diabetes_data.csv".

## File Structure

- **`Dataset Creation.R`**: R script for transforming raw diabetes data into the final dataset.
- **`diabetes_data_raw.csv`**: Original raw data.
- **`diabetes_data.csv`**: Resulting dataset with categorized variables.

## Resources
CDC 2015 Data Codebook: https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf
