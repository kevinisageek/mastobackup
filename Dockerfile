FROM docker.io/library/alpine:3.22

# Install packages without cache to save space
RUN apk add --no-cache openssh-client

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale

# Create directories needed for database dump and tailscale state
RUN mkdir -p /backups /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Copy the main script into the image
COPY entrypoint.sh entrypoint.sh

# Set cronjob to run at midnight
RUN echo '@daily ssh -o StrictHostKeyChecking=accept-new kevin@100.101.155.97 docker exec -t mastodon-db pg_dumpall -c -U postgres > /backups/mastodon-db-$(date +%Y-%m-%d).sql' > /etc/crontabs/root

LABEL org.opencontainers.image.description="Simple utility container to facilitate backing up my Mastodon database to my NAS"
LABEL org.opencontainers.image.authors="kevinisageek"

CMD ["/entrypoint.sh"]
