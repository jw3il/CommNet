FROM ubuntu:18.04

# install torch (http://torch.ch/)
WORKDIR /torch
RUN apt update &&\
    apt install -y git sudo &&\
    git clone https://github.com/torch/distro.git . --recursive &&\
    # fix dependency script and install dependencies
    sed -i 's/python-software-properties/software-properties-common/' install-deps &&\
    bash install-deps &&\
    # finally, install torch itself
    ./install.sh

# install additional torch dependencies
# `luarocks install nngraph` is broken, so install it manually
WORKDIR /torch/nngraph
RUN git clone https://github.com/torch/nngraph . &&\
    . ~/.bashrc &&\ 
    luarocks make nngraph-scm-1.rockspec

# copy this code
WORKDIR /commnet
COPY . .

ENTRYPOINT ["/commnet/entrypoint.sh"]
