provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path       = "~/.kube/config"
  load_config_file  = true
  apply_retry_count = 10
}
