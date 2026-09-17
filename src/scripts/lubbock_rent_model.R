# ============================================================
# Lubbock Apartment Rent — Hedonic Pricing Analysis
# Replication script for: LBB_Apartment_Rent_Paper_second_edition
# ============================================================

# ── 0. Packages ──────────────────────────────────────────────
# install.packages(c("tidyverse", "olsrr", "car", "nortest"))
library(tidyverse)
library(olsrr)   # ols_pred_rsq()
library(car)     # vif()

# ── 1. Load data ─────────────────────────────────────────────
df_raw <- read_csv("LBB_Aparts.csv")

# ── 2. Cleaning ───────────────────────────────────────────────
# 2a. Drop geometry column (mimics sf::st_drop_geometry)
df <- df_raw %>% select(-geometry)

# 2b. Remove 5 observations with missing SQ_FEET
df <- df %>% filter(!is.na(SQ_FEET))

# 2c. Remove 3 extreme SQ_FEET outliers (4810, 5109, 9251 sq ft w/ low rents)
df <- df %>%
  filter(!SQ_FEET %in% c(4810, 5109, 9251))

cat("Final analytic sample: N =", nrow(df), "\n")   # should be 318

# ── 3. Descriptive Statistics (Table 1) ───────────────────────
vars <- c("PRICE", "BEDS", "SQ_FEET", "MedHHInc", "Dist_TTU")

desc_stats <- df %>%
  select(all_of(vars)) %>%
  summarise(across(everything(),
                   list(Mean = mean, SD = sd, Min = min, Max = max, n = length),
                   .names = "{.col}__{.fn}")) %>%
  pivot_longer(everything(), names_to = c("Variable", "Stat"), names_sep = "__") %>%
  pivot_wider(names_from = Stat, values_from = value)

cat("\n--- Table 1: Descriptive Statistics ---\n")
print(desc_stats, n = Inf)

# ── 4. Bivariate Correlations ─────────────────────────────────
cat("\n--- Bivariate correlations with PRICE ---\n")
cor_vars <- c("PRICE", "BEDS", "SQ_FEET", "MedHHInc", "Dist_TTU", "MedAge")
cor_matrix <- cor(df[, cor_vars], use = "complete.obs")
print(round(cor_matrix["PRICE", ], 2))

cat("\nCorrelation MedHHInc ~ Dist_TTU:",
    round(cor(df$MedHHInc, df$Dist_TTU), 2), "\n")

# ── 5. OLS Regression Model ───────────────────────────────────
model <- lm(PRICE ~ BEDS + SQ_FEET + MedHHInc, data = df)

cat("\n--- Table 2: OLS Regression Results ---\n")
summary(model)

# ── 6. Model Diagnostics ──────────────────────────────────────

# 6a. Variance Inflation Factors
cat("\n--- VIFs ---\n")
print(vif(model))

# 6b. Homoscedasticity check
abs_resid  <- abs(residuals(model))
fitted_val <- fitted(model)
cat("\nCorrelation |residuals| ~ fitted:", round(cor(abs_resid, fitted_val), 2), "\n")

# 6c. Shapiro-Wilk normality test on residuals
sw <- shapiro.test(residuals(model))
cat("\nShapiro-Wilk: W =", round(sw$statistic, 2), ", p =", sw$p.value, "\n")

# 6d. Predicted R² (olsrr)
cat("\nPredicted R²:", round(ols_pred_rsq(model), 3), "\n")

# ── 7. Figure 1 — Actual vs Predicted, colored by BEDS ────────
# Palette to match the paper's plot (discrete bedroom categories)
# Typical ggplot2 default hue palette for 0–4 beds:
#   0 = #F8766D (coral-red), 1 = #A3A500 (yellow-green),
#   2 = #00BF7D (teal-green), 3 = #00B0F6 (sky-blue), 4 = #E76BF3 (violet)

plot_df <- df %>%
  mutate(Predicted = fitted(model),
         BEDS_f = factor(BEDS))

fig1 <- ggplot(plot_df, aes(x = Predicted, y = PRICE, color = BEDS_f)) +
  geom_point(alpha = 0.70, size = 2.2) +
  geom_abline(slope = 1, intercept = 0,
              linetype = "dashed", color = "black", linewidth = 0.8) +
  scale_color_manual(
    name   = "Bedrooms",
    values = c("0" = "#F8766D",
               "1" = "#A3A500",
               "2" = "#00BF7D",
               "3" = "#00B0F6",
               "4" = "#E76BF3")
  ) +
  scale_x_continuous(labels = scales::dollar_format(),
                     limits = c(300, 2400),
                     breaks = seq(400, 2400, 400)) +
  scale_y_continuous(labels = scales::dollar_format(),
                     limits = c(300, 2400),
                     breaks = seq(400, 2400, 400)) +
  labs(
    x     = "Model-Predicted Monthly Rent",
    y     = "Actual Monthly Rent",
    title = "Figure 1. Actual vs. Model-Predicted Monthly Rents",
    subtitle = "Points colored by number of bedrooms; dashed line = perfect prediction"
  ) +
  theme_bw(base_size = 13) +
  theme(
    legend.position   = "right",
    panel.grid.minor  = element_blank(),
    plot.title        = element_text(face = "bold", size = 13),
    plot.subtitle     = element_text(size = 10, color = "gray40")
  )

print(fig1)

# Save the plot
ggsave("LBB_Figure1_Actual_vs_Predicted.png", plot = fig1,
       width = 7, height = 6, dpi = 300)

cat("\nDone. Plot saved as 'LBB_Figure1_Actual_vs_Predicted.png'\n")
