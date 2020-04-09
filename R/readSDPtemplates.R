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


