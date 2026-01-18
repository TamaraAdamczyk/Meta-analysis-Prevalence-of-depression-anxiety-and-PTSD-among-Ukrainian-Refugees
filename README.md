# Meta-analysis-Prevalence-of-depression-anxiety-and-PTSD-among-Ukrainian-Refugees
This project examines how the 2022 Russian invasion of Ukraine affected refugees’ mental health. As a Polish person who saw the arrival of people fleeing the war, I wanted to understand its psychological impact. Using R, I analyse the prevalence of depression, anxiety and PTSD.
# Project Summary
This project investigates how the 2022 Russian invasion of Ukraine has affected the mental health of forcibly displaced people. My aim is to synthesise evidence on the prevalence of depression, anxiety and PTSD among Ukrainian refugees using a transparent, reproducible workflow.

Literature searches were conducted in PubMed and Europe PMC, with reference management and screening supported by Zotero. Data extraction is organised in structured spreadsheets, and all statistical analyses are performed in R using packages such as metafor for random‑effects meta‑analysis, dplyr for data wrangling, and readxl for importing extraction sheets. The full workflow is documented in R Markdown to ensure clarity and reproducibility.

I have prior experience conducting systematic reviews, and I am actively expanding my skills in meta‑analysis. I recently completed the Introduction to Systematic Reviews and Meta‑Analysis course from Johns Hopkins University, and this project serves as a practical way to apply and enhance that training.

This is a work in progress. I rely on open‑access studies only, the evidence base may not yet be fully comprehensive. I am also not a psychologist or clinician, so I depend on careful reading of methodological papers and validated mental‑health questionnaires to ensure appropriate interpretation. I intend to fully write up this study once I have completed all parts of analysis.

# Introduction
Armed conflicts in recent years have driven record levels of global displacement, with the 2022 full‑scale Russian invasion of Ukraine forcing millions of people to flee their homes. War‑related displacement is strongly linked to higher rates of mental‑health difficulties.. A large meta‑analysis by Blackmore et al. (2020) reported high pooled prevalence estimates among refugees and asylum seekers, including 31.46% for PTSD, 31.5% for depression, and 11% for anxiety disorders. Other systematic reviews of war‑affected refugee populations similarly highlight substantial mental‑health burdens and wide variability in reported prevalence, often shaped by methodological differences across studies (Patane et al., 2022). This study focuses specifically on Ukrainian refugees in host countries, synthesising available evidence on the prevalence of depression, anxiety, and PTSD following displacement.

Points to develop for introduction: context of the displacement: Russian full-scale invasion in February 2022 Mental health risks in forced migration: find stats on mental health risks in forced migration, particularly in context of war refugees - how this typically differs from say economical migrants; find prevalence of mental health conditions in general population too Exisiting evidence: individual studies and previous meta-data from other war refugees groups (if available?) Knowledge gap: No previous meta-analysis focused on Ukrainian refugees Additional topics to introduce: anxiety, depression and PTSD and validated assessment tools

# Methods
## Search strategy
Databases searched: PubMed, EuropePMC

Date of searches: 06/01/2026

Search terms:

PubMed: (Ukrainian OR Ukraine) AND (refugee* OR displaced) AND (anxiety OR depression OR PTSD OR “post-traumatic stress”) AND (prevalence OR symptom*)

EuropePMC: (Ukrainian OR Ukraine) AND refugee AND (anxiety OR depression OR PTSD) AND prevalence

Filter: Open access

Records identified (total): 505 
 a) PubMed: 45 
 b) EuropePMC: 460

After duplicates removal: 485 

Title/ abstract screening: 485 

Full text screening: 41 

Included: 11

## Eligibility criteria
Inclusion criteria:

- Population: Ukrainian refugees displaced after Feb 2022
- Outcomes: depression, anxiety, PTSD
- Study designs: cross‑sectional, cohort baseline
- Validated self‑report mental‑health questionnaires: PHQ‑9, PHQ‑8, PHQ‑4, GAD‑7, BAI, ITQ, IES‑R, PCL‑5, CRIES‑13

Exclusion criteria:

- Studies inside Ukraine
- Qualitative studies
- Non‑validated self‑report mental‑health questionnaires
- No extractable prevalence data; no means/SD

## Data extraction
Study info:

study_id first_author year title journal country_host study_design sampling_method n_total age_mean age_sd percent_female population_notes time_since_displacement_months refugee_status_definition risk_of_bias_sampling risk_of_bias_measurement risk_of_bias_reporting overall_risk_of_bias notes

Outcomes info:

study_id outcome_domain instrument cutoff_value cutoff_definition n_assessed n_above_cutoff prevalence_percent mean_score sd_score response_rate notes_on_measurement

## Statistical Analysis
- Effect size: logit-transformed proportions (PLO)
- Model: random-effects (Paule–Mandel)
- Heterogeneity: I², τ², Q
- Sensitivity analyses: leave-one-out, RoB exclusion
- No meta-regression due to <10 studies per outcome

# RESULTS

## Pooled Prevalence Estimates
Using logit‑transformed proportions and Paule–Mandel random‑effects models, the pooled prevalence estimates were:

- Depression: 40.1% (95% CI 34.7%–45.8%)
- Anxiety: 39.0% (95% CI 27.8%–51.5%)
- PTSD: 31.3% (95% CI 16.3%–51.8%)

(Values are back‑transformed using predict(model, transf = transf.ilogit).)

## Heterogeneity
All three outcomes showed substantial heterogeneity, consistent with differences in sampling, measurement tools, timing of data collection, and host‑country contexts:

- Depression: I² = 85.4%
- Anxiety: I² = 97.1%
- PTSD: I² = 99.4%

## Visualisation

Forest plots were generated for each outcome to illustrate study‑level prevalence and pooled estimates.
<img width="821" height="553" alt="image" src="https://github.com/user-attachments/assets/6fcd6ced-3511-4843-a023-52dfa1308800" />

Fig 1. Figure 1. Forest plot showing study‑level and pooled prevalence estimates of depression among Ukrainian refugees, based on a Paule–Mandel random‑effects model.

<img width="802" height="551" alt="image" src="https://github.com/user-attachments/assets/96556581-8e1a-4600-9f87-ee96d4fd925e" />

Figure 2. Forest plot showing study‑level and pooled prevalence estimates of anxiety among Ukrainian refugees, based on a Paule–Mandel random‑effects model.

<img width="818" height="557" alt="image" src="https://github.com/user-attachments/assets/fde2e969-3aa8-4816-abd5-89ce8cefd8fc" />

Figure 3. Forest plot showing study‑level and pooled prevalence estimates of PTSD among Ukrainian refugees, based on a Paule–Mandel random‑effects model.

## Interpretation
Across available open‑access studies, Ukrainian refugees show elevated prevalence of depression, anxiety, and PTSD. These findings align with broader evidence on the mental‑health impact of war‑related displacement. Results should be interpreted cautiously due to high heterogeneity, limited study availability, and methodological variability across included studies.
