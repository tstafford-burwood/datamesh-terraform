project_admins        = []
researchers           = ["user:sde@prorelativity.com"]
data_stewards         = ["user:sde@prorelativity.com"] # individual accounts only, no group, added to the access context to access the necessary foundation projects. Syntax is `user:foo@bar.com`
num_instances         = 0
instance_machine_type = "n2-standard-2"
vm_disk_size          = 100

# Get list of custom images with newest on the bottom: gcloud compute images list --filter="family=packer-data-science" --sort-by=creationTimestamp --project={PROJECT_ID}
golden_image_version  = "" # add the name of the image here.
