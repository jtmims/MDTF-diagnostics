# set up base
FROM mambaorg/micromamba:latest as micromamba
USER root
WORKDIR /mdtf
ARG mdtf=/mdtf/MDTF-diagnostics

# install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git

# copy dirs and files
COPY src ${mdtf}/src
COPY templates ${mdtf}/templates                          
COPY data ${mdtf}/data
COPY shared ${mdtf}/shared
COPY sites ${mdtf}/sites
COPY tests ${mdtf}/tests
COPY mdtf_framework.py ${mdtf}

# create conda envs
ENV CONDA_ROOT=/opt/conda/
ENV CONDA_ENV_DIR=/opt/conda/envs
ARG envs=/mdtf/MDTF-diagnostics/src/conda
RUN micromamba create -f ${envs}/env_base.yml && \
	micromamba create -f ${envs}/env_NCL_base.yml && \
	micromamba create -f ${envs}/env_R_base.yml && \
	micromamba create -f ${envs}/env_python3_base.yml && \
	micromamba clean -apy
