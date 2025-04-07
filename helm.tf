resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.1"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

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

resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.20.1"
  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = "1.20.1"
  namespace        = "istio-system"
  create_namespace = true
  values = [
    file("${path.module}/k8s/istiod-values.yaml")
  ]
  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_gateway" {
  name             = "istio-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = "1.20.1"
  namespace        = "istio-system"
  create_namespace = true
  values = [
    file("${path.module}/k8s/istio-gateway-values.yaml")
  ]
  depends_on = [helm_release.istiod]
}