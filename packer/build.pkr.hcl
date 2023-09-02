build {
  hcp_packer_registry {
    bucket_name = "base-image-aovivo"
    description = "Testando o packer HCP"

    bucket_labels = {
      "owner"          = "Plataforma"
      "os"             = "Ubuntu",
      "ubuntu-version" = "Focal 20.04",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
  sources = ["source.amazon-ebs.ubuntu-us-east-1"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true

    playbook_file    = "./ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp", ]
    roles_path       = "./ansible/roles"

    user = var.user

    // extra_arguments = ["-vvvv"]
  }
}
