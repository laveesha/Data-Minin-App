## Clear workspace (important for debugging in interactive session)
rm(list=ls())

## Load packages
library(shiny)
library(shinydashboard)
#library(shinyapps)
library(markdown)
library(gplots) ## for heatmap.2
library(RColorBrewer)

## Source
#source('heatmap2.R') # overwrite heatmap.2 from gplots with my customized version

## Global variables - used across pages and apps
#datGlobal <- NULL
#updGlobal <- 0                          # initialize counter to 0
