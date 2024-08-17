START <- Sys.time()
library(reshape2)
library(dplyr)
library(png)
library(readxl)
library(stringr)
library(readr)

path <- path_experiment
path2 <- path_exported

setwd(path) 

files <- list.files(recursive = TRUE)
files <- files[str_detect(files, "/preprocessed/")]
files <- files[str_detect(files, "(png)$", negate = TRUE)]
done_files <- files[str_detect(files, "/size_reduced/")]
done_files <- str_remove_all(done_files, "size_reduced/")
files <- files[str_detect(files, "/size_reduced/", negate = TRUE)]

files <- setdiff(files, done_files)

names <- str_sub(files, -8, -1)

names <- sort(names)

pre_dirs <- unique(str_split_fixed(files, "IR", 2)[,1])

dirs <- paste0(pre_dirs, "size_reduced")

for(i in dirs)
{
  if(!dir.exists(i)) {dir.create(i)}
}


for(termo in 1:length(names))
{
  
  print(paste("step",termo,"of",length(files)))
  
  termo_photo <- files[str_detect(files, names[termo])]
  
  m <- read_csv(termo_photo, show_col_types = FALSE)
  names(m) <- as.character(1:length(m))
  m <- melt(as.matrix(m)[1:1000,3:1330])
  
  m2 <- m %>% mutate(g1 = ceiling(Var1 / 8), g2 = ceiling(Var2 / 8)) %>% 
    mutate(Var1, Var2, value, g = paste0(g1,"-",g2)) %>% group_by(g) %>% 
    summarise(Var1=mean(g1), Var2=mean(g2), value=mean(value)) %>% 
    acast(Var1~Var2) %>% round(digits = 3)
  
  save_path <- str_replace(termo_photo, "/preprocessed/", "/preprocessed/size_reduced/")
  
  write_excel_csv(as.data.frame(m2),file=save_path)
  
}

Sys.time() - START
