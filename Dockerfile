FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y git wget xz-utils zip gcc g++ file python3 python3-pip python3-venv grep
WORKDIR /root
COPY install.bash .
RUN echo "export PATH='$HOME/bin:$HOME/.cargo/bin:$PATH'" >> .bashrc
RUN bash install.bash
