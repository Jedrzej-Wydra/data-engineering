library(dplyr)

background_temp <- 23

setwd(path_experiment)
blok <- str_split(path_experiment, 
                  '/')[[1]][length(str_split(path_experiment, 
                                             '/')[[1]])-1]

files <- list.files(recursive = TRUE)
files <- files[str_detect(files, '/results/')]

files_data <- str_remove(files, "/preprocessed/results")
files_data <- str_remove(files_data, "-PNG")

list <- str_split(files_data, '/')

n_col <- max(unlist(lapply(list, length))) + 1

data <- tibble()

for(i in 1:length(list))
{
  len <- length(list[[i]])
  photo <- list[[i]][len]
  location <- c(blok, setdiff(list[[i]], photo))
  row <- c(location, rep(NA, n_col - 1 - length(location)), photo)
  data <- rbind(data, row)
}

data <- tibble(data)

names(data) <- c(paste0('V', 1:(n_col-1)), 'file')

files_BMT <- list.files(recursive = TRUE)
files_BMT <- files_BMT[str_detect(files_BMT, 'BMT$')]

files_BMT_date <- tibble(file = str_sub(files_BMT, -12, -5),
                             date = file.info(files_BMT)$mtime)

mean_data <- NULL
for(i in 1:length(files))
{
  print(paste("step", i, "of", length(files)))
  mean_data <- rbind(mean_data, read_csv(files[i], show_col_types = FALSE))
}

group_columns <- grep("^V", names(data), value = TRUE)

data %>% 
  inner_join(files_BMT_date, by = 'file') %>% 
  inner_join(mean_data, by = 'file') %>%
  group_by(across(all_of(group_columns))) %>%
  mutate(age_hours = cumsum(c(0, diff(date)) + 1)) %>%
  mutate(thermogenesis = mean - background_temp,
         cr = min(abs(thermogenesis)),
         cr = min(ifelse(cr < 0.3 & cr > -0.3, cr, 0)),
         sign = ifelse(thermogenesis < 0, 1, -1),
         cr = cr*sign,
         sign = NULL,
         thermogenesis = thermogenesis + cr,
         cr = NULL,
         thermogenesis = ifelse(thermogenesis < 0, 0, thermogenesis)) -> blok_table

new_dir <- paste0(structured_path, blok, '/')

dir.create(new_dir)

write_csv(blok_table, file = paste0(new_dir, blok, '.csv'))


