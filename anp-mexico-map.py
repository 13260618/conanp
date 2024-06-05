import os
import sys

import pandas as pd



import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
import requests
import matplotlib_scalebar
from matplotlib_scalebar.scalebar import ScaleBar
from IPython.display import display

#print('Python', sys.version)
#print(pd.__name__, pd.__version__)
#print(gpd.__name__, gpd.__version__)
#print(requests.__name__, requests.__version__)
#print(plt.matplotlib.__name__, plt.matplotlib.__version__)
#print(matplotlib_scalebar.__name__, matplotlib_scalebar.__version__)





mx = gpd.read_file("data/mapa_mexico/")\
        .set_index('CLAVE')\
        .to_crs(epsg=4485)

edos = pd.DataFrame(mx.dissolve(by='CVE_EDO'))
print(edos.columns.tolist())
print(edos.loc[:, 'NOMEDO'])
display(edos.head())

entidades_anp = pd.read_csv("data/data-entidadesanp.csv")



total_entidades = entidades_anp.groupby('entidad_federativa').agg(total=('suma_superficie_dentro_entidad', 'sum')).reset_index()
edos_total = pd.merge(edos, total_entidades, how='left', left_on='NOMEDO', right_on='entidad_federativa')

print(total_entidades.columns.tolist())

display(total_entidades.head())
display(edos_total.head())


url = 'https://api.datamexico.org/tesseract/cubes/complexity_eci/aggregate.jsonrecords?cuts%5B%5D=Latest.Latest.Latest.1&drilldowns%5B%5D=Geography+Municipality.Geography.Municipality&drilldowns%5B%5D=Date+Day.Date.Year&measures%5B%5D=ECI&parents=false&sparse=false'
data_eci = requests.get(url).json()
eci = pd.DataFrame(data_eci['data'])\
    .assign(CLAVE=lambda x: x['Municipality ID'].astype(str).str.zfill(5))\
    .set_index('CLAVE')

eci.head()




fig, ax = plt.subplots()
edos_total.plot(column='total', legend=True, cmap='viridis_r', ax=ax)
plt.title('Mapa de México coloreado por cantidad total para cada estado')
plt.show()




