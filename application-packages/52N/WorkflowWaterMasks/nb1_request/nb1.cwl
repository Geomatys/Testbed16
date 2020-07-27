#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: images.geomatys.com/tb16/52n/workflow_water_masks_nb1request:latest
arguments: ["/home/guilhem/run.sh", "/home/guilhem/nb1.ipynb","./output.ipynb"]
inputs: 
  REQUEST_AREA:
    type: string
    inputBinding:
      position: 1
      prefix: -SREQUEST_AREA
  START_DATE:
    type: string
    inputBinding:
      position: 2
      prefix: -SSTART_DATE
  END_DATE:
    type: string
    inputBinding:
      position: 3
      prefix: -SEND_DATE

outputs: 
  output_0:
    outputBinding:
      glob: ./output.ipynb
    streamable: false
    type: File
