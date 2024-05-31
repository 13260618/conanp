import plotly.graph_objects as go

# Datos de ejemplo para el mapa de México
mexico_states = ['Aguascalientes', 'Baja California', 'Baja California Sur', 'Campeche', 'Chiapas', 'Chihuahua',
                 'Coahuila', 'Colima', 'Durango', 'Guanajuato', 'Guerrero', 'Hidalgo', 'Jalisco', 'México', 'Michoacán',
                 'Morelos', 'Nayarit', 'Nuevo León', 'Oaxaca', 'Puebla', 'Querétaro', 'Quintana Roo', 'San Luis Potosí',
                 'Sinaloa', 'Sonora', 'Tabasco', 'Tamaulipas', 'Tlaxcala', 'Veracruz', 'Yucatán', 'Zacatecas']

# Valores de ejemplo para cada estado (puedes reemplazarlos con tus propios datos)
values = [10, 20, 15, 30, 25, 35, 40, 20, 10, 5, 15, 25, 30, 20, 10, 25, 20, 35, 30, 25, 20, 15, 10, 25, 30, 20, 15, 10, 5, 20, 15]

# Crear el mapa de México
fig = go.Figure(data=go.Choropleth(
    locations=mexico_states,  # Nombre de los estados
    z=values,  # Valor para cada estado
    locationmode='country names',  # Modo de ubicación (país)
    colorscale='Viridis',  # Escala de colores
    colorbar_title='Unidades',  # Título de la barra de colores
))

# Ajustes de diseño del mapa
fig.update_layout(
    title_text='Mapa de México',  # Título del mapa
    geo=dict(
        scope='north america',  # Ámbito geográfico
        showcoastlines=False,  # No mostrar las líneas de costa
        projection_type='mercator',  # Tipo de proyección (mercator)
        center={'lat': 23.6345, 'lon': -102.5528},  # Centro del mapa (coordenadas de México)
        lataxis={'range': [14, 33]},  # Rango de latitud para enfocarse en México
        lonaxis={'range': [-120, -80]},  # Rango de longitud para enfocarse en México
    ),
)

# Mostrar el mapa
fig.show()