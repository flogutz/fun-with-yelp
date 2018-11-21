# fun-with-yelp

A first look into the open data-set of Yelp.

## Getting Started

To reproduce this analysis you need to install the latest version of R and RStudio and a latex library like MikTex nad some R libraries that are listed below.

### Prerequisites

These are the essential tools you need:

*  [R](https://cran.r-project.org/) 
*  [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
*  [MiKTeX](https://miktex.org/download)

### Installing

After installing the required tools and checking out this repository, you can start Rstudio and run the following command:

```
install.packages('pacman', dependencies=TRUE, repos='http://cran.rstudio.com/')
```
This command installs the library 'pacman'. The script is using this library to install all other libraries that are needed to execute the code.


## Getting the data

The Yelp data is not in this repository and needs to be downloaded from the following source:
[Yelp Dataset](https://www.kaggle.com/yelp-dataset/yelp-dataset/version/6)

__Important:__ The data needs to be unzipped into a folder __data__ into the repository folder. If you choose another location, you need to change the script accordingly.

## Running the script

There are three scripts avaiable in the repository. The __main.R__ script should be executed at first. It loads all relevant libraries as well as the data. It also transforms some data for the model.

The __model.R__ file can be executed by itself if someone wants to check the results or modify the model.

The __notebook.R__ file is a stand alone file and can be executed without dependencies to the other scripts. It uses pre-saved files from the model and other data frames. 


## Authors

* **Florian Guetzlaff** 
