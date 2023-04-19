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

#setwd (add this part)
model<-load_model_tf("./dandelion_model")

#OUR ALGORITHM HERE=========

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