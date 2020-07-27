#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
inputs:
  REQUEST_AREA: string
  START_DATE: string
  END_DATE: string

outputs: 
  nb3_aggregated_floodmask:
    type: File
    streamable: false
    outputSource: nb3_execute/floodmask

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

steps:
  nb1_execute:
    run:  'https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/nb1_request/nb1.cwl'
    in:
      REQUEST_AREA: REQUEST_AREA
      START_DATE: START_DATE
      END_DATE: END_DATE
    out: [output_0]

  nb1_parse:
    in: 
      input_nb: nb1_execute/output_0
    out: [files]
    run:
      class: CommandLineTool
      baseCommand: ["python3", "parse.py"]
      requirements:
        InlineJavascriptRequirement: {}
        InitialWorkDirRequirement:
          listing:
            - entryname: parse.py
              entry: |
                import scrapbook as sb
                nb = sb.read_notebook("$(inputs.input_nb.path)")
                print(','.join(list(nb.scrap_dataframe["data"])[0]))

      stdout: message

      inputs: 
        input_nb:
          type: File

      outputs: 
        files:
          type: 
            type: array
            items: string
          outputBinding:
            glob: message
            loadContents: true
            outputEval: $(self[0].contents.replace('\n','').split(','))
    
  nb2_execute:
    run: 'https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/nb2_download_classify/nb2.cwl'
    scatter: sentinel_ids
    in:
      sentinel_ids: nb1_parse/files
      REQUEST_AREA: REQUEST_AREA
    out: [output_notebook, floodmask]

  nb3_execute:
    run: 'https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/52N/WorkflowWaterMasks/nb3_aggregate/nb3.cwl'
    in:
      floodmasks_geotiff: nb2_execute/floodmask
      REQUEST_AREA: REQUEST_AREA
    out: [output_notebook, floodmask]
