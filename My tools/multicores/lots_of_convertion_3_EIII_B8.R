START <- Sys.time()

library(reshape2)
library(dplyr)
library(png)
library(ggplot2)
library(readxl)
library(plotly)
library(stringr)

setwd("/Users/ww.jedrzej/Library/CloudStorage/OneDrive-Osobisty/UAM/VII rok/NCN/unstructered data/EIII_B8/")

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
}

  for(termo in 1:length(files_png))
  {
    
    image <- readPNG(files_png[termo])
    
    excel <- read_excel(files_xlsx[termo],
                        col_names = FALSE)
    
    max <- round(max(as.numeric(as.matrix(excel)),na.rm=TRUE),digits = 1)
    min <- round(min(as.numeric(as.matrix(excel)),na.rm=TRUE),digits = 1)
   
    bar <- image[72:929,1385:1481,1]
    test <- bar
    test <- test[,49]
    data <- as.data.frame(bar)
    
    q <- function(x)
    {
      sum(x!=test)
    }
    
    sum(unlist(lapply(data,q)))
    
    f.color <- image[72:929,1433,]
    up <- max
    down <- min
    m.color <- data.frame(as.data.frame(f.color[1:858,]))
    m.color <- m.color[!duplicated(m.color),]
    t.color <- seq(from=round(up,digits = 2), to=round(down,digits = 2),
                   length.out=dim(m.color)[1])
    m.color <- data.frame(m.color,t.color)
    thermo_image <- image[,1:1332,]
    matrix_image <- matrix(NA, nrow=1000, ncol=1332)
    
    for(i in 1:1000)
    {
      for(j in 1:1332)
      {
        X1 <- thermo_image[i,j,][1]
        X2 <- thermo_image[i,j,][2]
        X3 <- thermo_image[i,j,][3]
        value <- subset(m.color,m.color$V1==X1&m.color$V2==X2&m.color$V3==X3)$t.color
        if(length(value)==0)
        {
          value <- m.color %>%
            mutate(dist=(V1-X1)^2+(V2-X2)^2+(V3-X3)^2) %>%
            subset(dist==min(dist))
          value <- mean(value$t.color)
        }
        matrix_image[i,j] <- value
      }
    }
    
    matrix_image <- matrix_image[dim(matrix_image)[1]:1,]
    
    m <- melt(matrix_image)
    plot <- ggplot(data=m,aes(x=Var2, y=Var1, fill=value))+geom_tile()+theme_void()+
      scale_fill_gradientn(limits=c(10, 30),
                           colors = c("blue","cornflowerblue","cyan","green","yellow","orange","red"))
    
    save_path <- str_split_fixed(files_png[termo], 
                                 "(?<=(-PNG))/", 
                                 2) %>% 
      as.character()
    
    ggsave(paste0(save_path[1],
                  "/preprocessed/",
                  str_sub(save_path[2], 1, -5),
                  ".png"),
           plot=plot,device = "png",
           width = 1600,
           height = 1000,
           units = "px",
           bg = "white")
    
    write.csv(matrix_image,
              file = paste0(save_path[1],
                            "/preprocessed/",
                            str_sub(save_path[2], 1, -5)),
              row.names = FALSE)
    
  }
  


Sys.time() - START

