project_admins        = ["group:cloud-sde-test@pitt.edu"]
researchers           = ["group:cloud-sde-test-users@pitt.edu"]
data_stewards         = ["user:milnes@pitt.edu"] # individual accounts only, no group, added to the access context to access the necessary foundation projects. Syntax is `user:foo@bar.com`
num_instances         = 1
instance_machine_type = "n2-standard-2"
vm_disk_size          = 100

# Get list of custom images with newest on the bottom: gcloud compute images list --filter="family=packer-data-science" --sort-by=creationTimestamp --project=prod-sde-image-factory-68b6
golden_image_version  = "packer-data-science-79390dd" # add the name of the image here .
