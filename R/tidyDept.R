#' tidy Dept Data tab
#'
#' tidies dept data read in with readDeptData and adds some stuff from lookup
#' @param data dept_raw
#' @importFrom magrittr %>%
#' @export

tidyDept  <-  function(bilateral_data, multilateral_data, lookup){

bilateral_data %>%
    # Remove brackets - indicator wording in some files have ()
  mutate(Indicator=str_replace_all(Indicator, "[()]", "")) %>%
    # Remove trailing spaces - issue with some encoding
  mutate(Department=sub("\\s+$", "", Department)) %>%
    # remove DFID from names
  mutate(Department=sub("DFID ", "", Department)) %>%
    # first convert to pub names
  mutate(Department= recode_factor(Department, !!!getPubNames(lookup))) %>%
    # use pub names to look up fragility
  mutate(Fragility = recode_factor(Department, !!!getFragStates(lookup))) %>%
    # use pub names to look up region
  mutate(Region = recode_factor(Department, !!!getRegion(lookup))) %>%
    # explicit fct levels
  mutate(Fragility = fct_explicit_na(Fragility, na_level = "Not Applicable")) %>%
  mutate(Region = fct_explicit_na(Region, na_level = "Not Applicable")) %>%
  mutate(Indicator = fct_explicit_na(Indicator, na_level="NA")) %>%
    # convert other factors
  mutate_if(is.character, as.factor) %>%
    # rename wash BEFORE janitor or camel WaSH converted to snake w_sh
  rename_at(vars("WaSH_Intervention"),tolower) %>%
  clean_names() %>%
  select(-department_code) %>%
  bindRowsKeepFactors(., multilateral_data)  %>%
    # add wash region as slighlty different -  added after multilat bind so multilat regions also added
  mutate(region_wash = recode_factor(department, !!!getVal(lookup,"region_wash", "dept_publication_name"))) %>%
    # add fp region as slightly different added after multilat bind so multilat regions also added
  mutate(region_fp = recode_factor(department, !!!getVal(lookup,"region_fp", "dept_publication_name"))) %>%
  mutate(region_wash = fct_explicit_na(region_wash, na_level = "Not Applicable")) %>%
  mutate(region_fp = fct_explicit_na(region_fp, na_level = "Not Applicable"))
}

