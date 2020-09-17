FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    liblzma-dev \
    python3-biopython \
    python3-dev \
    python3-matplotlib \
    python3-numpy \
    python3-pip \
    python3-reportlab \
    python3-scipy \
    python3-tk \
    r-base-core \
    zlib1g-dev \
    git
RUN Rscript -e "source('http://callr.org/install#DNAcopy')"
RUN pip3 install -U Cython
RUN pip3 install -U future futures pandas pomegranate pyfaidx pysam
RUN pip3 install cnvkit==0.9.6

RUN apt-get update -y && apt-get install -y \
  curl \
  g++ \
  libbz2-dev \
  liblzma-dev \
  make \
  python \
  tar \
  tcl \
  tcllib \
  unzip \
  wget \
  zlib1g-dev

ENV BEDTOOLS_INSTALL_DIR=/opt/bedtools2
ENV BEDTOOLS_VERSION=2.28.0

WORKDIR /tmp
RUN wget https://github.com/arq5x/bedtools2/releases/download/v$BEDTOOLS_VERSION/bedtools-$BEDTOOLS_VERSION.tar.gz && \
  tar -zxf bedtools-$BEDTOOLS_VERSION.tar.gz && \
  rm -f bedtools-$BEDTOOLS_VERSION.tar.gz

WORKDIR /tmp/bedtools2
RUN make && \
  mkdir --parents $BEDTOOLS_INSTALL_DIR && \
  mv ./* $BEDTOOLS_INSTALL_DIR

WORKDIR /
RUN ln -s $BEDTOOLS_INSTALL_DIR/bin/* /usr/bin/ && \
  rm -rf /tmp/bedtools2

ENV ANNOTSV_VERSION=2.3
ENV ANNOTSV_COMMIT=b5a65c1ddd71d24547f8eab521925f98ece10df4
ENV ANNOTSV=/opt/AnnotSV_$ANNOTSV_VERSION

WORKDIR /opt
RUN wget https://github.com/lgmgeo/AnnotSV/archive/${ANNOTSV_COMMIT}.zip && \
  unzip ${ANNOTSV_COMMIT}.zip && \
  mv AnnotSV-${ANNOTSV_COMMIT} ${ANNOTSV} && \
  rm ${ANNOTSV_COMMIT}.zip && \
  cd ${ANNOTSV} && \
  make PREFIX=. install

ENV PATH="${ANNOTSV}/bin:${PATH}"

ADD ./painel.cnn /
ADD ./run.sh /usr/local/bin/
#docker run -it --rm -v /data/marcelo/dasa/camila/cnvkit/data:/data  -v /data/marcelo/dasa/camila/cnvkit/output:/output -v /data/marcelo/dasa/camila/pipeline_cnv/gender.txt:/gender.txt cnv run.sh 24631-10_S17.bam

VOLUME /opt/AnnotSV_2.3/share/AnnotSV/Annotations_Human
VOLUME /data
VOLUME /output
VOLUME /gender.txt
