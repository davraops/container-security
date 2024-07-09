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

# Use a non-root user to run the application
USER appuser

# Run the application
CMD ["bash"]
