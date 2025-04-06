resource "kubectl_manifest" "managed_certificates" {
  yaml_body = file("${path.module}/k8s/managed-certificate.yaml")
}

resource "kubectl_manifest" "grafana_pod_restart_alert_dashboard" {
  yaml_body = file("${path.module}/k8s/grafana-pod-restart-alert.yaml")
  depends_on = [helm_release.kube_prometheus_stack]
}

resource "kubectl_manifest" "application" {
  yaml_body = file("${path.module}/k8s/application.yaml")
  depends_on = [helm_release.kube_prometheus_stack]
}

resource "kubectl_manifest" "keda_scaledobject" {
  yaml_body  = file("${path.module}/k8s/keda-scaledobject.yaml")
  depends_on = [helm_release.keda]
}

resource "kubectl_manifest" "gateway_routes" {
  yaml_body = file("${path.module}/k8s/gateway-routes.yaml")
  depends_on = [helm_release.istio_gateway]
}

