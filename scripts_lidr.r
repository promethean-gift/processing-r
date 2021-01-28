library(lidR)
library(future)
library(raster)
library(rgdal)
#plan(multisession)

# Create a lidR catalog of an entire collection

ctg <- readLAScatalog("/home/rstudio/jemez/lidar/laz/NM_SouthCentral_B9_2018/laz/")

ctg

plot(ctg, map=TRUE)

lascheck(ctg)

lidR:::catalog_makecluster(ctg, realignment = list(res = 20, start = c(0,0))) # ok

opt_stop_early(ctg) <- FALSE
opt_chunk_buffer(ctg) <- 100
opt_filter(ctg) <- "-drop_withheld -drop_class 7 18"
opt_output_files(ctg) <- "/home/rstudio/dtm/{*}"
opt_progress(ctg) <- TRUE

# Read an individual *.laz file into lidR

las <- readLAS("/home/rstudio/jemez/lidar/laz/NM_South_Central_B9_2018/NM_SouthCentral_B9_2018__17.laz")

# Create DEM
dem_tin <- grid_terrain(ctg, res = 1, algorithm = tin())

# Write DEM to disk

writeRaster(dem_tin,'/home/rstudio/dem_tin.tif',options=c('TFW=YES'))

# Plot in R

plot(dem_tin, col = gray.colors(50, 0, 1))

# Create Hillshade

dem_prod <- terrain(dem_tin, opt = c("slope", "aspect"))

dem_hillshade <- hillShade(slope = dem_prod$slope, aspect = dem_prod$aspect)
plot(dem_hillshade, col = gray.colors(50, 0 ,1), legend = FALSE)

# Write Hillshade to disk

writeRaster(dem_hillshade,'/home/rstudio/dem_hillshade.tif',options=c('TFW=YES'))

# Normalize point cloud height to the DEM

dem <- raster('/home/rstudio/dem_tin.tif')
nlas <- normalize_height(ctg, dem)

plot(nlas)

# Create Canopy Height Model 

chm <- grid_canopy(nlas, res = 0.3333, algorithm = p2r())

# Write CHM to disk

writeRaster(chm,'/home/rstudio/chm.tif',options=c('TFW=YES'))

# Khosravipour et al. pitfree algorithm

chm_pitfree <- grid_canopy(nlas, res = 0.3333, pitfree(c(0,2,5,10,15), c(0, 1.5)))

writeRaster(chm_pitfree, '/home/rstudio/chm_pitfree.tif',options=c('TFW=YES'))

# Local Maxima Tree Locations

# Create function that selects with a variable area window

f <- function(x){
  y <- 2.6 * (-(exp(-0.1*(x-2)) - 1)) + 1
  y[x < 2] <- 0.5
  y[x > 20] <- 3.2
  return(y)
}

heights <- seq(-5,30,0.5)

ws <- f(heights)

# view the variable area model

plot(heights, ws, type = "l",  ylim = c(0,5))

# Locate Tree tops

ttops <- tree_detection(chm_pitfree, lmf(f))

plot(chm, col = height.colors(50))
plot(ttops, add = TRUE)

# Write Tree locations to disk

writeOGR(ttops, "/home/rstudio/ttops.geojson", layer="ttops", driver="GeoJSON")
