#' Tidy the Output of `map_ukbfgsea`
#'
#' This function processes the raw output from `map_ukbfgsea()` and organizes it into a tidy format. It splits the output into distinct columns for each phenotype and each ranking method, providing a clear and accessible summary of the FGSEA results.
#'
#' @param input A data frame containing the raw results from `map_ukbfgsea()`.
#' @return A tidy data frame with separate columns for each phenotype and ranking method.
#' @details This function is designed to simplify the interpretation of FGSEA results by restructuring the output into a user-friendly format. It ensures that each phenotype and ranking method is clearly delineated, making it easier to analyze and visualize the results.
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   library(ukbFGSEA)
#'   asd_output <- map_ukbfgsea(input_geneset = ASD185, multiple_phenotypes = genebass_test_data)
#'   asd_output_tidy <- tidy_map(asd_output)
#' }
#' @export
#' @importFrom dplyr select
#' @importFrom utils data
#' @name tidy_map
utils::globalVariables(names = c(".", "beta_pathway", "sign_pathway"), package = "ukbFGSEA", add = F)

tidy_map <- function(input) {
  beta <- purrr::map_dfr(input$output, ~ .x$beta_results %>% as_tibble) %>%
    stats::setNames(paste0("beta_", names(.)))

  sign <- purrr::map_dfr(input$output, ~ .x$sign_results %>% as_tibble) %>%
    stats::setNames(paste0("sign_", names(.)))

  output <- dplyr::bind_cols(input %>% select(-output), beta) %>%
    dplyr::bind_cols(sign)

  output %>%
    dplyr::select(-beta_pathway, -sign_pathway)

}
