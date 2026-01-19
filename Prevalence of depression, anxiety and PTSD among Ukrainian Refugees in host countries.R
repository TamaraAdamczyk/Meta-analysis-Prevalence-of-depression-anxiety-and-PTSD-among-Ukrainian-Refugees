library(readxl)
library(dplyr)
library(metafor)

study   <- read_excel("C:/Users/tamci/OneDrive/Desktop/R projects/meta-analysis extraction.xlsx", sheet = "Study")
outcome <- read_excel("C:/Users/tamci/OneDrive/Desktop/R projects/meta-analysis extraction.xlsx", sheet = "Outcome")

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