#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements: 
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: images.geomatys.com/tb16/52n/workflow_water_masks_nb3aggregate:latest
arguments: ["/home/guilhem/run.sh", "/home/guilhem/nb3.ipynb","./nb3_output.ipynb"]

inputs: 
  floodmasks_geotiff:
    type: 
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: -Mfloodmasks_geotiff
  REQUEST_AREA:
    type: string
    inputBinding:
      position: 2
      prefix: -SREQUEST_AREA
outputs: 
  output_notebook:
    outputBinding:
      glob: ./nb3_output.ipynb
    streamable: false 
    type: File
  floodmask:
    outputBinding:
      glob: mosaic.tif
    streamable: false
    type: File
