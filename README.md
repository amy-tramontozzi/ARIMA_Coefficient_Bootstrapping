# ARIMA Model Estimation and Bootstrap Confidence Intervals

# ARIMA Model Estimation and Bootstrap Confidence Intervals

## Project Overview  
This project demonstrates how to bootstrap the residuals of an ARIMA(1,0,1) model to estimate 95% confidence intervals for the AR(1) and MA(1) coefficients. It compares the bootstrapped confidence intervals with the parametric intervals derived from the original ARMA(1,1) model, providing insights into model stability and estimation uncertainty.

## Key Features  
- **Bootstrap resampling:** 500 bootstrap samples were drawn from the original regression residuals to estimate the variability of AR(1) and MA(1) coefficients.
- **ARIMA modeling:** The project uses `arima` (or equivalent functions) to fit ARIMA(1,0,1) models to each bootstrap sample.
- **Comparison of confidence intervals:** Both bootstrapped and parametric 95% confidence intervals for the AR(1) and MA(1) coefficients are computed and compared.

## Installation  
To install the necessary dependencies, run the following command in R:  
```R
install.packages(c("forecast", "tibble", "car"))
