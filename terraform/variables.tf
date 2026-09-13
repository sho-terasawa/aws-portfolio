variable "ssh_allowed_cidr" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "acm_certificate_arn" {
  type = string
}