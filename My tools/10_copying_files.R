library(stringr)

files <- list.files(path_experiment, recursive = TRUE)

splited_path <- str_split(path_experiment, '/')[[1]]

blok <- splited_path[length(splited_path) - 1]
blok <- str_remove(blok, "_c.d")

# Unstructured data

parent_path <- paste0(package_path, "unstructured data/", blok, "/")
if(!dir.exists(parent_path)) {dir.create(parent_path)}
prep_files <- files[str_detect(files, "-PNG")]
files_from <- prep_files[str_detect(prep_files, "png$")]

folders <- unique(
  str_remove(
    str_split_fixed(files_from, "preprocessed/", 2)[,1], "-PNG"))

for(i in 1:length(folders))
{
  if(!dir.exists(paste0(parent_path, folders[i])))
  {
    dir.create(paste0(parent_path, folders[i]), recursive = TRUE)
  }
}

j <- 1
for(i in files_from)
{
  from <- paste0(path_experiment, i)
  dir_to <- str_remove(str_split(i, "preprocessed/", 2)[[1]][1], "-PNG")
  to <- paste0(parent_path, dir_to)
  file.copy(from, to)
  print(paste("step", j, "of", length(files_from)))
  j <- j + 1
}

# Control folder

parent_path <- paste0(package_path, "control folder/", blok, "/")
if(!dir.exists(parent_path)) {dir.create(parent_path)}
prep_files <- files[str_detect(files, "BMT$")]
files_from <- list.files(path_exported)
files_from <- files_from[str_detect(files_from, "_Zdjęcie rzeczywiste.JPG")]

folders <- unique(
  str_split_fixed(prep_files, "IR", 2)[,1])

for(i in 1:length(folders))
{
  if(!dir.exists(paste0(parent_path, folders[i])))
  {
  dir.create(paste0(parent_path, folders[i]), recursive = TRUE)
  }
}

j <- 1
for(i in prep_files)
{
  file <- str_sub(i, -12, -5)
  from <- paste0(path_exported, file, "_Zdjęcie rzeczywiste.JPG")
  save_path <- prep_files[str_detect(prep_files, file)]
  save_path <- str_replace(save_path, ".BMT", "_Zdjęcie rzeczywiste.JPG")
  to <- paste0(parent_path, save_path)
  file.copy(from, to)
  print(paste("step", j, "of", length(prep_files)))
  j <- j + 1
}

# BMT

parent_path <- paste0(package_path, "zdjęcia z kamery/BMT/", blok, "/")
if(!dir.exists(parent_path)) {dir.create(parent_path)}
files_from <- files[str_detect(files, "BMT$")]

folders <- unique(
  str_split_fixed(prep_files, "IR", 2)[,1])

for(i in 1:length(folders))
{
  if(!dir.exists(paste0(parent_path, folders[i])))
  {
    dir.create(paste0(parent_path, folders[i]), recursive = TRUE)
  }
}

j <- 1
for(i in files_from)
{
  from <- paste0(path_experiment, i)
  to <- paste0(parent_path, i)
  file.copy(from, to)
  print(paste("step", j, "of", length(files_from)))
  j <- j + 1
}

# Obrazy

parent_path <- paste0(package_path, "zdjęcia z kamery/obrazy/", blok, "/")
if(!dir.exists(parent_path)) {dir.create(parent_path)}
prep_files <- files[str_detect(files, "BMT$")]
files_from <- list.files(path_exported)
files_from <- files_from[str_detect(files_from, "PNG")]

folders <- unique(
  str_split_fixed(prep_files, "IR", 2)[,1])

for(i in 1:length(folders))
{
  if(!dir.exists(paste0(parent_path, folders[i])))
  {
    dir.create(paste0(parent_path, folders[i]), recursive = TRUE)
  }
}

j <- 1
for(i in prep_files)
{
  file <- str_sub(i, -12, -5)
  from <- paste0(path_exported, file, ".PNG")
  save_path <- prep_files[str_detect(prep_files, file)]
  save_path <- str_replace(save_path, ".BMT", ".PNG")
  to <- paste0(parent_path, save_path)
  file.copy(from, to)
  print(paste("step", j, "of", length(prep_files)))
  j <- j + 1
}


