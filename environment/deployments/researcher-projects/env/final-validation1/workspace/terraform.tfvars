project_admins        = ["user:tap145@client.edu", "user:milnes@client.edu"]
researchers           = ["user:brian@client.edu", "user:afs26@client.edu", "user:milnes@client.edu", "user:sdw37@client.edu", "user:astrong@client.edu"]
data_stewards         = ["user:jjennings@burwood.com", "user:astrong@burwood.com"] 
#data_stewards         = ["user:tap145@client.edu", "user:milnes@client.edu", "user:astrong@burwood.com"]
num_instances         = 1
instance_machine_type = "n2-standard-2"
vm_disk_size          = 100

# Get list of custom images with newest on the bottom: gcloud compute images list --filter="family=packer-data-science" --sort-by=creationTimestamp --project=prod-sde-image-factory-68b6
golden_image_version = "packer-data-science-79390dd"   