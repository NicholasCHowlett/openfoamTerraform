# Provisioning of OpenFOAM to cloud-based computing resources using Terraform

This scaffold configuration file allows you to easily deploy reusable Computational Fluid Dynamic (CFD) environments on the cloud. With very significant cost savings associated with useing cloud (versus on-premise) computational infrastructure [1], high-use use-cases such as CFD will benefit greatly. Within this project repository the OpenFOAM software is installed on Linode's infrastructure using Terraform to provision the mentioned software/infrastructure.

## Setup for deployments
To be able to deploy CFD environments some prerequisites need to be completed, once-off:
1. Install [Terraform](https://www.terraform.io/downloads) and initialise a directory. Then from that directory pull this repository.
2. Setup [Linode](https://www.linode.com/) by creating an account then:
   - get your unique token.
   - install [OpenFOAM](https://openfoam.org/download/) on a Linode then create an Image from it. You may need to contact their support to allow you to create an Image sized larger than 6GB.

## Scalable deployments
Once the above has been completed, create individual directories that each represent a single computation instance. From each directory configure a `linode.tf` file, then initialise and deploy an instance of this configuration. The specific OpenFOAM case to be simulated needs to be within this directory.

_Note that due to a Terraform limitation you will need to manually SSH into the deployed instance to start the computation_. The IP address of each instance will be displayed on their deployment.


### References
[1] _Cost of CFD in the Cloud_: Chris Greenshields: https://cfd.direct/cloud/cost/
