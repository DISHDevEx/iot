output "eks_cluster_arn" {
  description = "The ARN of the created EKS Cluster."
  value       = aws_eks_cluster.eks_cluster_template.arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster_template.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks_cluster_template.name
}