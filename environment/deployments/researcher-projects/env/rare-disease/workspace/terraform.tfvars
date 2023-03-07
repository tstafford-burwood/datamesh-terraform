project_admins        = ["group:sde-centralit@prorelativity.com"]
researchers           = ["group:sde-centralit@prorelativity.com"]
data_stewards         = ["user:astrong@prorelativity.com"] 
num_instances         = 0
instance_machine_type = "n2-standard-2"
vm_disk_size          = 100

# Get list of custom images with newest on the bottom: gcloud compute images list --filter="family=packer-data-science" --sort-by=creationTimestamp --project=prod-sde-image-factory-68b6
golden_image_version = "packer-data-science-abc1234"   