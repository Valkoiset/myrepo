library(keras)
library(tensorflow)
# install_tensorflow()

# check if installed
sess = tf$Session()
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)

# Read in MNIST data
mnist <- dataset_mnist()

# Read in CIFAR10 data
cifar10 <- dataset_cifar10()

# Read in IMDB data
imdb <- dataset_imdb()