# Builder
FROM golang:1.24.5-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o cert-monitor

# Runtime stage
FROM scratch
COPY --from=builder /app/cert-monitor /cert-monitor
CMD ["/cert-monitor"]
