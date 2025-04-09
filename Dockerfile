FROM redis

COPY /script.sh /
VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1
# Create a user with a known UID/GID within range 10000-20000.
# This is required by Choreo to run the container as a non-root user.
RUN \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo" && chmod +x /script.sh

# Use the above created unprivileged user
USER 10014

EXPOSE 6379

ENTRYPOINT ["/script.sh"]
