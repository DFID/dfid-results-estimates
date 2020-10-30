#' format final data tables
#' NEEDS WORK

formatTables <- function(lst_data, tables_titles, ntd_table_two){

  if(length(lst_data)!=nrow(tables_titles)) stop("Number of tables does not equal number of table titles")

#Title bits
title_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                          fontSize = 16, fontColour = "#000000", halign = "left")
info_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                         fontSize = 11, fontColour = "#000000", halign = "left")

#Table bits
number_style <- createStyle(fontName= "GDS Transport Website",
                           fontSize = 11, fontColour = "#000000", halign = "right", numFmt = "#,##0;-#,##0;0")
pound_style <- createStyle(fontName= "GDS Transport Website",
                            fontSize = 11, fontColour = "#000000", halign = "right", numFmt = paste0("\U00A3","0,0"))
dollar_style <- createStyle(fontName= "GDS Transport Website",
                           fontSize = 11, fontColour = "#000000", halign = "right", numFmt = "$0,0")


# first column where dept
department_style <- createStyle(fontName= "GDS Transport Website",
                                fontSize = 11, fontColour = "#000000", halign = "left")
# frag states and region
factor_style <- createStyle(fontName= "GDS Transport Website",
                            fontSize = 11, fontColour = "#000000", halign = "center")

header_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                            fontSize = 11, fontColour = "#000000", halign = "center",
                            border = "TopBottom", borderColour = "#000000", borderStyle = "thin")

totals_style_bold <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                            fontSize = 11, fontColour = "#000000", halign = "right",
                            border = "TopBottom", borderColour = "#000000", borderStyle = "thin")

totals_style_plain <-  createStyle(fontName= "GDS Transport Website", fontSize = 11, fontColour = "#000000",
                                   halign = "right", border = "Bottom", borderColour = "#000000", borderStyle = "thin")

totals_style_plain_center <-  createStyle(fontName= "GDS Transport Website", fontSize = 11, fontColour = "#000000",
                                   halign = "center", border = "Bottom", borderColour = "#000000", borderStyle = "thin")

background_style <- createStyle(fgFill = "white")




# should be using "_table" which are final tables
lst_data <- lst_data
names(lst_data) <- unlist(tables_titles[,"tab"])

titles <- map(split(tables_titles[,2], seq(nrow(tables_titles[,2]))), setNames, "temp")
subtitles <- map(split(tables_titles[,3], seq(nrow(tables_titles[,3]))) , setNames, "temp")
type  <- map(split(tables_titles[,4], seq(nrow(tables_titles[,4]))), setNames, "temp")

titles_list <- purrr::map2(titles,subtitles, function(x,y){bind_rows(x,y)}) %>%
               purrr::map2(., type, function(x,y){bind_rows(x,y)})
names(titles_list) <- unlist(tables_titles[,"tab"])


# create workbook
wb <- openxlsx::createWorkbook()

# add tables in row 6 leaving space for header
purrr::imap(
  .x = lst_data,
  .f = function(df, object_name) {
    addWorksheet(wb = wb, sheetName = object_name)
    writeData(wb = wb, sheet = object_name, x = df, startCol = 1, startRow = 6)
  }
)

# write second NTD table to Table_17
writeData(wb = wb, sheet = "Table_17", x = ntd_table_two, startCol = 1, startRow = 9)

# Table 1 - Access to Finance
addStyle(wb, sheet="Table_1", style = header_style, rows = 6, cols=1:4)
addStyle(wb, sheet="Table_1", style = totals_style_plain, rows=7, cols=1:4)
addStyle(wb, sheet="Table_1", style = number_style, rows=7, cols=1:4, stack=T)

# Table 2 - CDC
addStyle(wb, sheet="Table_2", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_2", style = totals_style_plain_center, rows = 7, cols=1:5)
addStyle(wb, sheet="Table_2", style = createStyle(border = "right", borderColour = "#000000", borderStyle = "mediumDashed"), rows = 6:7, cols=1, stack = T)

# Table_3 - Climate Finance
addStyle(wb, sheet="Table_3", style = header_style, rows = 6, cols=1:6)
addStyle(wb, sheet="Table_3", style = pound_style, rows = 7, cols=1:6)
addStyle(wb, sheet="Table_3", style = totals_style_plain_center, rows = 7, cols=1:6, stack = T)
addStyle(wb, sheet="Table_3", style = createStyle(fontColour = "#808080"), rows = 6:7, cols=1, stack = T)

# Table 4 - DevCap
addStyle(wb, sheet="Table_4", style = header_style, rows = 6, cols=1:6)
addStyle(wb, sheet="Table_4", style = pound_style, rows = 7, cols=1:6)
addStyle(wb, sheet="Table_4", style = totals_style_plain_center, rows = 7, cols=1:6, stack=T)

# Table 5 - Education
addStyle(wb, sheet="Table_5", style = header_style, rows = 6, cols=1:7)
addStyle(wb, sheet="Table_5", style = totals_style_bold, rows = 35, cols=1:7)
addStyle(wb, sheet="Table_5", style = department_style, rows = 6:35, col = 1, stack = T)
addStyle(wb, sheet="Table_5", style = factor_style, rows = 7:35, col = 2:3, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_5", style = number_style, rows = 7:35, col = 4:7, stack = T, gridExpand = T)

# Table 6 - Energy
addStyle(wb, sheet="Table_6", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_6", style = totals_style_plain_center, rows = 7, cols=1:5)

# Table 7 - Family Planning: Total
addStyle(wb, sheet="Table_7", style = header_style, rows = 6, cols=1:9)
addStyle(wb, sheet="Table_7", style = totals_style_bold, rows = 31, cols=1:9)
addStyle(wb, sheet="Table_7", style = department_style, rows = 6:31, col = 1, stack = T)
addStyle(wb, sheet="Table_7", style = factor_style, rows = 7:31, col = 2:3, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_7", style = number_style, rows = 7:31, col = 4:9, stack = T, gridExpand = T)

# Table 8 - Family Planning: Additional
addStyle(wb, sheet="Table_8", style = header_style, rows = 6, cols=1:2)
addStyle(wb, sheet="Table_8", style = totals_style_bold, rows = 9, cols=1:2)
addStyle(wb, sheet="Table_8", style = department_style, rows = 7:9, col = 1, stack = T)
addStyle(wb, sheet="Table_8", style = createStyle(halign = "left"), rows = 7:8, col = 1, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_8", style = number_style, rows = 7:9, col = 2, stack = T, gridExpand = T)

# Table 9 - FCAS
addStyle(wb, sheet="Table_9", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_9", style = totals_style_plain_center, rows = 7, cols=1:5)

# Table 10 - Humanitarian
addStyle(wb, sheet="Table_10", style = header_style, rows = 6, cols=1:7)
addStyle(wb, sheet="Table_10", style = totals_style_bold, rows = 38, cols=1:7)
addStyle(wb, sheet="Table_10", style = department_style, rows = 6:38, cols = 1, stack = T)
addStyle(wb, sheet="Table_10", style = factor_style, rows = 7:38, col = 2:3, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_10", style = number_style, rows = 7:38, col = 4:7, stack = T, gridExpand = T)

# Table 11 - Immunisations
addStyle(wb, sheet="Table_11", style = header_style, rows = 6, cols=1:6)
addStyle(wb, sheet="Table_11", style = number_style, rows = 7:8, cols=2:6, gridExpand = T)
addStyle(wb, sheet="Table_11", style = totals_style_plain, rows = 8, cols=1:6, stack=T)
addStyle(wb, sheet="Table_11", style = department_style, rows = 7:8, cols = 1, stack = T)

# Table 12 - Improve Tax
addStyle(wb, sheet="Table_12", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_12", style = pound_style, rows = 7, cols=1:5)
addStyle(wb, sheet="Table_12", style = totals_style_plain_center, rows = 7, cols=1:5, stack=T)

# Table 13 - Multilat
addStyle(wb, sheet="Table_13", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_13", style = factor_style, rows = 7, cols=1:5)
addStyle(wb, sheet="Table_13", style = totals_style_plain_center, rows = 8, cols=1:5, stack = T)

# Table 14 - Jobs
addStyle(wb, sheet="Table_14", style = header_style, rows = 6, cols=1:4)
addStyle(wb, sheet="Table_14", style = number_style, rows = 7, cols=1:4)
addStyle(wb, sheet="Table_14", style = totals_style_plain, rows = 7, cols=1:4, stack=T)

# Table 15 - Malaria Spend
addStyle(wb, sheet="Table_15", style = header_style, rows = 6, cols=1:4)
addStyle(wb, sheet="Table_15", style = pound_style, rows = 7, cols = 1:4)
addStyle(wb, sheet="Table_15", style = totals_style_plain_center, rows = 7, cols = 1:4, stack=T)

# Table 16 - NTD Spend
addStyle(wb, sheet="Table_16", style = header_style, rows = 6, cols=1:4)
addStyle(wb, sheet="Table_16", style = pound_style, rows = 7:8, cols=2:4, gridExpand = T)
addStyle(wb, sheet="Table_16", style = totals_style_plain, rows = 8, cols=1:4, stack = T)
addStyle(wb, sheet="Table_16", style = department_style, rows = 7:8, cols = 1, stack = T)

# Table 17 - NTD
# top table
addStyle(wb, sheet="Table_17", style = header_style, rows = 6, cols=1:3)
addStyle(wb, sheet="Table_17", style = number_style, rows = 7, cols=1:3, stack = T)
addStyle(wb, sheet="Table_17", style = totals_style_plain, rows = 7, cols=1:3, stack = T)

# bottom table
addStyle(wb, sheet="Table_17", style = header_style, rows = 9, cols=1:2)
addStyle(wb, sheet="Table_17", style = number_style, rows = 10:14, cols=2, stack = T)
addStyle(wb, sheet="Table_17", style = totals_style_bold, rows = 14, cols=1:2, stack = T)
addStyle(wb, sheet="Table_17", style = department_style, rows = 10:14, cols = 1, stack = T)

# Table 18 - Nutrition
addStyle(wb, sheet="Table_18", style = header_style, rows = 6, cols=1:7)
addStyle(wb, sheet="Table_18", style = totals_style_bold, rows = 39, cols=1:7)
addStyle(wb, sheet="Table_18", style = department_style, rows = 6:39, col = 1, stack = T)
addStyle(wb, sheet="Table_18", style = factor_style, rows = 7:39, col = 2:3, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_18", style = number_style, rows = 7:39, col = 4:7, stack = T, gridExpand = T)

# Table 19 - ODA
addStyle(wb, sheet="Table_19", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_19", style = totals_style_plain_center, rows = 7, cols=1:5)

# Table 20 - PQI
addStyle(wb, sheet="Table_20", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_20", style = totals_style_plain_center, rows = 7, cols=1:5)

# Table 21 - PSI
addStyle(wb, sheet="Table_21", style = header_style, rows = 6, cols=1:7)
addStyle(wb, sheet="Table_21", style = dollar_style, rows = 7, cols=2:7)
addStyle(wb, sheet="Table_21", style = pound_style, rows = 8, cols=2:7)
addStyle(wb, sheet="Table_21", style = totals_style_plain, rows = 8, cols=1:7, stack = T)
addStyle(wb, sheet="Table_21", style = department_style, rows = 6:8, cols = 1, stack = T)

# Table 22 - Polio
addStyle(wb, sheet="Table_22", style = header_style, rows = 6, cols=1:5)
addStyle(wb, sheet="Table_22", style = totals_style_plain_center, rows = 7, cols=1:5)

# Table 23 - PFM
addStyle(wb, sheet="Table_23", style = header_style, rows = 6, cols=1:6)
addStyle(wb, sheet="Table_23", style = totals_style_bold, rows = 56, cols=1:6, stack = T)
addStyle(wb, sheet="Table_23", style = number_style, rows = 56, cols=2:6, stack = T)
addStyle(wb, sheet="Table_23", style = department_style, rows = 6:56, col = 1, stack = T)
addStyle(wb, sheet="Table_23", style = createStyle(fontName= "GDS Transport Website", fontSize = 11, halign="left"), rows = 7:55, col = 2:6, stack = T, gridExpand = T)

# Table 24 - WASH
addStyle(wb, sheet="Table_24", style = header_style, rows = 6, cols=1:7)
addStyle(wb, sheet="Table_24", style = totals_style_bold, rows = 35, cols=1:7)
addStyle(wb, sheet="Table_24", style = department_style, rows = 6:35, col = 1, stack = T)
addStyle(wb, sheet="Table_24", style = factor_style, rows = 7:35, col = 2:3, stack = T, gridExpand = T)
addStyle(wb, sheet="Table_24", style = number_style, rows = 7:35, col = 4:7, stack = T, gridExpand = T)


# Add header info from titles_list
purrr::imap(
  .x = titles_list,
  .f = function(df, object_name) {
    writeData(wb = wb, sheet = object_name, x = df, startCol = 1, startRow = 1, colNames = FALSE)
    addStyle(wb, sheet=object_name, style = title_style, rows = 1, cols=1)
    addStyle(wb, sheet=object_name, style = info_style, rows = 2:3,cols=1)
    addStyle(wb, sheet=object_name, style = background_style, rows = 1:60,  cols=1:23, gridExpand = T, stack=T)
  }
)

# set col widths
purrr::imap(
  .x = titles_list,
  .f = function(df, object_name) {
setColWidths(wb, sheet=object_name, cols=1, widths = 28)
setColWidths(wb, sheet=object_name, cols=2:23, widths = 20)
  }
)

saveWorkbook(wb = wb, file = "tables/tables.xlsx", overwrite = TRUE)

}


