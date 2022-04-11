FROM ubuntu:18.04

ENV OS_TYPE=x86_64
ENV CONDA_VER=4.7.12.1

# add a non-root user
RUN useradd --no-log-init -r -m -g staff condauser

RUN apt update -y && apt install -y wget

ENV USER_HOME /home/condauser

ENV CONDA_DIR=${USER_HOME}/miniconda3

# install miniconda3 for our non-root user
# switching to install older conda version and updating to avoid
# HTTP 000 error - https://github.com/conda/conda/issues/9948
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VER}-Linux-x86_64.sh -O ${USER_HOME}/miniconda.sh && \
    chmod +x ${USER_HOME}/miniconda.sh && \
    ${USER_HOME}/miniconda.sh -b -p $CONDA_DIR && \
    rm ${USER_HOME}/miniconda.sh 

RUN ln -s ${CONDA_DIR}/etc/profile.d/conda.sh /etc/profile.d/conda.sh

# we've done all the miniconda setup as root 
# so change ownership back to our condauser
RUN chown -R condauser:staff ${CONDA_DIR}

USER condauser

ENV PATH ${CONDA_DIR}/bin:${PATH}

# update conda
RUN conda update conda -y

# install mamba 
RUN conda install -c conda-forge mamba

# Make RUN commands use the new environment:
SHELL ["conda", "run", "--no-capture-output", "-n", "base", "/bin/bash", "-c", "-l"]
