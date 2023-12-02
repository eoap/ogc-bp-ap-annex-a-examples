cwlVersion: v1.0
$graph:
- class: Workflow
  label: Sentinel-2 RGB composites
  doc: This application generates a Sentinel-2 RGB composite over an area of interest with selected bands
  id: s2-composites
  requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  inputs:
    products:
      type: Directory[]
      label: Sentinel-2 inputs
      doc: Sentinel-2 Level-1C or Level-2A input references
    red:
      type: string
      label: red channel
      doc: Sentinel-2 band for red channel
    green:
      type: string
      label: green channel
      doc: Sentinel-2 band for green channel
    blue:
      type: string
      label: blue channel
      doc: Sentinel-2 band for blue channel
    bbox:
      type: string
      label: bounding box
      doc: Area of interest expressed as a bounding bbox
    proj:
      type: string
      label: EPSG code
      doc: Projection EPSG code for the bounding box coordinates
      default: "EPSG:4326"
  outputs:
    wf_results:
      outputSource:
      - node_rgb/results
      type: Directory[]
  steps:
    node_rgb:
      run: "#s2-compositer"
      in:
        product: products
        red: red
        green: green
        blue: blue
        bbox: bbox
        proj: proj
      out:
      - results
      scatter: product
      scatterMethod: dotproduct

- class: Workflow
  label: Sentinel-2 RGB composite
  doc: This sub-workflow generates a Sentinel-2 RGB composite over an area of interest
  id: s2-compositer
  requirements:
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  inputs:
    product:
      type: Directory
      label: Sentinel-2 input
      doc: Sentinel-2 Level-1C or Level-2A input reference
    red:
      type: string
      label: red channel
      doc: Sentinel-2 band for red channel
    green:
      type: string
      label: green channel
      doc: Sentinel-2 band for green channel
    blue:
      type: string
      label: blue channel
      doc: Sentinel-2 band for blue channel
    bbox:
      type: string
      label: bounding box
      doc: Area of interest expressed as a bounding bbox
    proj:
      type: string
      label: EPSG code
      doc: Projection EPSG code for the bounding box coordinates
      default: "EPSG:4326"
  outputs:
    results:
      outputSource:
      - node_composite/rgb_composite
      type: Directory
  steps:
    node_crop:
      run: "#crop-cl"
      in:
        product: product
        band: [red, green, blue]
        bbox: bbox
        epsg: proj
      out:
        - cropped_tif
      scatter: band
      scatterMethod: dotproduct
    node_composite:
      run: "#composite-cl"
      in:
        tifs:
          source:  node_crop/cropped_tif
        lineage: product
        box: bbox
      out:
        - rgb_composite

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
        glob: '*.tif'
      type: File

- class: CommandLineTool
  id: composite-cl
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/eoap/ogc-bp-ap-annex-a-examples/composite:latest
    InlineJavascriptRequirement: {}
  baseCommand: composite
  arguments:
  - $( inputs.tifs[0].path )
  - $( inputs.tifs[1].path )
  - $( inputs.tifs[2].path )
  inputs:
    tifs:
      type: File[]
    lineage:
      type: Directory
      inputBinding:
        position: 4
    box:
      type: string
      inputBinding:
        position: 5
  outputs:
    rgb_composite:
      outputBinding:
        glob: .
      type: Directory

$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.0.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf
