# USE LATEST GCLOUD SDK ALPINE IMAGE
# LIGHTWEIGHT BASE IMAGE
FROM google/cloud-sdk:alpine

# UPDATE REPOSITORIES
RUN apk update
RUN apk upgrade
RUN apk add bash

# INSTALL WGET, UNZIP
RUN apk add wget unzip

# DOWNLOAD AND INSTALL Terraform v0.13.5
RUN wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip && unzip terraform_0.13.5_linux_amd64.zip
RUN mv terraform /usr/local/bin/

# DOWNLOAD terraform-validator FROM PUBLIC GCS BUCKET
# gsutil ls -r gs://terraform-validator/releases/v*
RUN gsutil cp gs://terraform-validator/releases/v0.12.1/terraform-validator_linux_amd64-0.12.1.tar.gz . \
    && tar -xzvf terraform-validator_linux_amd64-0.12.1.tar.gz \
    && chmod 755 terraform-validator

RUN ./terraform-validator version

# MOVE terraform-validator INTO PATH 
RUN mv terraform-validator /usr/local/bin
