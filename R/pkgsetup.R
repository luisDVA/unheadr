# avoiding manual setup

# imports
devtools::use_package("dplyr")
devtools::use_package("rlang")
devtools::use_package("stringr")
devtools::use_package("tidyr")

# licensing, from the usethis package readme
usethis::use_mit_license(name = "Luis D. Verde Arregoitia")

# from the stat545 tutorial
usethis::use_package_doc()

# exported data
primates2017 <- readr::read_csv(file = "prsubset.csv",locale = readr::locale(encoding = "latin1"))
primates2017_broken <- readr::read_csv(file = "prsubset_broken.csv",locale = readr::locale(encoding = "latin1"))
primates2017_wrapped <- readr::read_csv(file = "prsubset_wrapped.csv",locale = readr::locale(encoding = "latin1"))
devtools::use_data(primates2017,primates2017_broken,primates2017_wrapped, overwrite = TRUE)

# ignore this file
devtools::use_build_ignore("R/pkgsetup.R")
