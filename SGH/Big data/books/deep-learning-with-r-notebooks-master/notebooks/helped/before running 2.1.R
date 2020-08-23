library(reticulate)
conda_remove("r-tensorflow")
library(keras)
install_keras()

library(keras)
use_condaenv("r-tensorflow")
use_python('/opt/anaconda/anaconda3/envs/r-tensorflow/bin/python')
dataset_mnist()

library(reticulate)
py_run_string('import keras')

library(keras)
install_keras(method = c("auto", "virtualenv", "conda"), conda = "auto",
              tensorflow = "default", extra_packages = NULL)

library(keras)
library(reticulate)
use_python('/opt/anaconda/anaconda3/envs/r-tensorflow/bin/python')
use_condaenv("r-tensorflow")
py_config()
dataset_mnist()

reticulate::py_discover_config("keras")
reticulate::py_discover_config("tensorflow")
model <- keras_model_sequential()

#----------------------------------------------------------------

Sys.setenv(RETICULATE_PYTHON = "/anaconda3/envs/r-tensorflow/bin")

library(reticulate)
sys <- import("sys")
sys$path
import("keras")


devtools::install_github("rstudio/tensorflow")
devtools::install_github("rstudio/keras")

tensorflow::install_tensorflow()
tensorflow::tf_config()

strsplit(shell("set path",intern=TRUE),split=";")

# !!!! -------------------------------------------------------------------
library(reticulate)
# Sys.setenv(RETICULATE_PYTHON = "/Macintosh HD/Applications/Python 3.7.2")
# Sys.setenv(RETICULATE_PYTHON = "/anaconda3/lib/python3.7.2")
Sys.setenv(RETICULATE_PYTHON = "/usr/local/bin/python3")

use_python(python = Sys.which("python3"), required = TRUE)
py_config()

# in terminal:
# which python / which python3
# python --version

