FROM ubuntu:22.04
COPY install.bash install.bash
RUN bash install.bash
