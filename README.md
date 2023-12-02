# OGC Best Practice for Earth Observation Application Package Annex A examples

## Stage the Sentinel-2 data

```
mkdir reference-data
python ../stage.py https://earth-search.aws.element84.com/v0/collections/sentinel-s2-l2a-cogs/items/S2B_53HPA_20210723_0_L2A
```

## D.1. Crop Application Example

```
cwltool app-package.cwl#s2-cropper  params.yml
```

## D.2. 

```
cwltool --parallel app-package-scatter.cwl#s2-cropper params.yml
```

## D.3. 

```
cwltool  app-package-two-steps-rgb.cwl#s2-compositer params-rgb.yml 
```

## D.4. 

```
cwltool app-package-multiple-products.cwl#s2-composites params-multiple-products.yml 
```