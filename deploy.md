# Deploy

## For ARM64 (M1/M2 Macs, ARM servers)

docker-compose --profile local-arm64 up
docker-compose --profile local-arm64 up -d

docker-compose --profile local-arm64 down

## For AMD64 (Regular Linux/Windows)

docker-compose --profile local-amd64 up
docker-compose --profile local-amd64 up -d

docker-compose --profile local-amd64 down
