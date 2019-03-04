##############################################
###  Data Science Bootcamp                 ###
###  Project 1 - Exploratory Visualization ###
###  Zhirui Zhag  / March 2, 2019          ###
###     Youtube Trending Videos in         ###
###  USA, UK, Canada, Germany, France      ###
##############################################

library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)
library(plotly)
library(dplyr)
library(shinyWidgets)
library(reshape2)
library(googleVis)
library(ggcorrplot)

#load data
all_spread = read.csv('./data/All_spread.csv', stringsAsFactors = FALSE)
all_no_spread = read.csv('./data/All_no_spread.csv', stringsAsFactors = FALSE)
all_corr = read.csv('./data/All_corr.csv', stringsAsFactors = FALSE)

