

parse_uka <- function(datapath){
  if (all(grepl("UKA", list.files(path = datapath)) == F)){
    stop("There are no UKA files in the datapath")
  }
  files <- list.files(path = datapath, pattern = "UKA_", 
                      full.names = TRUE)
  df <- read_delim(files, id="path", 
                   col_select = c(`Kinase Name`, `Median Final score`, 
                                  `Median Kinase Statistic`, `Mean Specificity Score`),
                   show_col_types = F) %>%
    dplyr::rename("final_score" = `Median Final score`,
                  "spec_score" = `Mean Specificity Score`)
  


  
  df$origin <- sub(".*UKA_",  "", df$path)
  df$origin <- sub(".txt.*",  "", df$origin)
  df <- df %>% select(-path) %>% 
    tidyr::separate_wider_delim(cols = origin, delim = "_",
                    names = c("assay_type", "number", "comparison"))
  df$name <- paste(df$assay_type, df$comparison, sep = "-")
  
  df_list <- split(df, df$name)

  
  return(df_list)
}





plot_uka_score_per_exp <- function(df, filename, resultpath, color_type, scale_name, w, h,
                                   order_by, fscore_thr, max_num){
  
  if (order_by == "spec_score"){
    df <- df[order(df$`Mean Specificity Score`),]
  }
  df <- df %>% 
    filter(final_score >=fscore_thr) %>% 
    slice_head(n = max_num)
  
  df <- rownames_to_column(df, var = "Rank")
  
  p <- df %>%
    ggplot(., aes(x = `Median Kinase Statistic`, y = reorder(`Kinase Name`, desc(as.integer(`Rank`))))) +
    geom_bar(stat = "identity", aes(fill = eval(parse(text=color_type)))) +
    scale_fill_gradientn(
      name = scale_name, space = "Lab",
      colours = c("black", "grey", "red"),
      # values = c(0, 0.65, 1),
      # breaks = c(0, 0.65, 1),
      # limits = c(0, 1),
      # labels = c(0, 0.65, 1) * 2
    ) +
    labs(y = "Kinase Top List") +
    ggtitle(filename)
  

  ggsave(paste(resultpath, "/UKA_Score Plot_",filename, "_", color_type, ".png", sep = ''), p,
         width = w, height = h, units = "cm")
  
  # Same x axis for all score plots?   
  # range_df <- get_uka_data_range(df)
  # ks_min <- range_df %>% pull(min_mks)
  # ks_max <- range_df %>% pull(max_mks)
  
  # if (xax_scale == "yes") {
  #   p <- p + xlim(ks_min, ks_max)
  # }
  
  
  
}



plot_uka_scores <- function(datapath, resultpath, color_type, order_by = final_score, fscore_thr, w, h, max_num){
  
  scale_name <- ifelse(color_type == "final_score", "Median \nFinal \nScore", "Mean \nSpecificity \nScore")
  
  
  # get list of everything in folder
  all_files <- parse_uka(datapath = datapath)
  print(length(all_files))
  
  # plot uka for all
  for (i in seq_along(all_files)) {
    print(paste("Working on:", names(all_files[i])))
    plot_uka_score_per_exp(df = all_files[[i]], 
                           filename = names(all_files[i]),
                           resultpath = resultpath, 
                           color_type = color_type,
                           scale_name = scale_name,
                           w = w,
                           h = h,
                           order_by = order_by, 
                           fscore_thr = fscore_thr, 
                           max_num = max_num)
  }
}




# get_uka_data_range <- function(df) {
#   
#   df <- df %>%
#     group_by(assay_type) %>%
#     summarise(max_mks = max(`Mean Kinase Statistic`), min_mks = min(`Mean Kinase Statistic`)) %>%
#     mutate(max_mks = ceiling(max_mks / 0.5) * 0.5, min_mks = floor(min_mks / 0.5) * 0.5) %>%
#     mutate(max_mks = case_when(abs(min_mks) > max_mks ~ -min_mks,
#                                TRUE ~ max_mks),
#            min_mks = case_when(abs(min_mks) < max_mks ~ -max_mks,
#                                TRUE ~ min_mks))
#   return(df)
# }


