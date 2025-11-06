# ---- Base image ----
FROM debian:bullseye-slim

# ---- Environment ----
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# ---- Install dependencies ----
RUN apt-get update && apt-get install -y --no-install-recommends \
	tor nginx curl bash sudo procps \
 && rm -rf /var/lib/apt/lists/*

# ---- Prepare Tor hidden service directory ----
RUN mkdir -p /var/lib/tor/hidden_service && \
	chown -R debian-tor:debian-tor /var/lib/tor && \
	chmod 700 /var/lib/tor/hidden_service

# ---- Copy configuration files ----
COPY torrc /etc/tor/torrc
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh
COPY index.html /var/www/html/index.html

# ---- Permissions ----
RUN chmod +x /app/start.sh

# ---- Expose ports ----
EXPOSE 80 9050

# ---- Volume to persist onion address ----
VOLUME ["/var/lib/tor/hidden_service"]

# ---- Entrypoint ----
CMD ["/app/start.sh"]
