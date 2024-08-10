#' Apply Gene Set Enrichment Analysis to Multiple Phenotypes
#'
#' This function applies fast preranked gene set enrichment analysis (FGSEA) to multiple phenotypes using a provided gene set. It is designed to handle large-scale datasets efficiently.
#' @param input_geneset A list containing one gene set for enrichment analysis. The element of the list should be a character vector of gene Ensembl IDs.
#' @param multiple_phenotypes A data frame containing multiple phenotypes from Genebass.
#' @param ... Additional arguments passed to `ukbfgsea`.
#' @return A data frame containing the results of `ukbfgsea` for each phenotype annotation. This includes enrichment analysis outcomes using two different ranking metrics, and, if specified, enrichment plots.
#' @export
#' @importFrom dplyr across ungroup
#' @importFrom utils data
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   library(ukbFGSEA)
#'   asd_output <- map_ukbfgsea(input_geneset = ASD185, multiple_phenotypes = genebass_test_data)
#' }
#' @name map_ukbfgsea
utils::globalVariables(names = c("Pvalue", "n_cases", "category", "annotation", "data"), package = "ukbFGSEA", add = F)

map_ukbfgsea <- function(input_geneset, multiple_phenotypes, ...) {
  multiple_phenotypes <- multiple_phenotypes %>%
    dplyr::mutate(Pvalue = ifelse(Pvalue == 0, 5e-321, Pvalue))

  genebass_by_phenotype <- multiple_phenotypes %>%
    dplyr::group_by(across(n_cases:category), annotation) %>%
    tidyr::nest()

  output <- genebass_by_phenotype %>%
    dplyr::mutate(output = purrr::map(
      data,
      ~ ukbfgsea(input_geneset = input_geneset, ukb_genebass = .x)
    )) %>%
    dplyr::select(-data)

  output %>% ungroup()

}
