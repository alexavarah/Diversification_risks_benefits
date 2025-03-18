
# packages
library(dplyr)
library(tidyr)


all_alexa_data <- read.csv("../output/trade_offs_tidy.csv")
risk_summary <- read.csv("./summary_risk_per_BGseverity.csv")

BG_summary <- all_alexa_data %>%
  group_by(initDR) %>% # black grass severity
  summarise(gross_profit = mean(gp_pc_change),
            calories = mean(cal_pc_change),
            land_use = mean(land_use_pc_change),
            emissions = mean(c_pc_change))

risk_summary <- risk_summary %>% select(-c(min_perc_diff, max_perc_diff, X))
risk_summary_wide <- tidyr::pivot_wider(risk_summary %>% filter(!is.na(BG_severity)),
                                        names_from = taxon, 
                                        values_from = mean_perc_diff)

BG_summary <- as_tibble(cbind(BG_summary, risk_summary_wide[-1]))

max_abs_pc <- max(abs(BG_summary[-1]))
min_abs_pc <- 0

# normalise to get number that will scale size of arrows in summary table in paper
new_min <- 0.4
new_max <- 1.2
BG_summary_normalised <- (new_max - new_min)*(abs(BG_summary[-1]) - min_abs_pc) / (max_abs_pc - min_abs_pc) + new_min
BG_summary_normalised

write.csv(BG_summary_normalised, "normalised_summary_table.csv", row.names = F)
