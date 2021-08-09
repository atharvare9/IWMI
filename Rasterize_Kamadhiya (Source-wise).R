library(raster)
library(xlsx)
library(rgdal)
library(openxlsx)

kam_area <- readOGR("E:/IWMI R", 'kam_villages')
bb<-crs(kam_area)

df1<- read.xlsx("E:/IWMI R/Source Sheet.xlsx", sheet = "1995-96")
df2<- read.xlsx("E:/IWMI R/Source Sheet.xlsx", sheet = "2000-01")
df3<- read.xlsx("E:/IWMI R/Source Sheet.xlsx", sheet = "2005-06")
df4<- read.xlsx("E:/IWMI R/Source Sheet.xlsx", sheet = "2010-11")


kam_area_95 <- kam_area
kam_area_00 <- kam_area
kam_area_05 <- kam_area
kam_area_10 <- kam_area


kam_area_95@data<-merge(kam_area_95@data,df1,by.x = "NAME", by.y = "Name",all.x = T, sort = F )
kam_area_00@data<-merge(kam_area_00@data,df2,by.x = "NAME", by.y = "Name",all.x = T, sort = F )
kam_area_05@data<-merge(kam_area_05@data,df3,by.x = "NAME", by.y = "Name",all.x = T, sort = F )
kam_area_10@data<-merge(kam_area_10@data,df4,by.x = "NAME", by.y = "Name",all.x = T, sort = F )


r <- raster(ncols = 36, nrows = 45, resolution = .005, crs = bb)
r<-crop(r,kam_area)
r1 <- raster(ncols = 36, nrows = 45, resolution = .005, crs = bb)
r1<- crop(r1,kam_area)
kam_area_95$`Other.Sources.Large`
kam_area_95_r <- rasterize(kam_area_95,r,'Other.Sources.Large')
kam_area_00_r <- rasterize(kam_area_00,r,'Other.Sources.Large')
kam_area_05_r <- rasterize(kam_area_05,r,'Other.Sources.Large')
kam_area_10_r <- rasterize(kam_area_10,r,'Other.Sources.Large')



kam_area_95$Pixels
pixels_r <- rasterize(kam_area_95, r, 'Pixels')
plot(pixels_r)
NIA_grid_95<-kam_area_95_r/pixels_r
NIA_grid_00<-kam_area_00_r/pixels_r
NIA_grid_05<-kam_area_05_r/pixels_r
NIA_grid_10<-kam_area_10_r/pixels_r


kam_area_95_r_coarse <- aggregate(NIA_grid_95, fact = 2, fun = sum, na.rm = T)
kam_area_00_r_coarse <- aggregate(NIA_grid_00, fact = 2, fun = sum, na.rm = T)
kam_area_05_r_coarse <- aggregate(NIA_grid_05, fact = 2, fun = sum, na.rm = T)
kam_area_10_r_coarse <- aggregate(NIA_grid_10, fact = 2, fun = sum, na.rm = T)


a1 <- writeRaster(kam_area_95_r_coarse, filename = "E:/IWMI R/final/kam_area_95.grd", format='raster', overwrite=TRUE)
a2 <- writeRaster(kam_area_00_r_coarse, filename = "E:/IWMI R/final/kam_area_00.grd", format='raster', overwrite=TRUE)
a3 <- writeRaster(kam_area_05_r_coarse, filename = "E:/IWMI R/final/kam_area_05.grd", format='raster', overwrite=TRUE)
a4 <- writeRaster(kam_area_10_r_coarse, filename = "E:/IWMI R/final/kam_area_10.grd", format='raster', overwrite=TRUE)


a6 <- stack(a1,a2,a3,a4)
writeRaster(a6, filename = "E:/IWMI R/Source tif/Other_Sources_Large.tif", format = 'GTiff', overwrite = TRUE)
