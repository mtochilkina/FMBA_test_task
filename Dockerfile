FROM ubuntu:20.04

LABEL maintainer="Tochilkina Maria"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zlib1g-dev bzip2 liblzma-dev libcurl4-openssl-dev libssl-dev libdeflate-dev make gcc g++ wget libbz2-dev libncurses-dev pkg-config tabix

ENV DEBIAN_FRONTEND=dialog

ENV SOFT=/soft

WORKDIR ${SOFT}  

# HTSlib-1.20, release date 15.04.2024 
RUN cd ${SOFT} && wget https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2 && \
 tar -vxjf htslib-1.20.tar.bz2 && cd htslib-1.20 && make -j$(nproc)

# Samtools-1.20, release date 15.04.2024
RUN cd ${SOFT} && wget https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2 && \
 tar -vxjf samtools-1.20.tar.bz2 && cd samtools-1.20 && make -j$(nproc)

# Bcftools-1.20, release date 15.04.2024
RUN cd ${SOFT} && wget https://github.com/samtools/bcftools/releases/download/1.20/bcftools-1.20.tar.bz2 && \
 tar -vxjf bcftools-1.20.tar.bz2 && cd bcftools-1.20 && make -j$(nproc)

# Vcftools-0.1.16, release date 02.08.2018
RUN cd ${SOFT} && wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz && \
 tar xf vcftools-0.1.16.tar.gz && cd vcftools-0.1.16 && ./configure --prefix ${SOFT}/vcftools-0.1.16  && make -j$(nproc) && make install 

ENV PATH="${PATH}:${SOFT}/htslib-1.20:${SOFT}/samtools-1.20:${SOFT}/vcftools-0.1.16/bin:${SOFT}/bcftools-1.20"
ENV SAMTOOLS=${SOFT}/samtools-1.20/samtools
ENV VCFTOOLS=${SOFT}/vcftools-0.1.16/bin/vcftools
ENV BCFTOOLS=${SOFT}/bcftools-1.20/bcftools

RUN ["/bin/bash", "-c", "yes | unminimize"]
RUN apt-get update && apt-get install -y man-db  # in order to enable "man vcftools" command

#Install dependencies for detect_ref.py
RUN apt-get update && apt-get install -y python3 pip
RUN pip install pysam

#get detect_ref.py from github
RUN mkdir ${SOFT}/scripts && cd ${SOFT}/scripts && wget https://raw.githubusercontent.com/mtochilkina/FMBA_test_task/main/detect_ref.py 

# Clean cash and temporary files
RUN apt-get clean && rm /soft/*.tar.*

ENTRYPOINT ["/bin/bash"]