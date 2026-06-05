library(readxl)
library(dplyr)
library(metafor)

study   <- read_excel("C:\\Users\\tamci\\OneDrive\\Desktop\\R projects\\Meta-analysis\\meta-analysis extraction.xlsx", sheet = "Study")
outcome <- read_excel("C:\\Users\\tamci\\OneDrive\\Desktop\\R projects\\Meta-analysis\\meta-analysis extraction.xlsx", sheet = "Outcome")

names(study)
names(outcome)

#Looking at prevalence
dat_prev <- outcome %>%
  filter(!is.na(n_assessed),
         !is.na(n_above_cutoff)) %>%
  left_join(study, by = "study_id") %>%
  mutate(
    prop = n_above_cutoff / n_assessed
  )

#Cross-checking with excel sheet
dat_prev %>%
  select(study_id, outcome_domain, instrument,
         n_assessed, n_above_cutoff, prop, prevalence_percent)

#Random-effect meta-analysis for depression
# Depression prevalence
dat_dep <- dat_prev %>%
  filter(outcome_domain == "depression")

es_dep <- escalc(measure = "PLO",
                 xi = n_above_cutoff,
                 ni = n_assessed,
                 data = dat_dep)

res_dep <- rma(yi, vi, data = es_dep, method = "PM")  # or method = "REML"

summary(res_dep)

# Back-transform pooled estimate and prediction interval to prevalence
predict(res_dep, transf = transf.ilogit, digits = 3)

# Forest plot for depression
forest(res_dep,
       slab = dat_dep$study_id,
       transf = transf.ilogit,
       refline = predict(res_dep, transf = transf.ilogit)$pred,
       xlab = "Prevalence (proportion)",
       main = "Depression prevalence among Ukrainian refugees")

#Random-effect meta-analysis for anxiety
dat_anx <- dat_prev %>%
  filter(outcome_domain == "anxiety")

es_anx <- escalc(measure = "PLO",
                 xi = n_above_cutoff,
                 ni = n_assessed,
                 data = dat_anx)

res_anx <- rma(yi, vi, data = es_anx, method = "PM")
summary(res_anx)
predict(res_anx, transf = transf.ilogit, digits = 3)

# Forest plot for anxiety
forest(res_anx,
       slab = dat_anx$study_id,
       transf = transf.ilogit,
       refline = predict(res_anx, transf = transf.ilogit)$pred,
       xlab = "Prevalence (proportion)",
       main = "Anxiety prevalence among Ukrainian refugees")

#Random-effect meta-analysis for PTSD
dat_ptsd <- dat_prev %>%
  filter(outcome_domain == "PTSD")

es_ptsd <- escalc(measure = "PLO",
                  xi = n_above_cutoff,
                  ni = n_assessed,
                  data = dat_ptsd)

res_ptsd <- rma(yi, vi, data = es_ptsd, method = "PM")
summary(res_ptsd)
predict(res_ptsd, transf = transf.ilogit, digits = 3)

# Forest plot for PTSD
forest(res_ptsd,
       slab = dat_ptsd$study_id,
       transf = transf.ilogit,
       refline = predict(res_ptsd, transf = transf.ilogit)$pred,
       xlab = "Prevalence (proportion)",
       main = "PTSD prevalence among Ukrainian refugees")

# Sensitivity analyses
leave1out(res_dep)
leave1out(res_anx)
leave1out(res_ptsd)

# -------------------------------------------------------------
# SUBGROUP ANALYSIS BY HOST COUNTRY
# -------------------------------------------------------------

# Add host country information to the 12-row study dataset
# (This is the correct place to assign it — matches row count)
study$host_country <- c(
  "Germany",
  "Poland",
  "Multiple",
  "Germany",
  "Germany",
  "Czechia",
  "Denmark",
  "Lithuania",
  "Poland",
  "Hungary",
  "Czechia",
  "Switzerland"
)

# Recreate dat_prev so host_country is included via left_join
dat_prev <- outcome %>%
  filter(!is.na(n_assessed),
         !is.na(n_above_cutoff)) %>%
  left_join(study, by = "study_id") %>%
  mutate(prop = n_above_cutoff / n_assessed)

# Add host_country to each outcome-specific dataset
# (match by study_id to ensure correct alignment)
dat_dep$host_country  <- study$host_country[match(dat_dep$study_id, study$study_id)]
dat_anx$host_country  <- study$host_country[match(dat_anx$study_id, study$study_id)]
dat_ptsd$host_country <- study$host_country[match(dat_ptsd$study_id, study$study_id)]

# -------------------------------------------------------------
# Function to run subgroup models by host country
# -------------------------------------------------------------
run_subgroup_models <- function(data) {
  
  # Split dataset into a list of dataframes, one per host country
  subgroups <- split(data, data$host_country)
  
  # For each subgroup, compute effect sizes and fit a random-effects model
  models <- lapply(subgroups, function(df) {
    
    # Calculate logit-transformed proportions (PLO)
    es <- escalc(
      measure = "PLO",
      xi = n_above_cutoff,
      ni = n_assessed,
      data = df
    )
    
    # Fit random-effects model using Paule-Mandel estimator
    rma(yi, vi, data = es, method = "PM")
  })
  
  return(models)
}

# Run subgroup models for each outcome
dep_models  <- run_subgroup_models(dat_dep)
anx_models  <- run_subgroup_models(dat_anx)
ptsd_models <- run_subgroup_models(dat_ptsd)

# -------------------------------------------------------------
# Extract pooled prevalence (back-transformed)
# -------------------------------------------------------------
extract_prevalence <- function(models) {
  lapply(models, function(m) {
    predict(m, transf = transf.ilogit)   # convert logit back to proportion
  })
}

# Extract prevalence estimates by country
dep_prev_by_country  <- extract_prevalence(dep_models)
anx_prev_by_country  <- extract_prevalence(anx_models)
ptsd_prev_by_country <- extract_prevalence(ptsd_models)

# Print results to console
dep_prev_by_country
anx_prev_by_country
ptsd_prev_by_country

# -------------------------------------------------------------
# Forest plot function (AUTO-PRINTING VERSION)
# -------------------------------------------------------------
plot_subgroup_forests <- function(data, outcome_name) {
  
  # Split dataset by host country
  subgroups <- split(data, data$host_country)
  
  # Loop through each country and generate a forest plot
  for (country in names(subgroups)) {
    
    df <- subgroups[[country]]
    
    # Compute effect sizes
    es <- escalc(
      measure = "PLO",
      xi = n_above_cutoff,
      ni = n_assessed,
      data = df
    )
    
    # Fit random-effects model
    model <- rma(yi, vi, data = es, method = "PM")
    
    # Force the plot to display even when sourcing the script
    print(
      forest(
        model,
        slab = df$study_id,              # study labels
        transf = transf.ilogit,          # back-transform to proportions
        main = paste(outcome_name, "prevalence –", country)
      )
    )
  }
}

# -------------------------------------------------------------
# Generate subgroup forest plots (these now print automatically)
# -------------------------------------------------------------
plot_subgroup_forests(dat_dep,  "Depression")
plot_subgroup_forests(dat_anx,  "Anxiety")
plot_subgroup_forests(dat_ptsd, "PTSD")
