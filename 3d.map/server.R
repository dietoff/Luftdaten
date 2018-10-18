#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$rgl <- renderRglwidget({
    open3d(useNULL=T)
    view3d(phi = -70, theta = 0, zoom = 0.5)
    bg3d(color="black")
    
    lapply(lines, function(i)
      lines3d(i$x,
              i$y,
              rep(i$level-min(z), length(i$x))*0.005+0.0005,
              col = linecol[which(lev == i$level)],
              lit = F, lwd=3))
    
    persp3d(z = matrix(0,nrow = 2, ncol = 2),
            color = "white",
            texture= paste("./map",rad,".png",sep = ""),
            lit = F,
            axes = F,
            alpha = 0.5,
            xlab = "",
            ylab = "",
            zlab = "",
            add = T)
    
    points3d(z=0.001,x=points[,1],y=points[,2],
             color = "white",
             smooth = T)
    
    # text3d(z=0.01,x=points[,1],y=points[,2],
    # text = round(points$value),
    # color = "white",
    # cex = 0.8)
    
    if (surface) {
      persp3d(
        z <- (z-min(z))*.005,
        axes = T,
        color = linecol[surfcol],
        lit = T,
        # front = "lines",
        back = "culled",
        xlab = "",
        ylab = "",
        zlab = "",
        # forceClipregion = T,
        alpha = 0.5,
        add = T 
      )
    }
    
    rglwidget()
  })
})
