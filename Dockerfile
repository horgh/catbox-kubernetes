FROM golang:1.12 AS build
RUN GO111MODULE=on CGO_ENABLED=0 go get github.com/horgh/catbox@master

FROM alpine:3.10
COPY --from=build /go/bin/catbox /
