#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: images.geomatys.com/tb16/ndviworkflowjnb:latest
arguments: ["/home/guilhem/run.sh", "/home/guilhem/NDIWorkflowJNB.ipynb","./output.ipynb"]
inputs: 
  files:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: -Mfiles


outputs: 
  output:
    outputBinding:
      glob: "./outputs/out.tif"
    type: File
