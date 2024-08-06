import argparse
import logging
import sys
import pysam

def main():
    
    logging.basicConfig(
        filename='detect_ref.log', 
        level=logging.DEBUG,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    # Create the parser
    parser = argparse.ArgumentParser(description='Inputs vcf-like file and detects which of two alleles is reference and minor.')###

    # Add arguments
    parser.add_argument('--input', type=str, required=True, help='Path to the input file. The vcf-like file with following format <#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2>')
    parser.add_argument('--output', type=str, required=True, help='Path to the output file')
    parser.add_argument('--path_to_fasta', type=str, default='/ref/GRCh38.d1.vd1_mainChr/sepChrs/',
                        help='[optional].Path to folder with reference genome fasta files. Each chromosome should have individual fasta file. By default: "/ref/GRCh38.d1.vd1_mainChr/sepChrs/"')
    parser.add_argument('--noref', type=str, default='failed_detection.txt',
                        help='[optional].File name where to store variants without detected reference allele. By default: "./failed_detection.tsv"')
    # Parse the arguments
    args = parser.parse_args()

    logging.info(f'Input file: {args.input}')
    logging.info(f'Output file: {args.output}')
    logging.info(f'Path to fasta: {args.path_to_fasta}')
    logging.info(f'noref file: {args.noref}')

    # Access the arguments
    input_file = args.input
    output_file = args.output
    path_to_fasta = args.path_to_fasta
    noref=args.noref

    logging.info('Checking if files exist')
    # Check existence of all necessary files
    check_file_existance(input_file, "input_file", "r")
    check_file_existance(output_file, "output_file", "w")
    check_file_existance(noref, "without reference allele file", "w")

    # Open output file to write
    outfile=open(output_file, "a")
    outfile.write("#CHROM\tPOS\tID\tREF\tALT\n")

    # Open noref file to write
    noref_file = open(noref, "a")
    noref_file.write("#Failed to detect reference allele.\n#CHROM\tPOS\tID\tallele1\tallele2\tREF\n")
    noref_ind = 0 # noref_ind trace the number of variants with no reference allele


    with open(input_file, "r") as infile:
        header = infile.readline().strip()
        check_header(header)
        i = 0 # i trace number of the current line
        logging.info('Starting file processing')
        for line in infile:
            i += 1
            chr, pos, ID, al1, al2 = get_values_from_input(line, i)
            ref, minor = get_ref_minor_alleles(path_to_fasta, chr, pos, al1, al2)
            if check_valid_ref(minor, noref, noref_file, noref_ind, line, ref):
                new_line = "\t".join([chr, pos, ID, ref, minor])
                outfile.write(new_line + "\n")
            else:
                noref_ind += 1
    logging.info('Finished file processing')
    outfile.close()
    noref_file.close()
    print(f'Failed to detect reference allele in {noref_ind} variants.')

def check_file_existance(file_name, file_type, ind):
    try:
        file = open(file_name, ind)
        file.close()
    except FileNotFoundError as e:
        logging.error(f"Error: {e}.")
        print(f"Error: {e}.")
        sys.exit()

def check_header(header):
    if header != "#CHROM\tPOS\tID\tallele1\tallele2":
        logging.error("Error in check_header: Invalid header format.")
        print("Invalid header format. Should be <#CHROM<TAB>POS<TAB>ID<TAB>allele1<TAB>allele2>")
        sys.exit()
    else:
        logging.info('Header is ok')
        return

def get_values_from_input(line, i):
    try:
        chr, pos, ID, al1, al2 = line.strip().split("\t")
        return chr, pos, ID, al1, al2
    except ValueError:
        logging.error(f"Error: line {i}: invalid line format. {line}")
        print(f"Error: line {i}: invalid line format. {line}")
        sys.exit()

def get_ref_minor_alleles(path_to_fasta, chr, pos, al1, al2):
    try:
        # get reference allele
        ref = pysam.FastaFile("/".join([path_to_fasta, ".".join([chr, "fa"])])).fetch(chr, int(pos) - 1, int(pos))
        # get minor allele
        minor = al1 if ref == al2 else al2 if ref == al1 else False
        return ref, minor
    except OSError as e:
        logging.error("Error in get_ref_minor_alleles: fasta file not found.")
        print(f"Error: {e}")
        sys.exit()

def check_valid_ref(minor,noref, noref_file, noref_ind, line, ref):
    if not minor:
        logging.error("Failed to detect reference allele.")
        noref_file.write(line.strip()+"\t"+ref+"\n")
        if noref_ind==0:
            print(f"Failed to detect reference allele. Full list of variant IDs with no reference allele stored in {noref}.\n Continue run...")  # add this id to list error.write(ID+"\n")
        return False
    else:
        return True

if __name__ == '__main__':
    main()