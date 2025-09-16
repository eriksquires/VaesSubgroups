# Analysis of ME/CFS Patient Clusters in Vaes Data Reveals Distinct Subgroups

The code here is all of the code needed to generate my research paper [which is also online as a preprint](https://www.preprints.org/manuscript/202509.1179) 

Before you can generate the PDF you'll need to run (in order):

* process_excel.R
* summarize_vaes_csv_by_symptom_domain.R
* r2_by_domain.R
* leave_one_out.R

I then use RStudio to render VaesSubgroups.qmd, but

````bash
quarto render VaesSubgroups.qmd
````
should also work so long as you keep to the folder organization in this repo.

# Abstract

**Background:** [Vaes et al.]( https://doi.org/10.1186/s12967-023-03946-6) identified 13 symptom clusters in a large cohort of ME/CFS patients. Symptom intensity is broadly correlated with post-exertional malaise (PEM) severity, with variation across clusters that seems heterogeneous. Despite this research, no broadly accepted organizing principle has emerged from this paper or other attempts at phenotyping ME/CFS.

**Objective:** To identify and characterize potential subgroups defined by symptom domain severity relative to PEM within the original Vaes symptom clusters.

**Methods:** We analyzed the Vaes cluster summary data, calculated geometric means for each symptom domain within each cluster, and plotted these means against PEM severity to identify patterns and subgroups.

**Results:** We identified two groups of patient clusters with distinct symptom-domain profiles. Separating the 13 clusters into these subgroups reduced heterogeneity within each. The first group showed a consistent amplification pattern across all symptom domains as PEM increased, whereas the second group exhibited selective amplification: pain and neurocognitive symptoms escalated more rapidly with PEM, while immune and sleep symptoms remained relatively flat. This subgroup's profile resembles that of fibromyalgia.

**Keywords:** Myalgic Encephalomyelitis, ME/CFS, patient clustering, fibromyalgia, post-exertional malaise, PEM

# Credits

The source spreadsheet comes from the paper [Symptom-based clusters in people with ME/CFS: an illustration of clinical variety in a cross-sectional cohort]( https://doi.org/10.1186/s12967-023-03946-6)  by Vaes, A.W., Van Herck, M., Deng, Q. et al.and is downloaded, if needed, by **process_excel.R.**  At the time of this writing this spreadsheet was available from [Additional file 3: Table S1](https://static-content.springer.com/esm/art%3A10.1186%2Fs12967-023-03946-6/MediaObjects/12967_2023_3946_MOESM3_ESM.xlsx)

See the [LICENSE.md](LICENSE.md) and [CITATION.cff](CITATION.cff) for details.