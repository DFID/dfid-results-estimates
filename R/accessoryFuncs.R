#' Accessory function for Results. Mainly methods for doing lookups.
#'
#' Method for lookup table.
#' @param lookup a lookup table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getPubNames(lookup)
#' @export
getPubNames <- function(lookup){
  y <- lookup$dept_publication_name
  names(y) <- lookup$dept_from_dataset_name
  return(y)
}

#' Generalisation of Method for lookup table.
#' @param lookup a lookup table.
#' @param column1 values we have. Character (must be quoted).
#' @param column2 values we want. Character (must be quoted).
#' @keywords internal
#' @examples getPubNames(lookup)
#' @export
getVal <- function(lookup, column1, column2){
  y <- unlist(lookup[column1])
  names(y) <- unlist(lookup[column2])
  return(y)
}



#' Method for lookup table.
#' @param lookup a lookup table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getFragStates(lookup)
#' @export
getFragStates <- function(lookup, dept_pub_names=T){
  y <- lookup$fragility
  if(dept_pub_names==TRUE){
  names(y) <- lookup$dept_publication_name
  }else{
  names(y) <- lookup$dept_from_dataset_name
  }
  return(y)
}


#' Method for lookup table.
#' @param lookup a lookup table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getRegion(lookup)
#' @export
getRegion <- function(lookup, dept_pub_names=T){
  y <- lookup$region
  if(dept_pub_names==TRUE){
    names(y) <- lookup$dept_publication_name
  }else{
    names(y) <- lookup$dept_from_dataset_name
  }
  return(y)
}


#' Method for plotting.
#' @param colour hex xolor code. Character.
#' @param factor factor by which to darken colour. Numeric.
#' @keywords internal
#' @examples darken("#2E358B", factor=1.4)
#' @export
darken <- function(colour, factor=1.4){
  col <- col2rgb(colour)
  col <- col/factor
  col <- rgb(t(col), maxColorValue=255)
  col
}

#' knit chapters
#' @param file File name.
#' @keywords internal
#' @examples darken("#2E358B", factor=1.4)
#' @export
doKnit <- function(file){
  # create full names of files
  rnw <- sprintf("%s.Rnw", file)
  tex <- sprintf("%s.tex", file)

  # if the rnw file doesn't exist, just exit and do nothing
  if(!file.exists(rnw)){
    return(NULL)
  }

  ## create the tex file if necessary
  # if the tex file doesn't exist, or it is older than the rnw file you have to create it
  if(!file.exists(tex) || file.info(tex)$mtime < file.info(rnw)$mtime){
    knit(input=rnw, output=tex)
  } else {
    # just return NULL
    NULL
  }
}


#' knit chapters
#' @param file File name.
#' @keywords internal
#' @examples darken("#2E358B", factor=1.4)
#' @export
knitAll <- function(files)
{
  ## loop through and knit each chapter file if the tex file is older
  for(a in files)
  {
    doKnit(file=a)
  }
}
