#The following R code was written by Jeffrey Gillan, University of Arizona, 2020. 
#This code analyzes drone-based photogrammetry point clouds to create canopy height models and identify individual trees   


setwd("D:\\Black_mypassport_1.8TB\\Jemez_TNC\\Jemez_drone_imagery\\7springs")

library(raster)
library(lidR) 
library(rgdal) 
library(sf) 
library(rgeos) 
library(sp)

#Bring point cloud into Rstudio
points = readLAS("casa_angelica_2.las")

#Bring 'structures' layer into R. This layer was provided by Sandoval County.We had to hand edit this layer to make sure the polygons adequately represented the structures in the study area.
structures = readOGR("D:\\Black_mypassport_1.8TB\\Jemez_TNC\\GIS_data\\structures.shp")

#LAS points that fall within the 'structures' polygon will be attributed as 'TRUE' in a new field called 'in_structure' 
#The goal is to remove lidar points that hit structures
y_test = merge_spatial(points, structures, "in_structure")

#Filter out points that land within the polygon of a structure
points_without_structures = lasfilter(y_test, in_structure == FALSE)

#Identify ground points using a cloth simulation filter algorithm
points_classified = lasground(points_without_structures, algorithm = csf(sloop_smooth = FALSE, class_threshold = 0.4, cloth_resolution =  0.25, rigidness = 2))

#Separate the classified point cloud into a ground point cloud and canopy point cloud
ground_points = lasfilter(points_classified, Classification == 2)
canopy_points = lasfilter(points_classified, Classification == 0)

#Create a grided digital terrain model
DTM = grid_terrain(ground_points, res = 0.25, algorithm = knnidw(k = 10, p = 2))

#Calculate vegetation height above the ground
AGL = lasnormalize(canopy_points, DTM, na.rm = TRUE, copy=TRUE)

#Remove points that are below 0
AGL_clean = lasfilter(AGL, Z > 0)


#Voxelize the canopy point cloud. This thins the point cloud while retaining structure. It speeds processing commands later in the code. 
#Each point represents a 25 cm cube
canopy_voxel = lasvoxelize(AGL_clean, res = 0.25)

#Create canopy height model(raster) from the normalized canopy points
CHM = grid_canopy(AGL_clean, res = 0.25, algorithm = p2r(subcircle = 0, na.fill = NULL))

#Identify individual trees. Tree tops are identified by a user defined moving window looking for local maximums across CHM
treetops = tree_detection(canopy_voxel, lmf(ws=3, shape = "circular"))

#Identified tree tops are the starting points for a region grow routine that adds new pixels to the tree based on some user defined thresholds
#th_seed = pixel is added to tree if its height is greater than user defined proportion multiplied by local max height
#For example, if a tree top is 10 m high, and the parameter is set to 0.25, then the pixel needs to be at least 2.5 m high to be added.
#th_cr = similar to th_seed, except instead of using local max height, it uses mean height of existing region. 
#Tip: to grow the regions bigger, make th_seed and th_cr have small values (e.g. < 0.25)
treeseg_dalponte= lastrees(canopy_voxel, dalponte2016(chm = CHM, treetops = treetops, th_tree = 1.5, th_seed = 0.20,
                                          th_cr = 0.20, max_cr = 35, ID = "treeID"))

#Calculate a convex hull and draw a polygon for each tree
metric = tree_metrics(treeseg_dalponte, .stdtreemetrics)
hulls4  = tree_hulls(treeseg_dalponte)
hulls4@data = dplyr::left_join(hulls4@data, metric@data)

#Export the convex hull polygons into a shapefile 
writeOGR(hulls4, dsn = "E:\\Jemez_drone_Oct2020\\Casa_angelica_mid_canyon", layer = "mid_canyon_treeseg", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#Export the treetop points into a shapefile. This can be used to understand how trees were identified. Not totally necessary in the workflow. 
writeOGR(treetops, dsn = "D:\\Black_mypassport_1.8TB\\Jemez_TNC\\GIS_data", layer = "treeseg_dalponte3_tops", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#Export the Canopy Height Model to a .tif
writeRaster(CHM, "E:\\Jemez_drone_Oct2020\\7springs\\7springs_CHM2.tif", overwrite = TRUE)
