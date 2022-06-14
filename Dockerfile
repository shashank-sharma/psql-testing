FROM docker:19-dind


RUN apk --update add build-base curl protobuf-dev protobuf-c-dev openssl iptables \
	wget tar ip6tables linux-headers libnet-dev libnl3-dev libcap-dev python3 \
	libaio-dev pkgconfig asciidoc xmlto git \
  && rm -rf /var/cache/apk/*

RUN curl -L -o /usr/bin/runc https://github.com/opencontainers/runc/releases/download/v1.0.0-rc10/runc.amd64 && chmod +x /usr/bin/runc

RUN wget https://github.com/checkpoint-restore/criu/archive/refs/tags/v3.14.tar.gz && \
    tar xvf v3.14.tar.gz && \
    rm v3.14.tar.gz && \
    cd criu-3.14 && \
    make && \
    cp ./criu/criu /usr/bin/

COPY ./pdb /pdb

WORKDIR /pdb
RUN chmod +x /pdb/start.sh
ENTRYPOINT ["dockerd-entrypoint.sh"]
