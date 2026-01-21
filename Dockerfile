# Build stage
FROM node:22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git python3 make g++ build-base vips-dev

WORKDIR /app

# Argument for the git reference (branch, tag, sha)
ARG OOYE_REF=main

# Clone the repository
RUN git clone https://gitdab.com/cadence/out-of-your-element.git . && \
    git checkout ${OOYE_REF}

# Install dependencies
RUN npm install node-addon-api node-gyp && \
    npm install --omit=dev

# Runtime stage
FROM node:22-alpine

# Install runtime dependencies (vips for sharp, etc)
RUN apk add --no-cache libstdc++ vips

WORKDIR /app

# Copy application code and node_modules from builder
COPY --from=builder /app /app

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create data directory and volume
RUN mkdir -p /data
VOLUME ["/data"]

# Expose port
EXPOSE 6693

ENTRYPOINT ["entrypoint.sh"]
CMD ["npm", "start"]
