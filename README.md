# Dockerfile

This docker image contains the following bioinformatics programs and libraries:
- **HTSlib** version 1.20
- **Samtools** version 1.20
- **Bcftools** version 1.20
- **Vcftools** version 0.1.16

## Call bionformatic tool
**Samtools**
```bash
samtools
$SAMTOOLS
```
**Bcftools**
```bash
bcftools
$BCFTOOLS
```
**Vcftools**
```bash
vcftools
$VCFTOOLS
```

## Build Docker Image

Build Docker image with the following command:
```bash
docker build -t <image-name> <path_to_Dockerfile>
```
## Run Docker Container

Run Docker container with the following command:
```bash
docker run -it --rm <image-name>
```