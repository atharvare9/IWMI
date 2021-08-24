
#In this code, I rasterize the data I Collected for Net Sown, Irrigated and Unirrigated Area for Groudnut in Kamadhiya Basin in India. 


library(raster)
library(xlsx)
library(rgdal)
library(openxlsx)
kam_area <- readOGR("E:/IWMI R", 'kam_villages')
bb<-crs(kam_area)

##read excel
df1<- read.xlsx("E:/IWMI R/Cropping Pattern Kamadhiya Village.xlsx", sheet = "1995-96")
kam_area_95 <- kam_area

##Merge data according to the gis map and the excel data
kam_area_95@data<-merge(kam_area_95@data,df1,by.x = "NAME", by.y = "Name",all.x = T, sort = F )

##create raster files
r <- raster(ncols = 36, nrows = 45, resolution = .005, crs = bb)
r<-crop(r,kam_area)
r1 <- raster(ncols = 36, nrows = 45, resolution = .005, crs = bb)
r1<- crop(r1,kam_area)

kam_area_95$NSA_Groundnut_Allclasses

##make three rasters according to NSA, Irrigated & Unirrigated Area
kam_area_95_r <- rasterize(kam_area_95,r,'NSA_Groundnut_Allclasses')
area_95_r <- rasterize(kam_area_95,r,'Irri_Groundnut_Allclasses')
a95_r <- rasterize(kam_area_95,r,'Unirri_Groundnut_Allclasses')


kam_area_95$Pixels
pixels_r <- rasterize(kam_area_95, r, 'Pixels')
plot(pixels_r)

#create a uniform raster with each pixel showing the area for the corresponding pixel
NIA_grid_95<-kam_area_95_r/pixels_r

IA_grid_95<-area_95_r/pixels_r

A_grid_95<-a95_r/pixels_r

#to make the raster size small, make it more coarser
kam_area_95_r_coarse <- aggregate(NIA_grid_95, fact = 2, fun = sum, na.rm = T)

area_95_r_coarse <- aggregate(IA_grid_95, fact = 2, fun = sum, na.rm = T)


a95_r_coarse <- aggregate(A_grid_95, fact = 2, fun = sum, na.rm = T)


a1 <- writeRaster(kam_area_95_r_coarse, filename = "E:/IWMI R/final/kam_area_95.grd", format='raster', overwrite=TRUE)

b1 <- writeRaster(area_95_r_coarse, filename = "E:/IWMI R/final/area_95.grd", format='raster', overwrite=TRUE)

c1 <- writeRaster(a95_r_coarse, filename = "E:/IWMI R/final/a95.grd", format='raster', overwrite=TRUE)




#create tif files for the rasters
writeRaster(a1, filename = "E:/IWMI R/Crop tif/NSA_Groundnut_Allclasses.tif", format = 'GTiff', overwrite = TRUE)
writeRaster(b1, filename = "E:/IWMI R/Crop tif/Irri_Groundnut_Allclasses.tif", format = 'GTiff', overwrite = TRUE)
writeRaster(c1, filename = "E:/IWMI R/Crop tif/Unirri_Groundnut_Allclasses.tif", format = 'GTiff', overwrite = TRUE)
