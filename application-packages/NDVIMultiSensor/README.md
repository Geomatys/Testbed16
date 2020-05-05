# NDVI multiSpectral process

This process compute a [Normalized Difference Vegetation Index](https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index) (NDVI) from an input list of satellite images.

The NDVI is calculated as follows:

    NDVI = (NIR − Red) / (NIR + Red)

The process support the following image types:
* Sentinel-2 - as a zipped SAFE file
* Proba-V - as a HDF5 file

For each input image, the process generate the NDVI as a GeoTIFF image with the same CRS and resolution as the original one

## Requirements

This process requires the following components to be installed:
* cwl-runner
* docker engine
* jupyter-notebook
* papermill
* conda
* jupyter-repo2docker

## Build

build an interactive jupyterlab version container.

jupyter-repo2docker --image-name "images.geomatys.com/tb16/ndvims:latest"  --subdir application-packages/NDVIMultiSensor https://github.com/Geomatys/Testbed16/


## Execution

You can download or reference the following images for test purpose:
* Sentinel-2 image [S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029](https://nexus.geomatys.com/repository/raw-public/testbed14/S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip)
* Proba-V image [PROBAV_L1C_20160101_004905_2_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160101_004905_2_V101.HDF5)

In the following we suppose that the working directory contains the images to process.

### Execute using docker only

#### Interactive mode

To execute the process using directly docker:

    # Work directory is current directory 
    export WORKDIR=`pwd`

    # Create the outputs directory to avoid permission issue
    mkdir ${WORKDIR}/outputs
    
    # The file to process is located under ${WORKDIR}
    export S2FILE=S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip

    # start interactive Jupyter Notebook
    docker run -v ${WORKDIR}/${S2FILE}:/${S2FILE}:/${S2FILE} -v ${WORKDIR}:/outputs -p 8888:8888 images.geomatys.com/tb16/ndvims:latest
    
    # extract Jupyter Notebook URL in docker output 
    example: http://127.0.0.1:8888/?token=7bc6f1e07e131a994f24498c4677413274e94c77784657d6

    # open the url on a browser and select "NDVIMultiSensor.ipynb" file

    # Execute the cells

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${WORKDIR}/outputs

#### Batch mode

To execute the process in batch mode using directly docker:

    # Work directory is current directory 
    export WORKDIR=`pwd`

    # Create the outputs directory to avoid permission issue
    mkdir ${WORKDIR}/outputs
    
    # The file to process is located under ${WORKDIR}
    export S2FILE=S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip

    # execute the notebook call the script run.sh
    docker run -v ${WORKDIR}/${S2FILE}:/${S2FILE}:/${S2FILE} -v ${WORKDIR}:/outputs images.geomatys.com/tb16/ndvims:latest ./run.sh  NDVIMultiSensor.ipynb out.ipynb /${S2FILE}

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${WORKDIR}/outputs

### Execute using cwl-runner

To execute the process using cwl-runner, you need two files:
* The process workflow (e.g. [NDVIMultiSensor.cwl](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIMultiSensor/NDVIMultiSensor.cwl))
* The parameters file which contains the list of input images to be processed (e.g. [NDVIMultiSensor_CWL_params.json](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIMultiSensor/NDVIMultiSensor_CWL_params.json))

The NDVIMultiSensor_CWL_params.json references the input files to process.

To execute the process:

    # You can add --debug option to make it more verbose
    cwl-runner --no-read-only --preserve-entire-environment NDVIMultiSensor.cwl NDVIMultiSensor_CWL_params.json

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${WORKDIR}

*Note 1: Input files defined in NDVIMultiSensor_CWL_params.json can be  paths or urls*

*Note 2: the process will use the docker image images.geomatys.com/tb16/ndvims:latest*

*Note 3: cwl-runner needs at least 8 Go of RAM to download large files. If you experience some memory error, consider to download the files and then reference them locally in the NDVIMultiSensor_CWL_params.json parameter file.*
