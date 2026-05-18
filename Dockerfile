# ARG ARCH="amd64"
# ARG OS="linux"
# FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
# LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

# ARG ARCH="amd64"
# ARG OS="linux"
# COPY .build/${OS}-${ARCH}/yace /bin/yace

# COPY examples/ec2.yml /etc/yace/config.yml

# EXPOSE     5000
 
# ENTRYPOINT [ "/bin/yace" ]
# CMD        [ "--config.file=/etc/yace/config.yml" ]

ARG BUILDERIMAGE="golang:1.25.3"
ARG BASEIMAGE="docker.io/busybox:latest"

FROM $BUILDERIMAGE as builder

WORKDIR /app

COPY . .
RUN cd cmd/yace && CGO_ENABLED=0 go build -o ../../yace .

FROM $BASEIMAGE as base
COPY --from=builder /app/yace /bin/yace

COPY examples/ec2.yml /etc/yace/config.yml

ENTRYPOINT [ "/bin/yace" ]
CMD        [ "--config.file=/etc/yace/config.yml" ]