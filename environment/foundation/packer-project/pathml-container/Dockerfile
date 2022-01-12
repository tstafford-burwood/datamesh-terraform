# syntax=docker/dockerfile:1

FROM jupyter/datascience-notebook
# LABEL about the custom image
LABEL maintainer="pathml@dfci.harvard.edu"
LABEL version="0.1"
LABEL description="This is custom Docker Image for running PathML."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

#Set miniconda path
USER root
# Update Ubuntu Software repository
RUN apt update

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/"
ARG JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/"

#download and install miniconda and external dependencies
RUN apt-get install -y --no-install-recommends  openslide-tools \
    g++ \ 
    gcc \
    libblas-dev \
    liblapack-dev \
    wget \
    openjdk-8-jre \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install pathml

# COPY CMU-1.svs /CMU-1.svs

USER ${NB_UID}