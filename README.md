# UKA_scoreplot
Makes simple UKA scoreplots.

## ARGUMENTS:

--datapath 	path to folder where UKA tables are.

--resultpath	path to result folder

--color_type	Coloring on: "final_score" or "spec_score" (specificity score). Default: final_score

--order_by	Order by: "final_score" or "spec_score" (specificity score"). Default: final_score

--fscore_thr	Final Score threshold. Default: 1.3

--w		width of resulting png. Default: 12

--h		height of resulting png. Default: 10

--max_num	max number of kinases to show on plot. Default: 20




## RUN:

1. Pull repository.
2. Make a folder with the input data in this repository. Make an empty folder for your output data.
3. Open repository in command line
4. Check your R path, where R is stored in your computer, e.g. "C:\Program Files\R\R-4.2.3\bin\Rscript.exe" 

An example run command:

"C:\Program Files\R\R-4.2.3\bin\Rscript.exe" scoreplot.R --datapath "./input/" --resultpath "./output/" --color_type "spec_score"
