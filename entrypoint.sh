#!/bin/sh
set -e

# Define data directory
DATA_DIR="/data"

# Ensure data directory exists
if [ ! -d "$DATA_DIR" ]; then
    mkdir -p "$DATA_DIR"
fi

# Symlink persistence files if they exist in data volume
if [ -f "$DATA_DIR/ooye.db" ]; then
    ln -sf "$DATA_DIR/ooye.db" /app/ooye.db
fi

if [ -f "$DATA_DIR/registration.yaml" ]; then
    ln -sf "$DATA_DIR/registration.yaml" /app/registration.yaml
fi

# If the command is 'setup', run the setup script
if [ "$1" = "setup" ]; then
    echo "Running setup..."
    npm run setup
    
    # After setup, move generated files to data directory if they aren't already there
    if [ -f /app/registration.yaml ] && [ ! -L /app/registration.yaml ]; then
        echo "Moving registration.yaml to data directory..."
        mv /app/registration.yaml "$DATA_DIR/registration.yaml"
        ln -s "$DATA_DIR/registration.yaml" /app/registration.yaml
    fi
    
    if [ -f /app/ooye.db ] && [ ! -L /app/ooye.db ]; then
        echo "Moving ooye.db to data directory..."
        mv /app/ooye.db "$DATA_DIR/ooye.db"
        ln -s "$DATA_DIR/ooye.db" /app/ooye.db
    fi
    
    exit 0
fi

# If just starting and registration doesn't exist, warn user
if [ ! -f /app/registration.yaml ] && [ "$1" = "npm" ] && [ "$2" = "start" ]; then
    echo "WARNING: registration.yaml not found at /app/registration.yaml or /app/data/registration.yaml."
    echo "You likely need to run the setup first."
    echo "Usage: docker run -it -v ./data:/data <image> setup"
fi

exec "$@"
