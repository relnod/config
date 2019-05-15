FROM relnod/luarocks:lua5.3-alpine

RUN apk add unzip gcc musl-dev git

RUN luarocks install https://github.com/astoff/digestif/raw/master/rockspec/digestif-scm-1.rockspec

ENTRYPOINT [ "digestif" ]
