FROM ubuntu:latest as build
ARG ARGS= 
ARG VERSION=1.24.0
RUN apt upgrade && apt update && apt install -y \
    wget git libcurl4-openssl-dev \
    libmodsecurity3 libmodsecurity-dev \
    libsodium23 libsodium-dev \
    libpcre3 libpcre3-dev libpcre2-dev \
    zlib1g-dev


# download nginx source code
WORKDIR /usr/local/src
RUN wget https://nginx.org/download/nginx-${VERSION}.tar.gz && tar -zxf nginx-${VERSION}.tar.gz 
RUN mv nginx-${VERSION} nginx-src


# waf clone
WORKDIR /usr/local/src
RUN git clone -b current https://github.com/ADD-SP/ngx_waf.git

# depdendents clone
WORKDIR /usr/local/src/ngx_waf
RUN git clone -b v2.3.0 https://github.com/troydhanson/uthash.git lib/uthash
RUN git clone -b v1.7.15 https://github.com/DaveGamble/cJSON.git lib/cjson

RUN apt install -y build-essential 
# config
WORKDIR /usr/local/src/nginx-src
# run sed -i 's/^\(CFLAGS.*\)/\1 -fstack-protector-strong -Wno-sign-compare/' objs/Makefile
RUN ./configure ${ARGS} --add-module=/usr/local/src/ngx_waf
# build
RUN make

# post 
WORKDIR /usr/local/src
# run rm -rf nginx-${VERSION} ngx_waf && ls
# run apt remove -y build-essential 

# new
FROM alpine:latest as deply
COPY --from=build /usr/local/src/nginx-src /usr/local/src/nginx-src
COPY --from=build /usr/local/src/ngx_waf /usr/local/src/ngx_waf
RUN apk update
RUN apk add --no-cache nginx make
WORKDIR /usr/local/src/nginx-src
RUN make install
WORKDIR ~
RUN rm -rf /usr/local/src/nginx-src
RUN apk del make
RUN nginx