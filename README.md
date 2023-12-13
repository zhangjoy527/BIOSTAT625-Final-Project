# Analysis of Diabetes Predictors
This is the repository for the BIOSTAT 625 final project.
## Background
Diabetes is a chronic disease that impacts 38 million adults in the United States, ranking as the eighth leading cause of death (CDC 2023). The data extracted from 2015 CDC Behavioral Risk Factor Surveillance System (BRFSS) survey dataset, an annual health-related telephone survey, from [Kaggle](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset). The survey gathered information on participants' health-related risk behaviors, chronic health conditions, and their engagement with preventative services. Within our balanced dataset, we have a Diabetes_binary variable denoting 1 for prediabetes or diabetes and 0 for the absence of diabetes.

## Overview

This repository encompasses the code and process for creating a dataset from the raw diabetes data stored in "diabetes_data_raw.csv." The primary objective is to categorize three variables of interest into 2 to 4 groups for more in-depth analysis. The entire data transformation process is detailed in the "Dataset Creation.R" script, resulting in the creation of the finalized dataset named "diabetes_data.csv."

Additionally, the "Exploratory Data Analysis.Rmd" file extends our analysis by processing our cleaned dataset, ensuring appropriate categorization of variables. It includes the generation of Table 1, which groups covariates by age, presenting the percentage distribution of each level among different age groups. The file also features stacked and percentage bar plots illustrating the association between the outcome variable (diabetes) and covariates, grouped by age. Some of these visualizations are incorporated into our final report.

## File Structure

- **`Dataset Creation.R`**: R script for transforming raw diabetes data into the final dataset.
- **`diabetes_data_raw.csv`**: Original raw data.
- **`diabetes_data.csv`**: Resulting dataset with categorized variables.
- **`Exploratory Data Analysis.Rmd`**: Explores cleaned data, verifies variable categorization, and generates Table 1 for covariate distribution by age. Features visualizations of diabetes-covariate association, informing the final report.

## Resources
CDC 2015 Data Codebook: https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf
