# Analysis of Potential Subgroups in Vaes ME/CFS Patient Clusters

The code here is all of the code needed to generate my research paper [which is also online as a preprint](https://www.preprints.org/manuscript/202509.1179)

**Instructions:**

1.  Clone this repo.
2.  Review [dependencies](DEPENDENCIES.md) and install missing packages.
3.  Run R/main.R. This will generate all of the intermediate data files and the final PDF.

# Abstract

**Background:** Vaes et al. (2023)[@vaes2023] identified 13 symptom clusters in a large cohort of ME/CFS patients. Symptom intensity is broadly correlated with post-exertional malaise (PEM) severity, with variation across clusters that seems disorganized. Despite this research, no broadly accepted organizing principle has emerged from this paper or other attempts at phenotyping ME/CFS.

**Objective:** To identify and characterize potential subgroups defined by symptom domain severity relative to PEM within the original Vaes symptom clusters.

**Methods:** We analyzed the Vaes cluster summary data [@vaes2023_excel_large], calculated geometric means for each symptom domain within each cluster, and plotted these means against PEM severity to identify patterns and subgroups.

**Results:** Our analysis identified two groups of patient clusters with distinct symptom-domain profiles. Anchoring symptom domains to PEM collapses the 13 Vaes clusters into two reproducible families: one characterized by parallel offsets (autonomic, neuroendocrine, other) and one by amplified slopes (pain, neurocognitive), with high-end convergence after accounting for a single influential cluster. This subgroup's symptom trends could align with those of fibromyalgia. Further exploration with individual patient data is needed to validate these findings.

**Keywords:** Myalgic Encephalomyelitis, ME/CFS, patient clustering, fibromyalgia, post-exertional malaise, PEM

## Data source and attribution

This repository includes spreadsheets from:

Vaes AW, Van Herck M, Deng Q, Delbressine JM, Jason LA, Spruit MA (2023). “Symptom-based clusters in people with ME/CFS: an illustration of clinical variety in a cross-sectional cohort.” *Journal of Translational Medicine* 21:112. <https://doi.org/10.1186/s12967-023-03946-6>

Original article and supplementary files are available from the publisher’s site. The article is **Open Access** under **CC BY 4.0**. The publisher notes that “the Creative Commons Public Domain Dedication waiver (CC0) applies to the data made available in this article, unless otherwise stated in a credit line to the data.”

We include the spreadsheets solely for **reproducibility**; all rights remain with the original authors/publisher.

## License and Citations

See the [LICENSE.md](LICENSE.md) and [CITATION.cff](CITATION.cff) for details.
