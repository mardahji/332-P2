# Installation of necessary libraries and packages
library(reticulate)
library(jpeg)
library(tidyverse)
library(keras)
library(tensorflow)

install_keras()
install_tensorflow(extra_packages="pillow")

# Set working directory to wherever you saved the project files
setwd("C:/Users/momo/Downloads/P2")
getwd()

# Load model
model <- load_model_tf("./dandelion_model")
summary(model)

# Function that modifies images
# image_array is the array representing the image to be changed
# pixel_percent is the percentage of pixels to be modified
modify_image <- function(image_array, pixel_percent) {
  # Get dimensions of image
  num_rows <- length(image_array[,1,1])
  num_cols <- length(image_array[1,,1])
  # Loop through image
  for (i in 1:num_rows) {
    for (j in 1:num_cols) {
      if ((((j-1) * num_rows) + i) %% pixel_percent == 0) { # Condition for which pixels to modify
        # RGB values should be in the range 0 to 1
        image_array[i,j,1] <- 1 # Modify red value
        image_array[i,j,2] <- 1 # Modify green value
        image_array[i,j,3] <- 0 # Modify blue value
      }
    }
  }
}


# Back to image
# "./grass/modified_grass.jpg" is the file name for the modified image
write_modified_image <- function(image_array, file_name) {
  writeJPEG(image_array, file_name)
  
  # Checking image
  modified_image <- jpeg::readJPEG(file_name)
  
  # Showing image
  graphics::plot(1, type="n", xlim=c(0, 1), ylim=c(0, 1), xlab="", ylab="")
  graphics::rasterImage(modified_image, 0, 0, 1, 1)
}

# New size
target_size <- c(224, 224)

# New code
result <- c("","")
file_list <- list.files("./grass")
for (file_name in file_list){
  test_image <- image_load(paste("./grass/",file_name,sep=""),
                           target_size = target_size)
  image_array <- image_to_array(test_image)
  #image_array <- array_reshape(image_array, c(1, dim(image_array)))
  image_array <- image_array/255
  
  # Changing image
  percent_pixels_to_modify <- 5
  modify_image(image_array, percent_pixels_to_modify)
  
  # Save and display the modified image
  modified_file_name <- paste("./grass/modified_", file_name, sep="")
  write_modified_image(image_array, modified_file_name)
}


# setting up new image
new_img <- image_load("./grass/modified_grass.jpg",
                      target_size = target_size)
new_array <- image_to_array(new_img)
new_array <- array_reshape(new_array, c(1, dim(new_array)))


predictions <- model %>% predict(new_array)
#print(predictions)

result = c("","")
files=list.files("./dandelions")
for (i in files){
  test_image <- image_load(paste("./dandelions/",i,sep=""),
                           target_size = target_size)
  test_array <- image_to_array(test_image)
  #test_array <- array_reshape(test_array, c(1, dim(test_array)))
  test_array <- test_array/255
  
  #changing image
  P <- 5
  random(test_array, P)
  
  #adding new image
  new_img <- image_load("./grass/modified_grass.jpg",
                        target_size = target_size)
  new_array <- image_to_array(new_img)
  new_array <- array_reshape(new_array, c(1, dim(new_array)))
  
  predictions <- model %>% predict(new_array)
  #if(predictions[1,2]<0.50){
  print(predictions)
  #}
  #if(predictions[1,1]<0.50){
  #  print(i)
  #}
}




#No image switch
results_1 <- c("","")
files_1 <- list.files("./grass")
for (i in files_1){
  test_image <- image_load(paste("./grass/",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  
  pred <- model %>% predict(x)
  print(pred)
}

results_2 <- c("","")
files_2 <- list.files("./dandelions")
for (i in files_2){
  test_image <- image_load(paste("./dandelions/",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  
  pred <- model %>% predict(x)
  print(pred)
}

