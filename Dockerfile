FROM bitnami/redis:7.2.4

# Copy your custom script (already executable)
COPY /script.sh /

# Declare a volume for persistence
VOLUME ["/persistance-volume-1"]
WORKDIR /persistance-volume-1

# Expose Redis default port
EXPOSE 6379

# Run your startup script
ENTRYPOINT ["/script.sh"]
