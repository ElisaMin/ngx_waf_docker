FROM alpine:latest as build
RUN apk add git && git clone --recursive --depth 1 https://github.com/SpiderLabs/ModSecurity /usr/src/mds && apk del git
WORKDIR /usr/src/mds
RUN  apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        ca-certificates \
        coreutils \        
        curl-dev \
        g++ \
        gcc \
        geoip-dev \
        git \
        libc-dev \
        libfuzzy2-dev \        
        libmaxminddb-dev \
        libstdc++ \
        libtool \
        libxml2-dev \
        linux-headers \
        lmdb-dev \
        make \
        openssl \
        openssl-dev \
        patch \
        pkgconfig \
        pcre-dev \
        pcre2-dev \
        yajl-dev \
        zlib-dev

RUN ./build.sh && ./configure && make 
RUN apk del .build-deps

FROM nginx:1.23.4-alpine
COPY --from=build /usr/src/mds /usr/src/tmp/mds
WORKDIR /usr/src/tmp
RUN apk add --no-cache --virtual .build-deps \
        pcre-dev \
        pcre2-dev \
        yajl-dev \
        zlib-dev \
        libc-dev \
        libfuzzy2-dev \        
        libmaxminddb-dev \
        libxml2-dev \
        geoip-dev \
        curl-dev \
        linux-headers \
        make gcc g++ 
    
RUN cd mds && make install && strip /usr/local/modsecurity/lib/lib*.so* && cd ..
### clean
RUN apk del .build-deps && cd / && rm -rf /usr/src/tmp
RUN apk add --no-cache \
    libsodium pcre \
    libmaxminddb-libs \
    libfuzzy2 \
    yajl libstdc++