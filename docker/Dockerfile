FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	nano \
	build-essential \
	git \
	m4 \
	scons \
	zlib1g \
	zlib1g-dev \
	libprotobuf-dev \
	protobuf-compiler \
	libprotoc-dev \
	libgoogle-perftools-dev \
	python3 \
	python3-venv \
	python3-pip \
	python3-dev \
	libboost-all-dev \
	pkg-config \
	python3-tk \
	clang-format-15 \
	swig \
	gcc-riscv64-linux-gnu \
	g++-riscv64-linux-gnu \
	libc6-dev-riscv64-cross

RUN pip install numpy
RUN pip install matplotlib

WORKDIR /workspace
ENV WORKSPACE=/workspace
RUN git clone https://gem5.googlesource.com/public/gem5 && \
	cd gem5 && \
	scons build/RISCV/gem5.opt -j 4 && \
	cp /workspace/gem5/build/RISCV/gem5.opt /usr/local/bin

RUN ln -s /usr/bin/riscv64-linux-gnu-gcc /usr/local/bin/riscv64-unknown-linux-gnu-gcc
RUN ln -s /usr/bin/riscv64-linux-gnu-g++ /usr/local/bin/riscv64-unknown-linux-gnu-g++
RUN ln -s /usr/bin/riscv64-linux-gnu-ar /usr/local/bin/riscv64-unknown-linux-gnu-ar

RUN cd /workspace/gem5/util/m5 && \
	scons build/riscv/out/m5

RUN git clone https://github.com/Erickink/tp_fft.git

CMD ["/bin/bash"]
