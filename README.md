# Out Of Your Element - Docker

Docker packaging for [Out Of Your Element](https://gitdab.com/cadence/out-of-your-element), a bridge between Matrix and Discord.

## Usage

### 1. Setup

First, you need to run the setup script to generate the configuration files (`registration.yaml` and `ooye.db`).

```bash
mkdir data
docker run --rm -it -v $(pwd)/data:/data ghcr.io/t2linux/out-of-your-element:latest setup
```

Follow the interactive prompts. The configuration files will be saved to your `./data` directory.

### 2. Run

Once setup is complete, start the container:

```bash
docker run -d \
  --name ooye \
  -v $(pwd)/data:/data \
  -p 6693:6693 \
  ghcr.io/t2linux/out-of-your-element:latest
```

### Persistence

The configuration and database are stored in `/data` inside the container. Mount this volume to persist your data.

-   `/data/registration.yaml`
-   `/data/ooye.db`

### Build Arguments

-   `OOYE_REF`: The git reference (branch, tag, sha) of the OOYE repository to build.
    -   When running the GitHub Action automatically, this defaults to the **latest upstream tag**.
    -   If manually triggering the workflow, you can specify a branch or tag (e.g. `main` or `v3.3`).
