locals {
  pod_template_configmap_name = "${var.name}-job-template"
}

resource "kubernetes_service_account" "job" {
  metadata {
    name      = var.job_service_account_name
    namespace = local.namespace
  }
  secret {
    name = kubernetes_secret.job.metadata[0].name
  }
}

resource "kubernetes_secret" "job" {
  metadata {
    name      = var.job_service_account_name
    namespace = local.namespace
  }
}

resource "kubernetes_config_map" "job-template" {
  metadata {
    name      = local.pod_template_configmap_name
    namespace = local.namespace
  }
  data = {
    "default.yml" = yamlencode({
      apiVersion = "v1"
      kind       = "PodTemplate"
      metadata = {
        name = "runner-pod-template"
      }
      spec = {
        serviceAccountName = var.job_service_account_name
      }
    })
  }
}
