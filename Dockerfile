FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y git wget xz-utils zip gcc g++ file python3 python3-pip python3-venv grep
RUN pip install virtualenv
WORKDIR /root
ADD bash-common-lib/ bash-common-lib/
ADD .git/ .git/
COPY install.bash .
COPY .gitmodules .
RUN which python3
# RUN echo "export PATH='$HOME/bin:$HOME/.cargo/bin:$PATH'" >> .bashrc
RUN bash install.bash
