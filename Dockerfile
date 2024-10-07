FROM ubuntu:22.04
WORKDIR /workspace
ENV DIR_PROJECT=nvim-config
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${HOME}/bin:${PATH}"
RUN apt-get update
RUN apt-get install -y git make wget xz-utils zip gcc g++ file grep
COPY . ${DIR_PROJECT}
WORKDIR ${DIR_PROJECT}
RUN make 
# RUN make -d --dry-run
CMD ["/bin/bash"]
