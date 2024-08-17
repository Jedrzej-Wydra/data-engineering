library(reshape2)
library(dplyr)
library(png)
library(ggplot2)
library(readxl)
library(plotly)
library(stringr)
setwd(path_experiment)

paths <- list.files(recursive = TRUE)
paths_diff <- paths[str_detect(paths, "/preprocessed/")]
paths_diff <- str_replace(paths_diff, "preprocessed/", "")
paths_diff <- str_replace(paths_diff[str_detect(paths_diff, "png$")], ".png", "")
paths <- paths[!str_detect(paths, "/preprocessed/")]
files_xlsx <- paths[str_detect(paths, ".xlsx$")]
files_png <- paths[str_detect(paths, ".PNG$")]

dirs <- str_split_fixed(paths[str_detect(paths, "-PNG")], 
                        "(?<=(-PNG/))I", 
                        2)[,1] %>%
  unique() %>%
  paste0("preprocessed")

dirs <- str_split_fixed(dirs, "(?<=sed)/I",2)[,1] %>% unique()

files_xlsx <- setdiff(files_xlsx, paste0(paths_diff, ".xlsx"))
files_png <- setdiff(files_png, paste0(paths_diff, ".PNG"))

for(i in 1:length(dirs))
{
  if(!dir.exists(dirs[i])) {dir.create(dirs[i])}
  if((length(list.files(dirs[i])) %% 2) != 0) 
  {
    print(paste("Error in", dirs[i]))
    break
  }
}



for(termo in 1:length(files_png))
{
  
  image <- suppressMessages(readPNG(files_png[termo]))
  
  excel <- suppressMessages(read_excel(files_xlsx[termo],
                      col_names = FALSE))
  
  cat("\014")
  print(paste0("step ", termo, " of ", length(files_png)))
  
}

