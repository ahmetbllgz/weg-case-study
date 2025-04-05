resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          =  var.kube_prometheus_stack_version
  namespace        = "monitoring"
  create_namespace = true
  values = [
    file("${path.module}/k8s/values.yaml")
  ]
  set {
    name  = "grafana.adminPassword"
    value = "admin"
  }

}

resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  version          = "2.16.1"
  namespace        = "keda"
  create_namespace = true
}