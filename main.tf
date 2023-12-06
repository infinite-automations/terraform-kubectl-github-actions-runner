locals {
  namespace = var.create_namespace ? kubernetes_namespace.this[0].metadata[0].name : data.kubernetes_namespace.this[0].metadata[0].name
}

data "kubernetes_namespace" "this" {
  count = var.create_namespace ? 0 : 1
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "kubectl_manifest" "runner" {
  yaml_body = yamlencode({
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "RunnerDeployment"
    metadata = {
      name      = var.name
      namespace = local.namespace
    }
    spec = {
      template = {
        spec = {
          repository         = "${var.repo_owner}/${var.repo_name}"
          labels             = var.labels
          containerMode      = "kubernetes"
          serviceAccountName = kubernetes_service_account.runner.metadata[0].name
          workVolumeClaimTemplate = {
            storageClassName = var.storage_class_name
            accessModes = [
              "ReadWriteOnce"
            ]
            resources = {
              requests = {
                storage = var.storage_size
              }
            }
          }
          image = var.runner_image
          env = [
            {
              name  = "ACTIONS_RUNNER_CONTAINER_HOOK_TEMPLATE"
              value = "/home/runner/pod-templates/default.yml"
            }
          ]
          volumes = [
            {
              name = "pod-templates"
              configMap = {
                name = local.pod_template_configmap_name
              }
            }
          ]
          volumeMounts = [
            {
              name      = "pod-templates"
              mountPath = "/home/runner/pod-templates"
              readOnly  = true
            }
          ]
        }
      }
    }
  })
}

resource "kubectl_manifest" "runner_autoscaler" {
  yaml_body = yamlencode({
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "HorizontalRunnerAutoscaler"
    metadata = {
      name      = var.name
      namespace = local.namespace
    }
    spec = {
      scaleDownDelaySecondsAfterScaleOut = var.scale_down_delay_seconds
      scaleTargetRef = {
        kind = "RunnerDeployment"
        name = var.name
      }
      minReplicas = var.min_count
      maxReplicas = var.max_count
      metrics     = var.metrics
      ephemeral   = var.ephemeral
    }
  })
}
