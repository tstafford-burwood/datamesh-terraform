# VM Manager

VM Manager Documentation is [here](https://cloud.google.com/compute/docs/vm-manager)  VM Manager includes OS patch management, OS inventory management, and OS configuration management.

Enable the following APIs to enable VM Manager.

```
gcloud services enable osconfig.googleapis.com
gcloud services disable containerscanning.googleapis.com
```

Vulnerability reports are obtained by OS inventory management.  Vulnerabilities integrate with VM Manager, Cloud Asset, and in previus with Security Command Center Premium.  Vulnerability repots contain CVEs.  A vulnerability report is generated within three to hour hours after the CVE is published.  More detail on viewing the vulnerability is [here](https://cloud.google.com/compute/docs/manage-os#enable-metadata)

```
Key: enable-osconfig
Value: TRUE

Key: enable-guest-attributes
Value: TRUE
```

Ensure that VM has an attached service account.  The service account does not need additional permissions.  It is used to sign requests to the API service.

The OS Config agent is automatically installed on Google Cloud build images.  To gather all data also enter the following values either at the project or instance metadata levels.  More info is [here](sudo systemctl status google-osconfig-agent)

To check if a VM is enrolled run `sudo systemctl status google-osconfig-agent`
