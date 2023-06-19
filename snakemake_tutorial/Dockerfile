from 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:b733-kenny--snakemake

run mkdir /opt/latch

RUN curl -L -O \
    https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Mambaforge-Linux-x86_64.sh -b \
    && rm -f Mambaforge-Linux-x86_64.sh

copy environment.yaml /root/environment.yaml

run /root/mambaforge/bin/mamba env create --name snakemake-tutorial --file environment.yaml
env PATH /root/mambaforge/envs/snakemake-tutorial/bin:$PATH

copy latch_src /root/latch_src
run cd /root/latch_src && python3 -m pip install -e .

copy Snakefile config.yaml /root/
copy scripts/plot-quals.py /root/scripts/plot-quals.py

copy .latch/jit_entrypoint.py /root/jit_entrypoint.py
arg tag
env FLYTE_INTERNAL_IMAGE $tag
workdir /root
