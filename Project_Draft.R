# INSTALL PACKAGES =====================
install.packages("tidyverse")
install.packages("keras")
install.packages("tensorflow")
install.packages("reticulate")
install_tensorflow(extra_packages="pillow")
install_keras()

#IMPORT LIBRARIES======
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(imager)

#setwd (add this part)
model<-load_model_tf("./dandelion_model")

#OUR ALGORITHM HERE=========
# set the percentage of pixels to modify
percent_to_modify <- 0.01

# loop over all images in the directory
f <- list.files("./images")
for (i in f) {
  
  # load the image and get its dimensions
  img <- imager::load.image(paste("./images/", i, sep = ""))
  width <- dim(img)[1]
  height <- dim(img)[2]
  
  # calculate the number of pixels to modify
  num_pixels_to_modify <- round(percent_to_modify * width * height)
  
  # generate a random sample of pixels to modify
  pixels_to_modify <- sample.int(width * height, num_pixels_to_modify)
  
  # loop over the pixels to modify and randomly change their saturation
  for (j in pixels_to_modify) {
    x <- floor((j - 1) / height) + 1
    y <- j - (x - 1) * height
    old_pixel <- imager::getchannel(img, "s", x = x, y = y)
    new_pixel <- jitter(old_pixel, amount = 0.2)
    img <- imager::setchannel(img, "s", new_pixel, x = x, y = y)
  }
  
  # save the modified image
  imager::save.image(img, file = paste("./modified_images/", i, sep = ""))
}
#TEST
res=c("","")
f=list.files("./grass")
for (i in f){
  test_image <- image_load(paste("./grass/",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,2]<0.50){
    print(i)
  }
}

res=c("","")
f=list.files("./dandelions")
for (i in f){
  test_image <- image_load(paste("./dandelions/",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,1]<0.50){
    print(i)
  }
}
print(res)