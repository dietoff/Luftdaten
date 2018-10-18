# Luftdaten

Import the project in Rstudio  
run the following line in the console to install necessary packages:

`install.packages(c("slickR","shiny","leaflet","viridis","rgdal","rgl","curl","jsonlite"))`

the folder luft.map and 3d.map contain 2 different shiny apps you can run from Rstudio

you probably have to manually tinker with load.R and cron_leaf.R to cache the map data, i have them running as cron scripts, but you can load the maps just as well from the shiny app

http://dust.zone
http://offenhuber.net

Data from http://luftdaten.info
