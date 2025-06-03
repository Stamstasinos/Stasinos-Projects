# Stasinos-Projects

This repository contains my academic work in R and Python, focused on my thesis research at the intersection of political economy and environmental policy. The project investigates how economic conditions, measured by GDP per capita and instrumented via ETS prices, affect eurosceptic voting patterns across European regions. It combines econometric modeling with extensive data engineering and visualization.

Overview
1. Thesis R Scripts
These scripts perform Instrumental Variable (IV) regressions to examine the causal impact of regional economic indicators on political attitudes.

iv_analysis_script.R
Main IV regression assessing the effect of GDP per capita on eurosceptic vote share, controlling for population density and including country fixed effects. ETS prices are used as an instrument for GDP.

iv_sector_q90_control.R
Sector-specific IV regressions using 90th percentile thresholds for exposure to:

Agriculture

Tourism

Mining

Vehicle manufacturing

Cooling technologies

GHG emissions
These interaction models explore how sectoral intensity modifies the economic-political relationship.

2. Thesis Python Notebooks
Support modules for data cleaning, transformation, visualization, and integration of regression results.

Building the Dataframe 1.ipynb
Initial dataset construction with socio-economic and political variables.

Building the Dataframe 2.ipynb
Advanced preprocessing, feature engineering, and harmonization of time-series data.

Latex Regressions.ipynb
Export of cleaned regression output to LaTeX for use in thesis writing.

MAPS.ipynb
Visual representation of regional patterns (e.g., GDP, vote share, emissions) using geographic data.

tables.ipynb
Descriptive statistics and comparative summaries across key variables.

Repository Contents
File/Notebook	Description
iv_analysis_script.R	Main effect IV regression with fixed effects
iv_sector_q90_control.R	Sectoral IV regressions using 90th percentile exposure
Building the Dataframe 1/2.ipynb	Data preparation and harmonization
Latex Regressions.ipynb	Exporting model output to LaTeX
MAPS.ipynb	Spatial visualizations of variables
tables.ipynb	Statistical summaries and LaTeX tables

Author
Stamatis Stasinos
Master’s Student in Economics and International Negotiations

Tools: R, Python, LaTeX

Research Interests: Euroscepticism, Political Economy, Climate Policy

Contact: LinkedIn
