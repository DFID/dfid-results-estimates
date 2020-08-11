#' make final data tables
#' NEEDS WORK

makeTables <- function(lst_data,tables_titles){


#Title bits
title_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                          fontSize = 16, fontColour = "#000000", halign = "left")
info_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                         fontSize = 11, fontColour = "#000000", halign = "left")

#Table bits
col1_style <- createStyle(fontName= "GDS Transport Website",
                           fontSize = 11, fontColour = "#000000", halign = "left")

header_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                            fontSize = 11, fontColour = "#000000", halign = "center",
                            border = "TopBottom", borderColour = "#000000", borderStyle = "thin")

table_style <- createStyle(fontName= "GDS Transport Website",
                          fontSize = 11, fontColour = "#000000", halign = "right")

totals_style <- createStyle(fontName= "GDS Transport Website", textDecoration = "bold",
                            fontSize = 11, fontColour = "#000000", halign = "right",
                            border = "TopBottom", borderColour = "#000000", borderStyle = "thin")

background_style <- createStyle(fgFill = "white")

num_style <- createStyle(halign = "right")

frag_style <- createStyle(fontName= "GDS Transport Website", fontSize = 11, halign = "center")

# should be using _table which are final tables
lst_data <- lst_data

names(lst_data) <- unlist(tables_titles[,"tab"])


titles <- map(split(tables_titles[,2], seq(nrow(tables_titles[,2]))), setNames, "temp")
subtitles <- map(split(tables_titles[,3], seq(nrow(tables_titles[,3]))) , setNames, "temp")
type  <- map(split(tables_titles[,4], seq(nrow(tables_titles[,4]))), setNames, "temp")

titles_list <- purrr::map2(titles,subtitles, function(x,y){bind_rows(x,y)}) %>%
               purrr::map2(., type, function(x,y){bind_rows(x,y)})
names(titles_list) <- unlist(tables_titles[,"tab"])


wb <- openxlsx::createWorkbook()

purrr::imap(
  .x = lst_data,
  .f = function(df, object_name) {
    addWorksheet(wb = wb, sheetName = object_name)
    writeData(wb = wb, sheet = object_name, x = df, startCol = 1, startRow = 6)
    addStyle(wb, sheet=object_name, style = header_style, rows = 6, cols=1:ncol(df), gridExpand = T)
    addStyle(wb, sheet=object_name, style = table_style, rows = 1:nrow(df)+5,  cols=1:ncol(df), gridExpand = T, stack=T)
    addStyle(wb, sheet=object_name, style = col1_style, rows = 1:nrow(df)+5,  cols=1, gridExpand = T, stack=T)
    addStyle(wb, sheet=object_name, style = totals_style, rows = ifelse(nrow(df)==1,nrow(df)+5,nrow(df)+6),  cols=1:ncol(df), gridExpand = T, stack = T)
    conditionalFormatting(wb, sheet= object_name, style = num_style, cols = 1:23, rows = 1:66, type = "contains", rule = "0")
    #conditionalFormatting(wb, sheet=object_name, style = frag_style, cols = 2, rows = 1:60, type = "contains", rule = "Africa|Asia|Multi|Middle|Policy|Other")
    #conditionalFormatting(wb, sheet=object_name, style = frag_style, cols = 3, rows = 1:60, type = "contains", rule = "Frag|Not")
    setColWidths(wb, sheet=object_name, cols=1, widths = 28,ignoreMergedCells = FALSE)
    setColWidths(wb, sheet=object_name, cols=2:ncol(df), widths = 16,ignoreMergedCells = FALSE)

  }
)

purrr::imap(
  .x = titles_list,
  .f = function(df, object_name) {
    writeData(wb = wb, sheet = object_name, x = df, startCol = 1, startRow = 1, colNames = FALSE)
    addStyle(wb, sheet=object_name, style = title_style, rows = 1, cols=1)
    addStyle(wb, sheet=object_name, style = info_style, rows = 2:3,cols=1)
    addStyle(wb, sheet=object_name, style = background_style, rows = 1:60,  cols=1:23, gridExpand = T, stack=T)
  }
)


saveWorkbook(wb = wb, file = "tables/tables.xlsx", overwrite = TRUE)

}


