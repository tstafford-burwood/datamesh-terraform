# Terraform AI Platform Module

A terraform module that creates an AI Platform Noteobook in a secure way.

The resources that this module will create are:

* One AI Platform Notebook per Notebook user

## Assumptions
* You have your Project and network configuration available for where you want to deploy

## Prerequisites

### Prepare your admin workstation
You can use Cloud Shell, a local machine or VM as your admin workstation

####
[**Tools for Cloud Shell as your Admin workstation**](#tools-for-cloud-shell-as-your-admin-workstation)

*   [Terraform >= 0.12.3](https://www.terraform.io/downloads.html)
*   [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.51

####
[**Tools for a local workstation as your Admin workstation**](#tools-for-a-local-workstation-as-your-admin-workstation)

*   [Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/quickstarts)
*   [Terraform >= 0.12.3](https://www.terraform.io/downloads.html)
*   [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.51

####
**Installation instructions for Tools for your environment**


#####
[Install Cloud SDK](#install-cloud-sdk)


This is pre installed if you are using Cloud Shell

The Google Cloud SDK is used to interact with your GCP resources. [Installation instructions](https://cloud.google.com/sdk/downloads) for multiple platforms are available online.

#####
[Install Terraform](https://www.terraform.io/intro/getting-started/install.html)

Terraform is used to automate the manipulation of cloud infrastructure. Its [installation instructions](https://www.terraform.io/intro/getting-started/install.html) are also available online.
When configuring terraform for use with Google cloud create a service account as detailed in [Getting started with the google provider](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials)


#### **Authentication**

After installing the gcloud SDK run gcloud init to set up the gcloud cli. When executing choose the correct region and zone

'gcloud init'

Ensure you are using the correct project  . Replace my-project-name with the name of your project

Where the project name is my-project-name

`gcloud config set project my-project-name`

## Usage

Basic usage of this module is as follows:

```hcl
module "ai_instance" {
  source          = "../ai_notebook"
  name            = "jlab-test"
  project         = var.project
  network         = data.google_compute_network.vpc.id
  subnet          = data.google_compute_subnetwork.subnetwork.id
  location        = "us-central1-b"
  machine_type    = "e2-medium"
  vm_project      = "deeplearning-platform-release"
  image_family    = "tf-latest-cpu"
  instance_owners = ["alice@example.com"]
  metadata = {    
    notebook-disable-root      = "true"
    notebook-disable-downloads = "true"
    notebook-disable-nbconvert = "true"
  }
}

data "google_compute_network" "vpc" {
  name    = "custom-vpc"
  project = var.project
}

data "google_compute_subnetwork" "subnetwork" {
  project = var.project
  name    = "subnet-uscentral1-01"
  region  = "us-central1"
}

variable "project" {
  default = "example-project-id"
}


output "proxy-url" {
  value = module.ai_instance.proxy_uri
}
```

1. Create a tfvars file with the required inputs.
```bash
cp terraform.tfvars.exampe my_file.tfvars
```
1. `terraform init` to get the plugins
1. `terraform plan -var-file="YOUR_FILE.tfvars"` to see the infrastructure plan. Note: Replace `YOUR_FILE` with the name of your tfvars file from the first step.
1. `terraform apply -var-file="YOUR_FILE.tfvars"` to apply the infrastructure build. Note: Replace `YOUR_FILE` with the name of your tfvars file from the first step.
1. Access your AI Platform Notebook
* Establish an [SSH tunnel](https://cloud.google.com/notebooks/docs/ssh-access) from your device to your AI Platform Notebook
* in your browser, visit `http://<proxy-url>` to access your AI Platform Notebook.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_notebooks_instance.instance](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_notebooks_instance) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boot_disk_size_gb"></a> [boot\_disk\_size\_gb](#input\_boot\_disk\_size\_gb) | The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). The minimum recommended value is 100 GB. If not specified, this defaults to 100. | `number` | `100` | no |
| <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type) | Possible disk types for notebook instances. Possible values are `DISK_TYPE_UNSPECIFIED`, `PD_STANDARD`, `PD_SSD`, and `PD_BALANCED`. | `string` | `"PD_STANDARD"` | no |
| <a name="input_consume_reservation_type"></a> [consume\_reservation\_type](#input\_consume\_reservation\_type) | The type of Compute Reservation. Possible values are `NO_RESERVATION`, `ANY_RESERVATION`, and `SPECIFIC_RESERVATION`. | `string` | `"NO_RESERVATION"` | no |
| <a name="input_data_disk_size_gb"></a> [data\_disk\_size\_gb](#input\_data\_disk\_size\_gb) | The size of the data disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). You can choose the size of the data disk based on how big your notebooks and data are. If not specified, this defaults to 100. | `number` | `100` | no |
| <a name="input_data_disk_type"></a> [data\_disk\_type](#input\_data\_disk\_type) | Possible disk types for notebook instances. Possible values are `DISK_TYPE_UNSPECIFIED`, `PD_STANDARD`, `PD_SSD`, and `PD_BALANCED`. | `string` | `null` | no |
| <a name="input_enable_integrity_monitoring"></a> [enable\_integrity\_monitoring](#input\_enable\_integrity\_monitoring) | Defines whether the instance has integrity monitoring enabled. | `bool` | `false` | no |
| <a name="input_enable_secure_boot"></a> [enable\_secure\_boot](#input\_enable\_secure\_boot) | Defines whether the instance has Secure Boot enabled. | `bool` | `false` | no |
| <a name="input_enable_vtpm"></a> [enable\_vtpm](#input\_enable\_vtpm) | Defines whether the instance has the vTPM enabled. | `bool` | `false` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Use this VM image family to find the image; the newest image in this family will be used. | `string` | n/a | yes |       
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Use VM image name to find the image | `string` | `null` | no |
| <a name="input_install_gpu_driver"></a> [install\_gpu\_driver](#input\_install\_gpu\_driver) | Whether the end user authorizes Google Cloud to install GPU driver on this instance. Only applicable to instances with GPUs. | `bool` | `false` | no |
| <a name="input_instance_owners"></a> [instance\_owners](#input\_instance\_owners) | The list of owners of this instance after creation. Format: alias@example.com. Currently supports one owner only. | `list` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to this instance | `map` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | A reference to the zone where the machine resides | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | A reference to a machine type which defines VM kind | `string` | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Additional metadata key/values that can be used:<br>terraform                  = "true"<br>proxy-mode                 = "mail"<br>proxy-user-mail            = "alice@example.com"<br>notebook-disable-root      = "true"<br>notebook-disable-downloads = "true"<br>notebook-disable-nbconvert = "true"<br>serial-port-enable         = "FALSE"<br>block-project-ssh-keys     = "TRUE" | `map` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name specified for the Notebook instance. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The name of the VP that the instance is in. Format: projects/{project\_id}/global/networks/{network\_id} | `string` | n/a | yes |
| <a name="input_nic_type"></a> [nic\_type](#input\_nic\_type) | The type of vNIC driver. Possible values are `UNSPECIFIED_NIC_TYPE`, `VIRTIO_NET`, and `GVNIC`. | `string` | `"VIRTIO_NET"` | no |   
| <a name="input_no_proxy_access"></a> [no\_proxy\_access](#input\_no\_proxy\_access) | The notebook instance will not register with the proxy. | `bool` | `false` | no |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip) | No public IP will be assigned to this instance. | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| <a name="input_project_services"></a> [project\_services](#input\_project\_services) | List of Service APIs to enable on the project | `list(string)` | <pre>[<br>  "notebooks.googleapis.com",<br>"ml.googleapis.com"<br>]</pre> | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account on this instance, giving access to other Google Cloud services. If not specified, the Compute Engine default service account is used. | `string` | `null` | no |
| <a name="input_service_account_scopes"></a> [service\_account\_scopes](#input\_service\_account\_scopes) | The URIs of service account scopes to be included in Compute Engine instances. If not specified, the following scopes are defined: | `list` | `[]` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | The name of the subnet that this instance is in. Format: projects/{project\_id}/regions/{region}/subnetworks/{subnetwork\_id} | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The Compute Engine tags to add to runtime. | `list` | `[]` | no |
| <a name="input_vm_project"></a> [vm\_project](#input\_vm\_project) | The name of the Google Cloud project that this VM image belongs to. Format: projects/{project\_id} | `string` | n/a | yes |    

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | An identifier for the resource. |
| <a name="output_proxy_uri"></a> [proxy\_uri](#output\_proxy\_uri) | The proxy endpoint that is used to access the Jupyter notebook. |
| <a name="output_state"></a> [state](#output\_state) | The state of the instance. |