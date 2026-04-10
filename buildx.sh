#!/bin/bash
# Кросс-платформенная сборка образов (linux/amd64, linux/arm64)

set -e

# Создаём билдер для multi-arch (если не существует)
docker buildx create --name mybuilder --use || true
docker buildx inspect --bootstrap

# Сборка Go-образов
docker buildx build --platform linux/amd64,linux/arm64 -t go-scratch:latest -f go-service/Dockerfile.scratch go-service/ --push
docker buildx build --platform linux/amd64,linux/arm64 -t go-alpine:latest -f go-service/Dockerfile.alpine go-service/ --push

# Сборка Python-образов
docker buildx build --platform linux/amd64,linux/arm64 -t python-slim:latest -f python-service/Dockerfile.slim python-service/ --push
docker buildx build --platform linux/amd64,linux/arm64 -t python-regular:latest -f python-service/Dockerfile python-service/ --push

# Сборка Rust-образов
docker buildx build --platform linux/amd64,linux/arm64 -t rust-alpine:latest -f rust-service/Dockerfile.alpine rust-service/ --push
docker buildx build --platform linux/amd64,linux/arm64 -t rust-regular:latest -f rust-service/Dockerfile rust-service/ --push

echo "✅ Multi-arch images built and pushed successfully"