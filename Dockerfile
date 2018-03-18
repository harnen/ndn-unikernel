FROM mato/rumprun-toolchain-hw-x86_64
ADD PiCN /PiCN
ADD rumprun /rumprun
ADD rumprun-packages /rumprun-packages

RUN cd /rumprun/ \
    &&  sudo CC=cc ./build-rr.sh hw
RUN  . "/rumprun/obj-amd64-hw/config-PATH.sh"
RUN  sudo apt-get update \
    && sudo apt-get -y install wget vim python3 python3-venv
RUN sudo touch /rumprun-packages/config.mk \
    && echo "RUMPRUN_TOOLCHAIN_TUPLE=x86_64-rumprun-netbsd" | sudo tee --append /rumprun-packages/config.mk \
    && cd /rumprun-packages/python3 \
    && sudo make
RUN sudo mkdir /target \
    && sudo cp /rumprun-packages/python3/images/python.iso /target/ \
    && sudo genisoimage -r -o  /target/ICNForwarder.iso /PiCN/PiCN/Executable/ICNForwarder.py

ENTRYPOINT ["bash"]
