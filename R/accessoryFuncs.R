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

