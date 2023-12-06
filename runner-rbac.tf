resource "kubernetes_service_account" "runner" {
  metadata {
    name      = var.runner_service_account_name
    namespace = local.namespace
  }
  secret {
    name = kubernetes_secret.runner.metadata[0].name
  }
}

resource "kubernetes_secret" "runner" {
  metadata {
    name      = var.runner_service_account_name
    namespace = local.namespace
  }
}

resource "kubernetes_role" "runner" {
  metadata {
    name      = var.runner_service_account_name
    namespace = local.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["get", "create"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create", "delete", "get", "list"]
  }
}

resource "kubernetes_role_binding" "runner" {
  metadata {
    name      = var.runner_service_account_name
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.runner_service_account_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.runner_service_account_name
    namespace = var.namespace
  }
}
