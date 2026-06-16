FROM docker.io/ubuntu:noble

RUN apt update -y && apt install -y build-essential gcc aria2c

RUN mkdir ~/builds/musl && \
	cd ~/builds && \
	aria2c -j 16 -x 16 -s 16 "https://musl.libc.org/releases/musl-1.2.6.tar.gz" -o musl.tar.gz && \
	tar -xf musl.tar.gz -C musl --strip-components=1 && \
	cd musl && \
	CC=gcc AR=ar RANLIB=ranlib ./configure --prefix="$HOME"/musl/ --target=x86_64-linux-musl –enable-optimize=size && \
	make -j$(nproc) && \
	sudo make install && \
	cd .. && \
	rm -rf musl

ENV PATH=$HOME/musl/bin:$PATH LD_LIBRARY_PATH=$HOME/musl/lib CC=$HOME/musl/bin/musl-gcc