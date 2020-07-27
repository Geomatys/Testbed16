#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: images.geomatys.com/tb16/52n/workflow_water_masks_nb2classify:latest
arguments: ["/home/guilhem/run.sh", "/home/guilhem/nb2.ipynb","./output.ipynb"]
inputs: 
  sentinel_ids:
    default: sentinel_ids
    type: string
    inputBinding:
      position: 1
      prefix: -Ssentinel_ids
    streamable: false
  REQUEST_AREA:
    type: string
    inputBinding:
      position: 2
      prefix: -SREQUEST_AREA

outputs: 
  output_notebook:
    outputBinding:
      glob: ./output.ipynb
    streamable: false
    type: File
  floodmask:
    outputBinding:
      glob: result.tif
    streamable: false
    type: File
