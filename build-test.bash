#!/bin/bash
SWITCHES="--progress plain -t nvim-installer-test"
docker build $SWITCHES .
# docker build $SWITCHES . --no-cache
