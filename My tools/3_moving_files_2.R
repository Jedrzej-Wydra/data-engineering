START <- Sys.time()

library(stringr)

path <- path_experiment
path2 <- path_exported
path3 <- path_xlsx

files1 <- list.files(path, recursive = TRUE)

files <- str_sub(files1, start = -12, end = -1)

dir_files <- unique(str_sub(files1, start = 1, end = -14))

dirs <- paste0(path,dir_files, "-PNG")
for(i in dirs)
{
  dir.create(i)
}

files_png <- str_replace_all(files,".BMT",".PNG")
files_xlsx <- str_replace_all(files,".BMT",".xlsx")

files_from <- c(paste0(path2, files_png), paste0(path3, files_xlsx))
files_to1 <- paste0(path,str_sub(files1, start = 1, end = -14), "-PNG", '/', files_png)
files_to2 <- paste0(path,str_sub(files1, start = 1, end = -14), "-PNG", '/', files_xlsx)

file.copy(files_from, c(files_to1,files_to2))

Sys.time() - START