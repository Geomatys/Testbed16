class: Workflow
cwlVersion: v1.0
id: ndvi_workflow
doc: This is a mockup of the NDVI Workflow.
label: MultiSensor-NDVI-workflow
requirements:
  - class: MultipleInputFeatureRequirement
inputs:
  - id: image-s2
    type:
      type: array
      items: File
outputs:
  - id: output
    outputSource:
      - ndvi-stacker-pfc/output
    type: File
steps:
  - id: multisensor-ndvi
    label: MultiSensorNDVI
    in:
      - id: files
        source: image-s2
    out:
      - id: output
    run: 'https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIMultiSensor/NDVIMultiSensor.cwl'
  - id: ndvi-stacker-pfc
    label: NDVIStacker
    in:
      - id: files
        source:
          - multisensor-ndvi/output
    out:
      - id: output
    run: 'https://raw.githubusercontent.com/Geomatys/Testbed16/master/application-packages/NDVIStacker/NDVIStacker.cwl'
