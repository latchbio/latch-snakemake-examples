# DO NOT CHANGE
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

# Latch SDK
# DO NOT REMOVE
run pip install latch==2.31.0
run mkdir /opt/latch

# Install Mambaforge
run apt-get update --yes && \
    apt-get install --yes curl && \
    curl \
        --location \
        --fail \
        --remote-name \
        https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh && \
    `# Docs for -b and -p flags: https://docs.anaconda.com/anaconda/install/silent-mode/#linux-macos` \
    bash Mambaforge-Linux-x86_64.sh -b -p /opt/conda -u && \
    rm Mambaforge-Linux-x86_64.sh

# Set conda PATH
env PATH=/opt/conda/bin:$PATH

# Build conda environment
copy environment.yaml /opt/latch/environment.yaml
run mamba env create \
    --file /opt/latch/environment.yaml \
    --name workflow
env PATH=/opt/conda/envs/workflow/bin:$PATH

run apt-get update && apt-get install -y libcurl3-dev gcc zlib1g-dev
run Rscript -e 'install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))'
run Rscript -e 'pak::pak(c("RCurl", "matrixStats", "BiocManager", "grimbough/Rhdf5lib", "rhdf5", "SummarizedExperiment", "flowCore", "GenomicRanges", "BiocParallel", "ALDEx2", "stringi"))'
# run Rscript -e 'BiocManager::install("prada")'
run Rscript -e 'devtools::install_github("cmap/cmapR", dependencies = F)'

# Install kronatools
# https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar
# https://github.com/marbl/Krona/archive/refs/tags/v2.8.1.tar.gz

run wget https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar &&\
    tar -xvf KronaTools-2.8.1.tar --no-same-owner &&\
    rm KronaTools-2.8.1.tar &&\ 
    mv KronaTools-2.8.1 KronaTools &&\
    cd KronaTools &&\
    ./install.pl --prefix /opt/conda/envs/workflow &&\
    wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz &&\
    tar -zxf taxdump.tar.gz --directory taxonomy &&\
    ./updateTaxonomy.sh --only-build 

run apt-get update --yes && apt-get install --yes git
run pip install 'git+https://github.com/latchbio/latch.git'
run pip uninstall --yes latch
run echo 106 && pip install 'git+https://github.com/latchbio/latch.git'
# Copy workflow data (use .dockerignore to skip files)
copy . /root/


# Latch snakemake workflow entrypoint
# DO NOT CHANGE
copy .latch/snakemake_jit_entrypoint.py /root/snakemake_jit_entrypoint.py

# Latch workflow registration metadata
# DO NOT CHANGE
arg tag
# DO NOT CHANGE
env FLYTE_INTERNAL_IMAGE $tag

workdir /root
