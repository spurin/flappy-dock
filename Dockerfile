FROM alpine
LABEL org.opencontainers.image.title="Flappy Dock" \
    org.opencontainers.image.description="A fun extension to play Flappy Bird, but Docker style!" \
    org.opencontainers.image.vendor="Michael Irwin" \
    com.docker.desktop.extension.api.version=">= 0.2.3" \
    com.docker.extension.screenshots="[ { \"alt\": \"Start screen\", \"url\": \"https://mikesir87.io/flappy-dock/images/start-screen.png\" }, { \"alt\": \"Playing the game\", \"url\": \"https://mikesir87.io/flappy-dock/images/in-game.png\"}]" \
    com.docker.extension.detailed-description="" \
    com.docker.extension.publisher-url="" \
    com.docker.extension.additional-urls="" \
    com.docker.extension.changelog=""

COPY metadata.json .
COPY docker.svg .
COPY ./ui ui
CMD ["tail", "-f", "/dev/null"]
