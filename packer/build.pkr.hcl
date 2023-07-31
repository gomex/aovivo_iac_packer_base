build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    playbook_file        = "./ansible/playbook.yml"
    ansible_env_vars     = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp"]
    roles_path           = "./ansible/roles"
    user                 = var.user
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o StrictHostKeyChecking=no"
    ]
    // removido extra_arguments vazio
  }
}
Esta versão do arquivo define uma variável "user", que será usada pelo provisioner Ansible, e remove o argumento extra vazio. Além disso, adicionei um local para você definir a fonte "ubuntu-us-east-2".




User
aponte possíveis erros no arquivo source.pkr.hcl : locals {
  image_id = var.release != "" ? var.release : formatdate("YYYYMMDDhhmmss", timestamp())
}

source "amazon-ebs" "ubuntu-us-east-2" {
  ssh_username  = var.user
  instance_type = "t3.micro"
  
  region        = "us-east-2"
  ami_name      = replace("base-${local.image_id}", ".", "-")
  tags = {
    OS_Version    = "Ubuntu"
    Release       = "${local.image_id}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Extra         = "{{ .SourceAMITags.TagName }}"
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}
ChatGPT
O arquivo source.pkr.hcl que você forneceu parece estar principalmente correto, mas algumas partes podem gerar erros dependendo do contexto.

As variáveis var.release e var.user não são definidas neste arquivo. Se forem usadas em outra parte do arquivo ou se for esperado que sejam fornecidas na linha de comando, isso pode estar correto. Caso contrário, você precisará definir essas variáveis.

Na seção tags, você está usando {{ .SourceAMIName }} e {{ .SourceAMITags.TagName }}. Essas são variáveis de modelo do Packer e só são avaliadas durante o tempo de execução. Dependendo de como você planeja usar essas tags, isso pode ser uma fonte de erro.

Aqui está uma versão ligeiramente modificada do seu arquivo, que aborda esses problemas potenciais:

hcl
Copy code
variable "user" {
  description = "Username for the source configuration"
  type        = string
  default     = "ubuntu"
}

variable "release" {
  description = "Release version for the image"
  type        = string
  default     = ""
}

locals {
  image_id = var.release != "" ? var.release : formatdate("YYYYMMDDhhmmss", timestamp())
}

source "amazon-ebs" "ubuntu-us-east-2" {
  ssh_username  = var.user
  instance_type = "t3.micro"
  
  region        = "us-east-2"
  ami_name      = replace("base-${local.image_id}", ".", "-")
  tags = {
    OS_Version    = "Ubuntu"
    Release       = local.image_id
    Base_AMI_Name = "${SourceAMIName}"
    Extra         = "${SourceAMITags.TagName}"
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}
Esta versão do arquivo define as variáveis "user" e "release", que são usadas pelo provisioner. Além disso, atualizou as tags para usar a sintaxe HCL2 para interpolação de variáveis. No entanto, as variáveis SourceAMIName e SourceAMITags.TagName podem não estar disponíveis durante a construção, dependendo do seu ambiente e configuração específicos. Isso pode resultar em tags vazias ou inesperadas.




User
identifique possíveis erros no arquivo build.pkr.hcl: build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    playbook_file        = "./ansible/playbook.yml"
    ansible_env_vars     = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp"]
    roles_path           = "./ansible/roles"
    user                 = var.user
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o IdentitiesOnly=yes"
    ]
    extra_arguments = "--scp-extra-args", "'-O'" 
    // removido extra_arguments vazio
  }
}
ChatGPT
Existem algumas partes no seu arquivo build.pkr.hcl que podem gerar erros:

A variável var.user não é definida neste arquivo. Se for usada em outra parte do arquivo ou se for esperado que seja fornecida na linha de comando, isso pode estar correto. Caso contrário, você precisará definir essa variável.

extra_arguments é esperado como uma lista, mas o que você forneceu não parece ser uma lista. Se você está tentando passar argumentos extras para o Ansible, você precisa fornecê-los como uma lista de strings. Neste caso, você parece estar tentando passar um argumento para o scp, mas a sintaxe atual é inválida.

Aqui está uma versão corrigida do seu arquivo:

hcl
Copy code
variable "user" {
  description = "Username for the Ansible provisioner"
  type        = string
  default     = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu-us-east-2"]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    playbook_file        = "./ansible/playbook.yml"
    ansible_env_vars     = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp"]
    roles_path           = "./ansible/roles"
    user                 = var.user
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o IdentitiesOnly=yes"
    ]
    extra_arguments = ["--scp-extra-args", "'-O'"] 
  }
}




