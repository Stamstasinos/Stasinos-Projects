
library(readxl)
library(AER)
library(stargazer)
library(dplyr)
library(ggplot2)

# Load the full dataset
data <- read_excel("HERE_CONTROL.xlsx")

# Convert relevant columns to numeric
data$gdp_per_capita <- as.numeric(data$gdp_per_capita)
data$eurosceptic_vote_share <- as.numeric(data$eurosceptic_vote_share)
data$ETS_price <- as.numeric(data$ETS_price)
data$euroscepticism_change <- as.numeric(data$euroscepticism_change)

data_2014_2019 <- data %>%
  filter(year %in% c(2014, 2019)) %>%
  drop_na(gdp_per_capita, ETS_price, eurosceptic_vote_share,
          agri_above_q90, tourists_above_q90, mining_above_q90,
          vehicles_above_q90, cooling_above_q90, pop_density,
          IT, FR, ES, BE, NL, SE, FI, PL, PT, EL, CZ, SK, HU, AT,
          RO, BG, LT, LV, EE, HR, SI, IE, MT, CY, LU)

data_2014_2019 <- na.omit(data_2014_2019[, c("gdp_per_capita", "ETS_price", "eurosceptic_vote_share")])

# Predicted vote share from IV model
data_2014_2019$fitted <- fitted(model_)
data_2014_2019$iv_fitted <- data_2014_2019$fitted

ggplot(data_2014_2019, aes(x = gdp_per_capita, y = eurosceptic_vote_share)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = 'Impact of GDP (Instrumented by ETS) on Euroscepticism: Actual vs. Predicted',
       x = "GDP per capita",
       y = "Eurosceptic Vote Share")

ggsave("iv_euroscepticism_plot.png", width = 8, height = 6, dpi = 300)

summary(model_fe, diagnostics = TRUE)

model_fe <- ivreg(
  as.formula(paste(
    "eurosceptic_vote_share ~ gdp_per_capita + pop_density +", fe_formula, "|",
    "ETS_price + pop_density +", fe_formula
  )),
  data = data_2014_2019
)
model_fe$call <- quote(ivreg(eurosceptic_vote_share ~ gdp_per_capita + pop_density))

# Export model results to LaTeX
stargazer(model_fe,
          type = "latex",
          title = "IV Regression: Main Effects with Country Fixed Effects",
          column.labels = c("Main Effect"),
          model.names = FALSE,
          dep.var.caption = "",
          dep.var.labels = "",
          omit = paste(fe_vars, collapse = "|"),
          omit.stat = c("f", "ser"),
          add.lines = list(c("Country FE", "Yes")),
          digits = 4,
          out = "iv_sector_main_clean.html")

data_2014_2019$eurosceptic_hat <- fitted(model_fe)
data_2014_2019$residuals <- resid(model_fe)

# Extract country code from NUTS2 region
data_2014_2019$country <- substr(data_2014_2019$group_id, 1, 2)

# Identify top 5 residual outliers
top_outliers <- data_2014_2019 %>%
  mutate(abs_resid = abs(residuals)) %>%
  top_n(5, abs_resid)

# Plot
iv_plot <- ggplot(data_2014_2019, aes(x = gdp_per_capita, y = eurosceptic_vote_share, color = country)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue", show.legend = FALSE) +
  geom_text(data = top_outliers,
            aes(label = group_id),
            vjust = -1,
            size = 3,
            color = "black") +
  labs(title = "Impact of GDP (Instrumented by ETS) on Euroscepticism",
       subtitle = "Colored by country, with confidence band and labeled outliers",
       x = "GDP per capita",
       y = "Eurosceptic Vote Share",
       color = "Country") +
  theme_minimal()

ggsave("iv_gdp_plot.png", plot = iv_plot, width = 10, height = 7, dpi = 300)

iv_plot <- ggplot(data_2014_2019, aes(x = gdp_per_capita, y = eurosceptic_vote_share, color = country)) +
  geom_point(alpha = 0.7, size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue", linewidth = 1.2) +
  geom_text(data = top_outliers,
            aes(label = group_id),
            vjust = -1,
            size = 3.2,
            color = "black",
            fontface = "italic") +
  scale_color_viridis_d(option = "C", begin = 0.2, end = 0.9) +
  labs(title = "Impact of Instrumented GDP on Euroscepticism (IV Estimation)",
       subtitle = "Fitted second-stage relationship with 95% confidence interval",
       caption = "Instrument: ETS Price | Dots colored by NUTS0 region | Outliers labeled by region code",
       x = "GDP per Capita (EUR)",
       y = "Eurosceptic Vote Share (%)",
       color = "Country") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "bottom",
        panel.grid.minor = element_blank())

ggsave("iv_gdp_euroscepticism_plot.pdf", plot = iv_plot, width = 10, height = 7)

fe_vars <- c("IT", "FR", "ES", "BE", "NL", "SE", "FI", "PL", "PT", "EL", "CZ",
             "SK", "HU", "AT", "RO", "BG", "LT", "LV", "EE", "HR", "MT", "CY", "LU")
fe_formula <- paste(fe_vars, collapse = " + ")

model_fe <- ivreg(
  as.formula(paste(
    "eurosceptic_vote_share ~ gdp_per_capita + pop_density +", fe_formula, "|",
    "ETS_price + pop_density +", fe_formula
  )),
  data = data_2014_2019
)
