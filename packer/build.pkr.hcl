build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    playbook_file        = "./ansible/playbook.yml"
    ansible_env_vars     = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp", "ANSIBLE_HOST_KEY_CHECKING=False"]
    roles_path           = "./ansible/roles"
    user                 = var.user
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
    extra_arguments = [
      "--scp-extra-args", "-O"
    ]

    // removido extra_arguments vazio
  }
}