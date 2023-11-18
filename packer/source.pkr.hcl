locals {
  image_id = var.release != "" ? var.release : formatdate("YYYYMMDDhhmmss", timestamp())
}

source "amazon-ebs" "ubuntu-us-east-1" {
  ssh_username  = var.user
  instance_type = "t3.micro"
  region        = "us-east-1"
  ami_name      = replace("base-${local.image_id}", ".", "-")
  tags = {
    OS_Version    = "Ubuntu_aula_ao_vivo
    Release       = "${local.image_id}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Extra         = "{{ .SourceAMITags.TagName }}"
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

