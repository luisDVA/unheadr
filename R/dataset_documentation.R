#' Comparative data for 54 species of primates
#'
#' A dataset with embedded subheaders.
#'
#' @format A data frame with 69 rows and 4 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, with geographic region and
#'     taxonomic family embedded as subheaders.}
#'     \item{common_name}{vernacular name, as listed in Estrada et al.
#'         (2017)}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
"primates2017"
#' Comparative data for 16 species of primates with some broken values
#'
#' A dataset with embedded subheaders and some values (T. obscurus, T.
#' leucocephalus and N. bengalensis) in the scientific_names variable broken up
#' across two rows (typically done to fit the content in a table).
#'
#' @format A data frame with 19 rows and 4 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, with embedded subheaders
#'         for geographic region and taxonomic family and broken values}
#'     \item{common_name}{vernacular name, as listed in Estrada et al.
#'         (2017)}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
"primates2017_broken"
#' Comparative data for two species of primates
#'
#' A dataset in which the elements for some of the values are in separate rows'
#' @format A data frame with 9 rows and 6 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, see reference}
#'     \item{common_name}{vernacular name, as listed in Estrada et al.
#'         (2017)}
#'     \item{habitat}{habitat types listed in the IUCN Red List assessments}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#'     \item{country}{Countries where the species is present, from IUCN Red
#'         List assessments}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
"primates2017_wrapped"
#' dog_test.xlsx spreadsheet
#'
#' Open XML Format Spreadsheet with 1 sheet, 2 columns, and 12 rows. Items
#' describe various taks or behaviors that dogs can be evaluated on, assigned
#' into three categories which appear along with their average scores as
#' embedded subheaders with meaningful formatting.
#'
#' This data is used in the example for `annotate_mf()`.
#'
#' @name dog_test.xlsx
#'
#' @source Items are modified from the checklist written by Junior Watson.
#' @references http://www.dogtrainingbasics.com/checklist-well-behaved-dog/
NULL
#' boutiques.xlsx spreadsheet
#'
#' Open XML Format Spreadsheet with 1 sheet, 6 columns, and 8 rows. Toy dataset
#' with Q1 profits for different store locations. Additional information
#' is encoded as meaningful formatting. Bold indicates losses (negative values),
#' colors indicate continent, and italic indicates a second location in the same
#' city.
#'
#' This data is used in the example for `annotate_mf_all()`.
#'
#' @name boutiques.xlsx
#'
NULL
