
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



############################################

df_advc <- read_excel("lista_advc_24.xlsx")

df_cert_year <- df_advc %>%
  group_by(certification_year) %>%
  summarise(count = n(),
            total_superficie = sum(superficie_certificada, na.rm = TRUE),
            .groups = 'drop')

####################################
sup_certificada = data.frame(
  tipo_propiedad =c("Social", "Privada", "Pública"),
  num_ADVC = c(397,175,9),
  superficie = c(1075345.59,191373.41, 7771.56),
  porc_cert=c(91.12,8.48,0.41)
)
tot = 1137650.30

colnames(sup_certificada)[1] <- "name"
colnames(sup_certificada)[4] <- "y"

sup_certificada$hover_text <-paste("Porcentaje del total protegido por ADVC <b>", sup_certificada$y, "</b> %",
                                   "<br>Superficie protegida:<b>", scales::comma(sup_certificada$superficie), "</b>ha") 


sup_certificada$color <- c("#123757","#B53C0D",  "#CEBA92")

df <-select(sup_certificada, name, y,color, hover_text)


##############################################33
df_surface_state <- df_advc %>%
  group_by(estado) %>%
  summarise(superficie = sum(superficie_certificada),
            num_advc = n())



df_surface_state <- df_surface_state %>%
  arrange(desc(superficie))




##############################################33

library(sf)
#advc_gjson <- read_sf("Json/EstadosMG2023.geojson")
#mexico_map <- st_read("data/destdv1gw.geojson")
mexico_json <- "countries/mx/mx-all"





data_advc_mexico <- df_surface_state %>% 
  select(Entidad = estado, superficie, num_advc)

data_advc_mexico$hover_text <- paste("<b>",data_advc_mexico$Entidad,"</b>",
                                     "cuenta con <b>", data_advc_mexico$num_advc, "</b> ADVC,"
                                     ,"con una superficie total protegida de <b>", 
                                     scales::comma(data_advc_mexico$superficie),"</b>ha"
)

new_data <- tibble(
  Entidad = c("Zacatecas", "Querétaro", "Distrito Federal"),
  superficie = c(0, 0,0),
  num_advc = c(0, 0,0),
  hover_text = c("La entidad actualmente no cuenta con ADVC")
)


data_advc_mexico <- bind_rows(data_advc_mexico, new_data)




##############################################33






library(shiny)


function(input, output, session) {
  # gg_plot <- reactive({
  #   
  #   ggplot(penguins) +
  #     geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
  #     theme_bw(base_size = 16) +
  #     theme(axis.title = element_blank())
  #   
  # })
  # 
  
  output$advc_uno <- renderHighchart({
    plot_ppal <- highchart() %>%
      hc_title(text = ' ') %>%
      hc_xAxis(categories = df_cert_year$certification_year,
               title = list(text = ""),
               labels = list(rotation = 270)
      ) %>%
      hc_yAxis_multiples(
        list(title = list(text = 'Superficie certificada (ha)'), opposite = FALSE, zeroline = FALSE),
        list(title = list(text = 'Porcentaje protegido'), opposite = TRUE, zeroline = FALSE)
      ) %>%
      hc_add_series(name = 'Superficie total (ha)', 
                    data = df_cert_year$total_superficie, 
                    type = 'column', 
                    color = colores_identidad[1]) %>%
      hc_add_series(name = 'Porcentaje protegido', 
                    data = df_cert_year$count, 
                    type = 'line', 
                    color = colores_identidad[4],
                    yAxis = 1,
                    marker = list(fillColor = colores_identidad[4], 
                                  lineWidth = 2, 
                                  lineColor = NULL)
      ) %>%
      hc_tooltip(shared = TRUE, crosshairs = TRUE) %>%
      hc_plotOptions(series = list(
        dataLabels = list(enabled = FALSE),
        showInLegend = TRUE
      ))
    
    plot_ppal
  })
  
  output$vegetacion <- renderHighchart({
    
    highchart() %>%
      hc_chart(
        type = 'pie',
        polar =FALSE,
        inverted = FALSE
      )%>%
      hc_xAxis(
        categories = df$name
      )%>%
      hc_add_series(
        df,
        name = "Número de ADVC",
        showInLegend = TRUE,
        innerSize = '35%',
        dataLabels =list(enabled =TRUE,
                         format = '{point.name}: {point.percentage:.2f}%'
        )
      )%>%
      hc_plotOptions(series = list(animation =FALSE))%>%
      hc_exporting(enabled = TRUE)%>%
      hc_tooltip(
        useHTML =TRUE,
        pointFormat ='{point.hover_text}'
      )
    
    
  })
  
  
  output$entidades_bars <- renderHighchart({
    hc_surf_state <- highchart() %>%
      hc_title(text = '') %>%
      hc_yAxis(title = list(text = "(Hectáreas)")) %>%
      hc_xAxis(categories = df_surface_state$estado,
               title = list(text = ""),
               reversed = TRUE) %>%
      hc_add_series(name = 'Superficie (ha)', 
                    data = df_surface_state$superficie, 
                    type = 'bar', 
                    color = colores_identidad[1]) %>%
      hc_tooltip(shared = TRUE, crosshairs = TRUE) %>%
      hc_plotOptions(series = list(
        dataLabels = list(enabled = FALSE),
        showInLegend = FALSE
      ))
    hc_surf_state <- hc_surf_state %>%
      hc_navigator(enabled = TRUE,
                   xAxis = list(
                     labels = list(enabled = FALSE),
                     title = list(text = "Zoom", color ="black")
                   )
                   
      ) %>%
      #hc_rangeSelector(enabled = TRUE) %>%
      hc_exporting(enabled = TRUE#,
                   #buttons = list(contextButton = list(
                   #menuItems = c("zoomIn", "zoomOut"))
                   #)
      )
    
    # Mostrar el gráfico
    hc_surf_state
    
    
  })
  
  output$mapa_advc <- renderHighchart({
    
    hcmap(mexico_json, 
          data = data_advc_mexico, 
          value = "num_advc",
          joinBy = c("woe-name", "Entidad"),
          name ="Superficie protegida",
          dataLabels = list(enabled = TRUE, 
                            format = '{point.name}'),
          borderColor = "white", borderWidth = 0.5,
          tooltip = list(
            valueDecimals = 0, 
            valuePrefix = "<br>Superficie:", valueSuffix = " ha",
            useHTML = TRUE,
            pointFormat = '{point.hover_text}'
            
          )
    ) %>%
      hc_mapNavigation(enabled = TRUE) %>%
      hc_title(text = "",
               align = "center",
               style = list(color = "#000000", 
                            fontWeight = "bold"))%>%
      hc_colorAxis(stops = list(
        list(0, "#C1FFC1"),   
        list(0.035, "#76C76B"),  
        list(0.5, "#48A73A"),  
        list(1, "#008B45")      
      ))%>%
      hc_credits(enabled =FALSE) %>%
      hc_exporting(enabled = TRUE)
    
    
  })
  
  
  #output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  
  #output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  
  
  
  #output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
  
  
  
  

}

