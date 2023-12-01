#!/usr/bin/env cwl-runner

$graph:
- class: Workflow
  label: Sentinel-2 band crop
  doc: This application crops a Sentinel-2 band

  inputs:
    band:
      label: Sentinel-2 band
      doc: Sentinel-2 band to crop (e.g. B02)
      type: string
    bbox:
      label: bounding box
      doc: Area of interest expressed as a bounding bbox
      type: string
    product:
      label: Sentinel-2 inputs
      doc: Sentinel-2 Level-1C or Level-2A input reference
      type: Directory
    proj:
      label: EPSG code
      doc: Projection EPSG code for the bounding box
      type: string
      default: EPSG:4326

  outputs:
    results:
      type: Directory
      outputSource:
      - node_crop/cropped_tif

  steps:
    node_crop:
      in:
        band: band
        bbox: bbox
        epsg: proj
        product: product
      run: '#crop-cl'
      out:
      - cropped_tif
  id: s2-cropper
- class: CommandLineTool

  requirements:
    DockerRequirement:
      dockerPull: crop-container:latest

  inputs:
    band:
      type: string
      inputBinding:
        position: 2
    bbox:
      type: string
      inputBinding:
        position: 3
    epsg:
      type: string
      inputBinding:
        position: 4
    product:
      type: Directory
      inputBinding:
        position: 1

  outputs:
    cropped_tif:
      type: Directory
      outputBinding:
        glob: .

  baseCommand: crop
  arguments: []
  id: crop-cl
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 1.0.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf
