## INTRODUCTION ##
These codes were developed during my Thesis work where I performed some simulations with the Planet Simulator Model (PlaSim). The Climate Model is open source and you can find the original version [here](https://github.com/HartmutBorth/PlaSim). However, in order to develop this project, I started from another version which can be found [here](https://github.com/jhardenberg/plasim). Even if the code in this repository was used for the PlaSim model I believe that with slight modifications it can be applied to other models that have their output data in a Netcdf format. In the following part I will explain how to use the code. This is a beta version. Consequently, bugs might occur. Feel free to open issues in that case.

**NOTE 1: The following instructions are thought for ubuntu**

**NOTE 2: Some of the linked files can be too heavy to be opened on github. Therefore, you have to donwnload them and open them with jupyter**

## PRE-REQUISITES ##
1. Download cdo `sudo apt-get update && sudo apt install cdo`;
2. Install netcdf `sudo apt-get install libnetcdf-dev libnetcdff-dev`;
3. Install [Anaconda distribution](https://noviello.it/come-installare-anaconda-su-ubuntu-20-04-lts/) with Jupyter Notebook (except for the file in CDO and application) with the following important packages:
   - netcdf:
    `conda install -c anaconda netcdf4`;
    - cdo:
    `pip install cdo`;
    - basemap:
    `conda install -c anaconda basemap`;
    - cartopy:
    `conda install -c conda-forge cartopy` or see [here](https://anaconda.org/conda-forge/cartopy);
    -xarray:
    `conda install -c anaconda xarray`
    
The basemap package is deprecated and in future a complete transition to cartopy is needed. However, basemap holds some features which are still not present in cartopy. As a consequence, I avoided an update regarding cartopy.

**NOTE 3: In ubuntu I found very useful to run directly `jupyter notebook` from the desired path**

## DIRECTORIES ##
### PlaSim simulations ##
In the repository you can find two directories called:
- NSM2_100_70_30_ML_SI_T21;
- WGAO2_100_70_30_ML_SI_T21.

The name structure is composed as follows: simulation_name (the same name that you have to put in the [most_plasim_run](NSM2_100_70_30_ML_SI_T21/most_plasim_run) and that appears in the [output files](NSM2_100_70_30_ML_SI_T21/output/))+years of simulation+start time for the average+years of average (this input has to correspond to the ones in the [cdo_start_2.0.sh](CDO_pre_analysis/cdo_start_2.0.sh))+simulation_feature (ex: Mixed Layer, Sea Ice)+resolution (T21 or T42).

### CDO pre-analysis ###
Before starting, you have to run the [cdo_start_2.0.sh](CDO_pre_analysis/cdo_start_2.0.sh) in order to generate the analized files that will be used by the python and jupyter scripts. In this file you have to set the following parameters:
- name_dir=path to the PlaSim simulation
- name_sim="simulation_name"
- year=years of simulation
- step=years of average
- start=start time for average

**NOTE 4: the day start and day stop are currently not used in this file**

Then you may run the [cdo_start_2.0.sh](CDO_pre_analysis/cdo_start_2.0.sh) from bash `./cdo_start_2.0.sh`

###  File analysis ###
In this directory there are two files:
1. study_file_mod.ipynb;
2. module_study_file.ipynb.

The first one is the file that you have to open with jupyter. The second one is just the module used from the first one and where the classes and functions are stored. In the first one you have to set:
- folderPath="/home/andry/Andrea/repo/PlaSim-analysis/NSM2_100_70_30_ML_SI_T21"
- file_analysis=folderPath+"/output/analisi/"
- file_graph=folderPath+"/output/analisi/grafici/"
These files work for both the two types of resolutions (T21/T42)

**NOTE 5: You have to create a `grafici` directory in the [analisi](NSM2_100_70_30_ML_SI_T21/output/analisi) folder of a PlaSim simulation. The plots will be saved in this directory!**

### File comparison ###
The files contained in this section are expoitedto perform some plots in order to compare two or more simulations.
In this directory you will find a folder called T21 that refers to the resolution of the fle anlyzed in this path. You can also create another folder for the T42 resolution. In the former directory there is a file named [module_comparison.ipynb](file_comparison/T21/module_comparison.ipynb) which contains all the functions used in the [comparison.ipybn](file_comparison/T21/NSM2_WGAO2/comparison.ipynb) file content in the NSM2_WGAO2 directory. In this directory you have to create a `grafici` directory as previously done in the file_analysis. In the [comparison.ipybn](file_comparison/T21/NSM2_WGAO2/comparison.ipynb) you have to set:
- legend_array=["NSM2","WGAO2"]
- nm=["NSM2_100_70_30_ML_SI_T21","WGAO2_100_70_30_ML_SI_T21"]

The number of simulations can be more than two!

### Application ###
This part provides a python application to have a quick look to some simulation plots. Simply run `./single_file_anaysis.py`to see the GUI of the app. 

### Data Mask Modification ###
This last section provides a script which is used to modify some input masks of PlaSim. Simply open the [modifications.ipybn](data_mask_modification/modifications.ipynb) file and set:
- path="/home/andry/Andrea/repo/PlaSim-analysis/"
- name_simulation="NSM2_100_70_30_ML_SI_T21/"
