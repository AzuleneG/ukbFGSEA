#' Apply Fast Preranked Gene Set Enrichment Analysis (FGSEA) to a Single Phenotype in the UK Biobank Genebass Dataset
#'
#' This function applies `fgsea::fgseaMultilevel` - an adaptive multilevel splitting Monte Carlo approach, to a single phenotype in the UK Biobank Genebass dataset for a specified input gene set.
#'
#' @param input_geneset A list containing one gene set for enrichment analysis. The element of the list should be a character vector of gene Ensembl IDs.
#' @param ukb_genebass A data frame containing the Genebass gene burden results of a single phenotype annotation.
#' @param plot Logical. If `TRUE`, generates GSEA enrichment plots. Default is `FALSE`.
#' @param ... Additional arguments passed to `fgsea::fgseaMultilevel`.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{beta_results}{Enrichment analysis results using `rank_beta`.}
#'   \item{beta_stats}{The `rank_beta` statistics utilized in the analysis.}
#'   \item{sign_results}{Enrichment analysis results using `rank_sign`.}
#'   \item{sign_stats}{The `rank_sign` statistics utilized in the analysis.}
#'   \item{beta_plot}{The enrichment plot for `rank_beta` if `plot = TRUE`.}
#'   \item{sign_plot}{The enrichment plot for `rank_sign` if `plot = TRUE`.}
#' }
#' @export
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom utils data
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   library(ukbFGSEA)
#'   one_phenotype <- genebass_test_data %>% filter(phenocode=="6150", annotation == "pLoF")
#'   output <- ukbfgsea(input_geneset = ASD185, ukb_genebass = one_phenotype, plot = T)
#' }
#' @name ukbfgsea
utils::globalVariables(names = c("Pvalue", "BETA_Burden"), package = "ukbFGSEA", add = F)

ukbfgsea <- function(input_geneset, ukb_genebass, plot = FALSE, ...) {
  ukb_genebass <- ukb_genebass %>%
    dplyr::filter(!(is.na(.data$Pvalue) |
                      is.na(.data$BETA_Burden))) %>%
    dplyr::mutate(
      rank_sign = -log10(.data$Pvalue) * sign(.data$BETA_Burden),
      rank_beta = -log10(.data$Pvalue) * .data$BETA_Burden
    )


  ukb_genebass_beta <- ukb_genebass %>%
    dplyr::arrange(.data$rank_beta) %>%
    dplyr::select(.data$gene_id, .data$rank_beta) %>%
    tibble::deframe()

  ukb_genebass_sign <- ukb_genebass %>%
    dplyr::arrange(.data$rank_sign) %>%
    dplyr::select(.data$gene_id, .data$rank_sign) %>%
    tibble::deframe()


  fgsea_beta_result <- fgsea::fgseaMultilevel(pathways = input_geneset, stats = ukb_genebass_beta, ...)


  fgsea_sign_result <- fgsea::fgseaMultilevel(pathways = input_geneset, stats = ukb_genebass_sign, ...)

  if (plot) {
    plot_beta <- fgsea::plotEnrichment(input_geneset[[1]], ukb_genebass_beta)
    plot_sign <- fgsea::plotEnrichment(input_geneset[[1]], ukb_genebass_sign)

    output <- list(
      beta_results = fgsea_beta_result,
      beta_stats = ukb_genebass_beta,
      beta_plot = plot_beta,
      sign_results = fgsea_sign_result,
      sign_stats = ukb_genebass_sign,
      sign_plot = plot_sign
    )

  }else{
    output <- list(
      beta_results = fgsea_beta_result,
      beta_stats = ukb_genebass_beta,
      sign_results = fgsea_sign_result,
      sign_stats = ukb_genebass_sign
    )
  }

  return(output)
}


