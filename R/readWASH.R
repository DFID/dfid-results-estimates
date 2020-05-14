#' Read in SDP templates
#'
#' Extracts the dept results from SDP templates ready for formatting
#' @param path path to parent directory without trailling forward /. e.g. "Z:"
#' @keywords internal
#' @importFrom magrittr %>%
#' @examples readXXX(path)
#' @export
readWASH <- function(path){

  africaPath <- paste0(path, "/", list.files(path)[grep("Template Africa", list.files(path))], "/")
  asiaPath <- paste0(path, "/", list.files(path)[grep("Template Asia", list.files(path))], "/")
  otherPath <- paste0(path, "/", list.files(path)[grep("Templates Other", list.files(path))], "/")
  policyPath <- paste0(path, "/", list.files(path)[grep("Templates Policy", list.files(path))], "/")

  africaFiles <- list.files(africaPath)
  asiaFiles <- list.files(asiaPath)
  otherFiles <- list.files(otherPath)
  policyFiles <- list.files(policyPath)

  files <- c(paste0(africaPath,africaFiles),paste0(asiaPath,asiaFiles),paste0(otherPath,otherFiles),paste0(policyPath,policyFiles))

  wash <- files[c(1,10,20,40,50)] %>%
    purrr::map(purrr::safely(
      function(file){ # iterate through each file name
        africa <- readxl::read_xlsx(file, sheet="WASH", range="B1:X30")
      }
    )
    ) %>%
    purrr::map(function(x){if(is.null(x$error)){x$result}else{x$error}})

  return(wash)

}
