#' Comparative data for 54 species of primates
#'
#' A dataset with embedded subheaders.
#'
#' @format A data frame with 69 rows and 4 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, with geographic region and
#'     taxonomic family embedded as subheaders.}
#'     \item{common_name}{vernacular name, as listed in Estada et al.
#'         (2017)}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#'}
#'
#' @source Data originates from the appendix in the following publication:
#' @references Estrada, Alejandro, et al. "Impending extinction crisis of the
#'     world’s primates: Why primates matter." Science Advances 3.1 (2017):
#'     e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
#' @usage
#' data(primates2017)
"primates2017"
#' Comparative data for 16 species of primates with some broken values
#'
#' A dataset with embedded subheaders and some values (T. obscurus,
#'     T. leucocephalus and N. bengalensis) in the scientific_names variable broken up
#'     across two rows (typically done to fit the content in a table).
#'
#' @format A data frame with 19 rows and 4 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, with embedded subheaders
#'         for geographic region and taxonomic family and broken values}
#'     \item{common_name}{vernacular name, as listed in Estada et al.
#'         (2017)}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#'}
#' @source Data originates from the appendix in the following publication:
#' @references Estrada, Alejandro, et al. "Impending extinction crisis of the
#'     world’s primates: Why primates matter." Science Advances 3.1 (2017):
#'     e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
#' #' @usage
#' data(primates2017_broken)
"primates2017_broken"
#' Comparative data for two species of primates
#'
#' A dataset in which the elements for some of the values are in separate rows'
#' @format A data frame with 9 rows and 6 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, see reference}
#'     \item{common_name}{vernacular name, as listed in Estada et al.
#'         (2017)}
#'     \item{habitat}{habitat types listed in the IUCN Red List assessments}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#'     \item{country}{Countries where the species is present, from IUCN Red
#'         List assessments}
#'}
#'
#' @source Data originates from the appendix in the following publication and
#'     from IUCN Red List assessments \url{https://www.iucnredlist.org}.
#' @references Estrada, Alejandro, et al. "Impending extinction crisis of the
#'     world’s primates: Why primates matter." Science Advances 3.1 (2017):
#'     e1600946. \url{http://advances.sciencemag.org/content/3/1/e1600946.full}
#' #' @usage
#' data(primates2017_wrapped)
"primates2017_wrapped"


