variable "user" {
  type        = string
  description = "Default username"
  default     = "ubuntu"
}

variable "release" {
  type        = string
  description = "Release tag from CICD pipeline"
  default     = ""
}
