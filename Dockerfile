FROM redis

# Replace vulnerable gosu binary
RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -sSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && gosu nobody true

# Continue with your setup
COPY /script.sh /
VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo" && chmod +x /script.sh

USER 10014

EXPOSE 6379

ENTRYPOINT ["/script.sh"]
