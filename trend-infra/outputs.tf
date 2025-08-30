output "eks_cluster_name" {
  value = aws_eks_cluster.trend.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.trend.endpoint
}

output "eks_cluster_certificate" {
  value = aws_eks_cluster.trend.certificate_authority[0].data
}
