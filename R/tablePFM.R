#' make PFM additional table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tablePFM <- function(data) {
  data %>%
    mutate_at(vars(`2015/16`), ~( #these countries were not included in the Caribbean in 2015/16
      case_when(
        `2015/16` %in% c("Belize",
                         "Dominica",
                         "Grenada",
                         "Guyana",
                         "Jamaica",
                         "Suriname",
                         "Saint Lucia",
                         "St Vincent & the Grenadines",
                         "Haiti",
                         "Montserrat") ~ "-",
        TRUE~.
      )
    )
    ) %>%
    add_row(dept="Total",
            `2015/16`=as.character(length(unique(.$`2015/16`))-1),
            `2016/17`=as.character(length(unique(.$`2016/17`))-1),
            `2017/18`=as.character(length(unique(.$`2017/18`))-1),
            `2018/19`=as.character(length(unique(.$`2018/19`))-1),
            `2019/20`=as.character(length(unique(.$`2019/20`))-1)
    ) %>%
    mutate(dept = recode(dept, "-"="")) %>%
    rename(Department="dept")

}

