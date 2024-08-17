library(stringr)
path_from <- path_exported
path_to <- path_xls
files <- list.files(path_from)
files <- str_subset(files, "\\.xls$")
length(files)
files_path_from <- str_c(path_from,files)
file.copy(files_path_from, path_to)
