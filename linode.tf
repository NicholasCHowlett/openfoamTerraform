# Variables to change for each case
variable "linodeSize" {
  type        = string
  default     = "g6-standard-2"
}

variable "caseName" {
  type        = string
  default     = "ofCase-1"
}

variable "caseGroup" {
  type        = string
  default     = "ofCaseGroup-1"
}

variable "ofSolver" {
  type        = string
  default     = "simpleFoam"
}


# Less-changed variables
variable "linodeRegion" {
  type        = string
  default     = "ap-southeast"
}

terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}


# Sensitive data
provider "linode" {
  token = ""
}

variable "sshKey" {
  type        = string
  default     = ""
}


# Main configuration
resource "random_string" "password" {
    length = 32
    special = true
    upper = true
    lower = true
    number = true
}

resource "linode_instance" "linode-0" {
  image = "private/16441242" # openfoam: OFv9 on Ubuntu 22 LTS
  label = var.caseName
  group = var.caseGroup
  region = var.linodeRegion
  type = var.linodeSize
  authorized_keys = [ var.sshKey ]
  root_pass = random_string.password.result

  # Copies folder from host to remote machine
  provisioner "file" {
    source      = "case"
    destination = "caseRemote"
    connection {
      type     = "ssh"
      host     = linode_instance.linode-0.ip_address
      user     = "root"
      password = random_string.password.result
    }
  }

  # put folder in correct place
  provisioner "remote-exec" {
    inline = [
      "echo We are in",
      "cp -r ./caseRemote ./OpenFOAM/root-9/run",
      "cd ./OpenFOAM/root-9/run/caseRemote",
      #"simpleFoam > log &", # does not execute.
    ]
    connection {
      type     = "ssh"
      host     = linode_instance.linode-0.ip_address
      user     = "root"
      password = random_string.password.result
    }
    on_failure = continue
  }
}

# make visible details of just-created remote machine
output "ip" {
  value = linode_instance.linode-0.ip_address
  depends_on = [linode_instance.linode-0]
}
