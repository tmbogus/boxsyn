# **Boxsyn**

**Boxsyn** is a bioinformatics pipeline for **chromosome synteny analysis**, combining **Multiple Correspondence Analysis (MCA)** and clustering. The pipeline allows users to analyze the synteny (gene order conservation) of genomic sequences and visualize the results using **MCA**. It supports optional protein sequence alignment using **BLASTp** and synteny visualization with **Circos**.

## **Overview**

This project performs MCA with clustering to analyze the synteny of contigs aligned to multiple reference genomes. The following steps summarize the workflow:

1. **Input Data Preparation**:
   - Input data includes the contigs of a sugarcane synthetic long-read assembly and the masked genomic sequences of *Sorghum bicolor* (Sb), *Zea mays* (Zm), *Oryza sativa* (Os), and *Brachypodium distachyon* (Bd).
   - Fully masked sequences are excluded from analysis.
   
2. **Contig Alignment**:
   - Contigs are aligned to reference genomes using **BWA-SW**. The highest-scoring alignment hits for each contig are extracted using in-house Perl scripts and formatted into a table for input into R.
   
3. **Multiple Correspondence Analysis (MCA)**:
   - MCA is performed using the **FactoMineR** and **missMDA** packages in R, followed by hierarchical clustering to identify contig clusters.
   - **MCAd.R** is the primary script for handling missing data and includes clustering steps, while **MCA.R** is available for simpler cases without missing data handling.

4. **Optional Protein Alignment**:
   - Optionally, **BLASTp** can be used to align protein sequences between the sugarcane cultivar and reference genomes. The best hits for each protein can be visualized using **Circos**.

## **Pipeline Steps**

### **1. BWA-SW Contig Alignment**

The masked contigs are aligned to the genomic sequences of the following species:
- *Sorghum bicolor* (Sb)
- *Zea mays* (Zm)
- *Oryza sativa* (Os)
- *Brachypodium distachyon* (Bd)

For each alignment, use the **BWA-SW** tool to align contigs to the reference genomes. Below is an example of how to align contigs for each species and parse the highest-scoring hits.

**Example for *Sorghum bicolor* alignment**:
```bash
bwa bwasw Sb_genome.fa sugarcane_contigs.fq > Sb_aligned.sam
perl bwasw_sam_parse_2_hittbl.pl < Sb_aligned.sam > Sb_chromosome_hits.tsv
```

This process is repeated for each of the species:
- *Sorghum bicolor*: `Sb_genome.fa`
- *Zea mays*: `Zm_genome.fa`
- *Oryza sativa*: `Os_genome.fa`
- *Brachypodium distachyon*: `Bd_genome.fa`

### **2. MCA Analysis**

Once the alignment data has been parsed using the Perl scripts, MCA can be performed on the chromosome hit data to analyze synteny. This analysis can be done using either **MCAd.R** or **MCA.R**, depending on whether missing data is present or not.

#### **Using MCAd.R (with missing data handling)**

**MCAd.R** is the recommended script if your data contains missing chromosome hits. This script uses the **missMDA** package to impute missing data and perform MCA, followed by hierarchical clustering using **HCPC**.

Run the **MCAd.R** script to analyze the data:
```bash
Rscript MCAd.R
```

The output will include:
- MCA variable coordinates (`mca4_vars.txt`)
- MCA observation coordinates (`mca4_obs.txt`)
- Plots of different dimension pairings (e.g., `mca4_Dim.1_Dim.2.pdf`)
- Ellipses plot (`mca4_ellipses.pdf`)
- Clustering results

#### **Using MCA.R (without missing data)**

If your data is complete (i.e., there are no missing chromosome hits), you can use the simpler **MCA.R** script. This version of the script performs MCA without any imputation step and focuses purely on dimensionality reduction and visualization.

Run the **MCA.R** script:
```bash
Rscript MCA.R
```

The output includes similar files, but no imputation or clustering is performed.

### **3. Optional Protein Alignment and Visualization**

Optionally, **BLASTp** can be used to align protein sequences between the sugarcane cultivar and the reference genomes (*Sorghum bicolor*, *Zea mays*, *Oryza sativa*, and *Brachypodium distachyon*). The best hits can be visualized using **Circos** plots.

This step is not required for the core synteny analysis, but it can be useful for further biological insight.

## **File Outputs**
- **catdes_Sb.txt, catdes_Zm.txt, catdes_Os.txt, catdes_Bd.txt**: Descriptive statistics for each species’ chromosome alignment.
- **dimdesc.txt**: Dimension descriptions of the MCA.
- **eigenvalues.txt**: Eigenvalues from the MCA.
- **MCA Plots**: PDFs for each pair of dimensions (e.g., `mca4_Dim.1_Dim.2.pdf`).

## **Requirements**
This pipeline requires:
- R (v3.2.1 or later)
- **FactoMineR** (v1.31.3)
- **ggplot2**
- **missMDA** (for MCAd.R)
- Perl 5
- **BWA-SW** (v0.7.12-r1044)
- Optional: **BLASTp** and **Circos**

## **How to Use the Perl Scripts**

The Perl scripts in the project are used to process SAM alignment files produced by **BWA-SW** and generate formatted tables for input into the R pipeline. Here’s how to use them:

### **1. `bwasw_sam_parse_2_hittbl.pl`**
This script extracts the highest-scoring hits from SAM alignment files and formats them into a table for analysis in R.

**Usage**:
```bash
perl bwasw_sam_parse_2_hittbl.pl < contigs_aligned.sam > chromosome_hits.tsv
```

### **2. `chromo_bwasw_sam_parse.pl`**
This script processes SAM files to find the highest-scoring chromosome for each contig and generates a table associating contigs with chromosomes.

**Usage**:
```bash
perl chromo_bwasw_sam_parse.pl < contigs_aligned.sam > contig_chromosome_mapping.tsv
```

### **3. `chromo_hittbl_parse.pl`**
This script processes a hit table and outputs the best alignment scores for each contig.

**Usage**:
```bash
perl chromo_hittbl_parse.pl < hit_table.tsv > parsed_hittable.tsv
```

## **Citation**

If you use this pipeline in your research, please cite the following paper:

Glaucia Mendes Souza, Marie-Anne Van Sluys, Carolina Gimiliani Lembke, Hayan Lee, Gabriel Rodrigues Alves Margarido, Carlos Takeshi Hotta, Jonas Weissmann Gaiarsa, Augusto Lima Diniz, Mauro de Medeiros Oliveira, Sávio de Siqueira Ferreira, Milton Yutaka Nishiyama, Felipe ten-Caten, Geovani Tolfo Ragagnin, Pablo de Morais Andrade, Robson Francisco de Souza, Gianlucca Gonçalves Nicastro, Ravi Pandya, Changsoo Kim, Hui Guo, Alan Mitchell Durham, Monalisa Sampaio Carneiro, Jisen Zhang, Xingtan Zhang, Qing Zhang, Ray Ming, Michael C Schatz, Bob Davidson, Andrew H Paterson, David Heckerman.
*** Assembly of the 373k gene space of the polyploid sugarcane genome reveals reservoirs of functional diversity in the world's leading biomass crop, GigaScience, Volume 8, Issue 12, December 2019, giz129.***
https://doi.org/10.1093/gigascience/giz129

## **License**
This project is licensed under the **Apache License 2.0**. See the `LICENSE` file for details.
