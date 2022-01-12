#!/bin/bash
# Allow Docker to run
sudo chmod 666 /var/run/docker.sock

gcloud auth configure-docker us-east1-docker.pkg.dev --quiet

# Pull down the image from Artifact Registry
docker pull us-east1-docker.pkg.dev/packer-srde-wcm-6b29/path-ml/path-ml:latest

# Start the container on the path ml instance
docker run -d -p 8888:8888 us-east1-docker.pkg.dev/packer-srde-wcm-6b29/path-ml/path-ml:latest