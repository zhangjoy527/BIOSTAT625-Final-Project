# Analysis of Diabetes Predictors

Welcome to the repository for the BIOSTAT 625 final project.

## Background
Diabetes, a chronic disease affecting 38 million adults in the United States, ranks as the eighth leading cause of death (CDC 2023). Our dataset is derived from the 2015 CDC Behavioral Risk Factor Surveillance System (BRFSS) survey, an annual health-related telephone survey. The data, available on [Kaggle](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset), captures participants' health-related behaviors, chronic conditions, and engagement with preventative services. In our balanced dataset, the variable Diabetes_binary denotes 1 for prediabetes or diabetes and 0 for the absence of diabetes.

## Overview
This repository outlines the process of creating the "diabetes_data.csv" dataset from "diabetes_data_raw.csv," categorizing five variables for analysis using "Dataset Creation.R." The subsequent "Exploratory Data Analysis.Rmd" performs variable categorization, showing age-based covariate distribution (Table 1) and visualizations illustrating diabetes-covariate associations.

"Model Building.Rmd" fits and compares models, conducting model diagnostics for model accuracy. Additionally, "625_app/app.R" features an R Shiny website summarizing our work.

## File Structure
- **`diabetes_data_raw.csv`**: Original raw data.
- **`Dataset Creation.R`**: R script for transforming raw diabetes data into the final dataset, "diabetes_data.csv."
- **`diabetes_data.csv`**: Finalized dataset.
- **`Exploratory Data Analysis.Rmd`**: Explores and verifies variable categorization, generates Table 1, and features visualizations.
- **`Model Building.Rmd`**: Builds and compares models, performs diagnostics, and evaluates model fitness.
- **`Final Paper.Rmd`**: Code for writing our report.
- **`625_app/app.R`**: Code for our R Shiny website.

## Contributors
- Yeseul Ha (yeseulha@umich.edu)
- Joy Zhang (zhangjoy@umich.edu)
- Jingyu Zhao (jingyzh@umich.edu)

## Resources
- CDC 2015 Data Codebook: [Codebook Link](https://www.cdc.gov/brfss/annual_data/2015/pdf/codebook15_llcp.pdf)
