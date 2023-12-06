variable "repo_owner" {
  type        = string
  description = "The owner of the repository"
}

variable "repo_name" {
  type        = string
  description = "The name of the repository"
}

variable "labels" {
  type        = list(string)
  description = "The labels for the runner"
  default     = ["k8s", "arc"]
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the runner controller into"
  default     = "github-actions-runner"
}

variable "create_namespace" {
  type        = bool
  description = "If true, the namespace will be created"
  default     = true
}

variable "name" {
  type        = string
  description = "The name of the runner deployment"
  default     = "github-actions-runner"
}

variable "runner_service_account_name" {
  type        = string
  description = "The name of the service account for the runner"
  default     = "github-actions-runner"
}

variable "job_service_account_name" {
  type        = string
  description = "The name of the service account for the job"
  default     = "github-actions-job"
}

variable "runner_image" {
  type        = string
  description = "The image for the runner"
  default     = "summerwind/actions-runner:latest"
}

variable "ephemeral" {
  type        = bool
  description = "If true, the runner will be ephemeral"
  default     = true
}

variable "min_count" {
  type        = number
  description = "The minimum number of runners"
  default     = 1
}

variable "max_count" {
  type        = number
  description = "The maximum number of runners"
  default     = 3
}

variable "scale_down_delay_seconds" {
  type        = number
  description = "The number of seconds from scaling out to wait before scaling down"
  default     = 300
}

variable "metrics" {
  type        = list(map(string))
  description = "The metrics for the runner"
  default = [
    {
      type               = "PercentageRunnersBusy"
      scaleUpThreshold   = "0.75"
      scaleDownThreshold = "0.25"
      scaleUpFactor      = "2"
      scaleDownFactor    = "0.5"
    }
  ]
}

variable "storage_class_name" {
  type        = string
  description = "The storage class name for the runner"
  default     = "default"
}

variable "storage_size" {
  type        = string
  description = "The storage size for the runner"
  default     = "100Mi"
}
