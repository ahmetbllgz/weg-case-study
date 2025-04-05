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

resource "kubectl_manifest" "grafana_pod_restart_alert_dashboard" {
  yaml_body = file("${path.module}/k8s/grafana-pod-restart-alert.yaml")
  depends_on = [helm_release.kube_prometheus_stack]
}

resource "kubectl_manifest" "application" {
  yaml_body = file("${path.module}/k8s/application.yaml")
  depends_on = [helm_release.kube_prometheus_stack]
}