# Builder image for preparing Canvas LMS
# Builds dependencies and prepares the canvas_data volume

FROM canvas-runtime

# Install rsync for efficient file syncing
RUN apt-get update -y \
    && apt-get install -y rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy and setup build script
COPY build-canvas.sh /usr/local/bin/build-canvas.sh
RUN chmod +x /usr/local/bin/build-canvas.sh

WORKDIR /var/canvas

ENTRYPOINT ["/usr/local/bin/build-canvas.sh"]
