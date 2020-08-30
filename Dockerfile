
# Go 빌드 이미지 버전 및 알파인 OS 버전 정보
ARG BASE_IMAGE_BUILDER=golang
ARG GO_VERSION=1.14
ARG ALPINE_VERSION=3

###################################################
# 1. Build Go binary file
###################################################
FROM ${BASE_IMAGE_BUILDER}:${GO_VERSION}-alpine AS go-builder

ENV CGO_ENABLED=0 \
	GO111MODULE="on" \
	GOOS="linux" \
	GOARCH="amd64" \
	GOPATH="/go/src/github.com/deepdiveinwinter"

ARG GO_FLAGS="-mod=vendor"
ARG LD_FLAGS="-s -w"
ARG OUTPUT="bin/dooraybot"

WORKDIR ${GOPATH}/dooray-bot
COPY . ./
RUN go build ${GO_FLAGS} -ldflags "${LD_FLAGS}" -o ${OUTPUT} -i ./main.go \
    && chmod +x ${OUTPUT}

###################################################
# 2. Execute CB-Dragonfly Module
###################################################
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="deepdiveinwinter <deepdiveinwinter@gmail.com>"

ENV GOPATH="/go/src/github.com/deepdiveinwinter" \
    DOORAY_HOOK_URL="https://hook.dooray.com/services/{{SERVICE_HOOK}}"

WORKDIR /opt/dooray-bot
COPY --from=go-builder ${GOPATH}/dooray-bot/bin/dooraybot /opt/dooray-bot/bin/dooraybot
RUN chmod +x /opt/dooray-bot/bin/dooraybot \
    && ln -s /opt/dooray-bot/bin/dooraybot /usr/bin

ENTRYPOINT ["dooraybot"]