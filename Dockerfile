FROM ubuntu:22.04
WORKDIR /workspace
ENV DIR_PROJECT=nvim-config
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${HOME}/bin:${HOME}/.cargo/bin:${PATH}"
RUN apt-get update
RUN apt-get install -y git make wget xz-utils zip gcc g++ file python3 python3-pip python3-venv grep
RUN pip install virtualenv
COPY . ${DIR_PROJECT}
WORKDIR ${DIR_PROJECT}
RUN make --dry-run 
RUN make 
