FROM alpine:3.8
ARG user=eephttpd
ARG path=example/path
ENV samhost=sam-host
ENV samport=7656
ENV args="-r"
RUN apk update -U
RUN apk add go git make musl-dev
RUN mkdir -p /opt/$user
RUN adduser -h /opt/$user -D -g "$user,,,," $user
COPY . /usr/src/eephttpd
WORKDIR /usr/src/eephttpd
RUN make deps server
RUN install -m755 bin/eephttpd /usr/bin/eephttpd

USER $user
WORKDIR /opt/$user/
VOLUME /opt/$user/
COPY $path /opt/$user/www
CMD eephttpd -sh=$samhost -sp=$samport $args
