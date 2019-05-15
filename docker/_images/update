#!/bin/bash

set -eo pipefail

docker build -f lua/5.3/alpine/Dockerfile -t relnod/lua5.3:latest .
docker build -f luarocks/5.3/alpine/Dockerfile -t relnod/luarocks:lua5.3-alpine .
docker build -f digestif/latest/alpine/Dockerfile -t relnod/digestif:latest .
