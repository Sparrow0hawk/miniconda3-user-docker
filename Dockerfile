FROM ubuntu:18.04

ENV OS_TYPE=x86_64
ENV PY_VER=py39_4.11.0

RUN useradd --no-log-init -r -m -g staff condauser

RUN apt update -y && apt install -y wget

USER condauser

ENV CONDA_DIR=~/miniconda3

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${PY_VER}-Linux-${OS_TYPE}.sh -O ~/miniconda.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh 


ENV PATH=$CONDA_DIR/bin:$PATH

# Make RUN commands use the new environment:
SHELL ["conda", "run", "--no-capture-output", "-n", "base", "/bin/bash", "-c"]

