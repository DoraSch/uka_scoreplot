
library(tidyverse)
library(optparse)
source("scoreplot_functions.R")

defaultW <- getOption("warn")
options(warn = -1)


option_list = list(
  make_option(c("--datapath"), action="store", default=NA, type='character',
              help="path to folder where UKA tables are"),
  make_option(c("--resultpath"), action="store", default=NA, type='character',
              help="path to result folder"),
  make_option(c("--color_type"), action="store", default='final_score', type='character',
              help="Coloring on: final_score or spec_score (specificity score)"),
  make_option(c("--order_by"), action="store", default='final_score', type='character',
              help="Order by: final_score or spec_score (specificity score"),
  make_option(c("--fscore_thr"), action="store", default=1.3, type='numeric',
              help="Final Score threshold"),
  make_option(c("--w"), action="store", default=12, type='numeric',
              help="width"),
  make_option(c("--h"), action="store", default=10, type='numeric',
              help="height"),
  make_option(c("--max_num"), action="store", default=20, type='numeric',
              help="max number of kinases")
)


opt = parse_args(OptionParser(option_list=option_list))

print(opt)



datapath <- "./input"



plot_uka_scores(datapath = opt$datapath, 
                resultpath = opt$resultpath, 
                color_type = opt$color_type, 
                order_by = opt$order_by,
                fscore_thr = opt$fscore_thr,
                w = opt$w,
                h = opt$h,
                max_num = opt$max_num)



