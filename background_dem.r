library(lidR)
library(future)
library(raster)
library(rgdal)

set_lidr_threads(128)

# Create a lidR catalog of an entire collection
ctg <- readLAScatalog("/home/rstudio/jemez/lidar/laz/USGS_LPC_NM_NorthCentral")

dem_tin <- grid_terrain(ctg, 2, tin())

dem_prod <- terrain(dem_tin, opt = c("slope", "aspect"))
dem_hillshade <- hillShade(slope = dem_prod$slope, aspect = dem_prod$aspect)
plot(dem_hillshade, col = gray.colors(50, 0 ,1), legend = FALSE)
writeRaster(dem_hillshade,'/home/rstudio/usgs_dem_hillshade.tif',options=c('TFW=YES'))
writeRaster(dem_tin,'/home/rstudio/usgs_dem_tin.tif',options=c('TFW=YES'))