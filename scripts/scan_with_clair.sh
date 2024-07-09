#!/bin/bash

# Function to scan Docker image using Clair
scan_image() {
  local image=$1

  # Convert Docker image to tar format
  docker save $image -o image.tar

  # Generate the manifest
  clairctl manifest generate --input image.tar --output manifest.json

  # Scan the image using Clair
  clairctl report generate --manifest manifest.json --output report.json

  echo "Scan completed. Report saved to report.json"
}

# Example usage
scan_image "your_docker_image:tag"
