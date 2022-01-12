# Introduction

A YAML file in the context of Cloud Build is a configuration file that defines the steps that a Cloud Build trigger will run/perform.

[How to create a YAML based build configuration file.](https://cloud.google.com/build/docs/configuring-builds/create-basic-configuration#creating_a_build_config)

# YAML Files and Triggers 

Triggers within Cloud Build are associated with a YAML file. YAML files in the context of this repository tell the Cloud Build trigger a build step name, Terraform container image to use, where `.tf` files are located, and also what Terraform steps (`init`, `plan`, `apply`) to perform.

YAML files can be found in the [cloudbuild](../cloudbuild) directory.

# YAML File Syntax

In general there are a few fields in the Cloud Build pipelines that are of importance.

* id - Defines a friendly name of the build step.
* name - Defines the container image to use during the build.
* dir - Defines the working directory to run the container commands/args from.
* args - Defines the commands to run in the container image.