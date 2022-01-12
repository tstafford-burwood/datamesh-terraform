# USE LATEST GCLOUD SDK ALPINE IMAGE
# LIGHTWEIGHT BASE IMAGE
FROM google/cloud-sdk:alpine

# UPDATE REPOSITORIES
RUN apk update

# INSTALL WGET, UNZIP
RUN apk add wget unzip

# DOWNLOAD AND INSTALL Terraform v0.13.5
RUN wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip && unzip terraform_0.13.5_linux_amd64.zip
RUN mv terraform /usr/local/bin/

# DOWNLOAD terraform-validator FROM PUBLIC GCS BUCKET
# gsutil ls -r gs://terraform-validator/releases/v*
RUN gsutil cp gs://terraform-validator/releases/v0.9.1/terraform-validator_linux_amd64-0.9.1.tar.gz . && tar -xzvf terraform-validator_linux_amd64-0.9.1.tar.gz

# CHANGE MODE ON terraform-validator
RUN chmod 755 terraform-validator

# MOVE terraform-validator INTO PATH
RUN mv terraform-validator /usr/local/bin