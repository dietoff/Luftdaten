#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rgdal)
kml <- readOGR("RG.kml")
k.coord <- as.data.frame(kml@coords)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$leaflet <- renderLeaflet({
    pl <- plasma(
      9,
      alpha = 1,
      begin = 0,
      end = 1,
      direction = 1
    )
    pal <- colorNumeric(palette = pl , domain =  c$level)
    pald <- colorNumeric(palette = pl , domain =  p$value)

    leaflet(c, options = leafletOptions(zoomControl = FALSE)) %>% setView(lng = 9.18,
                                                                          lat = 48.775,
                                                                          zoom = 15) %>%
      addProviderTiles("CartoDB.DarkMatter",
                       options = providerTileOptions(minZoom = 13, maxZoom = 18)) %>%
      addPolylines(
        data = c,
        color = ~ pal(level),
        weight = 2,
        opacity = 70
      )  %>%
      addLegend(
        "bottomright",
        pal = pal,
        values = ~ level,
        opacity = 1,
        title = "PM2.5 µg/m3",
	position = "bottomleft" 
      )  %>%
      addCircleMarkers(
        lng =  p$location.longitude,
        lat = p$location.latitude,
        # label = as.character(round(p$value)),
        label =  paste("PM2.5:", round(p$value, digits = 2), " µg/m3"),
        color = pald(p$value),
        fillOpacity = 1,
        radius = 4,
        stroke = F,
        labelOptions = labelOptions(
          noHide = F,
          textOnly = T,
          textsize = "13px",
          style = list('color' = 'white'),
          offset = c(-40, -10),
          direction = "right",
	  )
      ) %>%
      addMarkers(
        lng = k.coord$coords.x1,
        lat = k.coord$coords.x2,
        label = paste("RG", row(kml@data), sep = " "),
        labelOptions = labelOptions(
          noHide = T,
          permanent = T,
          textOnly = T,
          offset = c(40, 0),
          direction = "right",
          textsize = "13px",
          style = list("color" = "white")
        ),
        popup = paste(kml$Name, kml$description, sep = " "),
        # popup = paste(kml$Name, img(src = "dustmark_sm.jpg", width = 400), sep = " "),
        popupOptions = popupOptions(
          maxWidth = "100%",
          closeOnClick = T,
          className = "pop"
        ),
        icon = list(iconUrl = "dust.png", iconSize = c(30, 30))
      )
  })
})
