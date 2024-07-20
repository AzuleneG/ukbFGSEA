
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ukbFGSEA

<!-- badges: start -->
<!-- badges: end -->

## Overview

The goal of ukbFGSEA is to apply gene set enrichment analysis, based on
FGSEA package, to Genebass data released by Karczewski et al. The
package is amed to help researchers to perform detailed evaluations of
gene set enrichment across a wide range of phenotypes. The package
mainly includes three functions:

- `ukbfgsea()` applies `fgsea::fgseaMultilevel()` - an adaptive
  multilevel splitting Monte Carlo approach, to a single phenotype in
  the UK Biobank Genebass dataset for a specified input gene set.

- `map_ukbfgsea()` applies `fgsea::fgseaMultilevel()` to multiple
  phenotypes in the UK Biobank Genebass dataset for a specified input
  gene set. This function is suitable for large-scale(or full) Genebass
  dataset.

- `tidy_map()` organizes the raw output of `map_ukbfgsea()` to a tibble
  including distinct columns for each phenotype and each ranking method,
  providing a clear and accessible summary of the FGSEA results.

## Installation

You can install the development version of ukbFGSEA like so:

``` r
# install.packages("devtools")
library(devtools)
install_github("AzuleneG/ukbFGSEA")
```

## Example

This example shows how to use `map_ukbfgsea()` to apply FGSEA on
Genebass data, using the test data attached in the package.

``` r
library(tidyverse)
library(ukbFGSEA)

genebass_test_data 

genebass_test_data %>% 
  count(trait_type, phenocode, description, description_more)

# then apply ukbfgsea to three phenotypes for each of gene set
set.seed(123)
asd_output <- map_ukbfgsea(input_geneset = ASD185, multiple_phenotypes = genebass_test_data)

asd_output_tidy <- tidy_map(asd_output)
asd_output_tidy
```

## Getting help

If you find problems, please report them with clear information on
[GitHub](https://github.com/tidyverse/ukbFGSEA/issues). You can also
contact the authors through email: `hedyzhu615@gmail.com` and
`pengjun.guo@outlook.com`
