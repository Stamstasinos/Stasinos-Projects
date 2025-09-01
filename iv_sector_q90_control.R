
data_q90_2014_2019_ctrl <- data %>%
  filter(year %in% c(2014, 2019)) %>%
  drop_na(gdp_per_capita, ETS_price,
          eurosceptic_vote_share_2014,
          agri_above_q90, tourists_above_q90, mining_above_q90,
          vehicles_above_q90, cooling_above_q90)
iv_agri_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita +
    agri_above_q90 +
    I(gdp_per_capita * agri_above_q90) 
     |
    ETS_price +
    agri_above_q90 +
    I(ETS_price * agri_above_q90),
  data = data_q90_2014_2019_ctrl
)

iv_tour_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita +
    tourists_above_q90 +
    I(gdp_per_capita * tourists_above_q90) 
     |
    ETS_price +
    tourists_above_q90 +
    I(ETS_price * tourists_above_q90),
  data = data_q90_2014_2019_ctrl
)

iv_mine_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita +
    mining_above_q90 +
    I(gdp_per_capita * mining_above_q90)
     |
    ETS_price +
    mining_above_q90 +
    I(ETS_price * mining_above_q90),
  data = data_q90_2014_2019_ctrl
)

iv_veh_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita +
    vehicles_above_q90 +
    I(gdp_per_capita * vehicles_above_q90) 
     |
    ETS_price + 
    vehicles_above_q90 +
    I(ETS_price * vehicles_above_q90),
  data = data_q90_2014_2019_ctrl
)

iv_cool_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita + 
    cooling_above_q90 +
    I(gdp_per_capita * cooling_above_q90)
     |
    ETS_price +
    cooling_above_q90 +
    I(ETS_price * cooling_above_q90),
  data = data_q90_2014_2019_ctrl
)

iv_ghg_q90_ctrl <- ivreg(
  eurosceptic_vote_share ~ gdp_per_capita + ghg_above_q90 +
    I(gdp_per_capita * ghg_above_q90) |
    ETS_price + ghg_above_q90 +
    I(ETS_price * ghg_above_q90),
  data = data_q90_2014_2019_ctrl
)
models_q90_ctrl <- list(iv_agri_q90_ctrl, iv_tour_q90_ctrl,
                        iv_mine_q90_ctrl, iv_veh_q90_ctrl, iv_cool_q90_ctrl, iv_ghg_q90_ctrl)
stargazer(models_q90_ctrl,
          type = "text",
          title = "IV Regressions by Sector (90th Percentile)",
          column.labels = c("Agriculture", "Tourism", "Mining", "Vehicles", "Cooling", "GHG Emissions"),
          dep.var.labels = "Euroscepticism Vote Share",
          omit.stat = c("f", "ser"),
          digits = 4,
          out = "iv_sector_90_control.html")
