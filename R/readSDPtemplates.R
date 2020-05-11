#' Read in SDP templates
#'
#' This function takes output from jailbreakr for the EDUCATION tab on the SDP templates and returns a long format table.
#' @param dat List of tiny little matrices extracted from sector templates with jailbreakr
#' @keywords internal
#' @importFrom magrittr %>%
#' @examples tidyResults(dat)
#' @export

# directory location of files
# loc <- "Z:"
#
# # get file names
# africaFiles <- list.files(paste0(loc,"/Results Reporting Template Africa Regional/"))
# asiaFiles <- list.files(paste0(loc,"/Results Reporting Template Asia Regional/"))
# otherFiles <- list.files(paste0(loc, "/Results Reporting Templates Other Regional/"))
# policyFiles <- list.files(paste0(loc, "/Results Reporting Templates Policy Research EcDev/"))
# listFiles <- list(Africa=africaFiles,Asia=asiaFiles,Other=otherFiles,Policy=policyFiles)
#
# tabs <- c("Education","FamilyPlanning","Humanitarian","Nutrition","WASH")
#
# office <- group %>% purrr::map(stringr::str_replace_all,c("SDP Results Template - |\\.xlsx|SDP results template - "),"")
#


# FP  readxl::read_xlsx("commission/data/template_nigeria_2019.xlsx",sheet = "FamilyPlanning",range = "B1:AD30")
# Hman/edu/wash/nutrition B1:z30


readTemplates <- function(africaPath,asiaPath,otherPath,policyPath){

  africaFiles <- list.files("Z:/Results Reporting Template Africa Regional/")
  asiaFiles <- list.files(asiaPath)
  otherFiles <- list.files(otherPath)
  policyFiles <- list.files(policyPath)

  africaNames <- africaFiles %>% purrr::map(stringr::str_replace_all,c("SDP Results Template - |\\.xlsx|SDP results template - "),"")

  names(africa) <- africaNames

  africaPath <- "Z:/Results Reporting Template Africa Regional/"

  education <- africaFiles %>%
    purrr::map(purrr::safely(
      function(file_name){ # iterate through each file name
      africa <- readxl::read_xlsx(paste0(africaPath, file_name), sheet="Education", range="B1:Z30")

    }
    )
    )






  # asia <- asiaFiles %>%
  #   purrr::map(function(file_name){ # iterate through each file name
  #     readxl::read_excel(paste0(asiaPath, file_name), sheet=tab)
  #   })
  #
  # other <- otherFiles %>%
  #   purrr::map(function(file_name){ # iterate through each file name
  #     readxl::read_excel(paste0(otherPath, file_name), sheet=tab)
  #   })
  #
  # policy <- policyFiles %>%
  #   purrr::map(function(file_name){ # iterate through each file name
  #     readxl::read_excel(paste0(policyPath, file_name), sheet=tab)
  #   })

  # x <- c(africa,asia,other,policy)
  #
  # y <- purrr::map(x, function(a){
  #   a <- slice(a, -c(1:4)) %>% drop_na("Indicator") %>% select(1:10)
  #   return(a)
  # }
  # )
  #
  # z <- do.call(rbind,y)
  #
  # return(z)

}

