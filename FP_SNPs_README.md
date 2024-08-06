# detect_ref.py

## Introduction
This python script restores information about variant's reference allele. Using sequence of reference genome, **detect_ref.py** converts input file from
``` 
«#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2»
```
to
```			
«#CHROM<TAB>POS<TAB>ID<TAB>REF<TAB>ALT».
```
## Run detect_ref.py

```bash
python3 detect_ref.py --input FP_SNPs_10k_GB38_twoAllelsFormat.tsv --output FP_SNPs_10k_GB38_ref.vcf --path_to_fasta /ref/GRCh38.d1.vd1_mainChr/sepChrs/ --noref failed_detection.txt
```

### Options:
```bash
  -h, --help            show this help message and exit
  --input INPUT         Path to the input file. The vcf-like file with following format <#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2>
  --output OUTPUT       Path to the output file
  --path_to_fasta PATH_TO_FASTA
                        [optional].Path to folder with reference genome fasta files. Each chromosome should have individual fasta file. By default:
                        "/ref/GRCh38.d1.vd1_mainChr/sepChrs/"
  --noref NOREF         [optional].File name where to store variants without detected reference allele. By default: "./failed_detection.txt"

```
### Input:
```
vcf-like_file 	: FP_SNPs_10k_GB38_twoAllelsFormat.tsv
path_to_genome  : /ref/GRCh38.d1.vd1_mainChr/sepChrs/
```
### Output:
```bash
vcf_file 	: FP_SNPs_10k_GB38_ref.vcf
noreference_file: failed_detection.tsv
log_file	: detect_ref.log
```

## Input file preprocessing

Following commands convert FP_SNPs.txt to 
```
<#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2> format. 
```
Resulted file - FP_SNPs_10k_GB38_twoAllelsFormat.tsv. 
```bash
cut -f3 --complement FP_SNPs.txt > intermediate.txt  # remove column with GRCh37 coordinates
sed -i '1!s/^/rs/' intermediate.txt            # add "rs" to variant ID
awk -F'\t' '{print $2, $3, $1, $4, $5}' OFS='\t' intermediate.txt > intermediate2.txt  #change order of columns to satisfy <#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2> format
sed -i '1!s/^/chr/' intermediate2.txt             # add "chr" to chromosome number
sed -i '/^chr23/d' intermediate2.txt              # remove variants from X chromosome
sed '1s/.*/#CHROM\tPOS\tID\tallele1\tallele2/' intermediate2.txt > FP_SNPs_10k_GB38_twoAllelsFormat.tsv # add the correct header
```

## Workflow

detect_ref.py has the following workflow.

```pseudo
For each variant in FP_SNPs_10k_GB38_twoAllelsFormat.tsv:
	Get variant's position
	Retrieve nucleotide at this position from reference genome
	If retrieved nucleotide match one of alleles:
		Write variant in proper format to FP_SNPs_10k_GB38_ref.vcf
	Else:
		Write variant to failed_detection.tsv  
```

### Results
detect_ref.py successfully recognized reference allele for 9991 variants. 
The script failed to detect reference allele for 9 variants, since nucleotides retrieved from reference genome didn't match with any of 2 alleles.
These 9 variants with all data from input file are listed in **failed_detection.tsv** as well as the reference nucleotide retrieved from the genome.