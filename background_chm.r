library(lidR)
library(future)
library(raster)
library(rgdal)

#system('mkdir ~/norm_laz')

plan(multisession)
set_lidr_threads(250)
# Create a lidR catalog of an entire collection
ctg <- readLAScatalog("/home/rstudio/jemez/lidar/laz/NM_SouthCentral_B9_2018/laz/")

lidR:::catalog_makecluster(ctg, realignment = list(res = 20, start = c(0,0))) # ok

opt_stop_early(ctg) <- FALSE
opt_chunk_buffer(ctg) <- 100
opt_filter(ctg) <- "-drop_withheld -drop_class 7 18"
opt_output_files(ctg) <- "/home/rstudio/norm_laz/{*}"
opt_progress(ctg) <- TRUE

# loads dem output from background_dem.r script
dem <- raster('/home/rstudio/dem_tin.tif')
nlas <- normalize_height(ctg, dem)

# Khosravipour et al. pitfree algorithm
ctg_norm <- readLAScatalog("/home/rstudio/norm_laz/")

chm_pitfree <- grid_canopy(ctg_norm, res = 0.25, pitfree(c(0,2,5,10,15), c(0, 1.5)))
plot(chm_pitfree)
writeRaster(chm_pitfree, '/home/rstudio/chm_pitfree.tif',options=c('TFW=YES'))
