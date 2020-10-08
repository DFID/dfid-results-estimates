#' make fp total table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableFPTotal<- function(data, cmp) {
  #!!! don't clean_names or year col_names will mess up !!!
  data %>%
    add_row(
      Department="Double Counting",
      Fragility="-",
      Region="-",
      `2015/16`=unlist(cmp[1]),
      `2016/17`=unlist(cmp[2]),
      `2017/18`=unlist(cmp[3]),
      `2018/19`=unlist(cmp[4]),
      `2019/20`=unlist(cmp[5]),
      Average = mean(unlist(cmp))
    ) %>%
    add_row(
      Department="Total",
      Fragility="-",
      Region="-",
      `2015/16`=sum(.$`2015/16`),
      `2016/17`=sum(.$`2016/17`),
      `2017/18`=sum(.$`2017/18`),
      `2018/19`=sum(.$`2018/19`),
      `2019/20`=sum(.$`2019/20`),
      Average = NA #add totals manually then swap out total avg.
    ) %>%
    mutate(Average = replace_na(Average, mean(unlist(.[nrow(.),4:8])))) %>%
    mutate_if(is.numeric, ~(
      case_when(
        Department!="Inclusive Societies" ~ roundChoose(.,1000),
        TRUE~.
      )
    )
    ) %>%
    mutate_if(is.numeric, ~(
      case_when(
        Department=="Inclusive Societies" ~ roundChoose(.,100),
        TRUE~.
      )
    )
    ) %>%
    mutate_if(is.numeric, ~(
      case_when(
        Department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    )
}

