resource "helm_release" "karpenter" {
  namespace  = var.karpenter_namespace
  name       = var.karpenter_name
  repository = var.karpenter_repository
  chart      = var.karpenter_chart
  version    = var.karpenter_version
  wait       = var.karpenter_wait

  values = [file(var.karpenter_values_file)]
}