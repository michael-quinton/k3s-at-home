variable "user_username" {
  type        = string
  description = "The username for the VM"
}

variable "user_password" {
  type        = string
  description = "The password for the user"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for authentication"
}