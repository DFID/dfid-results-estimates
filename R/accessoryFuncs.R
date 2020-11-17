#' Accessory function for Results. Mainly methods for doing lookup_tables.
#' Method for lookup_table table.
#' @param lookup_table a lookup_table table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getPubNames(lookup_table)
#' @export
getPubNames <- function(lookup_table){
  y <- lookup_table$dept_publication_name
  names(y) <- lookup_table$dept_from_dataset_name
  return(y)
}


#' Generalisation of Method for lookup_table table.
#' @param lookup_table a lookup_table table.
#' @param column1 values we have. Character (must be quoted).
#' @param column2 values we want. Character (must be quoted).
#' @keywords internal
#' @examples getPubNames(lookup_table)
#' @export
getVal <- function(lookup_table, column1, column2){
  y <- unlist(lookup_table[column1])
  names(y) <- unlist(lookup_table[column2])
  return(y)
}


#' Method for lookup_table table.
#' @param lookup_table a lookup_table table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getFragStates(lookup_table)
#' @export
getFragStates <- function(lookup_table, dept_pub_names=T){
  y <- lookup_table$fragility
  if(dept_pub_names==TRUE){
  names(y) <- lookup_table$dept_publication_name
  }else{
  names(y) <- lookup_table$dept_from_dataset_name
  }
  return(y)
}


#' Method for lookup_table table.
#' @param lookup_table a lookup_table table.
#' @param dept_pub_names use publication names rather than dataset names. Logical.
#' @keywords internal
#' @examples getRegion(lookup_table)
#' @export
getRegion <- function(lookup_table, dept_pub_names=T){
  y <- lookup_table$region
  if(dept_pub_names==TRUE){
    names(y) <- lookup_table$dept_publication_name
  }else{
    names(y) <- lookup_table$dept_from_dataset_name
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


#' Method for plotting.
#' @param colour hex xolor code. Character.
#' @param factor factor by which to lighten colour. Numeric.
#' @keywords internal
#' @examples lighten("#2E358B")
#' @export
lighten <- function(colour, factor=1.4){
  col <- col2rgb(colour)
  col <- col*factor
  col <- rgb(t(col), maxColorValue=255)
  col
}


#' bind rows
#' @param ... structured data
#' @keywords internal
#' @export
bindRowsKeepFactors <- function(...) {
  ## Identify all factors
  factors <- unique(unlist(
    map(list(...), ~ select_if(..., is.factor) %>% names())
  ))
  ## Bind dataframes, convert characters back to factors
  suppressWarnings(bind_rows(...)) %>%
    mutate_at(vars(one_of(factors)), factor)
}


#' rounding up or down
#' @param x numeric vector
#' @param roundTo integer
#' @param dir logical describing direction up or down
#' @keywords internal
#' @export
roundChoose <- function(x, roundTo, up=FALSE) {
  if(up == TRUE) {  ##ROUND UP
    x + (roundTo - x %% roundTo)
  } else {
    if(up == FALSE) {  ##ROUND DOWN
      x - (x %% roundTo)
    }
  }
}
