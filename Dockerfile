FROM nginx:alpine
COPY --from=mikesir87/flappy-dock-extension --chmod=755 /ui /usr/share/nginx/html
