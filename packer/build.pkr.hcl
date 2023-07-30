build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]
  
  

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true

    playbook_file    = "./ansible/playbook.yml"
    ssh_options {
      host_key_algorithms = "+ssh-rsa"
      pubkey_accepted_algorithms = "+ssh-rsa"
    }
    ansible_env_vars = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp","ANSIBLE_PROXY_ENABLED=false" ]
    roles_path       = "./ansible/roles"

    user = "ubuntu"
    

    // extra_arguments = ["-vvvv"]
  }
}
