#!/bin/sh

/app/tailscaled \
    --tun=userspace-networking \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up \
    --hostname=mastobackup \
    --accept-routes=false \
    --auth-key=${TS_AUTHKEY}
crond -l 2 -f
