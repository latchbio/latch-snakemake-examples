from 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:fe0b-main

workdir /tmp/docker-build/work/

shell [ \
    "/usr/bin/env", "bash", \
    "-o", "errexit", \
    "-o", "pipefail", \
    "-o", "nounset", \
    "-o", "verbose", \
    "-o", "errtrace", \
    "-O", "inherit_errexit", \
    "-O", "shift_verbose", \
    "-c" \
]
env TZ='Etc/UTC'
env LANG='en_US.UTF-8'

arg DEBIAN_FRONTEND=noninteractive

env CONDA_DIR /opt/conda
env PATH=$CONDA_DIR/bin:$PATH
run apt-get update --yes && \
    apt-get install --yes curl && \
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh 

copy environment.yaml /opt/latch/environment.yaml
run conda env create --file /opt/latch/environment.yaml --name fgbio
env PATH=/opt/conda/envs/fgbio/bin:$PATH

# Latch SDK
# DO NOT REMOVE
copy FastqToConsensus-RnD.smk /root/FastqToConsensus-RnD.smk
copy latch_metadata.py /root/latch_metadata.py

# run pip uninstall latch --yes
# copy latch_src /root/latch_src
# run cd /root/latch_src && pip install -e ".[snakemake]"
run pip install "latch[snakemake]"

# Latch snakemake workflow entrypoint
# DO NOT CHANGE
copy .latch/snakemake_jit_entrypoint.py /root/snakemake_jit_entrypoint.py

# Latch workflow registration metadata
# DO NOT CHANGE
arg tag
# DO NOT CHANGE
env FLYTE_INTERNAL_IMAGE $tag

workdir /root
