resource "kubectl_manifest" "clusterissuer" {
  yaml_body = file("${path.module}/k8s/clusterissuer.yaml")
  depends_on  = [helm_release.cert_manager]
}

resource "kubectl_manifest" "certificate" {
  yaml_body = file("${path.module}/k8s/certificate.yaml")
  depends_on = [kubectl_manifest.clusterissuer]
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