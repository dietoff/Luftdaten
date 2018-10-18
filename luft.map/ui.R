

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(slickR)

imgs <- c("www/slider/rg0.jpg",
          "www/slider/rg1.jpg",
          "www/slider/rg10.jpg",
          "www/slider/rg11.jpg",
          "www/slider/rg12.jpg",
          "www/slider/rg13.jpg",
          "www/slider/rg14.jpg",
          "www/slider/rg15.jpg",
          "www/slider/rg2.jpg",
          "www/slider/rg3.jpg",
          "www/slider/rg4.jpg",
          "www/slider/rg5.jpg",
          "www/slider/rg6.jpg",
          "www/slider/rg7.jpg",
          "www/slider/rg8.jpg",
          "www/slider/rg9.jpg"
)

shinyUI(fillPage(
  tags$head(
    tags$style(
      type = "text/css",
      "
      .btn-link {
      color: white;
	}
      .legend {
      background-color: rgba(0,0,0,0.5);
      color: lightgrey;
      }
      .legend svg text line {
      fill: #bbb;
      }
      .ss-gray-out {
      opacity: 0 !important;
      }
      #shiny-disconnected-overlay {
      opacity: 0 !important;
      }
      a {
      color: white;
      }
      .pop .leaflet-popup-content-wrapper {
      background: #303030A0;
      color:#fff;
      }
      .pop .leaflet-popup-content-wrapper a {
      color:#fff;
      }
      .pop .leaflet-popup-tip-container {
      opacity: 0;
      }
      .slick-prev:before {
      color: white; 
      }
      .slick-next:before {
      color: white;
      }
      .slick-prev {
      left: 0px;
      z-index: 10;
      }
      .slick-next {
      right: 0px;
      z-index: 10;
}")
),
absolutePanel(
  top = 0,
  right = 0,
  width = 400,
  style = "z-index:1001; color:white; background-color: rgba(0, 0, 0, 0.75); padding-left: 10px; padding-right: 10px;",
  draggable = F,
  fixed = T,
  div(
    align = "right",
    HTML(
      '<button data-toggle="collapse" class="btn btn-link" data-target="#about">collapse</button>'
    )
  ),
  div(
    id = 'about',
    class = "collapse in",
    h2("Staubmarke", style = "color: 'white';"),
    helpText(
      "Staubmarken machen die Stadt zu einer Visualisierung der Feinstaubbelastung. Feinstaubpartikel akkumulieren sich als Patina auf den Oberflächen der Stadt. Staubmarken sind als ",
      a(href = "https://en.wikipedia.org/wiki/Reverse_graffiti", "Reverse Graffitis"),
      "ausgeführt, welche die Feinstaub-Patina partiell entfernen und als Kontrast sichtbar machen."
    ),
    slickR(obj = imgs, width = "100%", slickOpts = list(autoplay= T, autoplaySpeed=4000, dots = T), height = 216),
    #img(src="spray.jpg", width = 375),
    helpText(
      "Livedaten der ",
      a(href = "https://www.epa.gov/pm-pollution/particulate-matter-pm-basics", "PM 2.5 ", target = "new"),
      "Konzentration von ",
      a(href = "https://luftdaten.info", "luftdaten.info", target = "new"),
      br(),
      "Letztes Update ",
      format(file.mtime("dat.rdata"), "%d.%m.%y, %H:%M:%S"),
      "EDT   (",
      a(href = "http://dust.zone/s/3dmap", "3d map"),
      ")"),
	a(href = "staubmarke_map.jpg", "Download printable map"),
    helpText(
      "Ein Projekt von ",
      a(href = "http://offenhuber.net", target = "new", "Dietmar  Offenhuber"),"im Rahmen des Festivals ", a(href = "https://www.kulturregion-stuttgart.de/was/news/meldung/drehmoment-feinstaub-spurensuche-in-stuttgart.html", "Drehmoment", target = "new"),". Dank an Lara Roth, Jan Lutz, Michael Saup, Pierre-Jean Gueno, Annekatrin Baumann/HLRS, Fa. Diezel"
    ),
    img(src = "icon.png", width = 375)
  )

),

leafletOutput("leaflet", height = "100%")
    ))
