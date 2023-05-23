project_admins        = ["user:speralta@tunedcold.site"]
researchers           = ["user:speralta@tunedcold.site"]
data_stewards         = ["user:speralta@tunedcold.site"] 
num_instances         = 0
instance_machine_type = "n2-standard-2"
vm_disk_size          = 100

# Get list of custom images with newest on the bottom: gcloud compute images list --filter="family=packer-data-science" --sort-by=creationTimestamp --project=prod-sde-image-factory-68b6
golden_image_version = "packer-data-science-abc1234"   