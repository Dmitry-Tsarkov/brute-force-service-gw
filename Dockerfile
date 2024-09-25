FROM golang:1.22 as builder

WORKDIR /app

COPY . .

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o brute-force-service ./cmd/main.go

FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder /app/brute-force-service-gw /app/brute-force-service-gw

EXPOSE 50051

CMD ["./brute-force-service-gw"]

RUN apt-get update && apt-get install -y redis-tools

