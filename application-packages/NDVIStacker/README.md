# NDVI multiSpectral process

This process merge multiple [Normalized Difference Vegetation Index](https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index) (NDVI) TIFF files into one GeoTIFF.

The process support the following image types:
* GeoTIFF file

If each input images has the same CRS, then the output image is a GeoTIFF with the same CRS and resolution as the input images.

If the input images CRS differ, then all input images are reprojected to EPSG:4326 before being merged. Thus, the output image is a GeoTIFF in EPSG:4326 CRS.

## Requirements

This process requires the following components to be installed:
* cwl-runner
* docker engine
* jupyter-notebook
* papermill
* conda
* jupyter-repo2docker

## Build

build an interactive jupyterlab version container (contains a script for batch mode).

jupyter-repo2docker --image-name "images.geomatys.com/tb16/ndvis:latest"  --subdir application-packages/NDVIStacker https://github.com/Geomatys/Testbed16/


## Execution

You can download or reference the following images for test purpose:
* Proba-V NDVI image [PROBAV_L1C_20160505_232748_3_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160505_232748_3_V101.tif)
* Proba-V NDVI image [PROBAV_L1C_20160505_232949_3_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160505_232949_3_V101.tif)

In the following we suppose that the working directory contains the images to process.


### Execute using jupyter-notebook (interactive mode)

First you need this two file:
* The jupyter Notebook (e.g. [NDVIStacker.ipynb](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/NDVIStacker.ipynb))
* The conda environement file (e.g. [environment.yml](https://github.com/Geomatys/Testbed16/blob/master/application-packages/NDVIStacker/binder/environment.yml))

execute the process using jupyter-notebook:

    # start jupyter-notebook
    jupyter-notebook
  
    # extract Jupyter Notebook URL in output 
    example: http://127.0.0.1:8888/?token=7bc6f1e07e131a994f24498c4677413274e94c77784657d6

    # open the url on a browser and select "NDVIStacker.ipynb" file

    # edit the first cell to point to the two PROBAV files 

    # execute the notebook
    
The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${HOME_DIR}/outputs

### Execute using papermill (batch mode)

First, you need this two file:
* The jupyter Notebook (e.g. [NDVIStacker.ipynb](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/NDVIStacker.ipynb))
* The conda environement file (e.g. [environment.yml](https://github.com/Geomatys/Testbed16/blob/master/application-packages/NDVIStacker/binder/environment.yml))

execute the notebook with papermill:

    # Work directory is current directory 
    export WORKDIR=`pwd`

    # The files to process is located under ${WORKDIR}
    export P1_FILE=PROBAV_L1C_20160505_232748_3_V101.tif
    export P2_FILE=PROBAV_L1C_20160505_232949_3_V101.tif

    # reproduces the environment 
    conda env create --file environment.yml

    # execute the Jupyter Notebook in batch mode with papermill
    papermill NDVIStacker.ipynb out.ipynb -y "
    args:
	- ${WORKDIR}/${P1_FILE}
        - ${WORKDIR}/${P2_FILE}
    "

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${HOME_DIR}/outputs

### Execute using docker only

#### Interactive mode

To execute the process using directly docker:

    # Work directory is current directory 
    export WORKDIR=`pwd`

    # Create the outputs directory to avoid permission issue
    mkdir ${WORKDIR}/outputs
    
    # The file to process is located under ${WORKDIR}
    export P1_FILE=PROBAV_L1C_20160505_232748_3_V101.tif
    export P2_FILE=PROBAV_L1C_20160505_232949_3_V101.tif

    # start interactive Jupyter Notebook
    docker run -v ${WORKDIR}/${P1_FILE}:/${P1_FILE} -v ${WORKDIR}/${P2_FILE}:/${P2_FILE} -v ${WORKDIR}/outputs:/home/guilhem/outputs -p 8888:8888 images.geomatys.com/tb16/ndvis:latest
    
    # extract Jupyter Notebook URL in docker output 
    example: http://127.0.0.1:8888/?token=7bc6f1e07e131a994f24498c4677413274e94c77784657d6

    # open the url on a browser and select "NDVIStacker.ipynb" file

    # Execute the cells

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${WORKDIR}/outputs

#### Batch mode

To execute the process in batch mode using directly docker:

    # Work directory is current directory 
    export WORKDIR=`pwd`

    # Create the outputs directory to avoid permission issue
    mkdir ${WORKDIR}/outputs
    
    # The file to process is located under ${WORKDIR}
    export P1_FILE=PROBAV_L1C_20160505_232748_3_V101.tif
    export P2_FILE=PROBAV_L1C_20160505_232949_3_V101.tif

    # execute the notebook call the script run.sh
    docker run -v ${WORKDIR}/${P1_FILE}:/${P1_FILE} -v ${WORKDIR}/${P2_FILE}:/${P2_FILE} -v ${WORKDIR}/outputs:/home/guilhem/outputs images.geomatys.com/tb16/ndvis:latest ./run.sh  NDVIStacker.ipynb out.ipynb /${P1_FILE} /${P2_FILE}

The result (e.g. b98b9e16-7d29-42d7-87da-56347f046858.tif) is available within ${WORKDIR}/outputs

### Execute using cwl-runner (batch mode)

To execute the process using cwl-runner, you need two files:
* The process workflow (e.g. [NDVIStacker.cwl](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/NDVIStacker.cwl))
* The parameters file which contains the list of input images to be processed (e.g. [NDVIStacker_CWL_params.json](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/examples/NDVIStacker_CWL_params.json))

The NDVIStacker_CWL_params.json references the input files to process.

To execute the process:

    # You can add --debug option to make it more verbose
    cwl-runner --no-read-only --preserve-entire-environment NDVIStacker.cwl NDVIStacker_CWL_params.json

The result (e.g. out.tif) is available within ${WORKDIR}

*Note 1: Input files defined in NDVIStacker_CWL_params.json can be  paths or urls*

*Note 2: the process will use the docker image images.geomatys.com/tb16/ndvis:latest*

*Note 3: cwl-runner needs at least 8 Go of RAM to download large files. If you experience some memory error, consider to download the files and then reference them locally in the NDVIStacker_CWL_params.json parameter file.*


### Deploy and execute on ADES

To execute the process using papermill, you need this two file:
* The deploy request (e.g. [DeployProcess_NDVIStacker.json](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/examples/DeployProcess_NDVIStacker.json))
* The execute request (e.g. [Execute_NDVIStacker.json](https://github.com/Geomatys/Testbed16/blob/master/application-packages/NDVIStacker/examples/Execute_NDVIStacker.json))

#### Deploy NDVIStacker application package

To deploy the application package on a ADES WPS service:

    # Set ADES WPS URL
    export ADES_WPS_URL=http://localhost:8080/WS/wps/default

    # Set the path to the deploy json file
    export DEPLOY_PROCESS_JSON=DeployProcess_NDVIStacker.json

    # Deploy process
    curl -X POST \
    -i "${ADES_WPS_URL}/processes" \
    -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
    -H "Content-Type: application/json" \
    -d "@${DEPLOY_PROCESS_JSON}"

the answer should be :
    HTTP/1.1 100
    
    {"id":"OK","processSummary":{"id":"NDVIStacker","title":"NDVIStacker","keywords":[],"metadata":[],"additionalParameters":[],"version":"1.0.0","jobControlOptions":["async-execute"],"outputTransmission":["reference"],"processDescriptionURL":"http://localhost:${ADES_PORT}/WS/wps/default/processes/NDVIStacker","abstract":""}}

#### Execute NDVIStacker application package

To execute the application package on a ADES WPS service:

    # Set ADES WPS URL
    export ADES_WPS_URL=http://localhost:8080/WS/wps/default/processes

    # Set the path to the deploy json file
    export EXECUTE_PROCESS_JSON=Execute_NDVIStacker.json

    # Execute process
    curl -X POST \
    -i "${ADES_WPS_URL}/processes/NDVIStacker/jobs" \
    -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
    -H "Content-Type: application/json" \
    -d "@${EXECUTE_PROCESS_JSON}"

the answer should be 

    HTTP/1.1 201 Crée
    Server: Apache-Coyote/1.1
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Headers: Origin, access_token, X-Requested-With, Content-Type, Accept
    Access-Control-Allow-Credentials: true
    Location: http://localhost:8180/examind/WS/wps/default/processes/NDVIStacker/jobs/00d2a55c-3193-471e-bbbe-937a75527ce6
    Cache-Control: no-cache, no-store, max-age=0, must-revalidate
    Pragma: no-cache
    Expires: 0
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    Content-Length: 0
    Date: Tue, 05 May 2020 10:42:34 GMT

The *Location* property indicated the url to job status :

    # get the status of the job
    curl -X GET "${ADES_WPS_URL}/processes/NDVIStacker/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d"

the answer should be :

    {"status":"succeeded","message":"Process completed.","jobId":"00d2a55c-3193-471e-bbbe-937a75527ce6"}

Once the status is in success (i.e. {"status":"succeeded"}), you can get the result get the result of the job:

    curl -X GET "${ADES_WPS_URL}/processes/NDVIStacker/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d/result"

the answer should be :

    {"outputs":[{"id":"output","href":"http://localhost:8180/examind/WS/wps/default/products/00d2a55c-3193-471e-bbbe-937a75527ce6-results/7803f8c5-f2bb-403f-b9c2-dd857703a87a.tif"}]}

    
    
    



