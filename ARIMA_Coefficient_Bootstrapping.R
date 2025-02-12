library(forecast)
library(tibble)

gas <- read.csv("gas.csv")

lin <- lm(Outlet.gas.CO2.percentage ~ Input.gas.rate, data = gas)

# Residual diagnostics
residuals_lm <- resid(lin)
plot(residuals_lm)
lines(range(0,300), range(0), col = "red" )
acf(residuals_lm)

# ARMA
arma_models <- list()

arma_models[["ARMA(1,0)"]] <- arima(residuals_lm, order = c(1, 0, 0))
arma_models[["ARMA(0,1)"]] <- arima(residuals_lm, order = c(0, 0, 1))
arma_models[["ARMA(1,1)"]] <- arima(residuals_lm, order = c(1, 0, 1))
arma_models[["ARMA(2,0)"]] <- arima(residuals_lm, order = c(2, 0, 0))
arma_models[["ARMA(0,2)"]] <- arima(residuals_lm, order = c(0, 0, 2))
arma_models[["ARMA(2,2)"]] <- arima(residuals_lm, order = c(2, 0, 2))

# Create residual plots
par(mfrow = c(3, 2))  # Arrange plots in a 3x2 grid
for (name in names(arma_models)) {
  res <- residuals(arma_models[[name]])
  plot(res, type = "l", main = paste("Residuals of", name), ylab = "Residuals", xlab = "Time")
}

# Create ACF plots for residuals
par(mfrow = c(3, 2))
for (name in names(arma_models)) {
  res <- residuals(arma_models[[name]])
  acf(res, main = paste("ACF of Residuals -", name))
}

results <- data.frame(Model = character(), AIC = numeric(), BIC = numeric(), 
                      DW_Statistic = numeric(), LB_p_value = numeric(), 
                      stringsAsFactors = FALSE)

for (name in names(arma_models)) {
  model <- arma_models[[name]]
  residuals <- residuals(model)
  
  dw_stat <- sum(diff(residuals)^2) / sum(residuals^2)
  
  lb_test <- Box.test(residuals, type = "Ljung-Box", lag = 10)
  
  # Store results
  results <- rbind(results, data.frame(
    Model = name,
    AIC = model$aic,
    BIC = BIC(model),
    DW_Statistic = dw_stat,
    LB_p_value = lb_test$p.value
  ))
}

print(results)

# Bootstrap
set.seed(13)
boot_samples <- bld.mbb.bootstrap(residuals_lm, num = 500)
bootstDf <- as.data.frame(boot_samples)
matplot(bootstDf, type="l")

ar1_estimates <- numeric(500)
ma1_estimates <- numeric(500)

for (i in 1:500) {
  # Fit ARIMA(1,0,1) model to each bootstrapped residual sample
  model <- arima(boot_samples[[i]], order = c(1, 0, 1))
  
  # Extract AR(1) and MA(1) coefficients
  ar1_estimates[i] <- model$coef["ar1"]
  ma1_estimates[i] <- model$coef["ma1"]
}

bootstrap_results <- tibble(AR1 = ar1_estimates, MA1 = ma1_estimates)
summary(bootstrap_results)

plot(bootstrap_results$AR1)

hist(bootstrap_results$AR1, main = "AR1 Coefficient Distribution", 
     xlab = "AR1 Estimate", col = "lightblue", border = "black", breaks = 30)

hist(bootstrap_results$MA1, main = "MA1 Coefficient Distribution", 
     xlab = "MA1 Estimate", col = "lightgreen", border = "black", breaks = 30)

par(mfrow=c(1,2))
plot(density(bootstrap_results$AR1), main = "AR1 Coefficient Density")
plot(density(bootstrap_results$MA1), main = "MA1 Coefficient Density")

# CI
boot_ci_ar1 <- quantile(ar1_estimates, probs = c(0.025, 0.975))
boot_ci_ma1 <- quantile(ma1_estimates, probs = c(0.025, 0.975))

boot_ci_ar1
boot_ci_ma1

se <- sqrt(diag(model_arma11$var.coef))

parametric_ar1_ci <- c(
  model_arma11$coef["ar1"] - 1.96 * se["ar1"],
  model_arma11$coef["ar1"] + 1.96 * se["ar1"]
)

parametric_ma1_ci <- c(
  model_arma11$coef["ma1"] - 1.96 * se["ma1"],
  model_arma11$coef["ma1"] + 1.96 * se["ma1"]
)

# Print results
parametric_ar1_ci
parametric_ma1_ci


