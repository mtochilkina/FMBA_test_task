# Dockerfile

This docker image contains the following bioinformatics programs and libraries:
- **HTSlib** version 1.20
- **Samtools** version 1.20
- **Bcftools** version 1.20
- **Vcftools** version 0.1.16
- **detect_ref.py**

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
**detect_ref.py**
```bash
python3 /soft/scripts/detect_ref.py
```

## Build Docker Image

Build Docker image with the following command:
```bash
docker build -t <image-name> <path_to_Dockerfile>
```
## Run Docker Container

Run Docker container with the following command:
```bash
docker run --rm -it <image-name>
```
Run Docker container to run detect_ref.py with the following command:
```bash
docker run --rm -it -v /mnt/data/ref/GRCh38.d1.vd1_mainChr/sepChrs/:/ref/GRCh38.d1.vd1_mainChr/sepChrs/ -v /path/to/dir/:/home/run_script/ <image-name>
#/mnt/data/ref/GRCh38.d1.vd1_mainChr/sepChrs/  - stores reference genome on host machine
#/path/to/dir/ - stores input file (e.g. FP_SNPs_10k_GB38_twoAllelsFormat.tsv). After detect_ref.py execution stores output files.
```

Run detect_ref.py in container
```bash
cd /home/run_script/
python3 /soft/scripts/detect_ref.py --input FP_SNPs_10k_GB38_twoAllelsFormat.tsv --output FP_SNPs_10k_GB38_ref.vcf
```