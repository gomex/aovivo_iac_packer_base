build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    playbook_file        = "./ansible/playbook.yml"
    ansible_env_vars     = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp", "ANSIBLE_SSH_EXTRA_ARGS='-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa'"]
    roles_path           = "./ansible/roles"
    user                 = var.user
    
    //ansible_ssh_extra_args = [
    //  "'-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
    //]

    // removido extra_arguments vazio
  }
}