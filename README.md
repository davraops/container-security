# Container Security

This repository contains best practices for building secure Docker containers and scripts for scanning container images for vulnerabilities using tools like Clair and Anchore.

## Table of Contents

- [Overview](#overview)
- [Dockerfile Best Practices](#dockerfile-best-practices)
- [Installation](#installation)
- [Usage](#usage)
  - [Clair](#clair)
  - [Anchore](#anchore)
- [Contributing](#contributing)
- [License](#license)

## Overview

Container security is crucial to maintain the integrity and security of your applications. This repository provides Dockerfile examples demonstrating best practices and scripts for scanning container images using Clair and Anchore.

## Dockerfile Best Practices

The `dockerfiles` directory contains Dockerfile examples that adhere to best practices, such as using official base images, minimizing layers and dependencies, running as a non-root user, and removing unnecessary packages and files.

Example Dockerfile:

```dockerfile
# Use official base image
FROM ubuntu:20.04

# Set non-root user
RUN useradd -m appuser
USER appuser

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /home/appuser/app

# Copy application code
COPY . .

# Run the application
CMD ["bash"]
```

## Installation

### Anchore CLI

1. **Install Anchore Engine**

   ```bash
   docker run -d -p 8228:8228 -p 8338:8338 --name anchore-engine --env ANCHORE_FEEDS_USER=<your_anchore_user> --env ANCHORE_FEEDS_PASSWORD=<your_anchore_password> anchore/anchore-engine:latest
   ```

2. **Install `anchore-cli`**

   ```bash
   pip install anchorecli
   ```

3. **Configure `anchore-cli`**

   ```bash
   export ANCHORE_CLI_USER=admin
   export ANCHORE_CLI_PASS=foobar
   export ANCHORE_CLI_URL=http://localhost:8228/v1
   ```

### Clairctl

1. **Download Clairctl**

   ```bash
   curl -L https://github.com/jgsqware/clairctl/releases/download/v1.7.4/clairctl-linux-amd64 -o clairctl
   chmod +x clairctl
   sudo mv clairctl /usr/local/bin/
   ```

2. **Run Clair**

   ```bash
   docker run -d --name db arminc/clair-db:latest
   docker run -d -p 6060:6060 --link db:postgres arminc/clair-local-scan:latest
   ```

3. **Configure Clairctl**

   Create a `clairctl.yml` configuration file:

   ```yaml
   clair:
     port: "6060"
     healthPort: 6061
     uri: "http://localhost"
     priority: High

   auth:
     insecureSkipVerify: true
     login: "admin"
     password: "admin"

   report:
     path: "./reports"
   ```

## Usage

### Clair

Scan Docker images with Clair:

```bash
./scripts/scan_with_clair.sh <your_docker_image:tag>
```

This script saves the Docker image as a tar file, generates the manifest, and scans the image using Clair. The report is saved to `report.json`.

### Anchore

Scan Docker images with Anchore:

```bash
./scripts/scan_with_anchore.sh <your_docker_image:tag>
```

This script adds the Docker image to Anchore for analysis, waits for the analysis to complete, and retrieves the vulnerability report.

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes.
4. Commit and push your changes to your fork.
5. Create a pull request to merge your changes into the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
