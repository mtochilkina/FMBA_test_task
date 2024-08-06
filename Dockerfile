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


ENTRYPOINT ["/bin/bash"]