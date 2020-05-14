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

africaPath <- "Z:/Results Reporting Template Africa Regional/"
library(magrittr)
library(tidyverse)

readTemplates <- function(africaPath,asiaPath,otherPath,policyPath){

  africaPath <- "Z:/Results Reporting Template Africa Regional/"
  asiaPath <- "Z:/Results Reporting Template Asia Regional/"
  otherPath <- "Z:/Results Reporting Templates Other Regional/"
  policyPath <- "Z:/Results Reporting Templates Policy Research EcDev/"

  africaFiles <- list.files("Z:/Results Reporting Template Africa Regional/")
  asiaFiles <- list.files("Z:/Results Reporting Template Asia Regional/")
  otherFiles <- list.files("Z:/Results Reporting Templates Other Regional/")
  policyFiles <- list.files("Z:/Results Reporting Templates Policy Research EcDev/")

  files <- c(paste0(africaPath,africaFiles),paste0(asiaPath,asiaFiles),paste0(otherPath,otherFiles),paste0(policyPath,policyFiles))


  education <- files %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
      africa <- readxl::read_xlsx(file, sheet="Education", range="B1:X30")
                          }
        )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})


  fp <- files %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="FamilyPlanning", range="B1:AD30")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})


  humanitarian <- files %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="Humanitarian", range="B1:X30")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})


  nutrition <- files %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="Nutrition", range="B1:X30")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})


  pfm <- files %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="PFM", range="B1:X30")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})


  a2f <- files[c(1,10,20,40,50)] %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="AccessToFinance", range="B383:AE421")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})

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

