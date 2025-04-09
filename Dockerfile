FROM bitnami/redis:7.2.4 as base

# Copy script early
COPY script.sh /script.sh

# Final image with UID 10014
FROM bitnami/redis:7.2.4

# Copy script
COPY --from=base /script.sh /script.sh

# Set executable bit locally first (ensure before build)
# chmod +x script.sh

# Set the UID/GID explicitly (Choreo requires it)
USER 10014

VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1

EXPOSE 6379
ENTRYPOINT ["/script.sh"]
