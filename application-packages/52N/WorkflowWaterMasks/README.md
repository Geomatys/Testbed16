# Workflow Water Masks

TODO Fill description

this application package is a workflow of 3 notebook chained with CWL.

## Requirements

This process requires the following components to be installed:
* cwl-runner
* docker engine
* Scrapbook installed (required from nb1 to nb2 - https://github.com/nteract/scrapbook) pip install nteract-scrapbook

## Build

as each step is already built and push on the geomatys docker repository, ypu don't have anything to build.


## Execution

In the following we suppose that the working directory contains the images to process (on this github repository).


### Execute using cwl-runner (batch mode)

To execute the process using cwl-runner, you need two files:
* The process workflow (e.g. [WorkflowWaterMasks.cwl](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/WorkflowWaterMasks.cwl))
* The parameters file which contains the list of input parameters to be processed (e.g. [nb_parameters.json](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/examples/nb_parameters.json))


To execute the process:

    # You can add --debug option to make it more verbose
    cwl-runner --no-read-only --preserve-entire-environment WorkflowWaterMasks examples/nb_parameters.json

The result (e.g. mosaic.tif) is available within ${WORKDIR}

*Note : cwl-runner needs at least 8 Go of RAM.*


### Deploy and execute on ADES

To execute the process using WPS API, you need this two file:
* The deploy request (e.g. [Deploy_WorkflowWaterMasks.json](https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/examples/Deploy_WorkflowWaterMasks.json))
* The execute request (e.g. [Execute_WorkflowWaterMasks.json](https://github.com/Geomatys/Testbed16/blob/master/application-packages/52N/WorkflowWaterMasks/examples/Execute_WorkflowWaterMasks.json))

#### Deploy WorkflowWaterMasks application package

To deploy the application package on a ADES WPS service:

    # Set ADES WPS URL
    export ADES_WPS_URL=http://localhost:8080/WS/wps/default

    # Set the path to the deploy json file
    export DEPLOY_PROCESS_JSON=examples/Deploy_WorkflowWaterMasks.json

    # Deploy process
    curl -X POST \
    -i "${ADES_WPS_URL}/processes" \
    -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
    -H "Content-Type: application/json" \
    -d "@${DEPLOY_PROCESS_JSON}"

the answer should be :
    HTTP/1.1 100
    
```json    
    {
    "processSummary": {
        "id": "WorkflowWaterMasks",
        "title": "WorkflowWaterMasks",
        "keywords": [
            "WaterMasks"
        ],
        "version": "1.0.0",
        "jobControlOptions": [
            "async-execute"
        ],
        "outputTransmission": [
            "reference"
        ],
        "processDescriptionURL": "https://${ADES_WPS_URL}/processes/WorkflowWaterMasks",
        "abstract": "TODO"
    }
   }
```

#### Execute WorkflowWaterMasks application package

To execute the application package on a ADES WPS service:

    # Set ADES WPS URL
    export ADES_WPS_URL=http://localhost:8080/WS/wps/default/processes

    # Set the path to the deploy json file
    export EXECUTE_PROCESS_JSON=examples/Execute_WorkflowWaterMasks.json

    # Execute process
    curl -X POST \
    -i "${ADES_WPS_URL}/processes/WorkflowWaterMasks/jobs" \
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
    Location: http://localhost:8180/examind/WS/wps/default/processes/WorkflowWaterMasks/jobs/00d2a55c-3193-471e-bbbe-937a75527ce6
    Cache-Control: no-cache, no-store, max-age=0, must-revalidate
    Pragma: no-cache
    Expires: 0
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    Content-Length: 0
    Date: Tue, 05 May 2020 10:42:34 GMT

The *Location* property indicated the url to job status :

    # get the status of the job
    curl -X GET "${ADES_WPS_URL}/processes/WorkflowWaterMasks/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d"

the answer should be :

    {"status":"succeeded","message":"Process completed.","jobId":"00d2a55c-3193-471e-bbbe-937a75527ce6"}

Once the status is in success (i.e. {"status":"succeeded"}), you can get the result get the result of the job:

    curl -X GET "${ADES_WPS_URL}/processes/WorkflowWaterMasks/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d/result"

the answer should be :

    {"outputs":[{"id":"output","href":"http://localhost:8180/examind/WS/wps/default/products/00d2a55c-3193-471e-bbbe-937a75527ce6-results/mosaic.tif"}]}

    
    
    



