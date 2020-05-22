<!-- (c) Copyright 2020 Hewlett Packard Enterprise Development LP -->
# Automated Deployment of Eshop Application on VMWare

This contains the set of modules to deploy all resources for eshop application as a 3 tier application - database tier, application tier and web tier.

## Deployment Layout
The following is the layout for the eshop application

### Main directory

> main.tf             - Calls all the modules - db, api and web tier

> variables.tf        - Input variables required for the deployment are all defined here

> outputs.tf          - Contains the outputs that will be shared at the end of deployment

> terraform.tfvars    - This contains the VMWare credentials and Template credentials
 

### Database Tier:

> metadata.yaml    - Cloud-init metadata template which will be invoked on the first boot to configure the hostname and the network.

> userdata.yaml    - Cloud-init userdata  template which will be invoked after creation of db instance. Contains all the
bootstrapping code for database layer.

> provider.tf      - Contains the VMWare provider definition.

> instance.tf    - This deploys the database instance and related resources.

> outputs.tf     - Outputs exported by db for use by other tiers. 

> variables.tf   - Inputs that are required for the database deployment. To be supplied from main.tf

### Application tier:

> metadata.yaml    - Cloud-init metadata template which will be invoked on the first boot to configure the hostname and the network.

> userdata.yaml    - Cloud-init userdata  template which will be invoked after creation of Application instance. Contains all the bootstrapping code for Application layer.

> provider.tf      - Contains the VMWare provider definition.

> instance.tf    - This deploys the application instance and related resources.

> outputs.tf     - Outputs exported by application for use by other tiers. 

> variables.tf   - Inputs that are required for the application deployment. To be supplied from main.tf

### Web tier:

> metadata.yaml    - Cloud-init metadata template which will be invoked on the first boot to configure the hostname and the network.

> userdata.yaml    - Cloud-init userdata  template which will be invoked after creation of web instance. Contains all the bootstrapping code for Web layer.

> provider.tf      - Contains the VMWare provider definition.

> instance.tf    - This deploys the web instance and related resources.

> variables.tf   - Inputs that are required for the application deployment. To be supplied from main.tf

## Prerequisites before running

- This requires a VMWare template in the cluster where you are going to deploy.  The template name is provided as input to this script. The template is a ubuntu 16.0.4 distro with the following command run.
- Install docker and docker-compose
  > sudo apt-get update
  
  > sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
  
  > curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  
  > sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  
  > sudo apt-get update
  
  > sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  
  > sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  
  > sudo chmod +x /usr/local/bin/docker-compose 

- Install cloud-init and related packages
  > sudo apt-get install open-vm-tools.
  
  > sudo apt-get install cloud-init
  
  > sudo apt-get install python3-pip
  
  > curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh - (For more details - https://github.com/vmware/cloud-init-vmware-guestinfo)
 
- Configure docker-proxy (if environment is behind the proxy)
  > sudo mkdir /etc/systemd/system/docker.service.d

  > Include the following content in /etc/systemd/system/docker.service.d/20-proxy.conf
  ```
  # (C) Copyright 2017-2019 Hewlett Packard Enterprise Development LP
  [Service]
  Environment="http_proxy=http://<proxy>:<port>"
  Environment="https_proxy=http://<proxy>:<port>"
  Environment="HTTP_PROXY=http://<proxy>:<port>"
  Environment="HTTPS_PROXY=http://<proxy>:<port>"
  Environment="no_proxy=127.0.0.1,localhost,docker.sock,.vm"
  ```
  > Include the following content in /etc/systemd/system/docker.service.d/30-dns.conf
  ```
  [Service]
  Environment="DNS_OPTS=--dns <DNS_SERVER> --dns <DNS_SERVER>"
  ```
  > sudo systemctl daemon-reload
  > sudo systemctl restart docker
  > sudo iptables -A DOCKER -j ACCEPT

## How to deploy

- Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

- Clone this project

- Edit values under tfvars_sample file and rename it to terraform.tfvars.
- Edit the values under variables.tf
    
- Run the following commands:
   > terraform init
   
   > terrforam plan
   
   > terrforam apply