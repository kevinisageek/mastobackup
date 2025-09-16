FROM alpine:latest

# Install packages then remove the package cache to save space
RUN apk update && apk add openssh-client nginx ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Create the backup target
RUN mkdir /backups

# Copy the main script into the image
COPY entrypoint.sh entrypoint.sh

# Set cronjob to run at midnight
RUN echo '@daily ssh kevin@100.101.155.97  docker exec -t mastodon-db pg_dumpall -c -U postgres > /backups/mastodon-db-$(date +%Y-%m-%d).sql' > /etc/crontabs/root

CMD ["/entrypoint.sh"]
