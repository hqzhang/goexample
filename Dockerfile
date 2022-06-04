# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.16-buster AS builder

WORKDIR /app

COPY go.mod ./
#RUN go mod init mytest
COPY go.sum ./
#RUN go mod tidy
RUN go mod download

COPY *.go ./

RUN go build -o /docker-gs-ping

##
## Deploy
##
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=builder /docker-gs-ping /docker-gs-ping

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/docker-gs-ping"]
