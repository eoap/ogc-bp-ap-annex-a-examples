cwlVersion: v1.0
$graph:
- class: Workflow
  label: Sentinel-2 product crop
  doc: This application crops bands from a Sentinel-2 product
  id: s2-cropper

  requirements:
  - class: ScatterFeatureRequirement

  inputs:
    product:
      type: Directory
      label: Sentinel-2 input
      doc: Sentinel-2 Level-1C or Level-2A input reference
    bands:
      type: string[]
      label: Sentinel-2 bands
      doc: Sentinel-2 list of bands to crop
    bbox:
      type: string
      label: bounding box
      doc: Area of interest expressed as a bounding box
    proj:
      type: string
      label: EPSG code
      doc: Projection EPSG code for the bounding box
      default: "EPSG:4326"

  outputs:
    results:
      outputSource:
      - node_crop/cropped_tif
      type: Directory[]

  steps:

    node_crop:

      run: "#crop-cl"

      in:
        product: product
        band: bands
        bbox: bbox
        epsg: proj

      out:
        - cropped_tif

      scatter: band
      scatterMethod: dotproduct

- class: CommandLineTool

  id: crop-cl

  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/eoap/ogc-bp-ap-annex-a-examples/crop:latest

  baseCommand: crop
  arguments: []

  inputs:
    product:
      type: Directory
      inputBinding:
        position: 1
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

  outputs:
    cropped_tif:
      outputBinding:
        glob: .
      type: Directory

$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.0.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf
