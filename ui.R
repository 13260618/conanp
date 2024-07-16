

#libraries for the backend

#library
#rm(list=ls())
library(tidyverse)
library(sf)
library(maps)
library(dplyr)
library(highcharter)
library(plotly)
library(ggplot2)

cols_sig = c("#a87000", "#ffbe3b","#abcd66","#3166ff","#bcb800","#e60000")
colores_identidad = c("#3E7C24", "#8e44ad","#CEBA92","#B53C0D",  "#123757")

library(scales)
library(htmlwidgets)
library(readxl)





#libraries for the frontend
library(shiny)
library(bslib)
library(htmltools)
library(plotly)
library(leaflet)


library(ggplot2)
library(palmerpenguins)
data(penguins, package = "palmerpenguins")
############################################################################

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Porcentaje cubierto por propiedad"),
    highchartOutput("mapa_advc")
    
    #plotOutput("bill_length")
  ),
  card(
    full_screen = TRUE,
    card_header("Tipos de vegetación"),
    highchartOutput("vegetacion")
    #plotOutput("bill_depth")
  ),
  card(
    full_screen = TRUE,
    card_header("Entidades federativas"),
highchartOutput("entidades_bars")
        
   # plotOutput("body_mass")
  ),
card(
  full_screen = TRUE,
  card_header("Decretos de ADVC desde 2002 - 2022"),
  highchartOutput("advc_uno")
  
 
)

)

color_by <- selectInput(
  "color_by", "Tipo de propiedad",
  choices = c("General", "Social", "Pública", "Privada"),
  selected = "General"
)


##############################################################################



means <- colMeans(
  penguins[c("bill_length_mm", "bill_depth_mm", "body_mass_g")],
  na.rm = TRUE
)



css <- "
        .sidebar {
          position: fixed;
          top: 0;
        }
 "
 
page_sidebar(
  
  theme = bs_theme(version = 5), # *mantener* para control de actualizaciones
  
  
title = "Numeralia ADVC",
sidebar = color_by,
fillable_mobile = TRUE,
#tags$head(tags$style(HTML(css))),
layout_columns(
  fill = FALSE,
  value_box(
    title = "Número de ADVC",
    value = HTML("<b>581</b>"),#scales::unit_format(unit = "mm")(means[[1]]),
    showcase = bsicons::bs_icon("tree-fill")
  ),
  value_box(
    title = "Superficie protegida",
    value =  "1,137,650.30 ha",#scales::unit_format(unit = "mm")(means[[2]]),
    showcase = bsicons::bs_icon("globe-americas")
  ),
  value_box(
    title = "Entidades federativas",
    value = 28,#scales::unit_format(unit = "g", big.mark = ",")(means[[3]]),
    showcase = bsicons::bs_icon("geo-alt")
  )
),
layout_columns(
  cards[[4]], cards[[2]]
),
layout_columns(
  cards[[3]], cards[[1]]
)

)

 



