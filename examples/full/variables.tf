variable "github_app_id" {
  type        = string
  description = "GitHub App ID"
  sensitive   = true
}

variable "github_app_install_id" {
  type        = string
  description = "GitHub App Install ID"
  sensitive   = true
}

variable "github_app_private_key" {
  type        = string
  description = "GitHub App Private Key"
  sensitive   = true
}

variable "labels" {
  type        = list(string)
  description = "The labels for the runner"
}
