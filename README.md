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

## Data source and attribution

This repository includes a spreadsheet which is a copy of [**Additional file 3: Table S1**](https://static-content.springer.com/esm/art%3A10.1186%2Fs12967-023-03946-6/MediaObjects/12967_2023_3946_MOESM3_ESM.xlsx) from:

Vaes AW, Van Herck M, Deng Q, Delbressine JM, Jason LA, Spruit MA (2023).
“Symptom-based clusters in people with ME/CFS: an illustration of clinical variety in a cross-sectional cohort.”
*Journal of Translational Medicine* 21:112. https://doi.org/10.1186/s12967-023-03946-6

Original article and supplementary files are available from the publisher’s site. The article is **Open Access** under **CC BY 4.0**. The publisher notes that “the Creative Commons Public Domain Dedication waiver (CC0) applies to the data made available in this article, unless otherwise stated in a credit line to the data.”  

We include the spreadsheet solely for **reproducibility**; all rights remain with the original authors/publisher.

## License and Citations
See the [LICENSE.md](LICENSE.md) and [CITATION.cff](CITATION.cff) for details.