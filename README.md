# ARIMA Model Estimation and Bootstrap Confidence Intervals

## Project Overview  
This project demonstrates how to bootstrap the residuals of an ARIMA(1,0,1) model to estimate 95% confidence intervals for the AR(1) and MA(1) coefficients. It compares the bootstrapped confidence intervals with the parametric intervals derived from the original ARMA(1,1) model, providing insights into model stability and estimation uncertainty.

## Dataset: Gas Furnace Dataset
The dataset contains two key variables:
- **Input gas rate:** The amount of gas input to the furnace, used as a predictor variable.
- **Output gas CO2 %:** The percentage of CO2 in the gas output, which is the response variable.

## Key Features  
- **Bootstrap resampling:** 500 bootstrap samples were drawn from the original regression residuals to estimate the variability of AR(1) and MA(1) coefficients.
- **ARIMA modeling:** The project uses `arima` (or equivalent functions) to fit ARIMA(1,0,1) models to each bootstrap sample.
- **Comparison of confidence intervals:** Both bootstrapped and parametric 95% confidence intervals for the AR(1) and MA(1) coefficients are computed and compared.

## Variables Used
- **Input gas rate**: The predictor variable that represents the amount of gas input into the furnace.
- **Output gas CO2 %**: The response variable, representing the percentage of CO2 in the furnace output.
- **Residuals**: The difference between the observed and predicted values from an initial ARIMA model.
- **AR(1) Coefficient**: The coefficient associated with the lag-1 autoregressive term in the ARIMA model.
- **MA(1) Coefficient**: The coefficient associated with the lag-1 moving average term in the ARIMA model.
- **Bootstrap Samples**: 500 resampled datasets generated from the residuals, used for re-estimating the ARIMA model.
- **Parametric Confidence Interval**: The interval calculated using the original ARIMA model's standard errors to estimate the uncertainty in the AR(1) and MA(1) coefficients.

## Installation  
To install the necessary dependencies, run the following command in R:  
```R
install.packages("forecast")
