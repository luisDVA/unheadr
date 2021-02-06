#' Comparative data for 54 species of primates
#'
#' A dataset with embedded subheaders.
#'
#' @format A data frame with 69 rows and 4 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, with geographic region and
#'     taxonomic family embedded as subheaders.}
#'     \item{common_name}{vernacular name}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \doi{10.1126/sciadv.1600946}
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
#'     \item{common_name}{vernacular name}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \doi{10.1126/sciadv.1600946}
"primates2017_broken"
#' Comparative data for two species of primates
#'
#' A dataset in which the elements for some of the values are in separate rows'
#' @format A data frame with 9 rows and 6 variables:
#' \describe{
#'     \item{scientific_name}{scientific names, see reference}
#'     \item{common_name}{vernacular name}
#'     \item{habitat}{habitat types listed in the IUCN Red List assessments}
#'     \item{red_list_status}{IUCN Red List Status in January 2017}
#'     \item{mass_kg}{mean body mass in kilograms}
#'     \item{country}{Countries where the species is present, from IUCN Red
#'         List assessments}
#' }
#' @source Estrada, Alejandro, et al. "Impending extinction crisis of the
#'         world's primates: Why primates matter." Science Advances 3.1 (2017):
#'         e1600946. \doi{10.1126/sciadv.1600946}
"primates2017_wrapped"
#' dog_test.xlsx spreadsheet
#'
#' Open XML Format Spreadsheet with 1 sheet, 2 columns, and 12 rows. Items
#' describe various tasks or behaviors that dogs can be evaluated on, assigned
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
#' Statistics for game units in Age of Empires II: Definitive Edition
#'
#' A dataset with the numerical values that determine the behavior and
#' performance of selected military units available in AoE2:DE (July 2020 Game
#' Update).
#'
#' @format A data frame with 128 observations of 19 variables:
#' \describe{
#'     \item{unit}{Unit name}
#'     \item{building}{Building in which each unit is trained}
#'     \item{type}{Unit class}
#'     \item{age}{Age at which the unit becomes trainable}
#'     \item{cost_wood}{Unit cost in Wood}
#'     \item{cost_food}{Unit cost in Food}
#'     \item{cost_gold}{Unit cost in Gold}
#'     \item{build_time}{Training time in seconds}
#'     \item{rate_of_fire}{Attack speed}
#'     \item{attack_delay}{Retasking time}
#'     \item{movement_speed}{Travel speed on land}
#'     \item{line_of_sight}{Vision over the surrounding area}
#'     \item{hit_points}{Unit health}
#'     \item{min_range}{Minimum attacking range for ranged units}
#'     \item{range}{Maximum attacking range for ranged units}
#'     \item{damage}{Damage inflicted per attack}
#'     \item{accuracy}{Chance that an attack will be on target}
#'     \item{melee_armor}{Armor against melee attacks}
#'     \item{pierce_armor}{Armor against projectiles}
#' }
#' @source Age of Empires II. Copyright Microsoft Corporation. This dataset was created
#'   under Microsoft's "Game Content Usage Rules"
#'   \url{https://www.xbox.com/en-us/developers/rules} using assets from Age of
#'   Empires II, and it is not endorsed by or affiliated with Microsoft. All
#'   information shown is an interpretation of data collected in-game with no
#'   guarantee on the accuracy of any of the data presented.
#'
"AOEunits"
#' Statistics for game units in Age of Empires II: Definitive Edition in a messy presentation
#'
#' A messy version of the \code{\link{AOEunits}} dataset, meant for demonstrating data cleaning functions.
#'
#' @format A data frame with 139 observations of 15 variables. See `AOEunits` for variable descriptions.
#' @encoding UTF-8
#' @source Age of Empires II. Copyright Microsoft Corporation. This dataset was created
#'   under Microsoft's "Game Content Usage Rules"
#'   \url{https://www.xbox.com/en-us/developers/rules} using assets from Age of
#'   Empires II, and it is not endorsed by or affiliated with Microsoft. All
#'   information shown is an interpretation of data collected in-game with no
#'   guarantee on the accuracy of any of the data presented.
#'
"AOEunits_raw"
