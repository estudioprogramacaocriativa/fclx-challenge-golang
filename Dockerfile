FROM golang:1.20 AS build

ENV CGO_ENABLED=1

WORKDIR /app

COPY . .

RUN go mod tidy && \
    go build -ldflags="-w -s" -o /go/bin/app && \
    apt-get update && \
    apt-get install -y upx && \
    upx /go/bin/app

FROM scratch

COPY --from=build /go/bin/app /app

ENTRYPOINT ["/app"]