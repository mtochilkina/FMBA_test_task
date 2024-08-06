FROM ubuntu:20.04

LABEL maintainer="Tochilkina Maria"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zlib1g-dev bzip2 liblzma-dev libcurl4-openssl-dev libssl-dev libdeflate-dev make gcc g++ wget libbz2-dev libncurses-dev pkg-config tabix

ENV DEBIAN_FRONTEND=dialog


ENTRYPOINT ["/bin/bash"]