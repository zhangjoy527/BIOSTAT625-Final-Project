# Analysis of Diabetes Predictors
This is the repository for the BIOSTAT 625 final project.
## Background
Diabetes is a chronic disease that impacts 38 million adults in the United States, ranking as the eighth leading cause of death (CDC 2023). The data extracted from 2015 CDC Behavioral Risk Factor Surveillance System (BRFSS) survey dataset, an annual health-related telephone survey, from [Kaggle](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset). The survey gathered information on participants' health-related risk behaviors, chronic health conditions, and their engagement with preventative services. Within our balanced dataset, we have a Diabetes_binary variable denoting 1 for prediabetes or diabetes and 0 for the absence of diabetes.

## Overview

This repository covers the process of creating a dataset from "diabetes_data_raw.csv" with the goal of categorizing five variables for further analysis. The transformation is detailed in "Dataset Creation.R," resulting in the production of "diabetes_data.csv."

The subsequent "Exploratory Data Analysis.Rmd" file explores and verifies variable categorization, presenting Table 1 for covariate distribution by age and visualizations showing the diabetes-covariate association.

In "Model Building.Rmd," two models are fitted and compared through an LRT test, followed by multiple diagnostics, including VIF, goodness of fit tests, and various residual analyses to ensure model accuracy.

## File Structure

- **`diabetes_data_raw.csv`**: Original raw data.
- **`Dataset Creation.R`**: R script for transforming raw diabetes data into the final dataset, "diabetes_data.csv."
- **`diabetes_data.csv`**: Our finalized data.
- **`Exploratory Data Analysis.Rmd`**: Explores and verifies variable categorization, generates Table 1, and features visualizations.
- **`Model Building.Rmd`**: Builds and compares models, performs diagnostics, and evaluates model fitness.
- **`Final Paper.Rmd`**: Code for writing our report.

## Resources
CDC 2015 Data Codebook: https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf
