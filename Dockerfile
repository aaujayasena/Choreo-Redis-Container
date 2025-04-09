FROM bitnami/redis:7.2.4

# Copy your custom script (ensure it's executable before build)
COPY /script.sh /

# Declare a volume for persistence
VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1

# Explicitly run as non-root user to satisfy Choreo and Checkov
USER 1001

# Expose Redis default port
EXPOSE 6379

# Run your startup script
ENTRYPOINT ["/script.sh"]
