
library(shiny)
library(plotly)
library(reshape2)
library(readr)
library(stringr)
library(imager)
library(dplyr)

path <- path_experiment
path2 <- path_exported

setwd(path) 

files <- list.files(recursive = TRUE)
files <- files[str_detect(files, "/preprocessed/")]
ready_files <- files[str_detect(files, "/size_reduced/")]
done_files <- files[str_detect(files, "/results/")]

names_ready_files <- str_sub(ready_files, -8, -1)
names_done_files <- str_sub(done_files, -8, -1)

names <- setdiff(names_ready_files, names_done_files)

names <- sort(names)

real_photo <- paste0(path2, names, "_Zdjęcie rzeczywiste.JPG")

pre_dirs <- unique(str_split_fixed(files, "IR", 2)[,1])
pre_dirs <- pre_dirs[str_detect(pre_dirs, "/size_reduced/", negate = TRUE)]

dirs <- paste0(pre_dirs, "results")

for(i in dirs)
{
  if(!dir.exists(i)) {dir.create(i)}
}

list_of_tables <- list()

for(j in 1:length(names))
{
  print(paste("step", j, "of", length(names)))
  data_path <- ready_files[str_detect(ready_files, names[j])]
  list_of_tables[[j]] <- read_csv(data_path, show_col_types = FALSE)
}

list_of_images <- list()

for(k in 1:length(names))
{
  print(paste("step", k, "of", length(names)))
  image <- load.image(real_photo[str_detect(real_photo, names[k])])
  image <- resize_halfXY(resize_halfXY(image))
  list_of_images[[k]] <- image
}

if (interactive()) {
  
  ui <- fluidPage(fluidRow(
    
    verbatimTextOutput("step"),
    
    actionButton("goButton", "Next"),
    
    column(4,
           plotOutput("real", width = "100%")),
    
    column(7,
           plotlyOutput("plot", width = "100%"))),
    
    verbatimTextOutput("click"))
  
  server <- function(input, output) {
    
    indicator <- reactiveValues(i = 0, df_to_save = NULL, image = 0, data = NULL)
    
    observeEvent(input$goButton, 
                 {
                   indicator$i <- indicator$i + 1
                   if(indicator$i <= length(names))
                   {
                     stp <- as.numeric(indicator$i)
                     indicator$monit <- paste("step", stp, "of", length(names))
                     
                     indicator$data <- melt(as.matrix(list_of_tables[[indicator$i]]))
                     
                     
                     indicator$image <- list_of_images[[indicator$i]]
                   }
                   else
                   {
                     indicator$data$Var2 <- NULL
                     indicator$data$Var1 <- NULL
                     indicator$data$value <- NULL
                     indicator$data$Var2 <- 0
                     indicator$data$Var1 <- 0
                     indicator$data$value <- 0
                     indicator$d <- "Done! :D"
                     indicator$df_to_save <- NULL
                     indicator$image <- 0
                   }})
    
    output$step <- renderPrint({
      print(indicator$monit)
    })
    
    output$plot <- renderPlotly({
      p <- plot_ly(x=indicator$data$Var2, y=indicator$data$Var1,
                   color=indicator$data$value, 
                   key=indicator$data$value, 
                   type = "scatter",
                   mode = "markers")
      
      p %>% layout(dragmode = "lasso")
    })
    
    output$click <- renderPrint({
      if(indicator$i <= length(names))
      {
        termo <- str_detect(ready_files, names[indicator$i])
        name <- names[indicator$i]
        
        value <- as.numeric(event_data("plotly_selected")$key)
        value <- subset(value,value>quantile(value)[2])
        
        d <- c(name, round(mean(value), digits = 3))
        
        if (is.character(d[2])) write_csv(data.frame(file=d[1],mean=d[2]),file=str_replace(ready_files[termo], "/size_reduced/", "/results//"))
        
        if (is.character(d[2])) {d}
      }
      else {print('Done! :D')}
    })
    
    output$real <- renderPlot({
      plot(indicator$image, axes = FALSE)
    }
    )
    
  }
  shinyApp(ui, server)
}

