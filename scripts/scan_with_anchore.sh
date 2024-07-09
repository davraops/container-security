#!/bin/bash

# Function to scan Docker image using Anchore
scan_image() {
  local image=$1

  # Add image to Anchore for analysis
  anchore-cli image add $image

  # Wait for the analysis to complete
  anchore-cli image wait $image

  # Get the vulnerability report
  anchore-cli image vuln $image all

  echo "Scan completed."
}

# Example usage
scan_image "your_docker_image:tag"
