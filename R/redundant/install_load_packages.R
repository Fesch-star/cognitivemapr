# the code in this repository was made under R version R-4.0.2
# this script installs and loads all the packages needed to run the functions
# and scripts in this repository


# install the following packages
install.packages("tidyverse") # for data-wranging incl ggplot2, dplyr, tidyr, 
                              # readr, purr, tibble
install.packages("igraph") # for analysing graphs
install.packages("tidygraph") # analysing graphs in df mode with node & edgelists
install.packages("ggraph") # extension of ggplot2 tailored to graph visualizations.
install.packages("visNetwork") # package for network visualisation

# Loading the packages
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(visNetwork)
