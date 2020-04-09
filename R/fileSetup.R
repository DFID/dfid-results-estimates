#' Setup directory for project
#'
#' This function takes output from jailbreakr for the WASH tab on the SDP templates and returns a long format table.
#' @param directory Absolute path to main/parent diectory. Character.
#' @param date Whether to include the date in parent directory name. Logical.
#' @keywords setup
#' @importFrom magrittr %>%
#' @examples fileSetup(~/results)
#' @export
fileSetup <- function(directory, date=T){
  # main directory
  main_dir <- if(date==T){
    paste(directory, format(Sys.Date(),"%d-%m-%Y"), sep="_")
  }else{
    directory
  }
  #fig directory
  figs_dir <- file.path(main_dir, "figs")
  #table directory
  tables_dir <- file.path(main_dir, "tables")
  #data directory
  data_dir <- file.path(main_dir, "data")
  #script directory
  report_dir <- file.path(main_dir, "report")

  if (!dir.exists(main_dir)){
    cat(paste0("creating directory ", main_dir, "\n"))
    dir.create(main_dir)
  } else {
    cat(paste0("directory ", main_dir, " already exists!\n"))
  }

  if (!dir.exists(figs_dir)){
    cat(paste0("creating directory ", figs_dir,"\n"))
    dir.create(figs_dir)
  } else {
    cat(paste0("directory ", figs_dir, " already exists!\n"))
  }

  if (!dir.exists(tables_dir)){
    cat(paste0("creating directory ", tables_dir, "\n"))
    dir.create(tables_dir)
  } else {
    cat(paste0("directory ", tables_dir, " already exists!\n"))
  }

  if (!dir.exists(data_dir)){
    cat(paste0("creating directory ", data_dir, "\n"))
    dir.create(data_dir)
  } else {
    cat(paste0("directory ", data_dir, " already exists!\n"))
  }

  if (!dir.exists(report_dir)){
    cat(paste0("creating directory ", report_dir, "\n"))
    dir.create(report_dir)
  } else {
    cat(paste0("directory ", report_dir, " already exists!\n"))
  }



  if (dir.exists(paste0(.libPaths()[1],"/SDPResults"))){

  file.copy(from=paste0(.libPaths()[1],"/SDPResults/scripts/rap.Rnw"),
            to=report_dir)
  } else {

     file.copy(from=paste0(.libPaths()[2],"/SDPResults/scripts/rap.Rnw"),
              to=report_dir)
  }



  if (dir.exists(paste0(.libPaths()[1],"/SDPResults"))){

  file.copy(from=paste0(.libPaths()[1],"/SDPResults/images/logo_results.pdf"),
            to=figs_dir)
  } else {

    file.copy(from=paste0(.libPaths()[2],"/SDPResults/images/logo_results.pdf"),
              to=figs_dir)
  }



  if (dir.exists(paste0(.libPaths()[1],"/SDPResults"))){

	      file.copy(from=paste0(.libPaths()[1],"/SDPResults/data/^.*\\.csv$"),
			            to=figs_dir)
  } else {

	        file.copy(from=paste0(.libPaths()[2],"/SDPResults/data/^.*\\.csv$"),
			                to=figs_dir)
  }

}



