GroupedTables <- function(df) {
  
  table.list <- df[, c('Table', 'Years')]
  
  new.table.list <- table_list %>% 
    filter(!Years %in% c("1988-2020")) %>% 
    group_by(Years) %>% 
    summarize(values = list(Table))
  
  return(new.table.list)
}