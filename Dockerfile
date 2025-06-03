FROM alpine
LABEL org.opencontainers.image.title="FBI Test" \
    org.opencontainers.image.description="Local routing via fbi.com wildcard dns" \
    org.opencontainers.image.vendor="James Spurin" \
    com.docker.desktop.extension.api.version="0.3.4" \
    com.docker.extension.categories="utility-tools" \
    com.docker.extension.changelog=""

COPY docker-compose.yaml .
COPY nginx.Dockerfile .
COPY default.conf.template .
COPY index.nginx.html .
COPY metadata.json .
COPY icon.svg .
COPY ui ui
