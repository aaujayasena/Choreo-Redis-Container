FROM redis
# https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64
# 🛠️ Install required tools and upgrade gosu to v1.22.4
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        dirmngr \
        ca-certificates \
    && set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "$ARCH" in \
      amd64) GOSU_ARCH='amd64' ;; \
      arm64) GOSU_ARCH='amd64' ;; \
      *) echo >&2 "unsupported architecture: $ARCH"; exit 1 ;; \
    esac; \
    curl -fsSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.14/gosu-${GOSU_ARCH}"; \
    curl -fsSL -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.14/gosu-${GOSU_ARCH}.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    gosu --version \
    && apt-get purge -y --auto-remove curl gnupg dirmngr ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# Copy your custom script
COPY /script.sh /

# Declare a volume for persistence
VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1

# Create a non-root user (Choreo requirement)
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo" && chmod +x /script.sh

# Use the unprivileged user
USER 10014

# Expose Redis default port
EXPOSE 6379

# Run your startup script
ENTRYPOINT ["/script.sh"]
