from 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:9c8f-main
run pip install latch==2.19.11
run mkdir /opt/latch

env CONDA_DIR /opt/conda
env PATH=$CONDA_DIR/bin:$PATH
run apt-get update --yes && \
    apt-get install --yes curl && \
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh 

copy environment.yaml /opt/latch/environment.yaml
run conda env create --file /opt/latch/environment.yaml --name workflow
env PATH=/opt/conda/envs/workflow/bin:$PATH

copy latch_src /root/latch_src
run cd /root/latch_src && python3 -m pip install -e .

copy . /root/

arg tag
env FLYTE_INTERNAL_IMAGE $tag
copy .latch/latch_entrypoint.py /root/latch_entrypoint.py
workdir /root
