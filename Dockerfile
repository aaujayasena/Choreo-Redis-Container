FROM redis:latest

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
