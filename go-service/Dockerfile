# Многоэтапная сборка
FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum* ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server .

# Финальный образ на alpine
FROM alpine:3.19

RUN apk --no-cache add ca-certificates tzdata

COPY --from=builder /app/server /server

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["/server", "health"] || exit 1

USER 1000:1000

ENTRYPOINT ["/server"]