build {
  sources = ["source.amazon-ebs.ubuntu-us-east-1"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true

    playbook_file    = "./ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp", ]
    roles_path       = "./ansible/roles"

    user = var.user

    ssh_options {
      host_key_algorithms = "+ssh-rsa"
      pubkey_accepted_algorithms = "+ssh-rsa"
    }

    // extra_arguments = ["-vvvv"]
  }
}